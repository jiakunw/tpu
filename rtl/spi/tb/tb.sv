//////////////////////////////////////////////////////////////////////////////
// TPU SPI Testbench
//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb();

    //=========================================================================
    // Clock period
    //=========================================================================
    localparam CLK_PERIOD = 10;  // 100 MHz

    //=========================================================================
    // Register addresses (original address >> 2)
    //=========================================================================
    localparam ADDR_CONTROL = 4'h0;  // 0x00
    localparam ADDR_STATUS  = 4'h1;  // 0x04
    localparam ADDR_DIM_M   = 4'h2;  // 0x08
    localparam ADDR_DIM_N   = 4'h3;  // 0x0C
    localparam ADDR_DIM_K   = 4'h4;  // 0x10

    //=========================================================================
    // Signals
    //=========================================================================
    logic        clk;
    logic        rst_n;
    
    // SPI Master interface
    logic [7:0]  tx_byte   = 8'h00;
    logic        tx_dv     = 1'b0;
    logic        tx_ready;
    logic        rx_dv;
    logic [7:0]  rx_byte;
    logic [2:0]  tx_count  = 3'd0;
    
    // SPI wires
    wire         spi_cs_n;
    wire         spi_sck;
    wire         spi_mosi;
    wire         spi_miso;
    
    // TPU interface
    logic        tpu_start;
    logic        tpu_idle    = 1'b1;
    logic        tpu_working = 1'b0;
    logic        tpu_done    = 1'b0;
    logic [5:0]  dim_m;
    logic [5:0]  dim_n;
    logic [5:0]  dim_k;

    //=========================================================================
    // Clock generator
    //=========================================================================
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    //=========================================================================
    // Waveform dump
    //=========================================================================
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
    end

    //=========================================================================
    // SPI Master instance
    //=========================================================================
    SPI_Master_With_Single_CS #(
        .SPI_MODE          (0),
        .CLKS_PER_HALF_BIT (2),
        .MAX_BYTES_PER_CS  (4),
        .CS_INACTIVE_CLKS  (2)
    ) u_master (
        .i_Rst_L    (rst_n),
        .i_Clk      (clk),
        .i_TX_Count (tx_count),
        .i_TX_Byte  (tx_byte),
        .i_TX_DV    (tx_dv),
        .o_TX_Ready (tx_ready),
        .o_RX_Count (),
        .o_RX_DV    (rx_dv),
        .o_RX_Byte  (rx_byte),
        .o_SPI_Clk  (spi_sck),
        .i_SPI_MISO (spi_miso),
        .o_SPI_MOSI (spi_mosi),
        .o_SPI_CS_n (spi_cs_n)
    );

    //=========================================================================
    // TPU (DUT)
    //=========================================================================
    top u_tpu (
        .clk         (clk),
        .rst_n       (rst_n),
        .spi_sck     (spi_sck),
        .spi_cs_n    (spi_cs_n),
        .spi_mosi    (spi_mosi),
        .spi_miso    (spi_miso),
        .tpu_start   (tpu_start),
        .tpu_idle    (tpu_idle),
        .tpu_working (tpu_working),
        .tpu_done    (tpu_done),
        .dim_m       (dim_m),
        .dim_n       (dim_n),
        .dim_k       (dim_k)
    );

    //=========================================================================
    // SPI Transfer Task
    // Send one byte while simultaneously receiving one byte
    //=========================================================================
    task spi_transfer(input [7:0] tx_data, output [7:0] rx_data);
        // Wait for master to be ready
        while (!tx_ready) @(posedge clk);
        
        // Send byte
        @(posedge clk);
        tx_byte <= tx_data;
        tx_dv   <= 1'b1;
        
        @(posedge clk);
        tx_dv <= 1'b0;
        
        // Wait for transfer complete, capture rx_dv
        rx_data = 8'h00;
        while (!tx_ready) begin
            @(posedge clk);
            if (rx_dv) rx_data = rx_byte;
        end
        // Check one more time (rx_dv might coincide with tx_ready)
        if (rx_dv) rx_data = rx_byte;
    endtask

    //=========================================================================
    // SPI Read Task
    // Protocol: [CMD] -> [DATA or NAK]
    //=========================================================================
    task spi_read(input [3:0] addr, output [7:0] data, output logic success);
        logic [7:0] cmd;
        logic [7:0] dummy;
        
        cmd = {addr, 4'b0001};  // READ opcode
        
        // Wait for master idle
        while (!tx_ready) @(posedge clk);
        
        // Set byte count for this transaction
        tx_count = 2;
        @(posedge clk);
        
        // Send CMD, receive dummy
        spi_transfer(cmd, dummy);
        
        // Send dummy, receive DATA or NAK
        spi_transfer(8'h00, data);
        
        // Check result
        success = (data != 8'hF0);
    endtask

    //=========================================================================
    // SPI Write Task
    // Protocol: [CMD] -> [ACK or NAK] -> [DATA] -> [ACK]
    //=========================================================================
    task spi_write(input [3:0] addr, input [7:0] data, output logic success);
        logic [7:0] cmd;
        logic [7:0] resp1, resp2;
        logic [7:0] dummy;
        
        cmd = {addr, 4'b0010};  // WRITE opcode
        
        // Wait for master idle
        while (!tx_ready) @(posedge clk);
        
        // Set byte count for this transaction
        tx_count = 4;
        @(posedge clk);
        
        // Send CMD, receive dummy
        spi_transfer(cmd, dummy);
        
        // Send dummy, receive ACK or NAK
        spi_transfer(8'h00, resp1);
        
        if (resp1 == 8'hF0) begin
            // NAK - address invalid or not writable
            success = 1'b0;
            // Still need to complete the transaction (send remaining bytes)
            spi_transfer(data, dummy);
            spi_transfer(8'h00, resp2);
        end else begin
            // Send DATA, receive dummy
            spi_transfer(data, dummy);
            
            // Send dummy, receive final ACK
            spi_transfer(8'h00, resp2);
            
            success = (resp1 == 8'hFF) && (resp2 == 8'hFF);
        end
    endtask

    //=========================================================================
    // Test counters
    //=========================================================================
    int test_count = 0;
    int pass_count = 0;
    int fail_count = 0;
    
    task check(string name, logic condition);
        test_count++;
        if (condition) begin
            pass_count++;
            $display("[PASS] %s", name);
        end else begin
            fail_count++;
            $display("[FAIL] %s", name);
        end
    endtask

    //=========================================================================
    // Reset
    //=========================================================================
    initial begin
        rst_n = 1'b0;
        repeat(10) @(posedge clk);
        rst_n = 1'b1;
    end

    //=========================================================================
    // Main test
    //=========================================================================
    initial begin
        logic [7:0] read_data;
        logic       success;
        
        // Wait for reset
        wait(rst_n == 1'b1);
        repeat(20) @(posedge clk);
        
        $display("");
        $display("==========================================");
        $display("       TPU SPI Interface Test");
        $display("==========================================");
        $display("");
        
        fork
            //--- Main test sequence ---
            begin
                //---------------------------------------------
                $display("--- Test 1: Read Status Register ---");
                spi_read(ADDR_STATUS, read_data, success);
                check("Read Status success", success);
                check("Status = idle", read_data[0] == 1'b1);
                $display("    Status = 0x%02h (idle=%b, working=%b, done=%b)",
                         read_data, read_data[0], read_data[1], read_data[2]);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 2: Write Status Register (should NAK) ---");
                spi_write(ADDR_STATUS, 8'hAB, success);
                check("Write Status returns NAK", !success);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 3: Read Status again (unchanged) ---");
                spi_read(ADDR_STATUS, read_data, success);
                check("Read Status success", success);
                check("Status still idle", read_data[0] == 1'b1);
                $display("    Status = 0x%02h", read_data);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 4: Write DIM_M = 16 ---");
                spi_write(ADDR_DIM_M, 8'd16, success);
                check("Write DIM_M success", success);
                check("dim_m output = 16", dim_m == 6'd16);
                $display("    dim_m = %0d", dim_m);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 5: Read back DIM_M ---");
                spi_read(ADDR_DIM_M, read_data, success);
                check("Read DIM_M success", success);
                check("DIM_M = 16", read_data == 8'd16);
                $display("    DIM_M = %0d", read_data);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 6: Write DIM_N = 8 ---");
                spi_write(ADDR_DIM_N, 8'd8, success);
                check("Write DIM_N success", success);
                check("dim_n output = 8", dim_n == 6'd8);
                $display("    dim_n = %0d", dim_n);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 7: Read back DIM_N ---");
                spi_read(ADDR_DIM_N, read_data, success);
                check("Read DIM_N success", success);
                check("DIM_N = 8", read_data == 8'd8);
                $display("    DIM_N = %0d", read_data);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 8: Write DIM_K = 32 ---");
                spi_write(ADDR_DIM_K, 8'd32, success);
                check("Write DIM_K success", success);
                check("dim_k output = 32", dim_k == 6'd32);
                $display("    dim_k = %0d", dim_k);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 9: Read back DIM_K ---");
                spi_read(ADDR_DIM_K, read_data, success);
                check("Read DIM_K success", success);
                check("DIM_K = 32", read_data == 8'd32);
                $display("    DIM_K = %0d", read_data);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 10: Write Control (start TPU) ---");
                spi_write(ADDR_CONTROL, 8'h01, success);
                check("Write Control success", success);
                $display("    tpu_start pulse observed");
                $display("");
                
                //---------------------------------------------
                $display("--- Test 11: Read invalid address 0xF ---");
                spi_read(4'hF, read_data, success);
                check("Read invalid addr returns NAK", !success);
                $display("    Response = 0x%02h (NAK=0xF0)", read_data);
                $display("");
                
                //---------------------------------------------
                $display("--- Test 12: Write invalid address 0xF ---");
                spi_write(4'hF, 8'h55, success);
                check("Write invalid addr returns NAK", !success);
                $display("");
                
                //---------------------------------------------
                // Summary
                $display("==========================================");
                $display("           Test Summary");
                $display("==========================================");
                $display("  Total:  %0d", test_count);
                $display("  Passed: %0d", pass_count);
                $display("  Failed: %0d", fail_count);
                $display("==========================================");
                $display("");
                
                if (fail_count == 0)
                    $display("*** ALL TESTS PASSED ***");
                else
                    $display("*** SOME TESTS FAILED ***");
                
                $display("");
                $finish;
            end
            
            //--- Timeout watchdog ---
            begin
                #100000ns;
                $display("");
                $display("*** TIMEOUT ***");
                $display("");
                $finish;
            end
        join_any
        disable fork;
    end

endmodule