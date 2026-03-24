///////////////////////////////////////////////////////////////////////////////
// bus_slave.sv
//
// TPU Bus Slave - 3-Channel Parallel Data Bus Interface
//
// This module receives data from FPGA Master via 3 parallel channels:
//   - Channel A: Write Matrix A + Bias to sram_reg_wrapper
//   - Channel B: Write Matrix B to sram_wrapper
//   - Channel C: Read Matrix C from sram_wrapper
//
// Memory Configuration:
//   - Channel A: sram_reg_wrapper (regf00=Bias + sram00=Matrix A) = 5120 bytes
//   - Channel B: sram_wrapper (Matrix B) = 4096 bytes
//   - Channel C: sram_wrapper (Matrix C) = 4096 bytes (read only from bus)
//
// Address Counter Logic:
//   - BUS_RST_N=0: All counters reset to 0
//   - WR/RD rising edge: Counter resets to 0 (new transfer starts)
//   - WR/RD held high: Counter increments each clock cycle
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module bus_slave #(
    parameter SRAM_A_AW   = 13,   // SRAM_A address width (5120 bytes)
    parameter SRAM_BC_AW  = 12,   // SRAM B/C byte address width (4096 bytes)
    parameter DW          = 8     // Data width (byte)
)(
    //=========================================================================
    // Bus Interface (from FPGA PMOD)
    //=========================================================================
    input  logic              BUS_CLK,          // 10 MHz bus clock from Master
    input  logic              BUS_RST_N,        // Active-low async reset
    
    // Channel A: Write Matrix A + Bias
    input  logic [DW-1:0]     CHA_WDATA,        // Channel A write data
    input  logic              CHA_WR,           // Channel A write enable
    
    // Channel B: Write Matrix B
    input  logic [DW-1:0]     CHB_WDATA,        // Channel B write data
    input  logic              CHB_WR,           // Channel B write enable
    
    // Channel C: Read Matrix C
    output logic [DW-1:0]     CHC_RDATA,        // Channel C read data
    input  logic              CHC_RD,           // Channel C read enable
    
    //=========================================================================
    // SRAM_A Interface (sram_reg_wrapper: regf00 + sram00)
    //=========================================================================
    output logic                   sram_a_we,
    output logic                   sram_a_re,
    output logic [SRAM_A_AW-1:0]   sram_a_addr,
    output logic [DW-1:0]          sram_a_din,
    input  logic [DW-1:0]          sram_a_dout,
    input  logic                   sram_a_dout_valid,
    
    //=========================================================================
    // SRAM_B Interface (sram_wrapper, write only from bus)
    //=========================================================================
    output logic                   sram_b_we,
    output logic                   sram_b_re,
    output logic [SRAM_BC_AW-1:0]  sram_b_addr,
    output logic [DW-1:0]          sram_b_din,
    input  logic [DW-1:0]          sram_b_dout,
    input  logic                   sram_b_dout_valid,
    
    //=========================================================================
    // SRAM_C Interface (sram_wrapper, read only from bus)
    //=========================================================================
    output logic                   sram_c_we,
    output logic                   sram_c_re,
    output logic [SRAM_BC_AW-1:0]  sram_c_addr,
    output logic [DW-1:0]          sram_c_din,
    input  logic [DW-1:0]          sram_c_dout,
    input  logic                   sram_c_dout_valid,
    
    //=========================================================================
    // Debug Outputs
    //=========================================================================
    output logic [SRAM_A_AW-1:0]   debug_cnt_a,
    output logic [SRAM_BC_AW-1:0]  debug_cnt_b,
    output logic [SRAM_BC_AW-1:0]  debug_cnt_c
);

    //=========================================================================
    // Internal Signals
    //=========================================================================
    logic [SRAM_A_AW-1:0]  cnt_a;      // Channel A address counter
    logic [SRAM_BC_AW-1:0] cnt_b;      // Channel B address counter
    logic [SRAM_BC_AW-1:0] cnt_c;      // Channel C address counter
    
    // Edge detection registers
    logic cha_wr_d1;
    logic chb_wr_d1;
    logic chc_rd_d1;
    
    // Rising edge detection signals
    logic cha_wr_rising;
    logic chb_wr_rising;
    logic chc_rd_rising;

    // Debug assignments
    assign debug_cnt_a = cnt_a;
    assign debug_cnt_b = cnt_b;
    assign debug_cnt_c = cnt_c;

    //=========================================================================
    // Edge Detection
    // Detect rising edge of WR/RD signals to reset address counters
    //=========================================================================
    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            cha_wr_d1 <= 1'b0;
            chb_wr_d1 <= 1'b0;
            chc_rd_d1 <= 1'b0;
        end else begin
            cha_wr_d1 <= CHA_WR;
            chb_wr_d1 <= CHB_WR;
            chc_rd_d1 <= CHC_RD;
        end
    end
    
    // Rising edge = current high AND previous low
    assign cha_wr_rising = CHA_WR & ~cha_wr_d1;
    assign chb_wr_rising = CHB_WR & ~chb_wr_d1;
    assign chc_rd_rising = CHC_RD & ~chc_rd_d1;

    //=========================================================================
    // Channel A Address Counter & SRAM Interface
    // Writes to sram_reg_wrapper (Bias + Matrix A)
    //=========================================================================
    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            cnt_a <= '0;
        end else if (cha_wr_rising) begin
            // Rising edge: start new transfer, first byte goes to addr 0
            // Counter set to 1 because addr 0 is output combinationally
            cnt_a <= {{(SRAM_A_AW-1){1'b0}}, 1'b1};
        end else if (CHA_WR) begin
            // While WR held high, increment counter each cycle
            cnt_a <= cnt_a + 1'b1;
        end
    end
    
    // SRAM_A interface signals
    assign sram_a_we   = CHA_WR;
    assign sram_a_re   = 1'b0;                              // No read from bus
    assign sram_a_addr = cha_wr_rising ? '0 : cnt_a;        // Use 0 on rising edge
    assign sram_a_din  = CHA_WDATA;

    //=========================================================================
    // Channel B Address Counter & SRAM Interface
    // Writes to sram_wrapper (Matrix B)
    //=========================================================================
    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            cnt_b <= '0;
        end else if (chb_wr_rising) begin
            cnt_b <= {{(SRAM_BC_AW-1){1'b0}}, 1'b1};
        end else if (CHB_WR) begin
            cnt_b <= cnt_b + 1'b1;
        end
    end
    
    // SRAM_B interface signals
    assign sram_b_we   = CHB_WR;
    assign sram_b_re   = 1'b0;                              // No read from bus
    assign sram_b_addr = chb_wr_rising ? '0 : cnt_b;
    assign sram_b_din  = CHB_WDATA;

    //=========================================================================
    // Channel C Address Counter & SRAM Interface (Read Only)
    // Reads from sram_wrapper (Matrix C)
    //=========================================================================
    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            cnt_c <= '0;
        end else if (chc_rd_rising) begin
            cnt_c <= {{(SRAM_BC_AW-1){1'b0}}, 1'b1};
        end else if (CHC_RD) begin
            cnt_c <= cnt_c + 1'b1;
        end
    end
    
    // SRAM_C interface signals
    assign sram_c_we   = 1'b0;                              // No write from bus
    assign sram_c_re   = CHC_RD;
    assign sram_c_addr = chc_rd_rising ? '0 : cnt_c;
    assign sram_c_din  = '0;
    
    // Output read data to bus
    assign CHC_RDATA = sram_c_dout;

endmodule