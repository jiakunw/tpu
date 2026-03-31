///////////////////////////////////////////////////////////////////////////////
// bus_slave_ab.sv
//
// TPU Bus Slave - AB Channel (simultaneous write to SRAM_A and SRAM_B)
//
// One WR pulse writes one byte to SRAM_A and one byte to SRAM_B at the same
// address. The address counter is shared between both SRAMs.
//
// Counter logic:
//   CHAB_START pulse -> counter resets to 0
//   CHAB_WR    pulse -> write at current counter, counter increments next cycle
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module bus_slave_ab #(
    parameter SRAM_AW = 12,   // byte address width: 4096 bytes (512 words x 8B)
    parameter DW      = 8
)(
    input  logic              BUS_CLK,
    input  logic              BUS_RST_N,

    //=========================================================================
    // Bus Interface
    //=========================================================================
    input  logic              CHAB_START,      // reset address counter to 0
    input  logic [DW-1:0]     CHAB_WDATA_A,   // byte for SRAM_A
    input  logic [DW-1:0]     CHAB_WDATA_B,   // byte for SRAM_B
    input  logic              CHAB_WR,         // single-cycle write pulse

    //=========================================================================
    // SRAM_A Interface (sram_wrapper, bus write only)
    //=========================================================================
    output logic               sram_a_we,
    output logic               sram_a_re,
    output logic [SRAM_AW-1:0] sram_a_addr,
    output logic [DW-1:0]      sram_a_din,
    input  logic [DW-1:0]      sram_a_dout,
    input  logic               sram_a_dout_valid,

    //=========================================================================
    // SRAM_B Interface (sram_wrapper, bus write only)
    //=========================================================================
    output logic               sram_b_we,
    output logic               sram_b_re,
    output logic [SRAM_AW-1:0] sram_b_addr,
    output logic [DW-1:0]      sram_b_din,
    input  logic [DW-1:0]      sram_b_dout,
    input  logic               sram_b_dout_valid,

    //=========================================================================
    // Debug
    //=========================================================================
    output logic [SRAM_AW-1:0] debug_cnt_ab
);

    logic [SRAM_AW-1:0] cnt_ab;

    always_ff @(negedge BUS_CLK or negedge BUS_RST_N) begin
        if      (!BUS_RST_N) cnt_ab <= '0;
        else if (CHAB_START) cnt_ab <= '0;
        else if (CHAB_WR)    cnt_ab <= cnt_ab + 1'b1;
    end

    // SRAM_A
    assign sram_a_we   = CHAB_WR;
    assign sram_a_re   = 1'b0;
    assign sram_a_addr = cnt_ab;
    assign sram_a_din  = CHAB_WDATA_A;

    // SRAM_B
    assign sram_b_we   = CHAB_WR;
    assign sram_b_re   = 1'b0;
    assign sram_b_addr = cnt_ab;
    assign sram_b_din  = CHAB_WDATA_B;

    assign debug_cnt_ab = cnt_ab;

endmodule