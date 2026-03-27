///////////////////////////////////////////////////////////////////////////////
// tb.sv
//
// Testbench: AXI SPI Master <-> rf_top (SPI Slave)
// 
// Clock Configuration:
//   Master AXI: 100 MHz
//   Slave:      10 MHz
//   SPI:        2 MHz (sampling ratio = 5x)
//
// TPU SPI Protocol:
//   Command format: [ADDR:4][OPCODE:4]
//   OPCODE: 0x1 = READ, 0x2 = WRITE
//   ACK = 0xFF, NAK = 0xF0
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb;

    //=========================================================================
    // Clock Parameters
    //=========================================================================
    parameter MASTER_CLK_PERIOD = 10;    // 100 MHz (10 ns period)
    parameter SLAVE_CLK_PERIOD  = 100;   // 10 MHz  (100 ns period)
    parameter CLKS_PER_HALF_BIT = 25;    // SPI = 100MHz / (2*25) = 2 MHz
    parameter SPI_MODE = 0;

    // TPU Protocol Constants
    localparam TPU_OP_READ  = 4'h1;
    localparam TPU_OP_WRITE = 4'h2;
    localparam TPU_ACK      = 8'hFF;
    localparam TPU_NAK      = 8'hF0;

    // TPU Register Addresses
    localparam TPU_REG_CONTROL = 4'h0;
    localparam TPU_REG_STATUS  = 4'h1;
    localparam TPU_REG_DIM_M   = 4'h2;
    localparam TPU_REG_DIM_N   = 4'h3;
    localparam TPU_REG_DIM_K   = 4'h4;

    //=========================================================================
    // Clocks and Reset
    //=========================================================================
    logic master_clk;  // 100 MHz
    logic slave_clk;   // 10 MHz
    logic aresetn;

    // Master clock: 100 MHz
    initial master_clk = 0;
    always #(MASTER_CLK_PERIOD/2) master_clk = ~master_clk;

    // Slave clock: 10 MHz
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
    // rf_top Interface
    //=========================================================================
    logic        tpu_start;
    logic        tpu_idle;
    logic        tpu_working;
    logic        tpu_done;
    logic [5:0]  dim_m;
    logic [5:0]  dim_n;
    logic [5:0]  dim_k;

    logic [1:0]  debug_wr_state;
    logic [1:0]  debug_rd_state;

    int errors;

    //=========================================================================
    // AXI SPI Master Register Addresses
    //=========================================================================
    localparam logic [6:0] SPI_REG_TX_DATA  = 7'h00;
    localparam logic [6:0] SPI_REG_RX_DATA  = 7'h04;
    localparam logic [6:0] SPI_REG_STATUS   = 7'h08;
    localparam logic [6:0] SPI_REG_CONTROL  = 7'h0C;

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
        .clk            (slave_clk),   // 10 MHz
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
        int timeout;
        logic got_awready, got_wready;
        
        @(posedge master_clk); #1;
        S_AXI_awaddr  = addr;

        @(posedge master_clk); #1;
        S_AXI_wdata   = data;
        S_AXI_awprot  = 3'd0;
        S_AXI_awvalid = 1'b1;
        S_AXI_wvalid  = 1'b1;
        S_AXI_wstrb   = 4'b1111;
        S_AXI_bready  = 1'b0;
        
        // write addr handshake
        wait(S_AXI_awvalid & S_AXI_awready);
        @(posedge master_clk); #1;

        // write data handshake
        wait(S_AXI_wvalid & S_AXI_wready);
        S_AXI_awvalid = 1'b0;
        S_AXI_wvalid  = 1'b0;
        @(posedge master_clk); #1;
        
        repeat($urandom_range(10, 4))
        
        S_AXI_bready = 1'b1;
        // write response handshake
        wait(S_AXI_wvalid & S_AXI_wready);
        @(posedge master_clk); #1;
        S_AXI_bready = 1'b0;
    endtask

    //=========================================================================
    // AXI Read Task
    //=========================================================================
    task axi_read(input logic [6:0] addr, output logic [31:0] data);
        int timeout;
        
        @(posedge master_clk); #1;
        S_AXI_araddr  = addr;
        S_AXI_arprot  = 3'd0;
        S_AXI_arvalid = 1'b1;
        S_AXI_rready  = 1'b0;
        
        timeout = 0;
        while (S_AXI_arready !== 1'b1) begin
            @(posedge master_clk);
            timeout++;
            if (timeout > 100) begin
                $display("ERROR: ARREADY timeout!");
                $finish;
            end
        end
        @(posedge master_clk); #1;
        S_AXI_arvalid = 1'b0;
        
        timeout = 0;
        while (S_AXI_rvalid !== 1'b1) begin
            @(posedge master_clk);
            timeout++;
            if (timeout > 100) begin
                $display("ERROR: RVALID timeout!");
                $finish;
            end
        end
        
        data = S_AXI_rdata;
        S_AXI_rready = 1'b1;
        @(posedge master_clk); #1;
        S_AXI_rready = 1'b0;
    endtask

    //=========================================================================
    // SPI Helper Tasks
    //=========================================================================
    
    task spi_wait_ready();
        logic [31:0] status;
        int timeout;
        timeout = 0;
        do begin
            axi_read(SPI_REG_STATUS, status);
            timeout++;
            if (timeout > 200) begin
                $display("ERROR: spi_wait_ready timeout!");
                $finish;
            end
            repeat(5) @(posedge master_clk);
        end while (status[0] == 1'b0);
    endtask

    task spi_cs_low();
        axi_write(SPI_REG_CONTROL, 32'h0);
        repeat($urandom_range(20, 5)) @(posedge master_clk);
    endtask

    task spi_cs_high();
        axi_write(SPI_REG_CONTROL, 32'h1);
        repeat($urandom_range(20, 5)) @(posedge master_clk);
    endtask

    task spi_transfer_byte(input logic [7:0] tx_byte, output logic [7:0] rx_byte);
        logic [31:0] rx_data;
        
        spi_wait_ready();
        axi_write(SPI_REG_TX_DATA, {24'h0, tx_byte});
        spi_wait_ready();
        repeat($urandom_range(30, 10)) @(posedge master_clk);
        axi_read(SPI_REG_RX_DATA, rx_data);
        rx_byte = rx_data[7:0];
    endtask

    //=========================================================================
    // TPU Protocol Tasks
    //=========================================================================

    task tpu_reg_read(input logic [3:0] addr, output logic [7:0] data, output int result);
        logic [7:0] cmd, rx;
        
        cmd = {addr, TPU_OP_READ};
        $display("  [tpu_reg_read] addr=%0d cmd=0x%02h", addr, cmd);
        
        spi_cs_low();
        spi_transfer_byte(cmd, rx);
        spi_transfer_byte(8'h00, rx);
        spi_cs_high();
        
        repeat($urandom_range(35, 10)) @(posedge slave_clk);
        
        if (rx == TPU_NAK) begin
            result = -1;
        end else begin
            data = rx;
            result = 0;
        end
    endtask

    task tpu_reg_write(input logic [3:0] addr, input logic [7:0] data, output int result);
        logic [7:0] cmd, resp1, resp2, dummy;
        
        cmd = {addr, TPU_OP_WRITE};
        $display("  [tpu_reg_write] addr=%0d data=0x%02h cmd=0x%02h", addr, data, cmd);
        
        spi_cs_low();
        spi_transfer_byte(cmd, dummy);
        spi_transfer_byte(8'h00, resp1);
        spi_transfer_byte(data, dummy);
        spi_transfer_byte(8'h00, resp2);
        spi_cs_high();
        
        repeat($urandom_range(35, 10)) @(posedge slave_clk);
        
        if (resp1 == TPU_NAK || resp1 != TPU_ACK || resp2 != TPU_ACK) begin
            result = -1;
        end else begin
            result = 0;
        end
    endtask

    //=========================================================================
    // Main Test
    //=========================================================================
    initial begin
        logic [31:0] status32;
        logic [7:0]  status8, read_data, data;
        int ret;
        
        $display("");
        $display("========================================");
        $display("    AXI SPI Master - TPU Test");
        $display("    Master: 100 MHz, Slave: 10 MHz");
        $display("    SPI: 2 MHz");
        $display("========================================");
        $display("");

        // Initialize
        errors        = 0;
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
        
        tpu_idle      = 1;
        tpu_working   = 0;
        tpu_done      = 0;

        // Reset
        repeat(20) @(posedge master_clk);
        aresetn = 1;
        repeat(100) @(posedge master_clk);

        spi_cs_high();
        repeat(50) @(posedge master_clk);

        //----------------------------------------------------------------------
        // Test 1: SPI Status
        //----------------------------------------------------------------------
        $display("[Test 1] SPI Status Register");
        axi_read(SPI_REG_STATUS, status32);
        $display("  STATUS = 0x%02X (READY=%0d)", status32[7:0], status32[0]);
        if (status32[0]) $display("  [PASS]");
        else begin $display("  [FAIL]"); errors++; end
        $display("");

        //----------------------------------------------------------------------
        // Test 2: Read TPU Status
        //----------------------------------------------------------------------
        $display("[Test 2] Read TPU Status");
        tpu_reg_read(TPU_REG_STATUS, data, ret);
        if (ret == 0) begin
            $display("  [PASS] Status = 0x%02X", data);
        end else begin
            $display("  [FAIL] NAK"); errors++;
        end
        $display("");

        //----------------------------------------------------------------------
        // Test 3: Write DIM_M = 16
        //----------------------------------------------------------------------
        $display("[Test 3] Write DIM_M = 16");
        tpu_reg_write(TPU_REG_DIM_M, 8'd16, ret);
        if (ret == 0 && dim_m == 6'd16) begin
            $display("  [PASS] dim_m = %0d", dim_m);
        end else begin
            $display("  [FAIL] ret=%0d dim_m=%0d", ret, dim_m);
            errors++;
        end
        $display("");

        //----------------------------------------------------------------------
        // Test 4: Read back DIM_M
        //----------------------------------------------------------------------
        $display("[Test 4] Read back DIM_M");
        tpu_reg_read(TPU_REG_DIM_M, data, ret);
        if (ret == 0 && data == 16) begin
            $display("  [PASS] DIM_M = %0d", data);
        end else begin
            $display("  [FAIL] data=%0d", data);
            errors++;
        end
        $display("");

        //----------------------------------------------------------------------
        // Test 5: Set All Dimensions
        //----------------------------------------------------------------------
        $display("[Test 5] Set M=16, N=8, K=32");
        tpu_reg_write(TPU_REG_DIM_M, 8'd16, ret);
        tpu_reg_write(TPU_REG_DIM_N, 8'd8, ret);
        tpu_reg_write(TPU_REG_DIM_K, 8'd32, ret);
        $display("  Hardware: dim_m=%0d, dim_n=%0d, dim_k=%0d", dim_m, dim_n, dim_k);
        if (dim_m == 16 && dim_n == 8 && dim_k == 32) begin
            $display("  [PASS]");
        end else begin
            $display("  [FAIL]");
            errors++;
        end
        $display("");

        // 读两次同一个寄存器
        tpu_reg_read(TPU_REG_DIM_K, read_data, ret);
        $display("First read: %0d, ret: %0d", read_data, ret);

        tpu_reg_read(TPU_REG_DIM_K, read_data, ret);
        $display("Second read: %0d, ret: %0d", read_data, ret);

        // //----------------------------------------------------------------------
        // // Test 6: Start TPU
        // //----------------------------------------------------------------------
        // $display("[Test 6] Start TPU");
        // tpu_reg_write(TPU_REG_CONTROL, 8'h01, ret);
        // repeat(10) @(posedge slave_clk);
        // if (tpu_start == 1'b1) begin
        //     $display("  [PASS] tpu_start = 1");
        // end else begin
        //     $display("  [FAIL] tpu_start = %0d", tpu_start);
        //     errors++;
        // end
        // $display("");

        //----------------------------------------------------------------------
        // Summary
        //----------------------------------------------------------------------
        $display("========================================");
        if (errors == 0)
            $display("    ALL TESTS PASSED!");
        else
            $display("    FAILED: %0d errors", errors);
        $display("========================================");

        $finish;
    end

    //=========================================================================
    // Timeout
    //=========================================================================
    initial begin
        #(MASTER_CLK_PERIOD * 5000000);
        $display("ERROR: Timeout!");
        $finish;
    end

endmodule