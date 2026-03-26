///////////////////////////////////////////////////////////////////////////////
// tb.sv
//
// Testbench: AXI SPI Master (100MHz) <-> rf_top Slave (10MHz)
// SPI Clock: 2 MHz
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

    // Debug from master
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
    // AXI Write Task
    //=========================================================================
    task axi_write(input logic [6:0] addr, input logic [31:0] data);
        $display("      [axi_write] START addr=0x%02h data=0x%08h", addr, data);
        
        @(posedge master_clk); #1;
        S_AXI_awaddr  = addr;
        S_AXI_wdata   = data;
        S_AXI_awprot  = 3'd0;
        S_AXI_awvalid = 1'b1;
        S_AXI_wvalid  = 1'b1;
        S_AXI_wstrb   = 4'b1111;
        S_AXI_bready  = 1'b0;  // ← 改这里
        
        // Wait for AWREADY
        $display("      [axi_write] Waiting AWREADY...");
        wait(S_AXI_awready == 1'b1);
        $display("      [axi_write] Got AWREADY");
        
        @(posedge master_clk); #1;
        S_AXI_awvalid = 1'b0;
        
        // Wait for WREADY
        $display("      [axi_write] Waiting WREADY...");
        wait(S_AXI_wready == 1'b1);
        $display("      [axi_write] Got WREADY");
        
        @(posedge master_clk); #1;
        S_AXI_wvalid = 1'b0;
        
        // Wait for BVALID
        $display("      [axi_write] Waiting BVALID...");
        wait(S_AXI_bvalid == 1'b1);
        $display("      [axi_write] Got BVALID");
        
        S_AXI_bready = 1'b1;  // ← 现在才设
        @(posedge master_clk); #1;
        S_AXI_bready = 1'b0;
        
        $display("      [axi_write] DONE");
    endtask

    //=========================================================================
    // AXI Read Task
    //=========================================================================
    task axi_read(input logic [6:0] addr, output logic [31:0] data);
        int timeout;
        
        $display("      [axi_read] START addr=0x%02h", addr);
        @(posedge master_clk); #1;
        S_AXI_araddr  = addr;
        S_AXI_arprot  = 3'd0;
        S_AXI_arvalid = 1'b1;
        S_AXI_rready  = 1'b0;  // ← 不要提前设 RREADY！
        
        // Wait for ARREADY
        $display("      [axi_read] Waiting ARREADY...");
        wait(S_AXI_arready == 1'b1);
        $display("      [axi_read] Got ARREADY");
        @(posedge master_clk); #1;
        S_AXI_arvalid = 1'b0;
        
        // Wait for RVALID
        $display("      [axi_read] Waiting RVALID...");
        wait(S_AXI_rvalid);
        $display("      [axi_read] Got RVALID");
        
        data = S_AXI_rdata;
        S_AXI_rready = 1'b1;  // ← 现在才设 RREADY
        @(posedge master_clk); #1;
        S_AXI_rready = 1'b0;
        $display("      [axi_read] DONE data=0x%08h", data);
    endtask

    //=========================================================================
    // Wait TX Ready
    //=========================================================================
    task wait_tx_ready();
        logic [31:0] status;
        int count;
        
        $display("    [wait_tx_ready] START");
        count = 0;
        
        do begin
            axi_read(MASTER_STATUS, status);
            $display("    [wait_tx_ready] status=0x%08h TX_READY=%b count=%0d", status, status[0], count);
            count++;
            if (count > 200) begin
                $display("ERROR: wait_tx_ready timeout!");
                $finish;
            end
            if (status[0] == 1'b0) begin
                repeat(50) @(posedge master_clk);
            end
        end while (status[0] == 1'b0);
        
        $display("    [wait_tx_ready] DONE");
    endtask

    //=========================================================================
    // SPI CS Assert/Deassert
    //=========================================================================
    task spi_cs_assert();
        $display("    [spi_cs_assert] CS -> LOW");
        axi_write(MASTER_CONTROL, 32'h0);
        repeat(20) @(posedge master_clk);
    endtask

    task spi_cs_deassert();
        $display("    [spi_cs_deassert] CS -> HIGH");
        axi_write(MASTER_CONTROL, 32'h1);
        repeat(20) @(posedge master_clk);
    endtask

    //=========================================================================
    // SPI Transfer (send byte, receive byte)
    //=========================================================================
    task spi_transfer(input logic [7:0] tx_byte, output logic [7:0] rx_byte);
        logic [31:0] rx_data;
        
        $display("    [spi_transfer] TX=0x%02h", tx_byte);
        
        wait_tx_ready();
        axi_write(MASTER_TX_DATA, {24'h0, tx_byte});
        wait_tx_ready();
        
        axi_read(MASTER_RX_DATA, rx_data);
        rx_byte = rx_data[7:0];
        
        $display("    [spi_transfer] RX=0x%02h", rx_byte);
    endtask

    //=========================================================================
    // Slave Register Write
    //=========================================================================
    task slave_reg_write(input logic [3:0] reg_addr, input logic [7:0] data);
        logic [7:0] cmd_byte;
        logic [7:0] dummy;
        
        $display("  [slave_reg_write] reg[%0d] <- 0x%02h", reg_addr, data);
        
        cmd_byte = {1'b0, 3'b000, reg_addr};  // WR=0
        
        spi_cs_assert();
        spi_transfer(cmd_byte, dummy);
        spi_transfer(data, dummy);
        spi_cs_deassert();
        
        repeat(50) @(posedge slave_clk);
        
        $display("  [slave_reg_write] DONE");
    endtask

    //=========================================================================
    // Slave Register Read
    //=========================================================================
    task slave_reg_read(input logic [3:0] reg_addr, output logic [7:0] data);
        logic [7:0] cmd_byte;
        logic [7:0] dummy;
        
        $display("  [slave_reg_read] reg[%0d]", reg_addr);
        
        cmd_byte = {1'b1, 3'b000, reg_addr};  // RD=1
        
        spi_cs_assert();
        spi_transfer(cmd_byte, dummy);
        spi_transfer(8'hFF, data);
        spi_cs_deassert();
        
        $display("  [slave_reg_read] -> 0x%02h", data);
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
        $display("[INIT] Initializing signals...");
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
        $display("[INIT] Applying reset...");
        repeat(20) @(posedge master_clk);
        aresetn = 1;
        $display("[INIT] Reset released");
        repeat(200) @(posedge master_clk);

        // Check initial TX_READY
        $display("[INIT] Checking initial SPI Master status...");
        begin
            logic [31:0] status;
            axi_read(MASTER_STATUS, status);
            $display("[INIT] Initial STATUS = 0x%08h, TX_READY = %b", status, status[0]);
        end

        // Initialize CS high
        $display("[INIT] Setting CS high...");
        spi_cs_deassert();
        repeat(100) @(posedge master_clk);

        $display("[INIT] Initialization complete!\n");

        //=============================================
        // Test 1: Simple SPI byte transfer
        //=============================================
        $display("============================================");
        $display("[Test 1] Simple SPI byte transfer");
        $display("============================================");
        
        begin
            logic [7:0] tx_data, rx_data;
            tx_data = 8'hA5;
            
            spi_cs_assert();
            spi_transfer(tx_data, rx_data);
            spi_cs_deassert();
            
            $display("[Test 1] Sent 0x%02h, Received 0x%02h", tx_data, rx_data);
            $display("[Test 1] COMPLETE\n");
        end

        //=============================================
        // Test 2: Write to slave register
        //=============================================
        $display("============================================");
        $display("[Test 2] Write dim_m = 8");
        $display("============================================");
        
        slave_reg_write(4'h2, 8'd8);
        
        $display("[Test 2] dim_m = %0d (expected 8)", dim_m);
        if (dim_m == 6'd8) begin
            $display("[Test 2] PASS\n");
        end else begin
            $display("[Test 2] FAIL\n");
            errors++;
        end

        //=============================================
        // Test 3: Write dim_n
        //=============================================
        $display("============================================");
        $display("[Test 3] Write dim_n = 16");
        $display("============================================");
        
        slave_reg_write(4'h3, 8'd16);
        
        $display("[Test 3] dim_n = %0d (expected 16)", dim_n);
        if (dim_n == 6'd16) begin
            $display("[Test 3] PASS\n");
        end else begin
            $display("[Test 3] FAIL\n");
            errors++;
        end

        //=============================================
        // Test 4: Write dim_k
        //=============================================
        $display("============================================");
        $display("[Test 4] Write dim_k = 32");
        $display("============================================");
        
        slave_reg_write(4'h4, 8'd32);
        
        $display("[Test 4] dim_k = %0d (expected 32)", dim_k);
        if (dim_k == 6'd32) begin
            $display("[Test 4] PASS\n");
        end else begin
            $display("[Test 4] FAIL\n");
            errors++;
        end

        //=============================================
        // Test 5: Read back from slave
        //=============================================
        $display("============================================");
        $display("[Test 5] Read dim_m back");
        $display("============================================");
        
        slave_reg_read(4'h2, rx_byte);
        
        $display("[Test 5] Read back: 0x%02h (expected 0x08)", rx_byte);
        if (rx_byte == 8'd8) begin
            $display("[Test 5] PASS\n");
        end else begin
            $display("[Test 5] FAIL\n");
            errors++;
        end

        //=============================================
        // Summary
        //=============================================
        repeat(200) @(posedge master_clk);
        
        $display("============================================");
        $display("  TEST SUMMARY");
        $display("============================================");
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
        #(MASTER_CLK_PERIOD * 50000000);
        $display("\n============================================");
        $display("ERROR: Global Timeout!");
        $display("============================================\n");
        $finish;
    end

    //=========================================================================
    // Waveform Dump
    //=========================================================================
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb_spi_master_slave);
    end

endmodule