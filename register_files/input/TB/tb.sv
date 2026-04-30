///////////////////////////////////////////////////////////////////////////////
// tb.sv - spi_slave_mmio_register_file with axi_spi_master in loop
//
// Topology:
//   tb (AXI master) --AXI--> axi_spi_master --SPI--> spi_slave_mmio_register_file
//
// AXI clock: 100 MHz (master_clk)
// Chip clock: 10 MHz (clk)
// SPI clock: derived from AXI clock by axi_spi_master via CLKS_PER_HALF_BIT
//
// CLKS_PER_HALF_BIT settings (@ 100 MHz AXI clock):
//   50  -> SCK = 1   MHz
//   10  -> SCK = 5   MHz
//    5  -> SCK = 10  MHz
//
// Random delays (20-50 cycles) inserted between AXI transactions to stress
// the AXI handshake interface and CDC paths.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb;

    localparam MASTER_CLK_PERIOD = 10;    // 100 MHz AXI master
    localparam CLK_PERIOD        = 100;   //  10 MHz chip clock

    // SPI commands
    localparam [3:0] CMD_READ  = 4'b0001;
    localparam [3:0] CMD_WRITE = 4'b0010;
    localparam [7:0] RESP_ACK  = 8'hFF;
    localparam [7:0] RESP_NAK  = 8'hF0;

    // axi_spi_master register map (byte addresses)
    localparam [6:0] M_ADDR_TX_DATA  = 7'h00;
    localparam [6:0] M_ADDR_RX_DATA  = 7'h04;
    localparam [6:0] M_ADDR_STATUS   = 7'h08;
    localparam [6:0] M_ADDR_CONTROL  = 7'h0C;

    // mmio_register_file register addresses (4-bit)
    localparam [3:0] ADDR_CONTROL         = 4'h0;
    localparam [3:0] ADDR_STATUS          = 4'h1;
    localparam [3:0] ADDR_DIM_M           = 4'h2;
    localparam [3:0] ADDR_DIM_N           = 4'h3;
    localparam [3:0] ADDR_DIM_K           = 4'h4;
    localparam [3:0] ADDR_NUM_COMPUTATION = 4'h5;
    localparam [3:0] ADDR_ZP_A            = 4'h6;
    localparam [3:0] ADDR_ZP_B            = 4'h7;
    localparam [3:0] ADDR_ZP_C            = 4'h8;
    localparam [3:0] ADDR_SCALE_LO        = 4'h9;
    localparam [3:0] ADDR_SCALE_HI        = 4'hA;
    localparam [3:0] ADDR_SCALE_SHIFT     = 4'hB;
    localparam [3:0] ADDR_KEEP_PE_VALUE   = 4'hC;
    localparam [3:0] ADDR_FULL_PERCISION  = 4'hD;

    //=========================================================================
    // Clocks and reset
    //=========================================================================
    logic master_clk;
    logic clk;
    logic master_aresetn;
    logic arstn;
    logic rstn;

    initial master_clk = 0;
    always #(MASTER_CLK_PERIOD/2) master_clk = ~master_clk;

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    //=========================================================================
    // AXI signals (tb -> master)
    //=========================================================================
    logic [6:0]  S_AXI_awaddr;  logic S_AXI_awvalid; logic S_AXI_awready; logic [2:0] S_AXI_awprot;
    logic [31:0] S_AXI_wdata;   logic [3:0] S_AXI_wstrb; logic S_AXI_wvalid; logic S_AXI_wready;
    logic [1:0]  S_AXI_bresp;   logic S_AXI_bvalid;  logic S_AXI_bready;
    logic [6:0]  S_AXI_araddr;  logic S_AXI_arvalid; logic S_AXI_arready; logic [2:0] S_AXI_arprot;
    logic [31:0] S_AXI_rdata;   logic [1:0] S_AXI_rresp; logic S_AXI_rvalid; logic S_AXI_rready;

    logic [1:0]  debug_wr_state, debug_rd_state;

    //=========================================================================
    // SPI signals (master <-> slave)
    //=========================================================================
    logic spi_sck;
    logic spi_cs_n;
    logic spi_mosi;
    logic spi_miso;

    //=========================================================================
    // SPI slave outputs (visible state for verification)
    //=========================================================================
    logic       fsm_start;
    logic [1:0] fsm_keep_pe_value;
    logic       fsm_tpu_full_percision;
    logic       fsm_idle;
    logic       fsm_working;
    logic       fsm_done;

    logic [6:0]  tpu_dim_m, tpu_dim_n, tpu_dim_k, tpu_num_computation;
    logic [7:0]  tpu_zero_point_a, tpu_zero_point_b, tpu_zero_point_c;
    logic [15:0] tpu_scale_factor;
    logic [4:0]  tpu_scale_shift;

    int errors;

    //=========================================================================
    // DUT 1: axi_spi_master (acts like FPGA-side master)
    //
    // CLKS_PER_HALF_BIT = 5 -> SCK = 100 MHz / (2*5) = 10 MHz
    //=========================================================================
    axi_spi_master #(
        .C_S_AXI_DATA_WIDTH (32),
        .C_S_AXI_ADDR_WIDTH (7),
        .SPI_MODE           (0),
        .CLKS_PER_HALF_BIT  (5)         // 10 MHz SCK
    ) u_master (
        .S_AXI_ACLK    (master_clk),
        .S_AXI_ARESETN (master_aresetn),

        .S_AXI_AWADDR  (S_AXI_awaddr),  .S_AXI_AWVALID (S_AXI_awvalid), .S_AXI_AWREADY (S_AXI_awready),
        .S_AXI_WDATA   (S_AXI_wdata),   .S_AXI_WSTRB   (S_AXI_wstrb),
        .S_AXI_WVALID  (S_AXI_wvalid),  .S_AXI_WREADY  (S_AXI_wready),
        .S_AXI_BRESP   (S_AXI_bresp),   .S_AXI_BVALID  (S_AXI_bvalid),  .S_AXI_BREADY  (S_AXI_bready),
        .S_AXI_ARADDR  (S_AXI_araddr),  .S_AXI_ARVALID (S_AXI_arvalid), .S_AXI_ARREADY (S_AXI_arready),
        .S_AXI_RDATA   (S_AXI_rdata),   .S_AXI_RRESP   (S_AXI_rresp),
        .S_AXI_RVALID  (S_AXI_rvalid),  .S_AXI_RREADY  (S_AXI_rready),

        .SPI_SCK       (spi_sck),
        .SPI_MOSI      (spi_mosi),
        .SPI_MISO      (spi_miso),
        .SPI_CS_N      (spi_cs_n),

        .debug_wr_state(debug_wr_state),
        .debug_rd_state(debug_rd_state)
    );

    //=========================================================================
    // DUT 2: spi_slave_mmio_register_file (chip side)
    //=========================================================================
    spi_slave_mmio_register_file u_dut (
        .clk                    (clk),
        .arstn                  (arstn),
        .rstn                   (rstn),

        .spi_sck                (spi_sck),
        .spi_cs_n               (spi_cs_n),
        .spi_mosi               (spi_mosi),
        .spi_miso               (spi_miso),

        .fsm_start              (fsm_start),
        .fsm_keep_pe_value      (fsm_keep_pe_value),
        .fsm_tpu_full_percision (fsm_tpu_full_percision),
        .fsm_idle               (fsm_idle),
        .fsm_working            (fsm_working),
        .fsm_done               (fsm_done),

        .tpu_dim_m              (tpu_dim_m),
        .tpu_dim_n              (tpu_dim_n),
        .tpu_dim_k              (tpu_dim_k),
        .tpu_num_computation    (tpu_num_computation),

        .tpu_zero_point_a       (tpu_zero_point_a),
        .tpu_zero_point_b       (tpu_zero_point_b),
        .tpu_zero_point_c       (tpu_zero_point_c),

        .tpu_scale_factor       (tpu_scale_factor),
        .tpu_scale_shift        (tpu_scale_shift),

        .sc_mmio_ctrl           (1'b0),
        .sc_mmio_reg_addr       (4'b0),
        .sc_mmio_reg_rd         (1'b0),
        .sc_mmio_reg_wr         (1'b0),
        .sc_mmio_reg_wdata      (8'b0),
        .sc_mmio_reg_rdata      (/* unused */),
        .sc_mmio_reg_addr_valid (/* unused */),
        .sc_mmio_reg_writable   (/* unused */)
    );

    //=========================================================================
    // AXI Write Task
    //=========================================================================
    task axi_write(input logic [6:0] addr, input logic [31:0] data);
        int timeout;
        logic got_awready, got_wready;
        @(posedge master_clk);
        S_AXI_awaddr  <= addr;
        S_AXI_wdata   <= data;
        S_AXI_awprot  <= 3'd0;
        S_AXI_awvalid <= 1'b1;
        S_AXI_wstrb   <= 4'b1111;
        S_AXI_bready  <= 1'b0;

        wait(S_AXI_awvalid & S_AXI_awready);
        S_AXI_wvalid  <= 1'b1;
        @(posedge master_clk);
        S_AXI_awvalid = 1'b0;
        wait(S_AXI_wvalid & S_AXI_wready);
        @(posedge master_clk);
        S_AXI_wvalid  <= 1'b0;

        repeat($urandom_range(10, 4)) @(posedge master_clk);

        S_AXI_bready <= 1'b1;
        wait(S_AXI_bvalid & S_AXI_bready);
        @(posedge master_clk);
        S_AXI_bready <= 1'b0;
    endtask

    //=========================================================================
    // AXI Read Task
    //=========================================================================
    task axi_read(input logic [6:0] addr, output logic [31:0] data);
        int timeout;

        @(posedge master_clk);
        S_AXI_araddr  <= addr;
        S_AXI_arprot  <= 3'd0;
        S_AXI_arvalid <= 1'b1;
        S_AXI_rready  <= 1'b0;

        wait(S_AXI_arvalid & S_AXI_arready);
        @(posedge master_clk);
        S_AXI_arvalid <= 1'b0;

        repeat($urandom_range(10, 4)) @(posedge master_clk);
        S_AXI_rready <= 1'b1;
        wait(S_AXI_rvalid & S_AXI_rready);
        data <= S_AXI_rdata;
        @(posedge master_clk);
        S_AXI_rready <= 1'b0;
    endtask

    //=========================================================================
    // Random gap between AXI transactions (20-50 master_clk cycles)
    //=========================================================================
    task random_gap();
        repeat($urandom_range(50, 20)) @(posedge master_clk);
    endtask

    //=========================================================================
    // Wait for SPI master to be ready (tx_ready=1, busy=0)
    //=========================================================================
    task wait_master_ready();
        logic [31:0] status;
        do begin
            axi_read(M_ADDR_STATUS, status);
            random_gap();
        end while (!status[0]);   // bit[0] = tx_ready
    endtask

    //=========================================================================
    // Send a single SPI byte through master (drives one byte transfer)
    //=========================================================================
    task spi_send_byte(input logic [7:0] tx_byte, output logic [7:0] rx_byte);
        logic [31:0] rdata;
        wait_master_ready();
        axi_write(M_ADDR_TX_DATA, {24'h0, tx_byte});
        random_gap();
        wait_master_ready();   // wait for transfer to complete
        random_gap();
        axi_read(M_ADDR_RX_DATA, rdata);
        rx_byte = rdata[7:0];
    endtask

    //=========================================================================
    // Drive a 4-byte SPI frame: assert CS_N=0, send 4 bytes, deassert CS_N=1
    //=========================================================================
    task spi_frame(
        input  logic [7:0] tx0, tx1, tx2, tx3,
        output logic [7:0] rx0, rx1, rx2, rx3
    );
        // CS_N = 0 (assert)
        axi_write(M_ADDR_CONTROL, 32'h0);
        random_gap();

        spi_send_byte(tx0, rx0);
        random_gap();
        spi_send_byte(tx1, rx1);
        random_gap();
        spi_send_byte(tx2, rx2);
        random_gap();
        spi_send_byte(tx3, rx3);
        random_gap();

        // CS_N = 1 (deassert)
        axi_write(M_ADDR_CONTROL, 32'h1);
        random_gap();
    endtask

    //=========================================================================
    // SPI register write
    //=========================================================================
    task spi_write_reg(input logic [3:0] addr, input logic [7:0] data);
        logic [7:0] r0, r1, r2, r3;
        spi_frame({addr, CMD_WRITE}, 8'h00, data, 8'h00, r0, r1, r2, r3);
        if (r1 !== RESP_ACK)
            $display("    [WARN] write addr=0x%0h byte1=0x%02h (expected 0xFF)", addr, r1);
        if (r3 !== RESP_ACK)
            $display("    [WARN] write addr=0x%0h byte3=0x%02h (expected 0xFF)", addr, r3);
    endtask

    //=========================================================================
    // SPI register read
    //=========================================================================
    task spi_read_reg(input logic [3:0] addr, output logic [7:0] data);
        logic [7:0] r0, r1, r2, r3;
        spi_frame({addr, CMD_READ}, 8'h00, 8'h00, 8'h00, r0, r1, r2, r3);
        data = r1;
    endtask

    //=========================================================================
    // Check helper
    //=========================================================================
    task check(input string name, input logic [31:0] got, input logic [31:0] exp);
        if (got === exp)
            $display("  PASS %-30s = 0x%0h", name, got);
        else begin
            $display("  FAIL %-30s exp=0x%0h got=0x%0h", name, exp, got);
            errors++;
        end
    endtask

    //=========================================================================
    // Main
    //=========================================================================
    logic [7:0]  rd;
    logic [31:0] rd32;

    initial begin
        $display("=================================================================");
        $display("  TB: spi_slave_mmio_register_file with axi_spi_master in loop");
        $display("  CLKS_PER_HALF_BIT = 5 -> SCK = 10 MHz");
        $display("=================================================================");

        // Init AXI
        S_AXI_awaddr  = 0; S_AXI_awvalid = 0; S_AXI_wdata = 0;
        S_AXI_wvalid  = 0; S_AXI_wstrb   = 0; S_AXI_bready = 0;
        S_AXI_araddr  = 0; S_AXI_arvalid = 0; S_AXI_rready = 0;
        S_AXI_awprot  = 0; S_AXI_arprot  = 0;

        // Init slave-side stimulus
        arstn       = 0;
        fsm_idle    = 1;
        fsm_working = 0;
        fsm_done    = 0;
        errors      = 0;

        master_aresetn = 0;

        // Reset both clock domains
        repeat(10) @(posedge master_clk);
        master_aresetn = 1;

        repeat(5) @(posedge clk);
        arstn = 1;
        repeat(20) @(posedge clk);

        // Initialize CS_N high (deasserted)
        axi_write(M_ADDR_CONTROL, 32'h1);
        random_gap();

        //----------------------------------------------------------------------
        // Test 1: Dimension registers
        //----------------------------------------------------------------------
        $display("\n[Test 1] Dimension registers");
        spi_write_reg(ADDR_DIM_M,           8'h08);
        spi_write_reg(ADDR_DIM_N,           8'h10);
        spi_write_reg(ADDR_DIM_K,           8'h08);
        spi_write_reg(ADDR_NUM_COMPUTATION, 8'h01);

        spi_read_reg (ADDR_DIM_M,           rd);  check("DIM_M readback", rd, 8'h08);
        spi_read_reg (ADDR_DIM_N,           rd);  check("DIM_N readback", rd, 8'h10);
        spi_read_reg (ADDR_DIM_K,           rd);  check("DIM_K readback", rd, 8'h08);
        spi_read_reg (ADDR_NUM_COMPUTATION, rd);  check("NUM_COMP readback", rd, 8'h01);

        repeat(10) @(posedge clk);
        check("tpu_dim_m output",           tpu_dim_m,           7'h08);
        check("tpu_dim_n output",           tpu_dim_n,           7'h10);
        check("tpu_dim_k output",           tpu_dim_k,           7'h08);
        check("tpu_num_computation output", tpu_num_computation, 7'h01);

        //----------------------------------------------------------------------
        // Test 2: Zero-point registers
        //----------------------------------------------------------------------
        $display("\n[Test 2] Zero-point registers");
        spi_write_reg(ADDR_ZP_A, 8'hAA);
        spi_write_reg(ADDR_ZP_B, 8'hBB);
        spi_write_reg(ADDR_ZP_C, 8'hCC);
        repeat(10) @(posedge clk);
        check("tpu_zero_point_a", tpu_zero_point_a, 8'hAA);
        check("tpu_zero_point_b", tpu_zero_point_b, 8'hBB);
        check("tpu_zero_point_c", tpu_zero_point_c, 8'hCC);

        //----------------------------------------------------------------------
        // Test 3: Scale factor / shift
        //----------------------------------------------------------------------
        $display("\n[Test 3] Scale factor / shift");
        spi_write_reg(ADDR_SCALE_LO,    8'h34);
        spi_write_reg(ADDR_SCALE_HI,    8'h12);
        spi_write_reg(ADDR_SCALE_SHIFT, 8'h05);
        repeat(10) @(posedge clk);
        check("tpu_scale_factor", tpu_scale_factor, 16'h1234);
        check("tpu_scale_shift",  tpu_scale_shift,   5'h05);

        //----------------------------------------------------------------------
        // Test 4: CONTROL.start triggers fsm_start; fsm_done clears it
        //----------------------------------------------------------------------
        $display("\n[Test 4] CONTROL.start -> fsm_start, fsm_done -> clear");
        spi_write_reg(ADDR_CONTROL, 8'h01);
        repeat(10) @(posedge clk);
        check("fsm_start asserted", fsm_start, 1'b1);

        @(posedge clk);
        fsm_done <= 1'b1;
        @(posedge clk);
        fsm_done <= 1'b0;
        repeat(10) @(posedge clk);
        check("fsm_start cleared after fsm_done", fsm_start, 1'b0);

        //----------------------------------------------------------------------
        // Test 5: STATUS register reflects fsm_idle / fsm_working
        //----------------------------------------------------------------------
        $display("\n[Test 5] STATUS register");
        fsm_idle    <= 1'b0;
        fsm_working <= 1'b1;
        repeat(10) @(posedge clk);
        spi_read_reg(ADDR_STATUS, rd);
        check("STATUS while working [1:0]", rd[1:0], 2'b10);

        fsm_idle    <= 1'b1;
        fsm_working <= 1'b0;
        repeat(10) @(posedge clk);
        spi_read_reg(ADDR_STATUS, rd);
        check("STATUS while idle [1:0]", rd[1:0], 2'b01);

        //----------------------------------------------------------------------
        // Test 6: Back-to-back stress
        //----------------------------------------------------------------------
        $display("\n[Test 6] Back-to-back stress");
        for (int i = 0; i < 8; i++) begin
            logic [7:0] expected, actual;
            expected = 8'(8'hF0 + i);
            spi_write_reg(ADDR_ZP_A, expected);
            spi_read_reg (ADDR_ZP_A, actual);
            check($sformatf("Back-to-back iter %0d", i), actual, expected);
        end

        repeat(50) @(posedge master_clk);
        $display("\n=================================================================");
        if (errors == 0) $display("  ALL TESTS PASSED!");
        else             $display("  FAILED: %0d error(s)", errors);
        $display("=================================================================");
        $finish;
    end

    initial begin #500_000_000; $display("TIMEOUT"); $finish; end

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule
