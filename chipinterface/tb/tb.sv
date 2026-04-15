///////////////////////////////////////////////////////////////////////////////
// tb_top.sv
//
// Full-chip integration testbench for top.sv
//
// Instances:
//   u_spi_master : axi_spi_master  @ SPI_BASE = 0x44A00000
//   u_bus_master : tpu_bus_master  @ BUS_BASE = 0x44A10000
//   u_top        : top (DUT)
//
// Clock domains:
//   master_clk : 100 MHz  (AXI for both IP, also bus_clk)
//   tpu_clk    :  10 MHz  (rf_top, tpu_core)
//
// ─── Test flow per run_test(M, N, K) ────────────────────────────────────────
//
//   1. SPI write  : dim_m/n/k, zp_a/b/c, scale_lo/hi, scale_shift
//   2. BUS write  : A (col-major, reversed within 8-byte group)
//                   B (row-major, reversed within 8-byte group)
//                   written simultaneously as byte pairs
//   3. SPI write  : CONTROL[0]=1 → tpu_start
//   4. SPI poll   : STATUS[2] until DONE
//   5. BUS read   : M×K bytes from C, decode position → C[row][col]
//   6. Compare    : C_hw vs C_golden (SW computation)
//
// ─── SRAM byte packing (sram_wrapper) ───────────────────────────────────────
//
//   bus_wbuf[byte_sel*8 +: 8] = bus_din
//     byte_sel=0 → bits[ 7: 0] (LSB)
//     byte_sel=7 → bits[63:56] (MSB)
//
//   tpu_core expects element_0 at MSB → must arrive at byte_sel=7 (last)
//
// ─── Write order for A (M rows × N cols) ────────────────────────────────────
//
//   SRAM_A layout: column-major, word = col*(M/8)+row_group
//   Within each 64-bit word: element at row r → byte_sel = 7-(r%8)
//
//   Write step s (0..M*N-1):
//     col  = s / M
//     row  = ((s/8) % (M/8)) * 8 + (7 - s%8)     ← reversed within group
//     send A[row][col]
//
// ─── Write order for B (N rows × K cols) ────────────────────────────────────
//
//   SRAM_B layout: row-major, word = row*(K/8)+col_group
//   Within each 64-bit word: element at col c → byte_sel = 7-(c%8)
//
//   Write step s (0..N*K-1):
//     row  = s / K
//     col  = ((s/8) % (K/8)) * 8 + (7 - s%8)     ← reversed within group
//     send B[row][col]
//
// ─── Read order for C (M rows × K cols) ─────────────────────────────────────
//
//   bus_read byte at position p (0..M*K-1):
//     word_idx  = p / 8
//     byte_sel  = p % 8
//     row       = word_idx / (K/8)
//     col_group = word_idx % (K/8)
//     col       = col_group*8 + (7 - byte_sel)    ← reversed within group
//
// ─── Golden formula ──────────────────────────────────────────────────────────
//
//   acc = Σ_t [ (A[i][t]-zp_a) × (B[t][j]-zp_b) ]
//   (bias = 0, tied off in top.sv)
//   scaled = hw_round( acc × scale_factor / 2^(16+shift) )
//   C[i][j] = clamp( scaled + zp_c, 0, 255 )
//
//   hw_round(x/d) = (x≥0) ? (x+d/2)>>log2(d) : (x-d/2)>>log2(d)
//
// ─── NOTE ────────────────────────────────────────────────────────────────────
//
//   top.sv currently passes dim_m directly to tpu_core as tile count.
//   tpu_core expects tile count = actual_dim / 8.
//   FIX NEEDED in top.sv: .m(7'(dim_m>>3)), .n(7'(dim_n>>3)), .k(7'(dim_k>>3))
//   Until fixed, only 8×8×8 (dim=8, tile=1) produces correct tpu_core behavior.
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_top;

    //=========================================================================
    // Parameters
    //=========================================================================
    localparam MASTER_CLK_PERIOD = 10;    // 100 MHz
    localparam TPU_CLK_PERIOD    = 100;   //  10 MHz
    localparam CLKS_PER_HALF_BIT = 50;    // SPI = 1 MHz
    localparam SPI_MODE          = 0;

    // Base addresses (for reference / documentation only)
    localparam logic [31:0] SPI_BASE = 32'h44A0_0000;
    localparam logic [31:0] BUS_BASE = 32'h44A1_0000;

    // SPI master AXI register offsets (7-bit, same as existing tb)
    localparam logic [6:0] SPI_OFF_TX  = 7'h00;  // TX_DATA
    localparam logic [6:0] SPI_OFF_RX  = 7'h04;  // RX_DATA
    localparam logic [6:0] SPI_OFF_STA = 7'h08;  // STATUS [0]=READY
    localparam logic [6:0] SPI_OFF_CTL = 7'h0C;  // CONTROL [0]=CS_N

    // Bus master AXI register offsets
    localparam logic [6:0] BUS_OFF_STATUS  = 7'h00;  // [0]=READY_AB [1]=READY_C
    localparam logic [6:0] BUS_OFF_START   = 7'h04;  // [0]=START_AB [1]=START_C
    localparam logic [6:0] BUS_OFF_DATA_AB = 7'h08;  // [15:8]=B [7:0]=A
    localparam logic [6:0] BUS_OFF_DATA_C  = 7'h0C;  // read: captured byte

    // TPU SPI protocol
    localparam logic [3:0] TPU_OP_READ  = 4'h1;
    localparam logic [3:0] TPU_OP_WRITE = 4'h2;
    localparam logic [7:0] TPU_ACK      = 8'hFF;
    localparam logic [7:0] TPU_NAK      = 8'hF0;

    // TPU register addresses (4-bit SPI)
    localparam logic [3:0] TPUR_CTRL    = 4'h0;
    localparam logic [3:0] TPUR_STAT    = 4'h1;
    localparam logic [3:0] TPUR_DIM_M   = 4'h2;
    localparam logic [3:0] TPUR_DIM_N   = 4'h3;
    localparam logic [3:0] TPUR_DIM_K   = 4'h4;
    localparam logic [3:0] TPUR_ZP_A    = 4'h5;
    localparam logic [3:0] TPUR_ZP_B    = 4'h6;
    localparam logic [3:0] TPUR_ZP_C    = 4'h7;
    localparam logic [3:0] TPUR_SCL_LO  = 4'h8;
    localparam logic [3:0] TPUR_SCL_HI  = 4'h9;
    localparam logic [3:0] TPUR_SCL_SHF = 4'hA;

    // Maximum static array size
    localparam MAX_DIM = 64;

    //=========================================================================
    // Clocks & Reset
    //=========================================================================
    logic master_clk;
    logic tpu_clk;
    logic aresetn;

    initial master_clk = 0;
    always #(MASTER_CLK_PERIOD/2) master_clk = ~master_clk;

    initial tpu_clk = 0;
    always #(TPU_CLK_PERIOD/2) tpu_clk = ~tpu_clk;

    //=========================================================================
    // SPI master AXI-Lite signals
    //=========================================================================
    logic [6:0]  spi_awaddr;  logic spi_awvalid; logic spi_awready; logic [2:0] spi_awprot;
    logic [31:0] spi_wdata;   logic [3:0] spi_wstrb;  logic spi_wvalid; logic spi_wready;
    logic [1:0]  spi_bresp;   logic spi_bvalid;  logic spi_bready;
    logic [6:0]  spi_araddr;  logic spi_arvalid; logic spi_arready; logic [2:0] spi_arprot;
    logic [31:0] spi_rdata;   logic [1:0] spi_rresp;  logic spi_rvalid; logic spi_rready;
    logic [1:0]  spi_dbg_wr,  spi_dbg_rd;

    //=========================================================================
    // Bus master AXI-Lite signals
    //=========================================================================
    logic [6:0]  bus_awaddr;  logic bus_awvalid; logic bus_awready; logic [2:0] bus_awprot;
    logic [31:0] bus_wdata;   logic [3:0] bus_wstrb;  logic bus_wvalid; logic bus_wready;
    logic [1:0]  bus_bresp;   logic bus_bvalid;  logic bus_bready;
    logic [6:0]  bus_araddr;  logic bus_arvalid; logic bus_arready; logic [2:0] bus_arprot;
    logic [31:0] bus_rdata;   logic [1:0] bus_rresp;  logic bus_rvalid; logic bus_rready;

    //=========================================================================
    // Chip I/O
    //=========================================================================
    logic spi_sck, spi_cs_n, spi_mosi, spi_miso;

    logic        bus_rst_n;
    logic        chab_start, chab_wr;
    logic [7:0]  chab_wdata_a, chab_wdata_b;
    logic        chc_start, chc_rd;
    logic [7:0]  chc_rdata;

    // Global error counter
    int total_errors = 0;

    //=========================================================================
    // DUT: axi_spi_master
    //=========================================================================
    axi_spi_master #(
        .C_S_AXI_DATA_WIDTH (32),
        .C_S_AXI_ADDR_WIDTH (7),
        .SPI_MODE           (SPI_MODE),
        .CLKS_PER_HALF_BIT  (CLKS_PER_HALF_BIT)
    ) u_spi_master (
        .S_AXI_ACLK    (master_clk),
        .S_AXI_ARESETN (aresetn),
        .S_AXI_AWADDR  (spi_awaddr),  .S_AXI_AWVALID (spi_awvalid), .S_AXI_AWREADY (spi_awready),
        .S_AXI_WDATA   (spi_wdata),   .S_AXI_WSTRB   (spi_wstrb),   .S_AXI_WVALID  (spi_wvalid),  .S_AXI_WREADY (spi_wready),
        .S_AXI_BRESP   (spi_bresp),   .S_AXI_BVALID  (spi_bvalid),  .S_AXI_BREADY  (spi_bready),
        .S_AXI_ARADDR  (spi_araddr),  .S_AXI_ARVALID (spi_arvalid), .S_AXI_ARREADY (spi_arready),
        .S_AXI_RDATA   (spi_rdata),   .S_AXI_RRESP   (spi_rresp),   .S_AXI_RVALID  (spi_rvalid),  .S_AXI_RREADY (spi_rready),
        .SPI_SCK       (spi_sck),
        .SPI_MOSI      (spi_mosi),
        .SPI_MISO      (spi_miso),
        .SPI_CS_N      (spi_cs_n),
        .debug_wr_state(spi_dbg_wr),
        .debug_rd_state(spi_dbg_rd)
    );

    //=========================================================================
    // DUT: tpu_bus_master
    //=========================================================================
    tpu_bus_master #(
        .C_S_AXI_DATA_WIDTH (32),
        .C_S_AXI_ADDR_WIDTH (7)
    ) u_bus_master (
        .S_AXI_ACLK    (master_clk),
        .S_AXI_ARESETN (aresetn),
        .S_AXI_AWADDR  (bus_awaddr),  .S_AXI_AWVALID (bus_awvalid), .S_AXI_AWREADY (bus_awready),
        .S_AXI_WDATA   (bus_wdata),   .S_AXI_WSTRB   (bus_wstrb),   .S_AXI_WVALID  (bus_wvalid),  .S_AXI_WREADY (bus_wready),
        .S_AXI_BRESP   (bus_bresp),   .S_AXI_BVALID  (bus_bvalid),  .S_AXI_BREADY  (bus_bready),
        .S_AXI_ARADDR  (bus_araddr),  .S_AXI_ARVALID (bus_arvalid), .S_AXI_ARREADY (bus_arready),
        .S_AXI_RDATA   (bus_rdata),   .S_AXI_RRESP   (bus_rresp),   .S_AXI_RVALID  (bus_rvalid),  .S_AXI_RREADY (bus_rready),
        .BUS_CLK       (master_clk),   // bus_clk = 100 MHz, same domain
        .BUS_RST_N     (bus_rst_n),
        .CHAB_START    (chab_start),
        .CHAB_WDATA_A  (chab_wdata_a),
        .CHAB_WDATA_B  (chab_wdata_b),
        .CHAB_WR       (chab_wr),
        .CHC_START     (chc_start),
        .CHC_RDATA     (chc_rdata),
        .CHC_RD        (chc_rd)
    );

    //=========================================================================
    // DUT: top (chip)
    //=========================================================================
    chipinterface u_top (
        .clk          (tpu_clk),
        .rst_n        (aresetn),
        .spi_sck      (spi_sck),
        .spi_cs_n     (spi_cs_n),
        .spi_mosi     (spi_mosi),
        .spi_miso     (spi_miso),
        .bus_clk      (master_clk),
        .bus_rst_n    (bus_rst_n),
        .chab_start   (chab_start),
        .chab_wr      (chab_wr),
        .chab_wdata_a (chab_wdata_a),
        .chab_wdata_b (chab_wdata_b),
        .chc_start    (chc_start),
        .chc_rd       (chc_rd),
        .chc_rdata    (chc_rdata)
    );

    //=========================================================================
    // SPI master AXI write / read (drives spi_* signals)
    //=========================================================================
    task automatic spi_axi_write(input logic [6:0] addr, input logic [31:0] data);
        @(posedge master_clk);
        spi_awaddr  <= addr;    spi_wdata   <= data;
        spi_awprot  <= 3'd0;    spi_awvalid <= 1'b1;
        spi_wstrb   <= 4'hF;    spi_bready  <= 1'b0;

        wait(spi_awvalid & spi_awready);
        spi_wvalid  <= 1'b1;
        @(posedge master_clk);
        spi_awvalid = 1'b0;

        wait(spi_wvalid & spi_wready);
        @(posedge master_clk);
        spi_wvalid  <= 1'b0;

        repeat($urandom_range(10,4)) @(posedge master_clk);
        spi_bready  <= 1'b1;
        wait(spi_bvalid & spi_bready);
        @(posedge master_clk);
        spi_bready  <= 1'b0;
    endtask

    task automatic spi_axi_read(input logic [6:0] addr, output logic [31:0] data);
        @(posedge master_clk);
        spi_araddr  <= addr;    spi_arprot  <= 3'd0;
        spi_arvalid <= 1'b1;    spi_rready  <= 1'b0;

        wait(spi_arvalid & spi_arready);
        @(posedge master_clk);
        spi_arvalid <= 1'b0;

        repeat($urandom_range(10,4)) @(posedge master_clk);
        spi_rready  <= 1'b1;
        wait(spi_rvalid & spi_rready);
        data        <= spi_rdata;
        @(posedge master_clk);
        spi_rready  <= 1'b0;
    endtask

    //=========================================================================
    // Bus master AXI write / read (drives bus_* signals)
    //=========================================================================
    task automatic bus_axi_write(input logic [6:0] addr, input logic [31:0] data);
        @(posedge master_clk);
        bus_awaddr  <= addr;    bus_wdata   <= data;
        bus_awprot  <= 3'd0;    bus_awvalid <= 1'b1;
        bus_wstrb   <= 4'hF;    bus_bready  <= 1'b0;

        wait(bus_awvalid & bus_awready);
        bus_wvalid  <= 1'b1;
        @(posedge master_clk);
        bus_awvalid = 1'b0;

        wait(bus_wvalid & bus_wready);
        @(posedge master_clk);
        bus_wvalid  <= 1'b0;

        repeat($urandom_range(10,4)) @(posedge master_clk);
        bus_bready  <= 1'b1;
        wait(bus_bvalid & bus_bready);
        @(posedge master_clk);
        bus_bready  <= 1'b0;
    endtask

    task automatic bus_axi_read(input logic [6:0] addr, output logic [31:0] data);
        @(posedge master_clk);
        bus_araddr  <= addr;    bus_arprot  <= 3'd0;
        bus_arvalid <= 1'b1;    bus_rready  <= 1'b0;

        wait(bus_arvalid & bus_arready);
        @(posedge master_clk);
        bus_arvalid <= 1'b0;

        repeat($urandom_range(10,4)) @(posedge master_clk);
        bus_rready  <= 1'b1;
        wait(bus_rvalid & bus_rready);
        data        <= bus_rdata;
        @(posedge master_clk);
        bus_rready  <= 1'b0;
    endtask

    //=========================================================================
    // SPI protocol tasks (build on spi_axi_*)
    //=========================================================================
    task automatic spi_wait_ready();
        logic [31:0] status;
        int timeout;
        timeout = 0;
        do begin
            spi_axi_read(SPI_OFF_STA, status);
            if (++timeout > 1000) begin
                $display("ERROR: spi_wait_ready timeout");
                $finish;
            end
            repeat(5) @(posedge master_clk);
        end while (!status[0]);
    endtask

    task automatic spi_cs_low();
        spi_axi_write(SPI_OFF_CTL, 32'h0);
        repeat($urandom_range(100,50)) @(posedge master_clk);
    endtask

    task automatic spi_cs_high();
        spi_axi_write(SPI_OFF_CTL, 32'h1);
        repeat($urandom_range(100,50)) @(posedge master_clk);
    endtask

    task automatic spi_xfer_byte(input logic [7:0] tx, output logic [7:0] rx);
        logic [31:0] rd;
        spi_wait_ready();
        spi_axi_write(SPI_OFF_TX, {24'h0, tx});
        spi_wait_ready();
        repeat($urandom_range(100,50)) @(posedge master_clk);
        spi_axi_read(SPI_OFF_RX, rd);
        rx = rd[7:0];
    endtask

    // TPU SPI write: [ADDR:4][OPCODE:4] + dummy + data + dummy
    task automatic tpu_spi_write(input logic [3:0] addr, input logic [7:0] data, output int result);
        logic [7:0] cmd, r1, r2, d;
        cmd = {addr, TPU_OP_WRITE};
        spi_cs_low();
        spi_xfer_byte(cmd,   d);
        spi_xfer_byte(8'h00, r1);
        spi_xfer_byte(data,  d);
        spi_xfer_byte(8'h00, r2);
        spi_cs_high();
        repeat($urandom_range(35,10)) @(posedge tpu_clk);
        result = ((r1 == TPU_ACK) && (r2 == TPU_ACK)) ? 0 : -1;
        if (result != 0)
            $display("  WARN: tpu_spi_write addr=0x%h r1=0x%02X r2=0x%02X", addr, r1, r2);
    endtask

    // TPU SPI read: [ADDR:4][OPCODE:4] + dummy (returns data or NAK)
    task automatic tpu_spi_read(input logic [3:0] addr, output logic [7:0] data, output int result);
        logic [7:0] cmd, rx;
        cmd = {addr, TPU_OP_READ};
        spi_cs_low();
        spi_xfer_byte(cmd,   rx);
        spi_xfer_byte(8'h00, rx);
        spi_cs_high();
        repeat($urandom_range(35,10)) @(posedge tpu_clk);
        if (rx == TPU_NAK) begin result = -1; end
        else               begin data = rx; result = 0; end
    endtask

    //=========================================================================
    // Bus protocol tasks
    //=========================================================================
    task automatic poll_ready_ab();
        logic [31:0] s;
        do begin bus_axi_read(BUS_OFF_STATUS, s); end while (!s[0]);
    endtask

    task automatic poll_ready_c();
        logic [31:0] s;
        do begin bus_axi_read(BUS_OFF_STATUS, s); end while (!s[1]);
    endtask

    // Write one A/B byte pair (blocks until bus is ready)
    task automatic bus_write_pair(input logic [7:0] a_byte, input logic [7:0] b_byte);
        poll_ready_ab();
        bus_axi_write(BUS_OFF_DATA_AB, {16'h0, b_byte, a_byte});
    endtask

    // Trigger one CHC_RD and capture the byte
    task automatic bus_read_c_byte(output logic [7:0] out_byte);
        logic [31:0] rd;
        poll_ready_c();
        bus_axi_write(BUS_OFF_DATA_C, 32'h0);   // any write triggers CHC_RD
        poll_ready_c();                           // wait for C_CAPTURE
        bus_axi_read(BUS_OFF_DATA_C, rd);
        out_byte = rd[7:0];
    endtask

    //=========================================================================
    // run_test(M, N, K)
    //
    // Preconditions:
    //   - M, N, K must be positive multiples of 8
    //   - M*N <= 4096  (SRAM_A capacity: 512 words × 64-bit)
    //   - N*K <= 4096  (SRAM_B capacity)
    //   - M*K <= 4096  (SRAM_C capacity)
    //   - Each dim <= MAX_DIM (64)
    //=========================================================================
    task automatic run_test(input int M, input int N, input int K);

        //----------------------------------------------------------------------
        // Local data (automatic task, allocated per invocation)
        //----------------------------------------------------------------------
        logic [7:0] A        [0:MAX_DIM-1][0:MAX_DIM-1];   // A[row][col]
        logic [7:0] B        [0:MAX_DIM-1][0:MAX_DIM-1];   // B[row][col]
        logic [7:0] C_golden [0:MAX_DIM-1][0:MAX_DIM-1];
        logic [7:0] C_hw     [0:MAX_DIM-1][0:MAX_DIM-1];

        logic [7:0]  zp_a, zp_b, zp_c;
        logic [15:0] scale_factor;
        logic [4:0]  scale_shift;

        int n_a, n_b, n_max;
        int ret, poll_cnt, errors;
        int col, row, col_group, word_idx, byte_sel_pos, words_per_row;
        logic [7:0] a_byte, b_byte, c_byte, status_val;

        // Signed 64-bit for golden arithmetic
        longint signed acc, product, half_val, result;
        longint signed a_val, b_val;
        int shift_total;

        //----------------------------------------------------------------------
        // Validate preconditions
        //----------------------------------------------------------------------
        if ((M % 8 != 0) || (N % 8 != 0) || (K % 8 != 0)) begin
            $display("ERROR: M/N/K must be multiples of 8 (got M=%0d N=%0d K=%0d)", M, N, K);
            total_errors++;
            return;
        end

        n_a   = M * N;
        n_b   = N * K;
        n_max = (n_a > n_b) ? n_a : n_b;
        errors = 0;

        $display("\n================================================================");
        $display("  run_test: M=%0d  N=%0d  K=%0d", M, N, K);
        $display("  A=%0d bytes  B=%0d bytes  C=%0d bytes  pairs=%0d",
                 n_a, n_b, M*K, n_max);
        $display("================================================================");

        //----------------------------------------------------------------------
        // Generate random matrices and quantization parameters
        //
        // Keep scale/shift modest so outputs land in [0,255] visibly.
        // scale_factor is a Q0.16 fixed-point value (0..1).
        //----------------------------------------------------------------------
        zp_a         = $urandom_range(0,  30);
        zp_b         = $urandom_range(0,  30);
        zp_c         = $urandom_range(0,  30);
        scale_factor = $urandom_range(16'h0200, 16'h1FFF);  // 0.008..0.125
        scale_shift  = $urandom_range(0, 3);

        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                A[i][j] = $urandom_range(0, 200);

        for (int i = 0; i < N; i++)
            for (int j = 0; j < K; j++)
                B[i][j] = $urandom_range(0, 200);

        $display("  zp_a=%0d  zp_b=%0d  zp_c=%0d  scale=0x%04X  shift=%0d",
                 zp_a, zp_b, zp_c, scale_factor, scale_shift);

        //----------------------------------------------------------------------
        // Compute golden result
        //
        // acc     = Σ_t [(A[i][t]-zp_a) * (B[t][j]-zp_b)]   (bias=0 in top.sv)
        // product = acc * scale_factor   (scale_factor is 16-bit unsigned)
        // result  = hw_round(product / 2^(16+shift)) + zp_c
        // output  = clamp(result, 0, 255)
        //----------------------------------------------------------------------
        shift_total = 16 + int'(scale_shift);

        for (int i = 0; i < M; i++) begin
            for (int j = 0; j < K; j++) begin
                acc = 0;
                for (int t = 0; t < N; t++) begin
                    a_val = longint'(A[i][t]) - longint'(zp_a);
                    b_val = longint'(B[t][j]) - longint'(zp_b);
                    acc  += a_val * b_val;
                end

                // Scale: multiply by Q0.16 scale_factor, then shift
                product  = acc * longint'(scale_factor);

                // hw_round: round half away from zero
                half_val = 64'd1 << (shift_total - 1);
                if (product >= 0)
                    result = (product + half_val) >>> shift_total;
                else
                    result = (product - half_val) >>> shift_total;

                // Add zero_point_c and clamp
                result = result + longint'(zp_c);
                if (result < 0)   result = 0;
                if (result > 255) result = 255;

                C_golden[i][j] = result[7:0];
            end
        end

        $display("  Golden computed.  C[0][0]=0x%02X  C[%0d][%0d]=0x%02X",
                 C_golden[0][0], M-1, K-1, C_golden[M-1][K-1]);

        //----------------------------------------------------------------------
        // Step 1: Configure TPU registers via SPI
        //----------------------------------------------------------------------
        $display("\n  [Step 1] SPI config...");

        tpu_spi_write(TPUR_DIM_M,   M[7:0],              ret);
        tpu_spi_write(TPUR_DIM_N,   N[7:0],              ret);
        tpu_spi_write(TPUR_DIM_K,   K[7:0],              ret);
        tpu_spi_write(TPUR_ZP_A,    zp_a,                ret);
        tpu_spi_write(TPUR_ZP_B,    zp_b,                ret);
        tpu_spi_write(TPUR_ZP_C,    zp_c,                ret);
        tpu_spi_write(TPUR_SCL_LO,  scale_factor[7:0],   ret);
        tpu_spi_write(TPUR_SCL_HI,  scale_factor[15:8],  ret);
        tpu_spi_write(TPUR_SCL_SHF, {3'b0, scale_shift}, ret);

        $display("  Done.");

        //----------------------------------------------------------------------
        // Step 2: Write A and B via bus
        //
        // Both channels are written simultaneously as paired bytes.
        // bus_slave_ab increments cnt_a and cnt_b independently.
        //
        // A byte at write step s (0 <= s < M*N):
        //   col  = s / M                                (which column of A)
        //   row  = ((s/8) % (M/8)) * 8 + (7 - s%8)    (reversed within group)
        //   send A[row][col]
        //
        // B byte at write step s (0 <= s < N*K):
        //   row  = s / K                                (which row of B)
        //   col  = ((s/8) % (K/8)) * 8 + (7 - s%8)    (reversed within group)
        //   send B[row][col]
        //
        // Pad with 0x00 when the smaller matrix runs out (ignored by slave).
        //----------------------------------------------------------------------
        $display("\n  [Step 2] Write A (col-major/rev) and B (row-major/rev) via bus...");

        poll_ready_ab();
        bus_axi_write(BUS_OFF_START, 32'h1);   // START_AB → reset cnt_a, cnt_b
        poll_ready_ab();

        for (int st = 0; st < n_max; st++) begin

            // A: column-major, element-0 in MSB (byte_sel=7)
            if (st < n_a) begin
                col   = st / M;
                row   = ((st / 8) % (M / 8)) * 8 + (7 - (st % 8));
                a_byte = A[row][col];
            end else begin
                a_byte = 8'h00;   // padding, ignored by bus_slave_ab
            end

            // B: row-major, element-0 in MSB (byte_sel=7)
            if (st < n_b) begin
                row   = st / K;
                col   = ((st / 8) % (K / 8)) * 8 + (7 - (st % 8));
                b_byte = B[row][col];
            end else begin
                b_byte = 8'h00;   // padding, ignored by bus_slave_ab
            end

            bus_write_pair(a_byte, b_byte);
        end

        poll_ready_ab();
        $display("  Done (%0d pairs sent).", n_max);

        //----------------------------------------------------------------------
        // Step 3: Start TPU via SPI (CONTROL[0] = 1)
        //
        // rf_top mmio holds tpu_start HIGH until tpu_done.
        //----------------------------------------------------------------------
        $display("\n  [Step 3] SPI start...");
        tpu_spi_write(TPUR_CTRL, 8'h01, ret);
        if (ret != 0) begin
            $display("  ERROR: START write returned NAK");
            total_errors++;
            return;
        end
        $display("  tpu_start asserted.");

        //----------------------------------------------------------------------
        // Step 4: Poll STATUS[2] (done) via SPI
        //
        // mmio STATUS[2] = done_latched, set by tpu_core done_flag pulse,
        // cleared on read (clear-on-read).
        //----------------------------------------------------------------------
        $display("\n  [Step 4] Polling STATUS[2] (done)...");
        poll_cnt = 0;
        do begin
            repeat(10) @(posedge tpu_clk);   // let TPU make progress
            tpu_spi_read(TPUR_STAT, status_val, ret);
            if (++poll_cnt > 500000) begin
                $display("  ERROR: done poll timeout! (M=%0d N=%0d K=%0d)", M, N, K);
                total_errors++;
                return;
            end
        end while (!status_val[2]);

        $display("  DONE received after %0d polls.", poll_cnt);

        //----------------------------------------------------------------------
        // Step 5: Read matrix C via bus
        //
        // Bus reads M*K bytes sequentially (cnt_c = 0..M*K-1).
        //
        // Byte position p maps to C[row][col]:
        //   word_idx  = p / 8
        //   byte_sel  = p % 8
        //   row       = word_idx / (K/8)
        //   col_group = word_idx % (K/8)
        //   col       = col_group*8 + (7 - byte_sel)   ← reversed within word
        //----------------------------------------------------------------------
        $display("\n  [Step 5] Read C via bus (%0d bytes)...", M*K);

        poll_ready_c();
        bus_axi_write(BUS_OFF_START, 32'h2);   // START_C → reset cnt_c
        poll_ready_c();

        words_per_row = K / 8;

        for (int p = 0; p < M * K; p++) begin
            bus_read_c_byte(c_byte);

            // Decode byte position to matrix index
            word_idx      = p / 8;
            byte_sel_pos  = p % 8;
            row           = word_idx / words_per_row;
            col_group     = word_idx % words_per_row;
            col           = col_group * 8 + (7 - byte_sel_pos);

            C_hw[row][col] = c_byte;
        end

        $display("  Done.  C_hw[0][0]=0x%02X  C_hw[%0d][%0d]=0x%02X",
                 C_hw[0][0], M-1, K-1, C_hw[M-1][K-1]);

        //----------------------------------------------------------------------
        // Step 6: Compare C_hw vs C_golden
        //----------------------------------------------------------------------
        $display("\n  [Step 6] Comparing...");
        for (int i = 0; i < M; i++) begin
            for (int j = 0; j < K; j++) begin
                if (C_hw[i][j] !== C_golden[i][j]) begin
                    if (errors < 16)
                        $display("  FAIL C[%0d][%0d]: golden=0x%02X  hw=0x%02X",
                                 i, j, C_golden[i][j], C_hw[i][j]);
                    errors++;
                end
            end
        end

        if (errors == 0)
            $display("  [PASS] All %0d pixels match!", M*K);
        else begin
            if (errors > 16)
                $display("  ... (and %0d more)", errors - 16);
            $display("  [FAIL] %0d / %0d mismatches", errors, M*K);
        end

        total_errors += errors;
    endtask

    //=========================================================================
    // Main test sequence
    //=========================================================================
    initial begin
        $display("================================================================");
        $display("  TPU Full-Chip Integration Testbench");
        $display("  SPI_BASE=0x%08X  BUS_BASE=0x%08X", SPI_BASE, BUS_BASE);
        $display("  master_clk=%0d MHz  tpu_clk=%0d MHz  SPI=%0d MHz",
                 1000/MASTER_CLK_PERIOD, 1000/TPU_CLK_PERIOD,
                 1000/(MASTER_CLK_PERIOD*2*CLKS_PER_HALF_BIT));
        $display("================================================================");

        // ── Initialise all AXI signals ──────────────────────────────────────
        spi_awaddr=0; spi_awvalid=0; spi_awprot=0;
        spi_wdata=0;  spi_wstrb=0;   spi_wvalid=0;  spi_bready=0;
        spi_araddr=0; spi_arvalid=0; spi_arprot=0;  spi_rready=0;

        bus_awaddr=0; bus_awvalid=0; bus_awprot=0;
        bus_wdata=0;  bus_wstrb=0;   bus_wvalid=0;  bus_bready=0;
        bus_araddr=0; bus_arvalid=0; bus_arprot=0;  bus_rready=0;

        total_errors = 0;

        // ── Reset ───────────────────────────────────────────────────────────
        aresetn = 0;
        repeat(20) @(posedge master_clk);
        aresetn = 1;
        repeat(100) @(posedge master_clk);

        // SPI master: deassert CS
        spi_cs_high();
        repeat(50) @(posedge master_clk);

        // ── Sanity check: SPI master STATUS should be READY ─────────────────
        begin
            logic [31:0] spi_status;
            spi_axi_read(SPI_OFF_STA, spi_status);
            if (!spi_status[0]) begin
                $display("ERROR: SPI master not ready at startup! STATUS=0x%08X", spi_status);
                $finish;
            end
            $display("\n  SPI master ready (STATUS=0x%02X). Starting tests.\n", spi_status[7:0]);
        end

        // ── Test cases ───────────────────────────────────────────────────────
        // All dims must be multiples of 8.
        // M*N and N*K must fit in SRAM (≤ 4096 bytes each).
        //
        // NOTE: Until top.sv is fixed to divide dim by 8 for tpu_core,
        //       only the 8×8×8 case will produce correct tpu_core behavior
        //       (passes dim=8 → tpu_core sees tile_count=8, too large).
        //       The SPI config and bus write/read paths are exercised correctly
        //       for all cases regardless of the divide-by-8 issue.

        run_test( 8,  8,  8);   // baseline: 1×1×1 tiles
        run_test(16,  8,  8);   // M=2 tiles
        run_test( 8, 16,  8);   // N=2 tiles
        run_test( 8,  8, 16);   // K=2 tiles
        run_test(16, 16, 16);   // 2×2×2 tiles
        run_test( 8,  8,  8);   // repeat baseline for stability

        // ── Summary ─────────────────────────────────────────────────────────
        $display("\n================================================================");
        if (total_errors == 0)
            $display("  ALL TESTS PASSED!");
        else
            $display("  FAILED: %0d total error(s)", total_errors);
        $display("================================================================");
        $finish;
    end

    //=========================================================================
    // Global timeout
    //=========================================================================
    initial begin
        #2_000_000_000;   // 2 s
        $display("ERROR: Global simulation timeout!");
        $finish;
    end

endmodule