///////////////////////////////////////////////////////////////////////////////
// tb.sv - SPI Master <-> Slave Testbench (Single 100MHz Clock)
//
// Protocol:
//   CMD byte: [ADDR[7:4] | CMD[3:0]]
//   CMD_READ  = 4'b0001 (0x1)
//   CMD_WRITE = 4'b0010 (0x2)
//
//   WRITE: [CMD] [ACK/NAK] [DATA] [ACK]  (4 bytes)
//   READ:  [CMD] [DATA]                   (2 bytes)
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_spi_master_slave;

    //=========================================================================
    // Parameters
    //=========================================================================
    parameter CLK_PERIOD        = 10;   // 100 MHz
    parameter CLKS_PER_HALF_BIT = 5;    // SPI = 100/(5*2) = 10 MHz
    parameter SPI_MODE          = 0;

    //=========================================================================
    // Protocol Constants
    //=========================================================================
    localparam logic [3:0] CMD_READ  = 4'b0001;  // 0x1
    localparam logic [3:0] CMD_WRITE = 4'b0010;  // 0x2
    localparam logic [7:0] RESP_ACK  = 8'hFF;
    localparam logic [7:0] RESP_NAK  = 8'hF0;

    // Register addresses
    localparam logic [3:0] REG_CONTROL = 4'h0;
    localparam logic [3:0] REG_STATUS  = 4'h1;
    localparam logic [3:0] REG_DIM_M   = 4'h2;
    localparam logic [3:0] REG_DIM_N   = 4'h3;
    localparam logic [3:0] REG_DIM_K   = 4'h4;

    //=========================================================================
    // Clock and Reset (Single Clock Domain)
    //=========================================================================
    logic clk;
    logic rst_n;

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

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
        .S_AXI_ACLK     (clk),
        .S_AXI_ARESETN  (rst_n),
        
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
    // DUT: rf_top SPI Slave (100 MHz - Same Clock!)
    //=========================================================================
    rf_top u_slave (
        .clk            (clk),      // Same 100MHz clock
        .rst_n          (rst_n),
        
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
        int timeout;
        logic got_awready, got_wready;
        
        $display("      [axi_write] START addr=0x%02h data=0x%08h", addr, data);
        @(posedge clk); #1;
        S_AXI_awaddr  = addr;
        S_AXI_wdata   = data;
        S_AXI_awprot  = 3'd0;
        S_AXI_awvalid = 1'b1;
        S_AXI_wvalid  = 1'b1;
        S_AXI_wstrb   = 4'b1111;
        S_AXI_bready  = 1'b0;
        
        got_awready = 0;
        got_wready = 0;
        timeout = 0;
        
        // Wait for BOTH AWREADY and WREADY (may come same or different cycles)
        while (!got_awready || !got_wready) begin
            @(posedge clk);
            if (S_AXI_awready) begin
                got_awready = 1;
                $display("      [axi_write] Got AWREADY");
            end
            if (S_AXI_wready) begin
                got_wready = 1;
                $display("      [axi_write] Got WREADY");
            end
            timeout++;
            if (timeout > 100) begin
                $display("ERROR: axi_write timeout! awready=%b wready=%b", got_awready, got_wready);
                $finish;
            end
        end
        
        #1;
        S_AXI_awvalid = 1'b0;
        S_AXI_wvalid  = 1'b0;
        
        // Wait for BVALID
        $display("      [axi_write] Waiting BVALID...");
        timeout = 0;
        while (S_AXI_bvalid !== 1'b1) begin
            @(posedge clk);
            timeout++;
            if (timeout > 100) begin
                $display("ERROR: BVALID timeout!");
                $finish;
            end
        end
        $display("      [axi_write] Got BVALID");
        
        S_AXI_bready = 1'b1;
        @(posedge clk); #1;
        S_AXI_bready = 1'b0;
        $display("      [axi_write] DONE");
    endtask

    //=========================================================================
    // AXI Read Task
    //=========================================================================
    task axi_read(input logic [6:0] addr, output logic [31:0] data);
        int timeout;
        
        @(posedge clk); #1;
        S_AXI_araddr  = addr;
        S_AXI_arprot  = 3'd0;
        S_AXI_arvalid = 1'b1;
        S_AXI_rready  = 1'b0;
        
        timeout = 0;
        while (S_AXI_arready !== 1'b1) begin
            @(posedge clk);
            timeout++;
            if (timeout > 100) begin $display("ERROR: ARREADY timeout!"); $finish; end
        end
        @(posedge clk); #1;
        S_AXI_arvalid = 1'b0;
        
        timeout = 0;
        while (S_AXI_rvalid !== 1'b1) begin
            @(posedge clk);
            timeout++;
            if (timeout > 100) begin $display("ERROR: RVALID timeout!"); $finish; end
        end
        
        data = S_AXI_rdata;
        S_AXI_rready = 1'b1;
        @(posedge clk); #1;
        S_AXI_rready = 1'b0;
    endtask

    //=========================================================================
    // SPI Helper Tasks
    //=========================================================================
    
    task wait_tx_ready();
        logic [31:0] status;
        int count;
        count = 0;
        do begin
            axi_read(MASTER_STATUS, status);
            count++;
            if (count > 500) begin $display("ERROR: TX_READY timeout!"); $finish; end
            repeat(2) @(posedge clk);
        end while (status[0] == 1'b0);
    endtask

    task spi_cs_assert();
        axi_write(MASTER_CONTROL, 32'h0);
        repeat(5) @(posedge clk);
    endtask

    task spi_cs_deassert();
        axi_write(MASTER_CONTROL, 32'h1);
        repeat(5) @(posedge clk);
    endtask

    task spi_transfer(input logic [7:0] tx_byte, output logic [7:0] rx_byte);
        logic [31:0] rx_data;
        wait_tx_ready();
        axi_write(MASTER_TX_DATA, {24'h0, tx_byte});
        wait_tx_ready();
        axi_read(MASTER_RX_DATA, rx_data);
        rx_byte = rx_data[7:0];
    endtask

    //=========================================================================
    // Write to slave register (4-byte protocol)
    //=========================================================================
    task slave_reg_write(input logic [3:0] reg_addr, input logic [7:0] data, output int success);
        logic [7:0] cmd_byte;
        logic [7:0] resp0, resp1, resp2, resp3;
        
        cmd_byte = {reg_addr, CMD_WRITE};
        
        spi_cs_assert();
        spi_transfer(cmd_byte, resp0);  // Byte 0: CMD
        spi_transfer(8'h00, resp1);     // Byte 1: ACK/NAK
        spi_transfer(data, resp2);      // Byte 2: DATA
        spi_transfer(8'h00, resp3);     // Byte 3: Final ACK
        spi_cs_deassert();
        
        success = (resp1 == RESP_ACK && resp3 == RESP_ACK) ? 1 : 0;
        
        repeat(10) @(posedge clk);
    endtask

    //=========================================================================
    // Read from slave register (2-byte protocol)
    //=========================================================================
    task slave_reg_read(input logic [3:0] reg_addr, output logic [7:0] data);
        logic [7:0] cmd_byte;
        logic [7:0] resp;
        
        cmd_byte = {reg_addr, CMD_READ};
        
        spi_cs_assert();
        spi_transfer(cmd_byte, resp);   // Byte 0: CMD
        spi_transfer(8'h00, data);      // Byte 1: DATA
        spi_cs_deassert();
    endtask

    //=========================================================================
    // Main Test
    //=========================================================================
    initial begin
        $display("============================================");
        $display("  SPI Master <-> Slave Testbench");
        $display("  Clock: 100 MHz, SPI: 10 MHz");
        $display("============================================\n");

        // Initialize
        rst_n         = 0;
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
        
        tpu_idle      = 1;
        tpu_working   = 0;
        tpu_done      = 0;
        errors        = 0;

        // Reset
        repeat(20) @(posedge clk);
        rst_n = 1;
        repeat(50) @(posedge clk);

        // CS high
        spi_cs_deassert();
        repeat(20) @(posedge clk);

        //=============================================
        // Test 1: Read Status
        //=============================================
        $display("[Test 1] Read Status");
        slave_reg_read(REG_STATUS, rx_byte);
        $display("         Status = 0x%02h (idle=%b)", rx_byte, rx_byte[0]);
        $display("");

        //=============================================
        // Test 2: Write DIM_M = 8
        //=============================================
        begin
            int ok;
            $display("[Test 2] Write DIM_M = 8");
            slave_reg_write(REG_DIM_M, 8'd8, ok);
            if (dim_m == 6'd8) begin
                $display("         PASS: dim_m = %0d", dim_m);
            end else begin
                $display("         FAIL: dim_m = %0d (expected 8)", dim_m);
                errors++;
            end
            $display("");
        end

        //=============================================
        // Test 3: Write DIM_N = 16
        //=============================================
        begin
            int ok;
            $display("[Test 3] Write DIM_N = 16");
            slave_reg_write(REG_DIM_N, 8'd16, ok);
            if (dim_n == 6'd16) begin
                $display("         PASS: dim_n = %0d", dim_n);
            end else begin
                $display("         FAIL: dim_n = %0d (expected 16)", dim_n);
                errors++;
            end
            $display("");
        end

        //=============================================
        // Test 4: Write DIM_K = 32
        //=============================================
        begin
            int ok;
            $display("[Test 4] Write DIM_K = 32");
            slave_reg_write(REG_DIM_K, 8'd32, ok);
            if (dim_k == 6'd32) begin
                $display("         PASS: dim_k = %0d", dim_k);
            end else begin
                $display("         FAIL: dim_k = %0d (expected 32)", dim_k);
                errors++;
            end
            $display("");
        end

        //=============================================
        // Test 5: Read back DIM_M
        //=============================================
        $display("[Test 5] Read DIM_M");
        slave_reg_read(REG_DIM_M, rx_byte);
        if (rx_byte == 8'd8) begin
            $display("         PASS: read = %0d", rx_byte);
        end else begin
            $display("         FAIL: read = %0d (expected 8)", rx_byte);
            errors++;
        end
        $display("");

        //=============================================
        // Test 6: Read back DIM_N
        //=============================================
        $display("[Test 6] Read DIM_N");
        slave_reg_read(REG_DIM_N, rx_byte);
        if (rx_byte == 8'd16) begin
            $display("         PASS: read = %0d", rx_byte);
        end else begin
            $display("         FAIL: read = %0d (expected 16)", rx_byte);
            errors++;
        end
        $display("");

        //=============================================
        // Test 7: Read back DIM_K
        //=============================================
        $display("[Test 7] Read DIM_K");
        slave_reg_read(REG_DIM_K, rx_byte);
        if (rx_byte == 8'd32) begin
            $display("         PASS: read = %0d", rx_byte);
        end else begin
            $display("         FAIL: read = %0d (expected 32)", rx_byte);
            errors++;
        end
        $display("");

        //=============================================
        // Test 8: Start TPU
        //=============================================
        begin
            int ok;
            $display("[Test 8] Start TPU");
            slave_reg_write(REG_CONTROL, 8'h01, ok);
            $display("         Control write done");
            $display("");
        end

        //=============================================
        // Summary
        //=============================================
        repeat(50) @(posedge clk);
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
        #(CLK_PERIOD * 500000);
        $display("ERROR: Timeout!");
        $finish;
    end

    //=========================================================================
    // Waveform
    //=========================================================================
    initial begin
        $dumpfile("spi_test.vcd");
        $dumpvars(0, tb_spi_master_slave);
    end

endmodule