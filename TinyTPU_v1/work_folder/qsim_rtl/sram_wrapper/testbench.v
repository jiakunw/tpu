`timescale 1ns/1ps
`define SD #1

module testbench;

    parameter SRAM_DATA_WIDTH = 64;
    parameter SRAM_ADDR_WIDTH = 9;
    parameter DEPTH = 512;

    reg clk;
    reg wr_en;
    reg rd_en;
    reg [SRAM_ADDR_WIDTH-1:0] waddr;
    reg [SRAM_ADDR_WIDTH-1:0] raddr;
    reg [SRAM_DATA_WIDTH-1:0] wdata;
    wire [SRAM_DATA_WIDTH-1:0] rdata;

    integer i;
    integer error_count;

    reg [SRAM_DATA_WIDTH-1:0] golden_mem [0:DEPTH-1];

    //------------------------------------------------
    // DUT
    //------------------------------------------------
    sram_wrapper u_dut (
        .clk(clk),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(wdata),
        .rdata(rdata)
    );

    //------------------------------------------------
    // 50 MHz Clock (period = 20ns)
    //------------------------------------------------
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end


    //------------------------------------------------
    // Test sequence
    //------------------------------------------------
    initial begin

        $dumpfile("tb_sram_wrapper.vcd");
        $dumpvars(0, testbench.u_dut);

        wr_en = 0;
        rd_en = 0;
        waddr = 0;
        raddr = 0;
        wdata = 0;
        error_count = 0;

        repeat(5) @(posedge clk);

        $display("=================================");
        $display("Start writing random data");
        $display("=================================");

        //--------------------------------------------
        // WRITE PHASE
        //--------------------------------------------
        for(i = 0; i < DEPTH; i = i + 1) begin
            @(posedge clk);
            `SD
            wr_en = 1;
            rd_en = 0;
            waddr = i;
            wdata = {$random, $random};

            golden_mem[i] = wdata;
        end

        @(posedge clk);
        `SD
        wr_en = 0;

        repeat(3) @(posedge clk);

        $display("=================================");
        $display("Start reading and checking");
        $display("=================================");

        //--------------------------------------------
        // READ PHASE
        //--------------------------------------------

        @(posedge clk);
        `SD
        wr_en = 0;
        rd_en = 1;
        raddr = 0;

        // pipeline read
        for(i = 1; i < DEPTH; i = i + 1) begin

            @(posedge clk);
            `SD

            // 检查上一拍的地址
            if(rdata !== golden_mem[i-1]) begin
                error_count = error_count + 1;
                $display("ERROR addr=%0d expected=%h got=%h",
                        i-1, golden_mem[i-1], rdata);
            end

            // 发下一地址
            raddr = i;

        end

        // 最后一个地址再检查一次
        @(posedge clk);
        `SD
        if(rdata !== golden_mem[DEPTH-1]) begin
            error_count = error_count + 1;
            $display("ERROR addr=%0d expected=%h got=%h",
                    DEPTH-1, golden_mem[DEPTH-1], rdata);
        end

        @(posedge clk);
        `SD
        rd_en = 0;

        repeat(3) @(posedge clk);

        $display("=================================");

        if(error_count == 0)
            $display("TEST PASS");
        else
            $display("TEST FAIL, errors = %0d", error_count);

        $display("=================================");

        $finish;

    end

endmodule