///////////////////////////////////////////////////////////////////////////////
// AXI-Lite SPI Master Wrapper (SystemVerilog)
// 
// Standard AXI-Lite slave interface wrapping the proven SPI_Master core.
// 
// Write sequence: 
//   1. WR_IDLE: Wait for AWVALID, assert AWREADY, latch address, go to WR_DATA
//   2. WR_DATA: Wait for WVALID, assert WREADY, execute write, go to WR_RESP
//   3. WR_RESP: Assert BVALID, wait for BREADY, go to WR_IDLE
//
// Read sequence:
//   1. RD_IDLE: Wait for ARVALID, assert ARREADY, go to RD_DATA
//   2. RD_DATA: Assert RVALID, wait for RREADY, go to RD_IDLE
//
// Register Map:
//   0x00: TX_DATA   [7:0]  - Write to send, auto-starts transfer
//   0x04: RX_DATA   [7:0]  - Read received byte (read-only)
//   0x08: STATUS    [0]    - TX_READY (1=ready)
//                   [1]    - RX_VALID (1=new data)
//                   [2]    - BUSY (1=transfer in progress)
//   0x0C: CONTROL   [0]    - CS_N (1=deselected, 0=selected)
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module axi_spi_master #(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 7,
    parameter integer SPI_MODE           = 0,
    parameter integer CLKS_PER_HALF_BIT  = 4
)(
    //=========================================================================
    // AXI-Lite Slave Interface
    //=========================================================================
    input  logic                              S_AXI_ACLK,
    input  logic                              S_AXI_ARESETN,
    
    // Write Address Channel
    input  logic [C_S_AXI_ADDR_WIDTH-1:0]     S_AXI_AWADDR,
    input  logic                              S_AXI_AWVALID,
    output logic                              S_AXI_AWREADY,
    
    // Write Data Channel
    input  logic [C_S_AXI_DATA_WIDTH-1:0]     S_AXI_WDATA,
    input  logic [C_S_AXI_DATA_WIDTH/8-1:0]   S_AXI_WSTRB,
    input  logic                              S_AXI_WVALID,
    output logic                              S_AXI_WREADY,
    
    // Write Response Channel
    output logic [1:0]                        S_AXI_BRESP,
    output logic                              S_AXI_BVALID,
    input  logic                              S_AXI_BREADY,
    
    // Read Address Channel
    input  logic [C_S_AXI_ADDR_WIDTH-1:0]     S_AXI_ARADDR,
    input  logic                              S_AXI_ARVALID,
    output logic                              S_AXI_ARREADY,
    
    // Read Data Channel
    output logic [C_S_AXI_DATA_WIDTH-1:0]     S_AXI_RDATA,
    output logic [1:0]                        S_AXI_RRESP,
    output logic                              S_AXI_RVALID,
    input  logic                              S_AXI_RREADY,
    
    //=========================================================================
    // SPI Interface
    //=========================================================================
    output logic                              SPI_SCK,
    output logic                              SPI_MOSI,
    input  logic                              SPI_MISO,
    output logic                              SPI_CS_N,
    //=========================================================================
    // Debug
    //=========================================================================
    output logic [1:0]                        debug_wr_state,
    output logic [1:0]                        debug_rd_state
);

    //=========================================================================
    // Constants
    //=========================================================================
    localparam logic [4:0] ADDR_TX_DATA  = 5'd0;   // 0x00 >> 2
    localparam logic [4:0] ADDR_RX_DATA  = 5'd1;   // 0x04 >> 2
    localparam logic [4:0] ADDR_STATUS   = 5'd2;   // 0x08 >> 2
    localparam logic [4:0] ADDR_CONTROL  = 5'd3;   // 0x0C >> 2

    assign S_AXI_BRESP = 2'b00;  // OKAY
    assign S_AXI_RRESP = 2'b00;  // OKAY

    //=========================================================================
    // Internal Registers
    //=========================================================================
    logic [7:0]  reg_tx_data;
    logic        reg_cs_n;
    logic        rx_valid_latch;
    
    // SPI Core signals
    logic        tx_dv;
    logic        tx_ready;
    logic        rx_dv;
    logic [7:0]  rx_byte;

    // Latched write address!
    logic [C_S_AXI_ADDR_WIDTH-1:0] aw_addr_latched;

    //=========================================================================
    // Write State Machine
    //=========================================================================
    typedef enum logic [1:0] {
        WR_IDLE,
        WR_DATA,
        WR_RESP
    } wr_state_t;
    
    wr_state_t wr_state;

    assign debug_wr_state = wr_state;
    
    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            wr_state        <= WR_IDLE;
            S_AXI_AWREADY   <= 1'b0;
            S_AXI_WREADY    <= 1'b0;
            S_AXI_BVALID    <= 1'b0;
            aw_addr_latched <= '0;
            reg_tx_data     <= 8'h00;
            reg_cs_n        <= 1'b1;
            tx_dv           <= 1'b0;
        end else begin
            // Default: clear tx_dv pulse
            tx_dv <= 1'b0;
            
            case (wr_state)
                //-------------------------------------------------------------
                // WR_IDLE: Wait for AWVALID
                //-------------------------------------------------------------
                WR_IDLE: begin
                    S_AXI_AWREADY <= 1'b0;
                    S_AXI_WREADY  <= 1'b0;
                    S_AXI_BVALID  <= 1'b0;
                    
                    if (S_AXI_AWVALID) begin
                        S_AXI_AWREADY   <= 1'b1;      // Accept address
                        aw_addr_latched <= S_AXI_AWADDR;
                        wr_state        <= WR_DATA;
                    end
                end
                
                //-------------------------------------------------------------
                // WR_DATA: Wait for WVALID
                //-------------------------------------------------------------
                WR_DATA: begin
                    S_AXI_AWREADY <= 1'b0;  // De-assert after handshake
                    
                    if (S_AXI_WVALID) begin
                        S_AXI_WREADY <= 1'b1;  // Accept data
                        
                        // Execute write based on latched address
                        case (aw_addr_latched[6:2])
                            ADDR_TX_DATA: begin
                                reg_tx_data <= S_AXI_WDATA[7:0];
                                tx_dv       <= 1'b1;  // Start SPI transfer
                            end
                            ADDR_CONTROL: begin
                                reg_cs_n <= S_AXI_WDATA[0];
                            end
                            default: ;  // Ignore other addresses
                        endcase
                        
                        wr_state <= WR_RESP;
                    end
                end
                
                //-------------------------------------------------------------
                // WR_RESP: Wait for BREADY
                //-------------------------------------------------------------
                WR_RESP: begin
                    S_AXI_WREADY <= 1'b0;   // De-assert after handshake
                    S_AXI_BVALID <= 1'b1;   // Assert response valid
                    
                    if (S_AXI_BREADY) begin
                        S_AXI_BVALID <= 1'b0;
                        wr_state     <= WR_IDLE;
                    end
                end
                
                default: wr_state <= WR_IDLE;
            endcase
        end
    end

    //=========================================================================
    // Read State Machine
    //=========================================================================
    typedef enum logic [1:0] {
        RD_IDLE,
        RD_DATA
    } rd_state_t;
    
    rd_state_t rd_state;
    logic [C_S_AXI_ADDR_WIDTH-1:0] ar_addr_latched;
    assign debug_rd_state = rd_state;
    
    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            rd_state        <= RD_IDLE;
            S_AXI_ARREADY   <= 1'b0;
            S_AXI_RVALID    <= 1'b0;
            S_AXI_RDATA     <= '0;
            ar_addr_latched <= '0;
        end else begin
            case (rd_state)
                //-------------------------------------------------------------
                // RD_IDLE: Wait for ARVALID
                //-------------------------------------------------------------
                RD_IDLE: begin
                    S_AXI_ARREADY <= 1'b0;
                    S_AXI_RVALID  <= 1'b0;
                    
                    if (S_AXI_ARVALID) begin
                        S_AXI_ARREADY   <= 1'b1;  // Accept address
                        ar_addr_latched <= S_AXI_ARADDR;
                        
                        // Prepare read data
                        case (S_AXI_ARADDR[6:2])
                            ADDR_TX_DATA:  S_AXI_RDATA <= {24'h0, reg_tx_data};
                            ADDR_RX_DATA:  S_AXI_RDATA <= {24'h0, rx_byte};
                            ADDR_STATUS:   S_AXI_RDATA <= {29'h0, ~tx_ready, rx_valid_latch, tx_ready};
                            ADDR_CONTROL:  S_AXI_RDATA <= {31'h0, reg_cs_n};
                            default:       S_AXI_RDATA <= 32'h0;
                        endcase
                        
                        rd_state <= RD_DATA;
                    end
                end
                
                //-------------------------------------------------------------
                // RD_DATA: Wait for RREADY
                //-------------------------------------------------------------
                RD_DATA: begin
                    S_AXI_ARREADY <= 1'b0;  // De-assert after handshake
                    S_AXI_RVALID  <= 1'b1;  // Assert data valid
                    
                    if (S_AXI_RREADY) begin
                        S_AXI_RVALID <= 1'b0;
                        rd_state     <= RD_IDLE;
                    end
                end
                
                default: rd_state <= RD_IDLE;
            endcase
        end
    end

    //=========================================================================
    // RX Valid Latch
    //=========================================================================
    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            rx_valid_latch <= 1'b0;
        end else begin
            if (rx_dv) begin
                rx_valid_latch <= 1'b1;
            end else if (rd_state == RD_IDLE && S_AXI_ARVALID && S_AXI_ARADDR[6:2] == ADDR_RX_DATA) begin
                rx_valid_latch <= 1'b0;  // Clear on RX_DATA read
            end
        end
    end

    //=========================================================================
    // CS_N Output
    //=========================================================================
    assign SPI_CS_N = reg_cs_n;

    //=========================================================================
    // SPI Master Core Instance (DO NOT MODIFY)
    //=========================================================================
    SPI_Master #(
        .SPI_MODE         (SPI_MODE),
        .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)
    ) u_spi_master (
        .i_Rst_L    (S_AXI_ARESETN),
        .i_Clk      (S_AXI_ACLK),
        
        // TX
        .i_TX_Byte  (reg_tx_data),
        .i_TX_DV    (tx_dv),
        .o_TX_Ready (tx_ready),
        
        // RX
        .o_RX_DV    (rx_dv),
        .o_RX_Byte  (rx_byte),
        
        // SPI
        .o_SPI_Clk  (SPI_SCK),
        .i_SPI_MISO (SPI_MISO),
        .o_SPI_MOSI (SPI_MOSI)
    );

endmodule


///////////////////////////////////////////////////////////////////////////////
// SPI Master Core (from nandland.com - DO NOT MODIFY)
///////////////////////////////////////////////////////////////////////////////
module SPI_Master
  #(parameter SPI_MODE = 0,
    parameter CLKS_PER_HALF_BIT = 2)
  (
   input        i_Rst_L,
   input        i_Clk,
   
   input [7:0]  i_TX_Byte,
   input        i_TX_DV,
   output reg   o_TX_Ready,
   
   output reg       o_RX_DV,
   output reg [7:0] o_RX_Byte,

   output reg o_SPI_Clk,
   input      i_SPI_MISO,
   output reg o_SPI_MOSI
   );

  wire w_CPOL;
  wire w_CPHA;

  reg [$clog2(CLKS_PER_HALF_BIT*2)-1:0] r_SPI_Clk_Count;
  reg r_SPI_Clk;
  reg [4:0] r_SPI_Clk_Edges;
  reg r_Leading_Edge;
  reg r_Trailing_Edge;
  reg       r_TX_DV;
  reg [7:0] r_TX_Byte;

  reg [2:0] r_RX_Bit_Count;
  reg [2:0] r_TX_Bit_Count;

  assign w_CPOL  = (SPI_MODE == 2) | (SPI_MODE == 3);
  assign w_CPHA  = (SPI_MODE == 1) | (SPI_MODE == 3);

  // Generate SPI Clock
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_TX_Ready      <= 1'b0;
      r_SPI_Clk_Edges <= 0;
      r_Leading_Edge  <= 1'b0;
      r_Trailing_Edge <= 1'b0;
      r_SPI_Clk       <= w_CPOL;
      r_SPI_Clk_Count <= 0;
    end
    else
    begin
      r_Leading_Edge  <= 1'b0;
      r_Trailing_Edge <= 1'b0;
      
      if (i_TX_DV)
      begin
        o_TX_Ready      <= 1'b0;
        r_SPI_Clk_Edges <= 16;
      end
      else if (r_SPI_Clk_Edges > 0)
      begin
        o_TX_Ready <= 1'b0;
        
        if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT*2-1)
        begin
          r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1'b1;
          r_Trailing_Edge <= 1'b1;
          r_SPI_Clk_Count <= 0;
          r_SPI_Clk       <= ~r_SPI_Clk;
        end
        else if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT-1)
        begin
          r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1'b1;
          r_Leading_Edge  <= 1'b1;
          r_SPI_Clk_Count <= r_SPI_Clk_Count + 1'b1;
          r_SPI_Clk       <= ~r_SPI_Clk;
        end
        else
        begin
          r_SPI_Clk_Count <= r_SPI_Clk_Count + 1'b1;
        end
      end  
      else
      begin
        o_TX_Ready <= 1'b1;
      end
    end
  end

  // Register TX Byte
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      r_TX_Byte <= 8'h00;
      r_TX_DV   <= 1'b0;
    end
    else
    begin
      r_TX_DV <= i_TX_DV;
      if (i_TX_DV)
      begin
        r_TX_Byte <= i_TX_Byte;
      end
    end
  end

  // Generate MOSI
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_SPI_MOSI     <= 1'b0;
      r_TX_Bit_Count <= 3'b111;
    end
    else
    begin
      if (o_TX_Ready)
      begin
        r_TX_Bit_Count <= 3'b111;
      end
      else if (r_TX_DV & ~w_CPHA)
      begin
        o_SPI_MOSI     <= r_TX_Byte[3'b111];
        r_TX_Bit_Count <= 3'b110;
      end
      else if ((r_Leading_Edge & w_CPHA) | (r_Trailing_Edge & ~w_CPHA))
      begin
        r_TX_Bit_Count <= r_TX_Bit_Count - 1'b1;
        o_SPI_MOSI     <= r_TX_Byte[r_TX_Bit_Count];
      end
    end
  end

  // Read MISO
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_RX_Byte      <= 8'h00;
      o_RX_DV        <= 1'b0;
      r_RX_Bit_Count <= 3'b111;
    end
    else
    begin
      o_RX_DV   <= 1'b0;

      if (o_TX_Ready)
      begin
        r_RX_Bit_Count <= 3'b111;
      end
      else if ((r_Leading_Edge & ~w_CPHA) | (r_Trailing_Edge & w_CPHA))
      begin
        o_RX_Byte[r_RX_Bit_Count] <= i_SPI_MISO;
        r_RX_Bit_Count            <= r_RX_Bit_Count - 1'b1;
        if (r_RX_Bit_Count == 3'b000)
        begin
          o_RX_DV   <= 1'b1;
        end
      end
    end
  end
  
  // SPI Clock output
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_SPI_Clk  <= w_CPOL;
    end
    else
    begin
      o_SPI_Clk <= r_SPI_Clk;
    end
  end

endmodule