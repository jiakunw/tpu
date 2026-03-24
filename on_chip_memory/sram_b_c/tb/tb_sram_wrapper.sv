///////////////////////////////////////////////////////////////////////////////
// tb_sram_wrapper.sv
//
// Testbench for sram_wrapper
// Tests:
//   1. Bus interface write (8-bit byte accumulation -> 64-bit word)
//   2. Bus interface read (64-bit word -> 8-bit byte extraction)
//   3. TPU interface write (64-bit word direct)
//   4. TPU interface read (64-bit word direct)
//   5. Mixed operations
//
// Timing:
//   - SRAM has 1-cycle read latency
//   - bus_dout_valid is asserted 1 cycle after bus_re
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_sram_wrapper;

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
    logic [11:0] bus_addr;      // 12-bit byte address (512 words * 8 bytes)
    logic [7:0]  bus_din;
    logic [7:0]  bus_dout;
    logic        bus_dout_valid;

    // TPU interface (64-bit word)
    logic        tpu_we;
    logic        tpu_re;
    logic [8:0]  tpu_addr;      // 9-bit word address (512 words)
    logic [63:0] tpu_din;
    logic [63:0] tpu_dout;

    // Test variables
    logic [63:0] expected_data;
    logic [63:0] read_data;
    int          errors;

    //=========================================================================
    // DUT
    //=========================================================================
    sram_wrapper #(
        .AW (9),
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
        .tpu_we         (tpu_we),
        .tpu_re         (tpu_re),
        .tpu_addr       (tpu_addr),
        .tpu_din        (tpu_din),
        .tpu_dout       (tpu_dout)
    );

    //=========================================================================
    // Clock Generation
    //=========================================================================
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    //=========================================================================
    // Tasks
    //=========================================================================
    
    // Write 8 bytes via bus interface (forms one 64-bit word)
    // Timing: 8 consecutive writes, then 1 cycle for SRAM write to fire
    task bus_write_word(input [8:0] word_addr, input [63:0] data);
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            bus_we   <= 1'b1;
            bus_addr <= {word_addr, i[2:0]};  // byte address
            bus_din  <= data[i*8 +: 8];
        end
        @(posedge clk);
        bus_we <= 1'b0;
        // Wait for write to complete (fires 1 cycle after 8th byte)
        @(posedge clk);
    endtask

    // Read 8 bytes via bus interface
    // Timing: 
    //   Cycle N: bus_re=1, bus_addr=X (non-blocking, takes effect at end of cycle)
    //   Cycle N+1: SRAM sees request, starts reading
    //   Cycle N+2: sram_q valid, bus_dout valid
    task bus_read_word(input [8:0] word_addr, output [63:0] data);
        data = 64'b0;
        for (int i = 0; i < 8; i++) begin
            // Issue read request
            @(posedge clk);
            bus_re   <= 1'b1;
            bus_addr <= {word_addr, i[2:0]};
            
            // Wait for data to be valid (2 cycles total from request)
            @(posedge clk);  // SRAM starts reading
            @(posedge clk);  // Data valid
            #1;              // Let non-blocking assignments settle
            
            // Capture data
            data[i*8 +: 8] = bus_dout;
            
            // Deassert bus_re
            bus_re <= 1'b0;
            @(posedge clk);
        end
    endtask

    // Write via TPU interface (direct 64-bit)
    task tpu_write_word(input [8:0] addr, input [63:0] data);
        @(posedge clk);
        tpu_we   <= 1'b1;
        tpu_addr <= addr;
        tpu_din  <= data;
        @(posedge clk);
        tpu_we   <= 1'b0;
    endtask

    // Read via TPU interface (direct 64-bit, 1-cycle latency)
    task tpu_read_word(input [8:0] addr, output [63:0] data);
        @(posedge clk);
        tpu_re   <= 1'b1;
        tpu_addr <= addr;
        @(posedge clk);
        tpu_re   <= 1'b0;
        @(posedge clk);  // 1-cycle latency
        #1;              // Let non-blocking assignments settle
        data = tpu_dout;
    endtask

    //=========================================================================
    // Main Test
    //=========================================================================
    initial begin
        $display("============================================");
        $display("  sram_wrapper Testbench");
        $display("============================================");
        
        // Initialize
        rstn     = 0;
        bus_we   = 0;
        bus_re   = 0;
        bus_addr = 0;
        bus_din  = 0;
        tpu_we   = 0;
        tpu_re   = 0;
        tpu_addr = 0;
        tpu_din  = 0;
        errors   = 0;

        // Reset
        repeat(5) @(posedge clk);
        rstn = 1;
        repeat(5) @(posedge clk);

        //=============================================
        // Test 1: Bus Write -> TPU Read
        //=============================================
        $display("\n[Test 1] Bus Write -> TPU Read");
        
        expected_data = 64'h0706050403020100;
        bus_write_word(9'd0, expected_data);
        
        repeat(3) @(posedge clk);
        tpu_read_word(9'd0, read_data);
        
        if (read_data == expected_data) begin
            $display("  PASS: addr=0, data=%h", read_data);
        end else begin
            $display("  FAIL: addr=0, expected=%h, got=%h", expected_data, read_data);
            errors++;
        end

        //=============================================
        // Test 2: TPU Write -> Bus Read
        //=============================================
        $display("\n[Test 2] TPU Write -> Bus Read");
        
        expected_data = 64'hDEADBEEFCAFEBABE;
        tpu_write_word(9'd1, expected_data);
        
        repeat(3) @(posedge clk);
        bus_read_word(9'd1, read_data);
        
        if (read_data == expected_data) begin
            $display("  PASS: addr=1, data=%h", read_data);
        end else begin
            $display("  FAIL: addr=1, expected=%h, got=%h", expected_data, read_data);
            errors++;
        end

        //=============================================
        // Test 3: TPU Write -> TPU Read
        //=============================================
        $display("\n[Test 3] TPU Write -> TPU Read");
        
        expected_data = 64'h123456789ABCDEF0;
        tpu_write_word(9'd10, expected_data);
        
        repeat(2) @(posedge clk);
        tpu_read_word(9'd10, read_data);
        
        if (read_data == expected_data) begin
            $display("  PASS: addr=10, data=%h", read_data);
        end else begin
            $display("  FAIL: addr=10, expected=%h, got=%h", expected_data, read_data);
            errors++;
        end

        //=============================================
        // Test 4: Bus Write -> Bus Read
        //=============================================
        $display("\n[Test 4] Bus Write -> Bus Read");
        
        expected_data = 64'hAABBCCDDEEFF0011;
        bus_write_word(9'd20, expected_data);
        
        repeat(3) @(posedge clk);
        bus_read_word(9'd20, read_data);
        
        if (read_data == expected_data) begin
            $display("  PASS: addr=20, data=%h", read_data);
        end else begin
            $display("  FAIL: addr=20, expected=%h, got=%h", expected_data, read_data);
            errors++;
        end

        //=============================================
        // Test 5: Multiple consecutive writes via bus
        //=============================================
        $display("\n[Test 5] Multiple consecutive writes via bus");
        
        for (int w = 0; w < 4; w++) begin
            expected_data = 64'hAA00000000000000 | (w << 8) | w;
            bus_write_word(9'd100 + w, expected_data);
        end
        
        repeat(5) @(posedge clk);
        
        for (int w = 0; w < 4; w++) begin
            expected_data = 64'hAA00000000000000 | (w << 8) | w;
            tpu_read_word(9'd100 + w, read_data);
            if (read_data == expected_data) begin
                $display("  PASS: addr=%0d, data=%h", 100+w, read_data);
            end else begin
                $display("  FAIL: addr=%0d, expected=%h, got=%h", 100+w, expected_data, read_data);
                errors++;
            end
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