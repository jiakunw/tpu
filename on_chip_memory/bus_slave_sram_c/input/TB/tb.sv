///////////////////////////////////////////////////////////////////////////////
// tb.sv
//
// Testbench: tpu_bus_master <-> bus_slave_sram_c
//
// DUT structure:
//   u_master  : tpu_bus_master    (AXI-Lite 100MHz -> bus signals 10MHz)
//   u_dut     : bus_slave_sram_c  (bus_slave_c + sram_wrapper_c, sram00 512x64)
//
// Tests:
//   1. TPU writes N_WORDS 64-bit words into SRAM_C via tpu_c_we/addr/din
//   2. CPU reads back via CHC (byte by byte through DATA_C), verifies data
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb;

    localparam MASTER_CLK_PERIOD = 10;   // 100 MHz AXI master
    localparam BUS_CLK_PERIOD    = 100;  //  10 MHz bus / TPU
    localparam N_WORDS           = 8;    // 64-bit words to write/read

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

    // -- Bus signals (AB unused / dangling for this tb) --------------------
    logic        chab_start, chab_wr;
    logic [7:0]  chab_wdata_a_unused;
    logic [7:0]  chab_wdata_b_unused;
    logic [7:0]  chab_wdata_bias_unused;

    // -- CHC bus (master <-> bus_slave_sram_c) -----------------------------
    logic        chc_start, chc_rd;
    logic [7:0]  chc_rdata;

    // -- TPU C-write port (TPU -> SRAM_C) ----------------------------------
    logic        tpu_c_we;
    logic [8:0]  tpu_c_addr;
    logic [63:0] tpu_c_din;

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
        .CHAB_WDATA_BIAS (chab_wdata_bias_unused),
        .CHAB_WR         (chab_wr),
        .CHC_START       (chc_start),
        .CHC_RDATA       (chc_rdata),
        .CHC_RD          (chc_rd)
    );

    //=========================================================================
    // DUT: bus_slave_sram_c (bus_slave_c + sram_wrapper_c)
    //=========================================================================
    bus_slave_sram_c #(
        .AW (9),
        .DW (8)
    ) u_dut (
        .clk             (bus_clk),
        .rstn            (bus_rst_n),

        .chip_chc_start  (chc_start),
        .chip_chc_rd     (chc_rd),
        .chip_chc_rdata  (chc_rdata),

        .tpu_c_we        (tpu_c_we),
        .tpu_c_addr      (tpu_c_addr),
        .tpu_c_din       (tpu_c_din),

        // Scan-chain disabled for functional sim
        .sc_mem_ctrl     (1'b0),
        .sc_cen          (1'b1),
        .sc_wen          (1'b1),
        .sc_addr         (9'b0),
        .sc_din          (64'b0),
        .sc_mem_dout     (/* unused */)
    );

    //=========================================================================
    // AXI Tasks
    //=========================================================================
    task axi_write(input logic [6:0] addr, input logic [31:0] data);
        @(posedge master_clk);
        S_AXI_awaddr  <= addr;    S_AXI_wdata   <= data;
        S_AXI_awprot  <= 3'd0;   S_AXI_awvalid <= 1'b1;
        S_AXI_wstrb   <= 4'b1111; S_AXI_bready  <= 1'b0;
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

    task axi_read(input logic [6:0] addr, output logic [31:0] data);
        @(posedge master_clk);
        S_AXI_araddr  <= addr;   S_AXI_arprot  <= 3'd0;
        S_AXI_arvalid <= 1'b1;  S_AXI_rready  <= 1'b0;
        wait(S_AXI_arvalid & S_AXI_arready);
        @(posedge master_clk);
        S_AXI_arvalid <= 1'b0;
        repeat($urandom_range(10, 4)) @(posedge master_clk);
        S_AXI_rready  <= 1'b1;
        wait(S_AXI_rvalid & S_AXI_rready);
        data <= S_AXI_rdata;
        @(posedge master_clk);
        S_AXI_rready  <= 1'b0;
    endtask

    task poll_ready_c();
        logic [31:0] status;
        do begin axi_read(7'h00, status); end while (!status[1]); // bit[1]=READY_C
    endtask

    //=========================================================================
    // TPU write task (bus_clk domain)
    //=========================================================================
    task tpu_write_c(input logic [8:0] word_addr, input logic [63:0] data);
        @(posedge bus_clk);
        tpu_c_we   <= 1'b1;
        tpu_c_addr <= word_addr;
        tpu_c_din  <= data;
        @(posedge bus_clk);
        tpu_c_we   <= 1'b0;
    endtask

    //=========================================================================
    // Test Data
    //=========================================================================
    logic [63:0] c_data [0:N_WORDS-1];

    logic [31:0] rdata;
    logic [7:0]  got_byte;
    int errors;

    initial begin
        $display("==============================================");
        $display("  TB: tpu_bus_master + bus_slave_sram_c");
        $display("==============================================");

        S_AXI_awaddr=0; S_AXI_awvalid=0; S_AXI_wdata=0;
        S_AXI_wvalid=0; S_AXI_wstrb=0;  S_AXI_bready=0;
        S_AXI_araddr=0; S_AXI_arvalid=0; S_AXI_rready=0;
        S_AXI_awprot=0; S_AXI_arprot=0;
        tpu_c_we=0; tpu_c_addr=0; tpu_c_din=0;
        errors = 0;

        // Build test data: word[i] = 0xC0+i*8+b in each byte slot
        for (int i = 0; i < N_WORDS; i++)
            for (int b = 0; b < 8; b++)
                c_data[i][b*8 +: 8] = 8'hC0 + i*8 + b;

        aresetn = 0;
        repeat(10) @(posedge master_clk);
        aresetn = 1;
        repeat(10) @(posedge master_clk);

        //----------------------------------------------------------------------
        // Step 1: TPU writes N_WORDS into SRAM_C
        //----------------------------------------------------------------------
        $display("\n[Step 1] TPU writes %0d words into SRAM_C", N_WORDS);
        for (int w = 0; w < N_WORDS; w++) begin
            tpu_write_c(w, c_data[w]);
            $display("  word[%0d] = 0x%016h", w, c_data[w]);
        end
        repeat(5) @(posedge bus_clk);
        $display("  TPU write done");

        //----------------------------------------------------------------------
        // Step 2: CPU reads via CHC (START_C + poll + read byte by byte)
        //----------------------------------------------------------------------
        $display("\n[Step 2] CPU reads via CHC");

        poll_ready_c();
        axi_write(7'h04, 32'h2);  // START[1] = START_C
        poll_ready_c();
        $display("  START_C acked");

        begin : read_loop
        logic [7:0] exp_byte;
        for (int w = 0; w < N_WORDS; w++) begin
            for (int b = 0; b < 8; b++) begin
                exp_byte = c_data[w][(7-b)*8 +: 8];   // C path is MSB-first

                repeat($urandom_range(100, 50)) @(posedge master_clk);

                // Write DATA_C (0x0C) to trigger CHC_RD
                poll_ready_c();
                axi_write(7'h0C, 32'h0);
                poll_ready_c();

                repeat($urandom_range(100, 50)) @(posedge master_clk);

                // Read DATA_C to get the byte
                axi_read(7'h0C, rdata);
                got_byte = rdata[7:0];

                if (got_byte === exp_byte)
                    $display("  PASS word[%0d] byte[%0d] = 0x%02h", w, b, got_byte);
                else begin
                    $display("  FAIL word[%0d] byte[%0d]: exp=0x%02h got=0x%02h",
                             w, b, exp_byte, got_byte);
                    errors++;
                end
            end
        end
        end : read_loop

        repeat(10) @(posedge master_clk);
        $display("\n==============================================");
        if (errors == 0) $display("  ALL TESTS PASSED");
        else             $display("  FAILED: %0d error(s)", errors);
        $display("==============================================\n");
        $finish;
    end

    initial begin #10_000_000; $display("TIMEOUT"); $finish; end

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule
