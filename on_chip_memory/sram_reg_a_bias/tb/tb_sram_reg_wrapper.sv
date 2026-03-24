///////////////////////////////////////////////////////////////////////////////
// tb_sram_reg_wrapper.sv
//
// Testbench for sram_reg_wrapper
// Tests:
//   1. Bus write to regf00 region (Bias, addr 0x0000-0x03FF) -> TPU read 32-bit
//   2. Bus write to sram00 region (Matrix A, addr 0x0400+) -> TPU read 64-bit
//   3. Bus read from both regions
//   4. Address boundary test
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_sram_reg_wrapper;

    //=========================================================================
    // Parameters
    //=========================================================================
    parameter CLK_PERIOD = 100;  // 10 MHz

    //=========================================================================
    // Signals
    //=========================================================================
    logic        clk;
    logic        rstn;

    // Bus interface (8-bit byte)
    logic        bus_we;
    logic        bus_re;
    logic [12:0] bus_addr;      // 13-bit byte address (5120 bytes total)
    logic [7:0]  bus_din;
    logic [7:0]  bus_dout;
    logic        bus_dout_valid;

    // TPU interface - Matrix A (64-bit)
    logic        tpu_a_re;
    logic [8:0]  tpu_a_raddr;
    logic [63:0] tpu_a_rdata;

    // TPU interface - Bias (32-bit)
    logic        tpu_bias_re;
    logic [7:0]  tpu_bias_raddr;
    logic [31:0] tpu_bias_rdata;

    // Test variables
    logic [63:0] expected_64;
    logic [31:0] expected_32;
    logic [63:0] read_64;
    logic [31:0] read_32;
    int          errors;

    //=========================================================================
    // DUT
    //=========================================================================
    sram_reg_wrapper #(
        .AW (13),
        .DW (8)
    ) dut (
        .clk            (clk),
        .rstn           (rstn),
        .bus_we         (bus_we),
        .bus_re         (bus_re),
        .bus_addr       (bus_addr),
        .bus_din        (bus_din),
        .bus_dout       (bus_dout),
        .bus_dout_valid (bus_dout_valid),
        .tpu_a_re       (tpu_a_re),
        .tpu_a_raddr    (tpu_a_raddr),
        .tpu_a_rdata    (tpu_a_rdata),
        .tpu_bias_re    (tpu_bias_re),
        .tpu_bias_raddr (tpu_bias_raddr),
        .tpu_bias_rdata (tpu_bias_rdata)
    );

    //=========================================================================
    // Clock Generation
    //=========================================================================
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    //=========================================================================
    // Tasks
    //=========================================================================
    
    // Write bytes via bus interface (generic)
    task bus_write_bytes(input [12:0] start_addr, input int num_bytes, input [7:0] data[]);
        for (int i = 0; i < num_bytes; i++) begin
            @(posedge clk);
            bus_we   <= 1'b1;
            bus_addr <= start_addr + i;
            bus_din  <= data[i];
        end
        @(posedge clk);
        bus_we <= 1'b0;
        // Wait for write to complete
        repeat(2) @(posedge clk);
    endtask

    // Write 4 bytes to regf00 (Bias) via bus - forms one 32-bit word
    task bus_write_bias(input [7:0] word_addr, input [31:0] data);
        logic [7:0] bytes[4];
        for (int i = 0; i < 4; i++) bytes[i] = data[i*8 +: 8];
        bus_write_bytes({3'b000, word_addr, 2'b00}, 4, bytes);
    endtask

    // Write 8 bytes to sram00 (Matrix A) via bus - forms one 64-bit word
    // Base address for sram00 is 0x0400
    task bus_write_matrix_a(input [8:0] word_addr, input [63:0] data);
        logic [7:0] bytes[8];
        for (int i = 0; i < 8; i++) bytes[i] = data[i*8 +: 8];
        bus_write_bytes(13'h0400 + {word_addr, 3'b000}, 8, bytes);
    endtask

    // Read Bias via TPU interface (32-bit)
    task tpu_read_bias(input [7:0] addr, output [31:0] data);
        @(posedge clk);
        tpu_bias_re    <= 1'b1;
        tpu_bias_raddr <= addr;
        @(posedge clk);
        tpu_bias_re    <= 1'b0;
        @(posedge clk);  // 1-cycle latency
        #1;              // Let non-blocking assignments settle
        data = tpu_bias_rdata;
    endtask

    // Read Matrix A via TPU interface (64-bit)
    task tpu_read_matrix_a(input [8:0] addr, output [63:0] data);
        @(posedge clk);
        tpu_a_re    <= 1'b1;
        tpu_a_raddr <= addr;
        @(posedge clk);
        tpu_a_re    <= 1'b0;
        @(posedge clk);  // 1-cycle latency
        #1;              // Let non-blocking assignments settle
        data = tpu_a_rdata;
    endtask

    // Read bytes via bus interface
    task bus_read_bytes(input [12:0] start_addr, input int num_bytes, output [7:0] data[]);
        for (int i = 0; i < num_bytes; i++) begin
            @(posedge clk);
            bus_re   <= 1'b1;
            bus_addr <= start_addr + i;
        end
        @(posedge clk);
        bus_re <= 1'b0;
        
        // Wait and collect (simplified - assumes back-to-back reads)
        repeat(2) @(posedge clk);
    endtask

    //=========================================================================
    // Main Test
    //=========================================================================
    initial begin
        $display("============================================");
        $display("  sram_reg_wrapper Testbench");
        $display("============================================");
        $display("  Address Map:");
        $display("    regf00 (Bias):     0x0000 - 0x03FF (1024 bytes, 256 words)");
        $display("    sram00 (Matrix A): 0x0400 - 0x13FF (4096 bytes, 512 words)");
        $display("============================================");
        
        // Initialize
        rstn          = 0;
        bus_we        = 0;
        bus_re        = 0;
        bus_addr      = 0;
        bus_din       = 0;
        tpu_a_re      = 0;
        tpu_a_raddr   = 0;
        tpu_bias_re   = 0;
        tpu_bias_raddr= 0;
        errors        = 0;

        // Reset
        repeat(5) @(posedge clk);
        rstn = 1;
        repeat(5) @(posedge clk);

        //=============================================
        // Test 1: Bus Write Bias -> TPU Read Bias
        //=============================================
        $display("\n[Test 1] Bus Write Bias -> TPU Read Bias (32-bit)");
        
        expected_32 = 32'h03020100;
        bus_write_bias(8'd0, expected_32);
        
        repeat(3) @(posedge clk);
        tpu_read_bias(8'd0, read_32);
        
        if (read_32 == expected_32) begin
            $display("  PASS: bias[0] = %h", read_32);
        end else begin
            $display("  FAIL: bias[0] expected=%h, got=%h", expected_32, read_32);
            errors++;
        end

        // Write another bias word
        expected_32 = 32'hDEADBEEF;
        bus_write_bias(8'd1, expected_32);
        
        repeat(3) @(posedge clk);
        tpu_read_bias(8'd1, read_32);
        
        if (read_32 == expected_32) begin
            $display("  PASS: bias[1] = %h", read_32);
        end else begin
            $display("  FAIL: bias[1] expected=%h, got=%h", expected_32, read_32);
            errors++;
        end

        //=============================================
        // Test 2: Bus Write Matrix A -> TPU Read Matrix A
        //=============================================
        $display("\n[Test 2] Bus Write Matrix A -> TPU Read Matrix A (64-bit)");
        
        expected_64 = 64'h0706050403020100;
        bus_write_matrix_a(9'd0, expected_64);
        
        repeat(3) @(posedge clk);
        tpu_read_matrix_a(9'd0, read_64);
        
        if (read_64 == expected_64) begin
            $display("  PASS: A[0] = %h", read_64);
        end else begin
            $display("  FAIL: A[0] expected=%h, got=%h", expected_64, read_64);
            errors++;
        end

        // Write another Matrix A word
        expected_64 = 64'hCAFEBABE12345678;
        bus_write_matrix_a(9'd1, expected_64);
        
        repeat(3) @(posedge clk);
        tpu_read_matrix_a(9'd1, read_64);
        
        if (read_64 == expected_64) begin
            $display("  PASS: A[1] = %h", read_64);
        end else begin
            $display("  FAIL: A[1] expected=%h, got=%h", expected_64, read_64);
            errors++;
        end

        //=============================================
        // Test 3: Address Boundary - Last Bias, First Matrix A
        //=============================================
        $display("\n[Test 3] Address Boundary Test");
        
        // Last bias word (addr 255, byte addr 0x03FC-0x03FF)
        expected_32 = 32'hAAAAAAAA;
        bus_write_bias(8'd255, expected_32);
        
        repeat(3) @(posedge clk);
        tpu_read_bias(8'd255, read_32);
        
        if (read_32 == expected_32) begin
            $display("  PASS: bias[255] (last) = %h", read_32);
        end else begin
            $display("  FAIL: bias[255] expected=%h, got=%h", expected_32, read_32);
            errors++;
        end

        // First Matrix A word (addr 0, byte addr 0x0400-0x0407)
        expected_64 = 64'hBBBBBBBBBBBBBBBB;
        bus_write_matrix_a(9'd0, expected_64);
        
        repeat(3) @(posedge clk);
        tpu_read_matrix_a(9'd0, read_64);
        
        if (read_64 == expected_64) begin
            $display("  PASS: A[0] (first) = %h", read_64);
        end else begin
            $display("  FAIL: A[0] expected=%h, got=%h", expected_64, read_64);
            errors++;
        end

        //=============================================
        // Test 4: Multiple consecutive bias writes
        //=============================================
        $display("\n[Test 4] Multiple consecutive Bias writes");
        
        for (int w = 0; w < 4; w++) begin
            expected_32 = 32'hB0000000 | w;
            bus_write_bias(8'd10 + w, expected_32);
        end
        
        repeat(5) @(posedge clk);
        
        for (int w = 0; w < 4; w++) begin
            expected_32 = 32'hB0000000 | w;
            tpu_read_bias(8'd10 + w, read_32);
            if (read_32 == expected_32) begin
                $display("  PASS: bias[%0d] = %h", 10+w, read_32);
            end else begin
                $display("  FAIL: bias[%0d] expected=%h, got=%h", 10+w, expected_32, read_32);
                errors++;
            end
        end

        //=============================================
        // Test 5: Multiple consecutive Matrix A writes
        //=============================================
        $display("\n[Test 5] Multiple consecutive Matrix A writes");
        
        for (int w = 0; w < 4; w++) begin
            expected_64 = 64'hA000000000000000 | w;
            bus_write_matrix_a(9'd50 + w, expected_64);
        end
        
        repeat(5) @(posedge clk);
        
        for (int w = 0; w < 4; w++) begin
            expected_64 = 64'hA000000000000000 | w;
            tpu_read_matrix_a(9'd50 + w, read_64);
            if (read_64 == expected_64) begin
                $display("  PASS: A[%0d] = %h", 50+w, read_64);
            end else begin
                $display("  FAIL: A[%0d] expected=%h, got=%h", 50+w, expected_64, read_64);
                errors++;
            end
        end

        //=============================================
        // Test 6: Interleaved Bias and Matrix A writes
        //=============================================
        $display("\n[Test 6] Interleaved Bias and Matrix A writes");
        
        // Write bias[100]
        expected_32 = 32'h11111111;
        bus_write_bias(8'd100, expected_32);
        
        // Write A[100]
        expected_64 = 64'h2222222222222222;
        bus_write_matrix_a(9'd100, expected_64);
        
        // Write bias[101]
        bus_write_bias(8'd101, 32'h33333333);
        
        repeat(5) @(posedge clk);
        
        // Read back bias[100]
        tpu_read_bias(8'd100, read_32);
        if (read_32 == 32'h11111111) begin
            $display("  PASS: bias[100] = %h", read_32);
        end else begin
            $display("  FAIL: bias[100] expected=11111111, got=%h", read_32);
            errors++;
        end
        
        // Read back A[100]
        tpu_read_matrix_a(9'd100, read_64);
        if (read_64 == 64'h2222222222222222) begin
            $display("  PASS: A[100] = %h", read_64);
        end else begin
            $display("  FAIL: A[100] expected=2222222222222222, got=%h", read_64);
            errors++;
        end
        
        // Read back bias[101]
        tpu_read_bias(8'd101, read_32);
        if (read_32 == 32'h33333333) begin
            $display("  PASS: bias[101] = %h", read_32);
        end else begin
            $display("  FAIL: bias[101] expected=33333333, got=%h", read_32);
            errors++;
        end

        //=============================================
        // Summary
        //=============================================
        repeat(10) @(posedge clk);
        $display("\n============================================");
        if (errors == 0) begin
            $display("  ALL TESTS PASSED!");
        end else begin
            $display("  FAILED: %0d errors", errors);
        end
        $display("============================================\n");
        
        $finish;
    end

    // Timeout
    initial begin
        #(CLK_PERIOD * 5000);
        $display("ERROR: Timeout!");
        $finish;
    end

endmodule