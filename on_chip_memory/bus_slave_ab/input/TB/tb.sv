///////////////////////////////////////////////////////////////////////////////
// tb.sv - with bus debug monitor
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb;

    localparam MASTER_CLK_PERIOD = 10;
    localparam BUS_CLK_PERIOD    = 100;
    localparam N_PAIRS           = 64;

    logic master_clk, bus_clk, aresetn;

    initial master_clk = 0;
    always #(MASTER_CLK_PERIOD/2) master_clk = ~master_clk;
    initial bus_clk = 0;
    always #(BUS_CLK_PERIOD/2) bus_clk = ~bus_clk;

    // AXI-Lite
    logic [6:0]  S_AXI_awaddr;  logic S_AXI_awvalid; logic S_AXI_awready; logic [2:0] S_AXI_awprot;
    logic [31:0] S_AXI_wdata;   logic [3:0] S_AXI_wstrb; logic S_AXI_wvalid; logic S_AXI_wready;
    logic [1:0]  S_AXI_bresp;   logic S_AXI_bvalid;  logic S_AXI_bready;
    logic [6:0]  S_AXI_araddr;  logic S_AXI_arvalid; logic S_AXI_arready; logic [2:0] S_AXI_arprot;
    logic [31:0] S_AXI_rdata;   logic [1:0] S_AXI_rresp; logic S_AXI_rvalid; logic S_AXI_rready;

    logic bus_rst_n;
    logic chab_start, chab_wr;
    logic [7:0] chab_wdata_a, chab_wdata_b;
    logic chc_start, chc_rd;
    logic [7:0] chc_rdata;
    assign chc_rdata = 8'h00;

    logic sram_a_we;
    logic [11:0] sram_a_addr;
    logic [7:0]  sram_a_din;

    logic sram_b_we;
    logic [11:0] sram_b_addr;
    logic [7:0]  sram_b_din;

    logic        tpu_a_re;
    logic [8:0]  tpu_a_addr;
    logic [63:0] tpu_a_dout;
    logic        tpu_b_re;
    logic [8:0]  tpu_b_addr;
    logic [63:0] tpu_b_dout;

    logic [11:0] debug_cnt_ab;

    // DUTs
    tpu_bus_master #(.C_S_AXI_DATA_WIDTH(32), .C_S_AXI_ADDR_WIDTH(7)) u_master (
        .S_AXI_ACLK(master_clk), .S_AXI_ARESETN(aresetn),
        .S_AXI_AWADDR(S_AXI_awaddr), .S_AXI_AWVALID(S_AXI_awvalid), .S_AXI_AWREADY(S_AXI_awready),
        .S_AXI_WDATA(S_AXI_wdata), .S_AXI_WSTRB(S_AXI_wstrb), .S_AXI_WVALID(S_AXI_wvalid), .S_AXI_WREADY(S_AXI_wready),
        .S_AXI_BRESP(S_AXI_bresp), .S_AXI_BVALID(S_AXI_bvalid), .S_AXI_BREADY(S_AXI_bready),
        .S_AXI_ARADDR(S_AXI_araddr), .S_AXI_ARVALID(S_AXI_arvalid), .S_AXI_ARREADY(S_AXI_arready),
        .S_AXI_RDATA(S_AXI_rdata), .S_AXI_RRESP(S_AXI_rresp), .S_AXI_RVALID(S_AXI_rvalid), .S_AXI_RREADY(S_AXI_rready),
        .BUS_CLK(bus_clk), .BUS_RST_N(bus_rst_n),
        .CHAB_START(chab_start), .CHAB_WDATA_A(chab_wdata_a), .CHAB_WDATA_B(chab_wdata_b), .CHAB_WR(chab_wr),
        .CHC_START(chc_start), .CHC_RDATA(chc_rdata), .CHC_RD(chc_rd)
    );

    bus_slave_ab #(.SRAM_AW(12), .DW(8)) u_slave_ab (
        .BUS_CLK(bus_clk), .BUS_RST_N(bus_rst_n),
        .CHAB_START(chab_start), .CHAB_WDATA_A(chab_wdata_a), .CHAB_WDATA_B(chab_wdata_b), .CHAB_WR(chab_wr),
        .sram_a_we(sram_a_we), .sram_a_addr(sram_a_addr), .sram_a_din(sram_a_din),
        .sram_b_we(sram_b_we), .sram_b_addr(sram_b_addr), .sram_b_din(sram_b_din),
        .debug_cnt_ab(debug_cnt_ab)
    );

    sram_wrapper #(.AW(9), .DW(8)) u_sram_a (
        .clk(bus_clk), .rstn(bus_rst_n),
        .bus_we(sram_a_we), .bus_addr(sram_a_addr), .bus_din(sram_a_din),
        .tpu_re(tpu_a_re), .tpu_addr(tpu_a_addr),
        .tpu_dout(tpu_a_dout)
    );

    sram_wrapper #(.AW(9), .DW(8)) u_sram_b (
        .clk(bus_clk), .rstn(bus_rst_n),
        .bus_we(sram_b_we), .bus_addr(sram_b_addr), .bus_din(sram_b_din),
        .tpu_re(tpu_b_re), .tpu_addr(tpu_b_addr),
        .tpu_dout(tpu_b_dout)
    );

    //=========================================================================
    // Bus debug monitor (print only, no early stop)
    //=========================================================================
    always @(posedge bus_clk) begin
        if (sram_a_we)
            $display("  [BUS DBG @%0t] we=1 addr=%0d dinA=0x%02h dinB=0x%02h",
                     $time, sram_a_addr, sram_a_din, sram_b_din);
    end

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

    task poll_ready_ab();
        logic [31:0] status;
        do begin axi_read(7'h00, status); end while (!status[0]);
    endtask

    task tpu_read_a(input logic [8:0] word_addr, output logic [63:0] data);
        @(posedge bus_clk);
        tpu_a_re   <= 1'b1;
        tpu_a_addr <= word_addr;
        @(posedge bus_clk);
        @(negedge bus_clk);
        data        = tpu_a_dout;
        @(posedge bus_clk);
        tpu_a_re   <= 1'b0;
    endtask

    task tpu_read_b(input logic [8:0] word_addr, output logic [63:0] data);
        @(posedge bus_clk);
        tpu_b_re   <= 1'b1;
        tpu_b_addr <= word_addr;
        @(posedge bus_clk);
        @(negedge bus_clk);
        data        = tpu_b_dout;
        @(posedge bus_clk);
        tpu_b_re   <= 1'b0;
    endtask

    logic [7:0] a_data [0:N_PAIRS-1];
    logic [7:0] b_data [0:N_PAIRS-1];

    function automatic logic [63:0] pack_word(
        input logic [7:0] arr [0:N_PAIRS-1],
        input int word_idx
    );
        logic [63:0] w;
        for (int b = 0; b < 8; b++)
            w[b*8 +: 8] = arr[word_idx*8 + b];
        return w;
    endfunction

    logic [31:0] rdata;
    logic [63:0] got_a, got_b;
    int errors;

    initial begin
        $display("==============================================");
        $display("  TB: tpu_bus_master + bus_slave_ab + SRAMs");
        $display("==============================================");

        S_AXI_awaddr=0; S_AXI_awvalid=0; S_AXI_wdata=0;
        S_AXI_wvalid=0; S_AXI_wstrb=0;  S_AXI_bready=0;
        S_AXI_araddr=0; S_AXI_arvalid=0; S_AXI_rready=0;
        S_AXI_awprot=0; S_AXI_arprot=0;
        tpu_a_re=0; tpu_a_addr=0;
        tpu_b_re=0; tpu_b_addr=0;
        errors = 0;

        for (int i = 0; i < N_PAIRS; i++) begin
            a_data[i] = 8'hA0 + i;
            b_data[i] = 8'hB0 + i;
        end

        aresetn = 0;
        repeat($urandom_range(10, 5)) @(posedge master_clk);
        aresetn = 1;
        repeat($urandom_range(10, 5)) @(posedge master_clk);

        $display("\n[Step 1] Send START_AB");
        poll_ready_ab();
        axi_write(7'h04, 32'h1);
        poll_ready_ab();
        $display("  START_AB acked");

        $display("\n[Step 2] Write %0d byte-pairs", N_PAIRS);
        for (int i = 0; i < N_PAIRS; i++) begin
            poll_ready_ab();
            axi_write(7'h08, {16'h0, b_data[i], a_data[i]});
            $display("  [%0d] A=0x%02h B=0x%02h", i, a_data[i], b_data[i]);
            repeat($urandom_range(80, 50)) @(posedge bus_clk);
        end
        poll_ready_ab();
        $display("  All byte-pairs sent");

        repeat($urandom_range(70, 40)) @(posedge bus_clk);

        $display("\n[Step 3] Readback via TPU port");
        for (int w = 0; w < N_PAIRS/8; w++) begin
            automatic logic [63:0] exp_a = pack_word(a_data, w);
            automatic logic [63:0] exp_b = pack_word(b_data, w);
            tpu_read_a(w, got_a);
            tpu_read_b(w, got_b);
            if (got_a === exp_a)
                $display("  PASS SRAM_A word[%0d] = 0x%016h", w, got_a);
            else begin
                $display("  FAIL SRAM_A word[%0d]: exp=0x%016h got=0x%016h", w, exp_a, got_a);
                errors++;
            end
            if (got_b === exp_b)
                $display("  PASS SRAM_B word[%0d] = 0x%016h", w, got_b);
            else begin
                $display("  FAIL SRAM_B word[%0d]: exp=0x%016h got=0x%016h", w, exp_b, got_b);
                errors++;
            end
        end

        repeat(10) @(posedge master_clk);
        $display("\n==============================================");
        if (errors == 0) $display("  ALL TESTS PASSED");
        else             $display("  FAILED: %0d error(s)", errors);
        $display("==============================================\n");
        $finish;
    end

    initial begin #5_000_000; $display("TIMEOUT"); $finish; end

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule
