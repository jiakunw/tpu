///////////////////////////////////////////////////////////////////////////////
// tb_spi_master_slave.sv
//
// Testbench: AXI SPI Master (100MHz) <-> rf_top Slave (10MHz)
// SPI Clock: 2 MHz (CLKS_PER_HALF_BIT = 25)
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_spi_master_slave;

    //=========================================================================
    // Parameters
    //=========================================================================
    parameter MASTER_CLK_PERIOD = 10;    // 100 MHz
    parameter SLAVE_CLK_PERIOD  = 100;   // 10 MHz
    parameter CLKS_PER_HALF_BIT = 25;    // SPI = 100MHz / (2*25) = 2 MHz
    parameter SPI_MODE = 0;

    //=========================================================================
    // Clocks and Reset
    //=========================================================================
    logic master_clk;
    logic slave_clk;
    logic aresetn;

    initial master_clk = 0;
    always #(MASTER_CLK_PERIOD/2) master_clk = ~master_clk;

    initial slave_clk = 0;
    always #(SLAVE_CLK_PERIOD/2) slave_clk = ~slave_clk;

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
    // SPI Signals
    //=========================================================================
    logic spi_sck;
    logic spi_cs_n;
    logic spi_mosi;
    logic spi_miso;

    //=========================================================================
    // rf_top TPU Interface
    //=========================================================================
    logic        tpu_start;
    logic        tpu_idle;
    logic        tpu_working;
    logic        tpu_done;
    logic [5:0]  dim_m;
    logic [5:0]  dim_n;
    logic [5:0]  dim_k;

    // Debug
    logic [1:0]  debug_wr_state;
    logic [1:0]  debug_rd_state;

    // Test variables
    logic [31:0] read_data;
    logic [7:0]  rx_byte;
    int          errors;

    //=========================================================================
    // Master Register Addresses
    //=========================================================================
    localparam logic [6:0] MASTER_TX_DATA  = 7'h00;
    localparam logic [6:0] MASTER_RX_DATA  = 7'h04;
    localparam logic [6:0] MASTER_STATUS   = 7'h08;
    localparam logic [6:0] MASTER_CONTROL  = 7'h0C;

    //=========================================================================
    // DUT: AXI SPI Master (100 MHz)
    //=========================================================================
    axi_spi_master #(
        .C_S_AXI_DATA_WIDTH (32),
        .C_S_AXI_ADDR_WIDTH (7),
        .SPI_MODE           (SPI_MODE),
        .CLKS_PER_HALF_BIT  (CLKS_PER_HALF_BIT)
    ) u_master (
        .S_AXI_ACLK     (master_clk),
        .S_AXI_ARESETN  (aresetn),
        
        .S_AXI_AWADDR   (S_AXI_awaddr),
        .S_AXI_AWVALID  (S_AXI_awvalid),
        .S_AXI_AWREADY  (S_AXI_awready),
        
        .S_AXI_WDATA    (S_AXI_wdata),
        .S_AXI_WSTRB    (S_AXI_wstrb),
        .S_AXI_WVALID   (S_AXI_wvalid),
        .S_AXI_WREADY   (S_AXI_wready),
        
        .S_AXI_BRESP    (S_AXI_bresp),
        .S_AXI_BVALID   (S_AXI_bvalid),
        .S_AXI_BREADY   (S_AXI_bready),
        
        .S_AXI_ARADDR   (S_AXI_araddr),
        .S_AXI_ARVALID  (S_AXI_arvalid),
        .S_AXI_ARREADY  (S_AXI_arready),
        
        .S_AXI_RDATA    (S_AXI_rdata),
        .S_AXI_RRESP    (S_AXI_rresp),
        .S_AXI_RVALID   (S_AXI_rvalid),
        .S_AXI_RREADY   (S_AXI_rready),
        
        .SPI_SCK        (spi_sck),
        .SPI_MOSI       (spi_mosi),
        .SPI_MISO       (spi_miso),
        .SPI_CS_N       (spi_cs_n),
        
        .debug_wr_state (debug_wr_state),
        .debug_rd_state (debug_rd_state)
    );

    //=========================================================================
    // DUT: rf_top SPI Slave (10 MHz)
    //=========================================================================
    rf_top u_slave (
        .clk            (slave_clk),
        .rst_n          (aresetn),
        
        .spi_sck        (spi_sck),
        .spi_cs_n       (spi_cs_n),
        .spi_mosi       (spi_mosi),
        .spi_miso       (spi_miso),
        
        .tpu_start      (tpu_start),
        .tpu_idle       (tpu_idle),
        .tpu_working    (tpu_working),
        .tpu_done       (tpu_done),
        
        .dim_m          (dim_m),
        .dim_n          (dim_n),
        .dim_k          (dim_k)
    );

    //=========================================================================
    // AXI Write Task (uses master_clk)
    //=========================================================================
    task axi_write(input logic [6:0] addr, input logic [31:0] data);
        @(posedge master_clk); #1;
        S_AXI_awaddr  = addr;
        S_AXI_wdata   = data;
        S_AXI_awprot  = 3'd0;
        S_AXI_awvalid = 1'b1;
        S_AXI_wvalid  = 1'b1;
        S_AXI_wstrb   = 4'b1111;
        S_AXI_bready  = 1'b1;
        
        wait(S_AXI_awready == 1'b1);
        @(posedge master_clk); #1;
        S_AXI_awvalid = 1'b0;
        
        wait(S_AXI_wready == 1'b1);
        @(posedge master_clk); #1;
        S_AXI_wvalid = 1'b0;
        
        wait(S_AXI_bvalid == 1'b1);
        @(posedge master_clk); #1;
        S_AXI_bready = 1'b0;
    endtask

    //=========================================================================
    // AXI Read Task (uses master_clk)
    //=========================================================================
    task axi_read(input logic [6:0] addr, output logic [31:0] data);
        @(posedge master_clk); #1;
        S_AXI_araddr  = addr;
        S_AXI_arprot  = 3'd0;
        S_AXI_arvalid = 1'b1;
        S_AXI_rready  = 1'b1;
        
        wait(S_AXI_arready == 1'b1);
        @(posedge master_clk); #1;
        S_AXI_arvalid = 1'b0;
        
        wait(S_AXI_rvalid == 1'b1);
        data = S_AXI_rdata;
        @(posedge master_clk); #1;
        S_AXI_rready = 1'b0;
    endtask

    //=========================================================================
    // SPI Helper Tasks
    //=========================================================================
    
    // Wait for SPI TX Ready
    task wait_tx_ready();
        logic [31:0] status;
        int timeout;
        timeout = 0;
        do begin
            axi_read(MASTER_STATUS, status);
            timeout++;
            if (timeout > 1000) begin
                $display("ERROR: wait_tx_ready timeout!");
                $finish;
            end
        end while (status[0] == 1'b0);
    endtask

    // Assert CS (select slave)
    task spi_cs_assert();
        axi_write(MASTER_CONTROL, 32'h0);  // CS_N = 0
        repeat(10) @(posedge master_clk);
    endtask

    // Deassert CS (deselect slave)
    task spi_cs_deassert();
        axi_write(MASTER_CONTROL, 32'h1);  // CS_N = 1
        repeat(10) @(posedge master_clk);
    endtask

    // Send byte and receive response
    task spi_transfer(input logic [7:0] tx_byte, output logic [7:0] rx_byte);
        logic [31:0] rx_data;
        
        wait_tx_ready();
        axi_write(MASTER_TX_DATA, {24'h0, tx_byte});
        wait_tx_ready();
        
        axi_read(MASTER_RX_DATA, rx_data);
        rx_byte = rx_data[7:0];
    endtask

    // Write to slave register
    // Protocol: [WR=0 | ADDR[6:0]] [DATA]
    task slave_reg_write(input logic [3:0] reg_addr, input logic [7:0] data);
        logic [7:0] cmd_byte;
        logic [7:0] dummy;
        
        cmd_byte = {1'b0, 3'b000, reg_addr};  // WR=0
        
        spi_cs_assert();
        spi_transfer(cmd_byte, dummy);
        spi_transfer(data, dummy);
        spi_cs_deassert();
        
        // Wait for slave to process (a few slave clock cycles)
        repeat(20) @(posedge slave_clk);
        
        $display("  [SPI WR] reg[%0d] <- 0x%02h", reg_addr, data);
    endtask

    // Read from slave register
    // Protocol: [RD=1 | ADDR[6:0]] [DUMMY] -> [DATA]
    task slave_reg_read(input logic [3:0] reg_addr, output logic [7:0] data);
        logic [7:0] cmd_byte;
        logic [7:0] dummy;
        
        cmd_byte = {1'b1, 3'b000, reg_addr};  // RD=1
        
        spi_cs_assert();
        spi_transfer(cmd_byte, dummy);
        spi_transfer(8'hFF, data);
        spi_cs_deassert();
        
        $display("  [SPI RD] reg[%0d] -> 0x%02h", reg_addr, data);
    endtask

    //=========================================================================
    // Main Test
    //=========================================================================
    initial begin
        $display("============================================");
        $display("  SPI Master <-> Slave Testbench");
        $display("  Master CLK: 100 MHz");
        $display("  Slave CLK:  10 MHz");
        $display("  SPI CLK:    2 MHz");
        $display("============================================");

        // Initialize AXI signals
        aresetn       = 0;
        S_AXI_awaddr  = 0;
        S_AXI_awvalid = 0;
        S_AXI_awprot  = 0;
        S_AXI_wdata   = 0;
        S_AXI_wstrb   = 0;
        S_AXI_wvalid  = 0;
        S_AXI_bready  = 0;
        S_AXI_araddr  = 0;
        S_AXI_arvalid = 0;
        S_AXI_arprot  = 0;
        S_AXI_rready  = 0;
        
        // Initialize TPU status
        tpu_idle      = 1;
        tpu_working   = 0;
        tpu_done      = 0;
        errors        = 0;

        // Reset sequence
        repeat(20) @(posedge master_clk);
        aresetn = 1;
        repeat(20) @(posedge master_clk);

        // Initialize CS high
        spi_cs_deassert();
        repeat(50) @(posedge master_clk);

        //=============================================
        // Test 1: Write dim_m
        //=============================================
        $display("\n[Test 1] Write dim_m = 8");
        slave_reg_write(4'h2, 8'd8);
        
        if (dim_m == 6'd8) begin
            $display("  PASS: dim_m = %0d", dim_m);
        end else begin
            $display("  FAIL: dim_m expected=8, got=%0d", dim_m);
            errors++;
        end

        //=============================================
        // Test 2: Write dim_n
        //=============================================
        $display("\n[Test 2] Write dim_n = 16");
        slave_reg_write(4'h3, 8'd16);
        
        if (dim_n == 6'd16) begin
            $display("  PASS: dim_n = %0d", dim_n);
        end else begin
            $display("  FAIL: dim_n expected=16, got=%0d", dim_n);
            errors++;
        end

        //=============================================
        // Test 3: Write dim_k
        //=============================================
        $display("\n[Test 3] Write dim_k = 32");
        slave_reg_write(4'h4, 8'd32);
        
        if (dim_k == 6'd32) begin
            $display("  PASS: dim_k = %0d", dim_k);
        end else begin
            $display("  FAIL: dim_k expected=32, got=%0d", dim_k);
            errors++;
        end

        //=============================================
        // Test 4: Read back dim_m
        //=============================================
        $display("\n[Test 4] Read dim_m");
        slave_reg_read(4'h2, rx_byte);
        
        if (rx_byte == 8'd8) begin
            $display("  PASS: read dim_m = %0d", rx_byte);
        end else begin
            $display("  FAIL: read dim_m expected=8, got=%0d", rx_byte);
            errors++;
        end

        //=============================================
        // Test 5: Read status
        //=============================================
        $display("\n[Test 5] Read status");
        slave_reg_read(4'h1, rx_byte);
        $display("  Status = 0x%02h", rx_byte);

        //=============================================
        // Test 6: Start TPU
        //=============================================
        $display("\n[Test 6] Start TPU (write control)");
        slave_reg_write(4'h0, 8'h01);
        
        repeat(10) @(posedge slave_clk);
        
        if (tpu_start == 1'b1) begin
            $display("  PASS: tpu_start = 1");
        end else begin
            $display("  FAIL: tpu_start not asserted");
            errors++;
        end

        //=============================================
        // Test 7: Multiple transactions
        //=============================================
        $display("\n[Test 7] Multiple writes");
        for (int i = 0; i < 4; i++) begin
            slave_reg_write(4'h2, 8'd20 + i);
        end
        
        if (dim_m == 6'd23) begin
            $display("  PASS: dim_m = %0d", dim_m);
        end else begin
            $display("  FAIL: dim_m expected=23, got=%0d", dim_m);
            errors++;
        end

        //=============================================
        // Summary
        //=============================================
        repeat(100) @(posedge master_clk);
        $display("\n============================================");
        if (errors == 0) begin
            $display("  ALL TESTS PASSED!");
        end else begin
            $display("  FAILED: %0d errors", errors);
        end
        $display("============================================\n");

        $finish;
    end

    //=========================================================================
    // Timeout
    //=========================================================================
    initial begin
        #(MASTER_CLK_PERIOD * 500000);
        $display("ERROR: Timeout!");
        $finish;
    end

    //=========================================================================
    // Waveform Dump
    //=========================================================================
    initial begin
        $dumpfile("spi_master_slave.vcd");
        $dumpvars(0, tb_spi_master_slave);
    end

endmodule