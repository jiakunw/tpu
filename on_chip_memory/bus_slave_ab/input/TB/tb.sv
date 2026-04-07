///////////////////////////////////////////////////////////////////////////////
// tb.sv
//
// Testbench: tpu_bus_master <-> bus_slave_ab <-> sram_wrapper x2
// Tests multiple M/N/K combinations sequentially.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb;

    localparam MASTER_CLK_PERIOD = 10;
    localparam BUS_CLK_PERIOD    = 100;
    localparam MAX_BYTES         = 64;

    logic master_clk, bus_clk, aresetn;
    initial master_clk = 0; always #(MASTER_CLK_PERIOD/2) master_clk = ~master_clk;
    initial bus_clk    = 0; always #(BUS_CLK_PERIOD/2)    bus_clk    = ~bus_clk;

    // AXI-Lite
    logic [6:0]  S_AXI_awaddr;  logic S_AXI_awvalid; logic S_AXI_awready; logic [2:0] S_AXI_awprot;
    logic [31:0] S_AXI_wdata;   logic [3:0] S_AXI_wstrb; logic S_AXI_wvalid; logic S_AXI_wready;
    logic [1:0]  S_AXI_bresp;   logic S_AXI_bvalid;  logic S_AXI_bready;
    logic [6:0]  S_AXI_araddr;  logic S_AXI_arvalid; logic S_AXI_arready; logic [2:0] S_AXI_arprot;
    logic [31:0] S_AXI_rdata;   logic [1:0] S_AXI_rresp; logic S_AXI_rvalid; logic S_AXI_rready;

    // Bus signals
    logic bus_rst_n;
    logic chab_start, chab_wr;
    logic [7:0] chab_wdata_a, chab_wdata_b;
    logic chc_start, chc_rd;
    logic [7:0] chc_rdata;
    assign chc_rdata = 8'h00;

    // SRAM wires
    logic        sram_a_we;
    logic [11:0] sram_a_addr;
    logic [7:0]  sram_a_din;
    logic        sram_b_we;
    logic [11:0] sram_b_addr;
    logic [7:0]  sram_b_din;

    // TPU read ports
    logic        tpu_a_re;  logic [8:0] tpu_a_addr; logic [63:0] tpu_a_dout;
    logic        tpu_b_re;  logic [8:0] tpu_b_addr; logic [63:0] tpu_b_dout;

    // DIM ports
    logic [7:0] dim_m, dim_n, dim_k;
    logic [11:0] debug_cnt_a, debug_cnt_b;

    // Module-level error counter (accessible from tasks)
    int total_errors = 0;

    // DUTs
    tpu_bus_master #(.C_S_AXI_DATA_WIDTH(32), .C_S_AXI_ADDR_WIDTH(7)) u_master (
        .S_AXI_ACLK(master_clk), .S_AXI_ARESETN(aresetn),
        .S_AXI_AWADDR(S_AXI_awaddr), .S_AXI_AWVALID(S_AXI_awvalid), .S_AXI_AWREADY(S_AXI_awready),
        .S_AXI_WDATA(S_AXI_wdata),   .S_AXI_WSTRB(S_AXI_wstrb),   .S_AXI_WVALID(S_AXI_wvalid), .S_AXI_WREADY(S_AXI_wready),
        .S_AXI_BRESP(S_AXI_bresp),   .S_AXI_BVALID(S_AXI_bvalid), .S_AXI_BREADY(S_AXI_bready),
        .S_AXI_ARADDR(S_AXI_araddr), .S_AXI_ARVALID(S_AXI_arvalid), .S_AXI_ARREADY(S_AXI_arready),
        .S_AXI_RDATA(S_AXI_rdata),   .S_AXI_RRESP(S_AXI_rresp),   .S_AXI_RVALID(S_AXI_rvalid), .S_AXI_RREADY(S_AXI_rready),
        .BUS_CLK(bus_clk), .BUS_RST_N(bus_rst_n),
        .CHAB_START(chab_start), .CHAB_WDATA_A(chab_wdata_a), .CHAB_WDATA_B(chab_wdata_b), .CHAB_WR(chab_wr),
        .CHC_START(chc_start), .CHC_RDATA(chc_rdata), .CHC_RD(chc_rd)
    );

    bus_slave_ab #(.SRAM_AW(12), .DW(8)) u_slave_ab (
        .BUS_CLK(bus_clk), .BUS_RST_N(bus_rst_n),
        .DIM_M(dim_m), .DIM_N(dim_n), .DIM_K(dim_k),
        .CHAB_START(chab_start), .CHAB_WDATA_A(chab_wdata_a), .CHAB_WDATA_B(chab_wdata_b), .CHAB_WR(chab_wr),
        .sram_a_we(sram_a_we), .sram_a_addr(sram_a_addr), .sram_a_din(sram_a_din),
        .sram_b_we(sram_b_we), .sram_b_addr(sram_b_addr), .sram_b_din(sram_b_din),
        .debug_cnt_a(debug_cnt_a), .debug_cnt_b(debug_cnt_b)
    );

    sram_wrapper #(.AW(9), .DW(8)) u_sram_a (
        .clk(bus_clk), .rstn(bus_rst_n),
        .bus_we(sram_a_we), .bus_addr(sram_a_addr), .bus_din(sram_a_din),
        .tpu_re(tpu_a_re), .tpu_addr(tpu_a_addr), .tpu_dout(tpu_a_dout)
    );

    sram_wrapper #(.AW(9), .DW(8)) u_sram_b (
        .clk(bus_clk), .rstn(bus_rst_n),
        .bus_we(sram_b_we), .bus_addr(sram_b_addr), .bus_din(sram_b_din),
        .tpu_re(tpu_b_re), .tpu_addr(tpu_b_addr), .tpu_dout(tpu_b_dout)
    );

    //=========================================================================
    // AXI Tasks (unchanged)
    //=========================================================================
    task automatic axi_write(input logic [6:0] addr, input logic [31:0] data);
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

    task automatic axi_read(input logic [6:0] addr, output logic [31:0] data);
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

    task automatic poll_ready_ab();
        logic [31:0] status;
        do begin axi_read(7'h00, status); end while (!status[0]);
    endtask

    //=========================================================================
    // TPU read tasks
    //=========================================================================
    task automatic tpu_read_a(input logic [8:0] word_addr, output logic [63:0] data);
        @(posedge bus_clk); tpu_a_re <= 1; tpu_a_addr <= word_addr;
        @(posedge bus_clk); @(negedge bus_clk); data = tpu_a_dout;
        @(posedge bus_clk); tpu_a_re <= 0;
    endtask

    task automatic tpu_read_b(input logic [8:0] word_addr, output logic [63:0] data);
        @(posedge bus_clk); tpu_b_re <= 1; tpu_b_addr <= word_addr;
        @(posedge bus_clk); @(negedge bus_clk); data = tpu_b_dout;
        @(posedge bus_clk); tpu_b_re <= 0;
    endtask

    //=========================================================================
    // Run one test case
    //=========================================================================
    task automatic run_test(input int m, n, k, input string label);
        int n_a, n_b, n_max, n_words_a, n_words_b, case_errors;
        logic [7:0]  a_buf [0:MAX_BYTES-1];
        logic [7:0]  b_buf [0:MAX_BYTES-1];
        logic [63:0] got, exp;
        logic [31:0] rdata;

        n_a         = m * n;
        n_b         = n * k;
        n_max       = (n_a > n_b) ? n_a : n_b;
        n_words_a   = (n_a + 7) / 8;
        n_words_b   = (n_b + 7) / 8;
        case_errors = 0;

        $display("\n----------------------------------------------");
        $display("  %s: M=%0d N=%0d K=%0d  A=%0d bytes  B=%0d bytes",
                 label, m, n, k, n_a, n_b);
        $display("----------------------------------------------");

        for (int i = 0; i < MAX_BYTES; i++) begin
            a_buf[i] = (i < n_a) ? (8'hA0 + i) : 8'h00;
            b_buf[i] = (i < n_b) ? (8'hB0 + i) : 8'h00;
        end

        dim_m = 8'(m); dim_n = 8'(n); dim_k = 8'(k);
        repeat(2) @(posedge bus_clk);

        poll_ready_ab();
        axi_write(7'h04, 32'h1);
        poll_ready_ab();

        for (int i = 0; i < n_max; i++) begin
            poll_ready_ab();
            axi_write(7'h08, {16'h0, b_buf[i], a_buf[i]});
            repeat($urandom_range(20, 10)) @(posedge bus_clk);
        end
        poll_ready_ab();
        repeat(10) @(posedge bus_clk);

        // Verify SRAM_A
        for (int w = 0; w < n_words_a; w++) begin
            exp = 64'h0;
            for (int b = 0; b < 8; b++) begin
                int idx = w*8 + b;
                exp[b*8 +: 8] = (idx < n_a) ? a_buf[idx] : 8'h00;
            end
            tpu_read_a(9'(w), got);
            if (got === exp)
                $display("  PASS A word[%0d] = 0x%016h", w, got);
            else begin
                $display("  FAIL A word[%0d]: exp=0x%016h got=0x%016h", w, exp, got);
                case_errors++;
            end
        end

        // Verify SRAM_B
        for (int w = 0; w < n_words_b; w++) begin
            exp = 64'h0;
            for (int b = 0; b < 8; b++) begin
                int idx = w*8 + b;
                exp[b*8 +: 8] = (idx < n_b) ? b_buf[idx] : 8'h00;
            end
            tpu_read_b(9'(w), got);
            if (got === exp)
                $display("  PASS B word[%0d] = 0x%016h", w, got);
            else begin
                $display("  FAIL B word[%0d]: exp=0x%016h got=0x%016h", w, exp, got);
                case_errors++;
            end
        end

        if (case_errors == 0)
            $display("  >>> PASS (%s)", label);
        else
            $display("  >>> FAIL (%s): %0d error(s)", label, case_errors);

        total_errors += case_errors;
    endtask

    //=========================================================================
    // Main
    //=========================================================================
    initial begin
        $display("==============================================");
        $display("  TB: bus_slave_ab multi-dimension test");
        $display("==============================================");

        S_AXI_awaddr=0; S_AXI_awvalid=0; S_AXI_wdata=0;
        S_AXI_wvalid=0; S_AXI_wstrb=0;   S_AXI_bready=0;
        S_AXI_araddr=0; S_AXI_arvalid=0; S_AXI_rready=0;
        S_AXI_awprot=0; S_AXI_arprot=0;
        tpu_a_re=0; tpu_a_addr=0;
        tpu_b_re=0; tpu_b_addr=0;
        dim_m=1; dim_n=1; dim_k=1;

        aresetn = 0;
        repeat(10) @(posedge master_clk);
        aresetn = 1;
        repeat(10) @(posedge master_clk);

        run_test(4, 3, 5,  "asymmetric A<B");
        run_test(8, 4, 2,  "A much > B");
        run_test(2, 4, 8,  "A much < B");
        run_test(4, 4, 4,  "square equal");
        run_test(8, 8, 8,  "8-aligned large");
        run_test(3, 5, 7,  "unaligned both");
        run_test(1, 1, 1,  "minimum 1x1");
        run_test(8, 1, 8,  "thin x wide");

        repeat(10) @(posedge master_clk);
        $display("\n==============================================");
        if (total_errors == 0) $display("  ALL TESTS PASSED");
        else                   $display("  FAILED: %0d total error(s)", total_errors);
        $display("==============================================\n");
        $finish;
    end

    initial begin #100_000_000; $display("TIMEOUT"); $finish; end
    initial begin $dumpfile("tb.vcd"); $dumpvars(0, tb); end

endmodule