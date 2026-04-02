`timescale 1ns/1ps
`define ARM_UD_MODEL
`define delay #2

module TB;

    parameter AW       = 9;
    parameter DW       = 64;
    parameter CLK_HALF = 5;               // 10 ns, 100 MHz
    parameter WORDS    = (1 << AW);       // 512 words, test all

    // -------------------------------------------------------------------------
    // Clock & reset
    // -------------------------------------------------------------------------
    reg clk  = 1'b0;
    reg rstn = 1'b0;
    always #CLK_HALF clk = ~clk;

    // -------------------------------------------------------------------------
    // DUT
    // -------------------------------------------------------------------------
    reg  [AW-1:0] addr;
    reg  [DW-1:0] din;
    reg           we;
    reg           re;
    wire [DW-1:0] dout;
    wire          dout_valid;

    sram_wrapper  spsram (
        .clk        (clk),
        .rstn       (rstn),
        .we         (we),
        .re         (re),
        .addr       (addr),
        .din        (din),
        .dout       (dout),
        .dout_valid (dout_valid)
    );

    // -------------------------------------------------------------------------
    // Golden reference  (512 × 64-bit)
    // -------------------------------------------------------------------------
    reg [DW-1:0] golden [0:511];

    integer pass_cnt;
    integer fail_cnt;
    integer i;
    integer expect_idx;
    // -------------------------------------------------------------------------
    // Stimulus
    // -------------------------------------------------------------------------
    initial begin
        pass_cnt = 0;
        fail_cnt = 0;
        we   = 1'b0;
        re   = 1'b0;
        addr = 0;
        din  = 0;

        // ---- Generate random golden data ----
        for (i = 0; i < WORDS; i = i + 1)
            golden[i] = {$random, $random};   // 64-bit random per word

        // ---- Reset ----
        rstn = 1'b0;
        repeat(5) @(posedge clk);
        @(negedge clk); rstn = 1'b1;
        repeat(3) @(posedge clk);
        #1;

        // =================================================================
        // Write phase: we=1 held, all WORDS locations written sequentially
        // =================================================================
        $display("=== Write phase: %0d words ===", WORDS);
        we = 1'b1;
        re = 1'b0;
        @(posedge clk); 
        for (i = 0; i < WORDS; i = i + 1) begin
            addr = i;
            din  = golden[i];
            @(posedge clk); 
        end
        @(posedge clk); 
        we   = 1'b0;
        addr = 0;
        din  = 0;
        $display("  Write done.");

        // Idle gap
        repeat(4) @(posedge clk);
        #1;

        // =================================================================
        // Read phase: re=1 held, all WORDS locations read sequentially.
        // Pipeline delay = 1 iteration (controller reg + sram reg folded
        // into the same loop offset as the write phase above).
        //   i=0        : addr=0 presented, no valid output yet
        //   i=1        : addr=1 presented, dout = golden[0]  ← check i-1
        //   ...
        //   i=WORDS-1  : addr=WORDS-1 presented, dout = golden[WORDS-2]
        //   i=WORDS    : flush cycle,             dout = golden[WORDS-1]
        // =================================================================
        $display("=== Read phase: %0d words ===", WORDS);
        re   = 1'b1;
        we   = 1'b0;
        addr = 0;
    // @(posedge clk); #0.5;
// log index of expected data for debugging

        expect_idx = 0;

        for (i = 0; i < WORDS + 2; i = i + 1) begin  // +2 to flush out last data
            if (i < WORDS)
                addr = i;
            if (dout_valid) begin
                if (dout == golden[expect_idx]) begin
                    pass_cnt = pass_cnt + 1;
                end else begin
                    $display("  [FAIL] addr=%0d  exp=0x%016h  got=0x%016h",
                             expect_idx, golden[expect_idx], dout);
                    fail_cnt = fail_cnt + 1;
                end
                expect_idx = expect_idx + 1;    
            end
            @(posedge clk); 
        end
        re   = 1'b0;
        @(posedge clk); 
        addr = 0; 
        repeat(4) @(posedge clk);
        // 检查是否所有数据都被验证到
        if (expect_idx != WORDS)
            $display("  [WARN] only %d out of %d words verified", expect_idx, WORDS);

        re   = 1'b0;
        addr = 0;
        $display("  Read done.");

        // ---- Summary ----
        $display("=== Result: %0d PASS / %0d FAIL ===", pass_cnt, fail_cnt);
        $finish;
    end

    // Watchdog
    initial begin
        #2_000_000;
        $display("[TIMEOUT]");
        $finish;
    end

    initial begin
        $dumpfile("tb_sram_wrapper.vcd");
        $dumpvars(0, TB.spsram);
    end

endmodule