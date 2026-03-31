///////////////////////////////////////////////////////////////////////////////
// tb.sv
//
// Testbench: tpu_bus_master <-> bus_slave_ab <-> sram_wrapper x2
//
// Tests:
//   1. START_AB: poll READY_AB, send START, poll READY_AB again
//   2. Write N byte-pairs via DATA_AB, poll READY_AB between each
//   3. Readback via TPU port (sram_wrapper tpu_re) to verify data
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb;

    //=========================================================================
    // Parameters
    //=========================================================================
    localparam MASTER_CLK_PERIOD = 10;   // 100 MHz
    localparam BUS_CLK_PERIOD    = 100;  // 10 MHz
    localparam N_PAIRS           = 16;   // byte pairs to write (2 full 64-bit words each)

    //=========================================================================
    // Clocks & Reset
    //=========================================================================
    logic master_clk;
    logic bus_clk;
    logic aresetn;

    initial master_clk = 0;
    always #(MASTER_CLK_PERIOD/2) master_clk = ~master_clk;

    initial bus_clk = 0;
    always #(BUS_CLK_PERIOD/2) bus_clk = ~bus_clk;

    //=========================================================================
    // AXI-Lite Signals
    //=========================================================================
    logic [6:0]  S_AXI_awaddr;
    logic        S_AXI_awvalid;
    logic        S_AXI_awready;
    logic [2:0]  S_AXI_awprot;

    logic [31:0] S_AXI_wdata;
    logic [3:0]  S_AXI_wstrb;
    logic        S_AXI_wvalid;
    logic        S_AXI_wready;

    logic [1:0]  S_AXI_bresp;
    logic        S_AXI_bvalid;
    logic        S_AXI_bready;

    logic [6:0]  S_AXI_araddr;
    logic        S_AXI_arvalid;
    logic        S_AXI_arready;
    logic [2:0]  S_AXI_arprot;

    logic [31:0] S_AXI_rdata;
    logic [1:0]  S_AXI_rresp;
    logic        S_AXI_rvalid;
    logic        S_AXI_rready;

    //=========================================================================
    // Bus Interface Signals
    //=========================================================================
    logic        bus_rst_n;
    logic        chab_start;
    logic [7:0]  chab_wdata_a;
    logic [7:0]  chab_wdata_b;
    logic        chab_wr;

    // C bus (not tested here, tie off)
    logic        chc_start;
    logic [7:0]  chc_rdata;
    logic        chc_rd;
    assign chc_rdata = 8'h00;

    //=========================================================================
    // bus_slave_ab <-> sram_wrapper wires
    //=========================================================================
    logic        sram_a_we, sram_a_re;
    logic [11:0] sram_a_addr;
    logic [7:0]  sram_a_din, sram_a_dout;
    logic        sram_a_dout_valid;

    logic        sram_b_we, sram_b_re;
    logic [11:0] sram_b_addr;
    logic [7:0]  sram_b_din, sram_b_dout;
    logic        sram_b_dout_valid;

    // TPU readback ports
    logic        tpu_a_we, tpu_a_re;
    logic [8:0]  tpu_a_addr;
    logic [63:0] tpu_a_din, tpu_a_dout;

    logic        tpu_b_we, tpu_b_re;
    logic [8:0]  tpu_b_addr;
    logic [63:0] tpu_b_din, tpu_b_dout;

    // Tie off TPU write ports (A is write-only from bus, B read-only from bus)
    assign tpu_a_we  = 1'b0;
    assign tpu_a_din = 64'h0;
    assign tpu_b_we  = 1'b0;
    assign tpu_b_din = 64'h0;

    logic [11:0] debug_cnt_ab;

    //=========================================================================
    // DUT Instances
    //=========================================================================
    tpu_bus_master #(
        .C_S_AXI_DATA_WIDTH (32),
        .C_S_AXI_ADDR_WIDTH (7)
    ) u_master (
        .S_AXI_ACLK    (master_clk),
        .S_AXI_ARESETN (aresetn),
        .S_AXI_AWADDR  (S_AXI_awaddr),
        .S_AXI_AWVALID (S_AXI_awvalid),
        .S_AXI_AWREADY (S_AXI_awready),
        .S_AXI_WDATA   (S_AXI_wdata),
        .S_AXI_WSTRB   (S_AXI_wstrb),
        .S_AXI_WVALID  (S_AXI_wvalid),
        .S_AXI_WREADY  (S_AXI_wready),
        .S_AXI_BRESP   (S_AXI_bresp),
        .S_AXI_BVALID  (S_AXI_bvalid),
        .S_AXI_BREADY  (S_AXI_bready),
        .S_AXI_ARADDR  (S_AXI_araddr),
        .S_AXI_ARVALID (S_AXI_arvalid),
        .S_AXI_ARREADY (S_AXI_arready),
        .S_AXI_RDATA   (S_AXI_rdata),
        .S_AXI_RRESP   (S_AXI_rresp),
        .S_AXI_RVALID  (S_AXI_rvalid),
        .S_AXI_RREADY  (S_AXI_rready),
        .BUS_CLK       (bus_clk),
        .BUS_RST_N     (bus_rst_n),
        .CHAB_START    (chab_start),
        .CHAB_WDATA_A  (chab_wdata_a),
        .CHAB_WDATA_B  (chab_wdata_b),
        .CHAB_WR       (chab_wr),
        .CHC_START     (chc_start),
        .CHC_RDATA     (chc_rdata),
        .CHC_RD        (chc_rd)
    );

    bus_slave_ab #(
        .SRAM_AW (12),
        .DW      (8)
    ) u_slave_ab (
        .BUS_CLK          (bus_clk),
        .BUS_RST_N        (bus_rst_n),
        .CHAB_START       (chab_start),
        .CHAB_WDATA_A     (chab_wdata_a),
        .CHAB_WDATA_B     (chab_wdata_b),
        .CHAB_WR          (chab_wr),
        .sram_a_we        (sram_a_we),
        .sram_a_re        (sram_a_re),
        .sram_a_addr      (sram_a_addr),
        .sram_a_din       (sram_a_din),
        .sram_a_dout      (sram_a_dout),
        .sram_a_dout_valid(sram_a_dout_valid),
        .sram_b_we        (sram_b_we),
        .sram_b_re        (sram_b_re),
        .sram_b_addr      (sram_b_addr),
        .sram_b_din       (sram_b_din),
        .sram_b_dout      (sram_b_dout),
        .sram_b_dout_valid(sram_b_dout_valid),
        .debug_cnt_ab     (debug_cnt_ab)
    );

    sram_wrapper #(
        .AW (9),
        .DW (8)
    ) u_sram_a (
        .clk          (bus_clk),
        .rstn         (bus_rst_n),
        .bus_we       (sram_a_we),
        .bus_re       (sram_a_re),
        .bus_addr     (sram_a_addr),
        .bus_din      (sram_a_din),
        .bus_dout     (sram_a_dout),
        .bus_dout_valid(sram_a_dout_valid),
        .tpu_we       (tpu_a_we),
        .tpu_re       (tpu_a_re),
        .tpu_addr     (tpu_a_addr),
        .tpu_din      (tpu_a_din),
        .tpu_dout     (tpu_a_dout)
    );

    sram_wrapper #(
        .AW (9),
        .DW (8)
    ) u_sram_b (
        .clk          (bus_clk),
        .rstn         (bus_rst_n),
        .bus_we       (sram_b_we),
        .bus_re       (sram_b_re),
        .bus_addr     (sram_b_addr),
        .bus_din      (sram_b_din),
        .bus_dout     (sram_b_dout),
        .bus_dout_valid(sram_b_dout_valid),
        .tpu_we       (tpu_b_we),
        .tpu_re       (tpu_b_re),
        .tpu_addr     (tpu_b_addr),
        .tpu_din      (tpu_b_din),
        .tpu_dout     (tpu_b_dout)
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

        // write addr handshake
        wait(S_AXI_awvalid & S_AXI_awready);
        S_AXI_wvalid  <= 1'b1;
        @(posedge master_clk);
        S_AXI_awvalid = 1'b0;

        // write data handshake
        wait(S_AXI_wvalid & S_AXI_wready);
        @(posedge master_clk);
        S_AXI_wvalid  <= 1'b0;

        repeat($urandom_range(10, 4)) @(posedge master_clk);

        S_AXI_bready <= 1'b1;
        // write response handshake
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

        // address read handshake
        wait(S_AXI_arvalid & S_AXI_arready);
        @(posedge master_clk);
        S_AXI_arvalid <= 1'b0;

        repeat($urandom_range(10, 4)) @(posedge master_clk);
        S_AXI_rready <= 1'b1;

        // read data handshake
        wait(S_AXI_rvalid & S_AXI_rready);
        data <= S_AXI_rdata;
        @(posedge master_clk);
        S_AXI_rready <= 1'b0;
    endtask

    //=========================================================================
    // Poll READY_AB task (bit 0 of STATUS 0x00)
    //=========================================================================
    task poll_ready_ab();
        logic [31:0] status;
        do begin
            axi_read(7'h00, status);
        end while (!status[0]);
    endtask

    //=========================================================================
    // TPU readback task (bus_clk domain)
    //=========================================================================
    task tpu_read_a(input logic [8:0] word_addr, output logic [63:0] data);
        @(posedge bus_clk);
        tpu_a_re   <= 1'b1;
        tpu_a_addr <= word_addr;
        @(posedge bus_clk);
        tpu_a_re   <= 1'b0;
        @(posedge bus_clk);  // 1-cycle SRAM read latency
        #1;
        data = tpu_a_dout;
    endtask

    task tpu_read_b(input logic [8:0] word_addr, output logic [63:0] data);
        @(posedge bus_clk);
        tpu_b_re   <= 1'b1;
        tpu_b_addr <= word_addr;
        @(posedge bus_clk);
        tpu_b_re   <= 1'b0;
        @(posedge bus_clk);
        #1;
        data = tpu_b_dout;
    endtask

    //=========================================================================
    // Test Data
    //=========================================================================
    // N_PAIRS bytes for A and B
    // A data: 0xA0, 0xA1, ... 
    // B data: 0xB0, 0xB1, ...
    logic [7:0] a_data [0:N_PAIRS-1];
    logic [7:0] b_data [0:N_PAIRS-1];

    // Expected 64-bit words (8 bytes packed, LSB-first)
    // Word 0: bytes [0..7], Word 1: bytes [8..15]
    function automatic logic [63:0] pack_word(
        input logic [7:0] arr [0:N_PAIRS-1],
        input int word_idx
    );
        logic [63:0] w;
        for (int b = 0; b < 8; b++)
            w[b*8 +: 8] = arr[word_idx*8 + b];
        return w;
    endfunction

    //=========================================================================
    // Main Test
    //=========================================================================
    logic [31:0] rdata;
    logic [63:0] got_a, got_b;
    int errors;

    initial begin
        $display("==============================================");
        $display("  TB: tpu_bus_master + bus_slave_ab + SRAMs");
        $display("==============================================");

        // Init AXI signals
        S_AXI_awaddr  = 0; S_AXI_awvalid = 0;
        S_AXI_wdata   = 0; S_AXI_wvalid  = 0; S_AXI_wstrb = 0;
        S_AXI_bready  = 0;
        S_AXI_araddr  = 0; S_AXI_arvalid = 0;
        S_AXI_rready  = 0;
        S_AXI_awprot  = 0; S_AXI_arprot  = 0;

        // Init TPU readback ports
        tpu_a_re = 0; tpu_a_addr = 0;
        tpu_b_re = 0; tpu_b_addr = 0;

        errors = 0;

        // Build test data
        for (int i = 0; i < N_PAIRS; i++) begin
            a_data[i] = 8'hA0 + i;
            b_data[i] = 8'hB0 + i;
        end

        // Reset
        aresetn = 0;
        repeat(10) @(posedge master_clk);
        aresetn = 1;
        repeat(10) @(posedge master_clk);

        //----------------------------------------------------------------------
        // Step 1: Send START_AB (bit 0 of START reg 0x04)
        //----------------------------------------------------------------------
        $display("\n[Step 1] Send START_AB");
        poll_ready_ab();
        axi_write(7'h04, 32'h1);  // START[0] = 1 -> START_AB
        poll_ready_ab();
        $display("  START_AB acked, counter reset confirmed");

        //----------------------------------------------------------------------
        // Step 2: Write N_PAIRS byte-pairs via DATA_AB (0x08)
        //         [15:8] = B byte, [7:0] = A byte
        //----------------------------------------------------------------------
        $display("\n[Step 2] Write %0d byte-pairs to DATA_AB", N_PAIRS);
        for (int i = 0; i < N_PAIRS; i++) begin
            poll_ready_ab();
            axi_write(7'h08, {16'h0, b_data[i], a_data[i]});
            $display("  [%0d] A=0x%02h B=0x%02h  (DATA_AB=0x%04h)",
                     i, a_data[i], b_data[i], {b_data[i], a_data[i]});
        end
        poll_ready_ab();  // wait for last byte to finish
        $display("  All byte-pairs sent");

        //----------------------------------------------------------------------
        // Step 3: Wait a few BUS cycles for sram_wrapper to commit
        //         (wrapper fires 64-bit write 1 cycle after 8th byte)
        //----------------------------------------------------------------------
        repeat(5) @(posedge bus_clk);

        //----------------------------------------------------------------------
        // Step 4: Readback via TPU port and verify
        //----------------------------------------------------------------------
        $display("\n[Step 3] Readback via TPU port");
        for (int w = 0; w < N_PAIRS/8; w++) begin
            automatic logic [63:0] exp_a = pack_word(a_data, w);
            automatic logic [63:0] exp_b = pack_word(b_data, w);

            tpu_read_a(w, got_a);
            tpu_read_b(w, got_b);

            if (got_a === exp_a)
                $display("  PASS SRAM_A word[%0d] = 0x%016h", w, got_a);
            else begin
                $display("  FAIL SRAM_A word[%0d]: expected=0x%016h got=0x%016h",
                         w, exp_a, got_a);
                errors++;
            end

            if (got_b === exp_b)
                $display("  PASS SRAM_B word[%0d] = 0x%016h", w, got_b);
            else begin
                $display("  FAIL SRAM_B word[%0d]: expected=0x%016h got=0x%016h",
                         w, exp_b, got_b);
                errors++;
            end
        end

        //----------------------------------------------------------------------
        // Summary
        //----------------------------------------------------------------------
        repeat(10) @(posedge master_clk);
        $display("\n==============================================");
        if (errors == 0)
            $display("  ALL TESTS PASSED");
        else
            $display("  FAILED: %0d error(s)", errors);
        $display("==============================================\n");
        $finish;
    end

    // Timeout
    initial begin
        #5_000_000;
        $display("TIMEOUT");
        $finish;
    end

    // Waveform
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule