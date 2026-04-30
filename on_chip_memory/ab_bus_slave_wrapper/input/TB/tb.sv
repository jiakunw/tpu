///////////////////////////////////////////////////////////////////////////////
// tb.sv - tpu_bus_master + bus_slave_sram_ab
//
// DUT structure:
//   u_master  : tpu_bus_master   (AXI-Lite 100MHz -> bus signals 10MHz)
//   u_dut     : bus_slave_sram_ab (bus_slave_ab + sram_wrapper_ab x2)
//
// AB write path only -- no bias.
// DATA_AB AXI word: [7:0]=A_byte  [15:8]=B_byte  (upper 16 bits = 0)
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb;

    localparam MASTER_CLK_PERIOD = 10;    // 100 MHz AXI master
    localparam BUS_CLK_PERIOD    = 25;   //  10 MHz bus / TPU
    localparam MAX_PAIRS         = 512;   // max bytes per matrix

    logic master_clk, bus_clk, aresetn;
    logic bus_rst_n;

    initial master_clk = 0;
    always #(MASTER_CLK_PERIOD/2) master_clk = ~master_clk;
    initial bus_clk = 0;
    always #(BUS_CLK_PERIOD/2) bus_clk = ~bus_clk;

    // -- AXI-Lite signals ---------------------------------------------------
    logic [6:0]  S_AXI_awaddr;  logic S_AXI_awvalid; logic S_AXI_awready; logic [2:0] S_AXI_awprot;
    logic [31:0] S_AXI_wdata;   logic [3:0] S_AXI_wstrb; logic S_AXI_wvalid; logic S_AXI_wready;
    logic [1:0]  S_AXI_bresp;   logic S_AXI_bvalid;  logic S_AXI_bready;
    logic [6:0]  S_AXI_araddr;  logic S_AXI_arvalid; logic S_AXI_arready; logic [2:0] S_AXI_arprot;
    logic [31:0] S_AXI_rdata;   logic [1:0] S_AXI_rresp; logic S_AXI_rvalid; logic S_AXI_rready;

    // -- Bus channel signals (master -> DUTs) -------------------------------
    logic        chab_start, chab_wr;
    logic [7:0]  chab_wdata_a, chab_wdata_b;
    logic [7:0]  chab_wdata_bias_unused;   // master still drives this; leave dangling
    logic        chc_start, chc_rd;
    logic [7:0]  chc_rdata;
    assign chc_rdata = 8'h00;   // C channel not used in this tb

    // -- TPU read ports -----------------------------------------------------
    logic        tpu_a_re;
    logic [8:0]  tpu_a_addr;
    logic [63:0] tpu_a_dout;

    logic        tpu_b_re;
    logic [8:0]  tpu_b_addr;
    logic [63:0] tpu_b_dout;

    // -- MMIO dim / control -------------------------------------------------
    logic [7:0]  dim_m, dim_n, dim_k;
    logic [7:0]  num_computation;

    // -- Test data ----------------------------------------------------------
    logic [7:0]  a_data [0:MAX_PAIRS-1];
    logic [7:0]  b_data [0:MAX_PAIRS-1];
    logic [63:0] got_a, got_b;
    int          errors, w, b, idx;
    logic [31:0] rdata;

    //=========================================================================
    // DUT: tpu_bus_master
    //=========================================================================
    tpu_bus_master #(
        .C_S_AXI_DATA_WIDTH (32),
        .C_S_AXI_ADDR_WIDTH (7)
    ) u_master (
        .S_AXI_ACLK    (master_clk),   .S_AXI_ARESETN  (aresetn),
        .S_AXI_AWADDR  (S_AXI_awaddr), .S_AXI_AWVALID  (S_AXI_awvalid), .S_AXI_AWREADY (S_AXI_awready),
        .S_AXI_WDATA   (S_AXI_wdata),  .S_AXI_WSTRB    (S_AXI_wstrb),   .S_AXI_WVALID  (S_AXI_wvalid),  .S_AXI_WREADY (S_AXI_wready),
        .S_AXI_BRESP   (S_AXI_bresp),  .S_AXI_BVALID   (S_AXI_bvalid),  .S_AXI_BREADY  (S_AXI_bready),
        .S_AXI_ARADDR  (S_AXI_araddr), .S_AXI_ARVALID  (S_AXI_arvalid), .S_AXI_ARREADY (S_AXI_arready),
        .S_AXI_RDATA   (S_AXI_rdata),  .S_AXI_RRESP    (S_AXI_rresp),   .S_AXI_RVALID  (S_AXI_rvalid),  .S_AXI_RREADY (S_AXI_rready),
        .BUS_CLK       (bus_clk),
        .BUS_RST_N     (bus_rst_n),
        .CHAB_START      (chab_start),
        .CHAB_WDATA_A    (chab_wdata_a),
        .CHAB_WDATA_B    (chab_wdata_b),
        .CHAB_WDATA_BIAS (chab_wdata_bias_unused),
        .CHAB_WR         (chab_wr),
        .CHC_START       (chc_start),
        .CHC_RDATA       (chc_rdata),
        .CHC_RD          (chc_rd)
    );

    //=========================================================================
    // DUT: bus_slave_sram_ab (bus_slave_ab + sram_wrapper_ab x 2)
    //=========================================================================
    bus_slave_sram_ab #(
        .AW    (9),
        .DW    (8),
        .DIM_W (8)
    ) u_dut (
        .clk                  (bus_clk),
        .rstn                 (bus_rst_n),

        .mmio_dim_m           (dim_m),
        .mmio_dim_n           (dim_n),
        .mmio_dim_k           (dim_k),
        .mmio_num_computation (num_computation),

        // AB write interface (renamed: pin_* -> chip_*)
        .chip_chab_start      (chab_start),
        .chip_chab_wdata_a    (chab_wdata_a),
        .chip_chab_wdata_b    (chab_wdata_b),
        .chip_chab_wr         (chab_wr),

        // TPU read ports
        .tpu_a_re             (tpu_a_re),
        .tpu_a_addr           (tpu_a_addr),
        .tpu_a_dout           (tpu_a_dout),

        .tpu_b_re             (tpu_b_re),
        .tpu_b_addr           (tpu_b_addr),
        .tpu_b_dout           (tpu_b_dout),

        // Scan-chain disabled for functional sim:
        //   sc_*_mem_ctrl = 0  -> mux selects system path
        //   sc_*_cen/wen  = 1  -> idle (active-low SRAM control)
        .sc_a_mem_ctrl        (1'b0),
        .sc_a_cen             (1'b1),
        .sc_a_wen             (1'b1),
        .sc_a_addr            (9'b0),
        .sc_a_din             (64'b0),
        .sc_a_mem_dout        (/* unused */),

        .sc_b_mem_ctrl        (1'b0),
        .sc_b_cen             (1'b1),
        .sc_b_wen             (1'b1),
        .sc_b_addr            (9'b0),
        .sc_b_din             (64'b0),
        .sc_b_mem_dout        (/* unused */)
    );

    //=========================================================================
    // AXI tasks
    //=========================================================================
    task automatic axi_write(input logic [6:0] addr, input logic [31:0] data);
        @(posedge master_clk);
        S_AXI_awaddr  <= addr;    S_AXI_wdata   <= data;
        S_AXI_awprot  <= 3'd0;    S_AXI_awvalid <= 1'b1;
        S_AXI_wstrb   <= 4'hF;    S_AXI_bready  <= 1'b0;
        wait(S_AXI_awvalid & S_AXI_awready);
        S_AXI_wvalid  <= 1'b1;
        @(posedge master_clk);
        S_AXI_awvalid = 1'b0;
        wait(S_AXI_wvalid & S_AXI_wready);
        @(posedge master_clk);
        S_AXI_wvalid  <= 1'b0;
        repeat($urandom_range(10, 4)) @(posedge master_clk);
        S_AXI_bready  <= 1'b1;
        wait(S_AXI_bvalid & S_AXI_bready);
        @(posedge master_clk);
        S_AXI_bready  <= 1'b0;
    endtask

    task automatic axi_read(input logic [6:0] addr, output logic [31:0] data);
        @(posedge master_clk);
        S_AXI_araddr  <= addr;    S_AXI_arprot  <= 3'd0;
        S_AXI_arvalid <= 1'b1;   S_AXI_rready  <= 1'b0;
        wait(S_AXI_arvalid & S_AXI_arready);
        @(posedge master_clk);
        S_AXI_arvalid <= 1'b0;
        repeat($urandom_range(10, 4)) @(posedge master_clk);
        S_AXI_rready  <= 1'b1;
        wait(S_AXI_rvalid & S_AXI_rready);
        data = S_AXI_rdata;
        @(posedge master_clk);
        S_AXI_rready  <= 1'b0;
    endtask

    task automatic poll_ready_ab();
        logic [31:0] status;
        do begin axi_read(7'h00, status); end while (!status[0]);
    endtask

    task automatic tpu_read_a(input logic [8:0] word_addr, output logic [63:0] data);
        @(posedge bus_clk);
        tpu_a_re <= 1'b1; tpu_a_addr <= word_addr;
        @(posedge bus_clk); @(negedge bus_clk);
        data = tpu_a_dout;
        @(posedge bus_clk);
        tpu_a_re <= 1'b0;
    endtask

    task automatic tpu_read_b(input logic [8:0] word_addr, output logic [63:0] data);
        @(posedge bus_clk);
        tpu_b_re <= 1'b1; tpu_b_addr <= word_addr;
        @(posedge bus_clk); @(negedge bus_clk);
        data = tpu_b_dout;
        @(posedge bus_clk);
        tpu_b_re <= 1'b0;
    endtask

    //=========================================================================
    // run_test(M, N, K)
    //
    // Writes A (M*N bytes) and B (N*K bytes) via DATA_AB,
    // then reads back via TPU ports and verifies.
    //
    // DATA_AB AXI word: [7:0]=A_byte  [15:8]=B_byte  (upper 16 bits zero)
    //=========================================================================
    task automatic run_test(input int M, N, K);
        int n_a, n_b, n_max, n_words_a, n_words_b;
        logic [63:0] exp_a, exp_b;

        n_a       = M * N;
        n_b       = N * K;
        n_max     = (n_a > n_b) ? n_a : n_b;
        n_words_a = (n_a + 7) / 8;
        n_words_b = (n_b + 7) / 8;

        $display("\n=== run_test M=%0d N=%0d K=%0d  A=%0d B=%0d bytes ===",
                 M, N, K, n_a, n_b);

        // Generate test data
        for (int i = 0; i < MAX_PAIRS; i++) begin
            a_data[i] = (i < n_a) ? 8'($urandom_range(0, 200)) : 8'h00;
            b_data[i] = (i < n_b) ? 8'($urandom_range(0, 200)) : 8'h00;
        end

        // bus_slave_ab expects TILE counts (dim/8), not element counts.
        // It internally shifts left by 3 to get element counts.
        dim_m           = 8'(M/8);
        dim_n           = 8'(N/8);
        dim_k           = 8'(K/8);
        num_computation = 8'd1;
        repeat(2) @(posedge bus_clk);

        // START_AB
        poll_ready_ab();
        axi_write(7'h04, 32'h1);
        poll_ready_ab();

        // Write n_max AB pairs (zero-pad the shorter matrix)
        for (int i = 0; i < n_max; i++) begin
            logic [7:0] a_b, b_b;
            a_b = (i < n_a) ? a_data[i] : 8'h00;
            b_b = (i < n_b) ? b_data[i] : 8'h00;
            poll_ready_ab();
            axi_write(7'h08, {16'h0000, b_b, a_b});
            repeat($urandom_range(20, 10)) @(posedge bus_clk);
        end
        poll_ready_ab();
        repeat(20) @(posedge bus_clk);

        // -- Verify SRAM_A --------------------------------------------------
        $display("  Verifying SRAM_A (%0d words)...", n_words_a);
        for (w = 0; w < n_words_a; w++) begin
            exp_a = 64'h0;
            for (b = 0; b < 8; b++) begin
                idx = w*8 + b;
                exp_a[b*8 +: 8] = (idx < n_a) ? a_data[idx] : 8'h00;
            end
            tpu_read_a(9'(w), got_a);
            if (got_a === exp_a)
                $display("    PASS A[%0d] = 0x%016h", w, got_a);
            else begin
                $display("    FAIL A[%0d]: exp=0x%016h got=0x%016h", w, exp_a, got_a);
                errors++;
            end
        end

        // -- Verify SRAM_B --------------------------------------------------
        $display("  Verifying SRAM_B (%0d words)...", n_words_b);
        for (w = 0; w < n_words_b; w++) begin
            exp_b = 64'h0;
            for (b = 0; b < 8; b++) begin
                idx = w*8 + b;
                exp_b[b*8 +: 8] = (idx < n_b) ? b_data[idx] : 8'h00;
            end
            tpu_read_b(9'(w), got_b);
            if (got_b === exp_b)
                $display("    PASS B[%0d] = 0x%016h", w, got_b);
            else begin
                $display("    FAIL B[%0d]: exp=0x%016h got=0x%016h", w, exp_b, got_b);
                errors++;
            end
        end
    endtask

    //=========================================================================
    // Main
    //=========================================================================
    initial begin
        $display("=================================================================");
        $display("  TB: tpu_bus_master + bus_slave_sram_ab  (AB only, no bias)");
        $display("=================================================================");

        // Init AXI
        S_AXI_awaddr=0; S_AXI_awvalid=0; S_AXI_wdata=0;
        S_AXI_wvalid=0; S_AXI_wstrb=0;   S_AXI_bready=0;
        S_AXI_araddr=0; S_AXI_arvalid=0; S_AXI_rready=0;
        S_AXI_awprot=0; S_AXI_arprot=0;
        // Init TPU read ports
        tpu_a_re=0; tpu_a_addr=0;
        tpu_b_re=0; tpu_b_addr=0;
        // Init dims
        dim_m=1; dim_n=1; dim_k=1; num_computation=1;
        errors = 0;

        // Reset
        aresetn = 0;
        repeat($urandom_range(10, 5)) @(posedge master_clk);
        aresetn = 1;
        repeat($urandom_range(10, 5)) @(posedge master_clk);

        // -- Test cases ------------------------------------------------------
        // Dims must be multiples of 8 for TPU tile alignment.
        // SRAM_A: M*N <= 4096, SRAM_B: N*K <= 4096
        run_test( 8,  8,  8);
        run_test(16,  8,  8);
        run_test( 8, 16,  8);
        run_test(16, 16,  8);
        run_test(32,  8,  8);
        run_test( 8, 24,  8);

        repeat(10) @(posedge master_clk);
        $display("\n=================================================================");
        if (errors == 0) $display("  ALL TESTS PASSED!");
        else             $display("  FAILED: %0d error(s)", errors);
        $display("=================================================================");
        $finish;
    end

    initial begin #100_000_000; $display("TIMEOUT"); $finish; end

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule
