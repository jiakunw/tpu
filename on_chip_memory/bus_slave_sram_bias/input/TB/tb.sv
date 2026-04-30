///////////////////////////////////////////////////////////////////////////////
// tb.sv - tpu_bus_master + bus_slave_sram_bias
//
// DUT structure:
//   u_master  : tpu_bus_master       (AXI-Lite 100MHz -> bus signals 10MHz)
//   u_dut     : bus_slave_sram_bias  (bus_slave_bias + bias_wrapper)
//
// Test path: AXI DATA_AB[23:16]=bias_byte -> master.CHAB_WDATA_BIAS
//            -> bus_slave_bias counter -> bias_wrapper 4-byte accumulator
//            -> sram01 -> TPU read -> verify
//
// DATA_AB AXI word: [7:0]=A_unused  [15:8]=B_unused  [23:16]=BIAS_byte
//
// Note on NCOMP:
//   bus_slave_bias counts cnt_bias 0..NCOMP*M*4-1 sequentially without
//   wrapping. So NCOMP*M total words are written to SRAM word addresses
//   0..NCOMP*M-1, NOT overwriting earlier blocks.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb;

    localparam MASTER_CLK_PERIOD = 10;    // 100 MHz AXI master
    localparam BUS_CLK_PERIOD    = 100;   //  10 MHz bus / TPU
    localparam MAX_BYTES         = 2048;  // bias SRAM = 512 words = 2048 bytes

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

    // -- Bus channel signals (master -> DUT) --------------------------------
    logic        chab_start, chab_wr;
    logic [7:0]  chab_wdata_a_unused;
    logic [7:0]  chab_wdata_b_unused;
    logic [7:0]  chab_wdata_bias;
    logic        chc_start, chc_rd;
    logic [7:0]  chc_rdata;
    assign chc_rdata = 8'h00;

    // -- TPU bias read port -------------------------------------------------
    logic        tpu_bias_re;
    logic [8:0]  tpu_bias_addr;
    logic [31:0] tpu_bias_dout;

    // -- MMIO dim / control -------------------------------------------------
    logic [7:0]  dim_m;
    logic [7:0]  num_computation;

    // -- Test data ----------------------------------------------------------
    logic [7:0]  bias_data [0:MAX_BYTES-1];
    logic [31:0] got_bias;
    int          errors, w;
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
        .CHAB_WDATA_A    (chab_wdata_a_unused),
        .CHAB_WDATA_B    (chab_wdata_b_unused),
        .CHAB_WDATA_BIAS (chab_wdata_bias),
        .CHAB_WR         (chab_wr),
        .CHC_START       (chc_start),
        .CHC_RDATA       (chc_rdata),
        .CHC_RD          (chc_rd)
    );

    //=========================================================================
    // DUT: bus_slave_sram_bias (bus_slave_bias + bias_wrapper)
    //=========================================================================
    bus_slave_sram_bias #(
        .AW    (9),
        .DW    (8),
        .DIM_W (8)
    ) u_dut (
        .clk                  (bus_clk),
        .rstn                 (bus_rst_n),

        .mmio_dim_m           (dim_m),
        .mmio_num_computation (num_computation),

        .chip_chab_start      (chab_start),
        .chip_chab_wdata_bias (chab_wdata_bias),
        .chip_chab_wr         (chab_wr),

        .tpu_bias_re          (tpu_bias_re),
        .tpu_bias_addr        (tpu_bias_addr),
        .tpu_bias_dout        (tpu_bias_dout),

        .sc_mem_ctrl          (1'b0),
        .sc_cen               (1'b1),
        .sc_wen               (1'b1),
        .sc_addr              (9'b0),
        .sc_din               (32'b0),
        .sc_mem_dout          (/* unused */)
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

    task automatic tpu_read_bias(input logic [8:0] word_addr, output logic [31:0] data);
        @(posedge bus_clk);
        tpu_bias_re <= 1'b1; tpu_bias_addr <= word_addr;
        @(posedge bus_clk); @(negedge bus_clk);
        data = tpu_bias_dout;
        @(posedge bus_clk);
        tpu_bias_re <= 1'b0;
    endtask

    //=========================================================================
    // run_test(M, NCOMP)
    //
    // Sends NCOMP*M*4 bias bytes via DATA_AB[23:16]. The slave fills SRAM
    // word addresses 0..NCOMP*M-1 sequentially:
    //   word[w] = {bias_data[w*4+3], bias_data[w*4+2],
    //              bias_data[w*4+1], bias_data[w*4+0]}
    // Total verified words = NCOMP * M.
    //=========================================================================
    task automatic run_test(input int M, input int NCOMP);
        int          n_bias_bytes;
        int          n_total_words;
        int          base;
        logic [31:0] exp_bias;

        n_bias_bytes  = NCOMP * M * 4;
        n_total_words = NCOMP * M;

        $display("\n=== run_test M=%0d NCOMP=%0d  bias_bytes=%0d  total_words=%0d ===",
                 M, NCOMP, n_bias_bytes, n_total_words);

        // Generate test data
        for (int i = 0; i < MAX_BYTES; i++) begin
            bias_data[i] = (i < n_bias_bytes) ? 8'($urandom_range(0, 255)) : 8'h00;
        end

        dim_m           = 8'(M/8);
        num_computation = 8'(NCOMP);
        repeat(2) @(posedge bus_clk);

        // START_AB
        poll_ready_ab();
        axi_write(7'h04, 32'h1);
        poll_ready_ab();

        // Send bias bytes via DATA_AB[23:16]
        for (int i = 0; i < n_bias_bytes; i++) begin
            poll_ready_ab();
            axi_write(7'h08, {8'h00, bias_data[i], 16'h0000});
            repeat($urandom_range(20, 10)) @(posedge bus_clk);
        end
        poll_ready_ab();
        repeat(20) @(posedge bus_clk);

        // -- Verify all NCOMP*M words --------------------------------------
        $display("  Verifying BIAS SRAM (%0d words)...", n_total_words);
        for (w = 0; w < n_total_words; w++) begin
            base = w * 4;
            exp_bias = {bias_data[base+3], bias_data[base+2],
                        bias_data[base+1], bias_data[base+0]};
            tpu_read_bias(9'(w), got_bias);
            if (got_bias === exp_bias)
                $display("    PASS BIAS[%0d] = 0x%08h", w, got_bias);
            else begin
                $display("    FAIL BIAS[%0d]: exp=0x%08h got=0x%08h", w, exp_bias, got_bias);
                errors++;
            end
        end
    endtask

    //=========================================================================
    // Main
    //=========================================================================
    initial begin
        $display("=================================================================");
        $display("  TB: tpu_bus_master + bus_slave_sram_bias  (bias path only)");
        $display("=================================================================");

        // Init AXI
        S_AXI_awaddr=0; S_AXI_awvalid=0; S_AXI_wdata=0;
        S_AXI_wvalid=0; S_AXI_wstrb=0;   S_AXI_bready=0;
        S_AXI_araddr=0; S_AXI_arvalid=0; S_AXI_rready=0;
        S_AXI_awprot=0; S_AXI_arprot=0;
        // Init TPU read port
        tpu_bias_re=0; tpu_bias_addr=0;
        // Init dims
        dim_m=1; num_computation=1;
        errors = 0;

        // Reset
        aresetn = 0;
        repeat($urandom_range(10, 5)) @(posedge master_clk);
        aresetn = 1;
        repeat($urandom_range(10, 5)) @(posedge master_clk);

        // -- Test cases ------------------------------------------------------
        // M must be a multiple of 8 (dim_m is in tile units).
        // NCOMP fixed at 1 per teammate's design decision.
        run_test(  8, 1);
        run_test( 16, 1);
        run_test( 32, 1);
        run_test( 64, 1);
        run_test(128, 1);
        run_test(256, 1);

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
