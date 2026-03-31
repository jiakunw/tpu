///////////////////////////////////////////////////////////////////////////////
// sram_wrapper.sv
//
// Dual-port wrapper for sram00 (512 x 64-bit)
//
// Hold-time fix: SRAM control inputs (CEN/WEN/A/D) are registered at
// negedge clk before driving the SRAM instance. This guarantees they are
// stable for a full half-period (50 ns @ 10 MHz) before and after every
// posedge CLK, satisfying the SRAM's setup and hold requirements.
//
// Timing diagram:
//   posedge N  : arbitration logic settles (sram_*_r updated from _d1 FFs)
//   negedge N  : sram_*_ff latched          <- SRAM inputs change here
//   posedge N+1: SRAM samples               <- inputs stable for 50 ns ✓
//
// Write latency: bus write commits at negedge after bus_we_d1, i.e. 1.5
//   cycles after the 8th byte arrives (was 1 cycle before fix).
// Read latency: 1 full cycle from bus_re / tpu_re (unchanged).
//
// Port A: bus_slave interface (8-bit byte, inputs change at negedge externally)
// Port B: tpu_core interface (64-bit word, posedge)
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module sram_wrapper #(
    parameter AW = 9,       // Word address width (512 words)
    parameter DW = 8        // bus_slave data width (byte)
)(
    input  wire          clk,
    input  wire          rstn,

    //=========================================================================
    // Port A: bus_slave interface (8-bit byte)
    //=========================================================================
    input  wire          bus_we,
    input  wire          bus_re,
    input  wire [AW+2:0] bus_addr,      // 12-bit byte address
    input  wire [DW-1:0] bus_din,
    output wire [DW-1:0] bus_dout,
    output reg           bus_dout_valid,

    //=========================================================================
    // Port B: tpu_core interface (64-bit word)
    //=========================================================================
    input  wire          tpu_we,
    input  wire          tpu_re,
    input  wire [AW-1:0] tpu_addr,      // 9-bit word address
    input  wire [63:0]   tpu_din,
    output wire [63:0]   tpu_dout
);

    // =========================================================================
    // bus_slave write accumulator (8 bytes -> 64-bit word)
    // =========================================================================
    reg [63:0]   bus_wbuf;
    reg          bus_we_d1;
    reg [AW-1:0] bus_waddr_d1;

    wire [2:0]    bus_byte_sel  = bus_addr[2:0];
    wire [AW-1:0] bus_word_addr = bus_addr[AW+2:3];

    // Accumulate bytes into write buffer at posedge
    always @(posedge clk) begin
        if (bus_we)
            bus_wbuf[bus_byte_sel*8 +: 8] <= bus_din;
    end

    // Fire write flag one posedge after the 8th byte arrives
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bus_we_d1    <= 1'b0;
            bus_waddr_d1 <= '0;
        end else begin
            bus_we_d1    <= bus_we && (bus_byte_sel == 3'b111);
            bus_waddr_d1 <= bus_word_addr;
        end
    end

    // =========================================================================
    // SRAM control arbitration (combinational)
    // Priority: tpu_we > bus_we_d1 > tpu_re > bus_re
    // =========================================================================
    reg        sram_cen_r;
    reg        sram_wen_r;
    reg [8:0]  sram_addr_r;
    reg [63:0] sram_din_r;

    always @(*) begin
        if (tpu_we) begin
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b0;     // WEN=0: write
            sram_addr_r = tpu_addr;
            sram_din_r  = tpu_din;
        end else if (bus_we_d1) begin
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b0;
            sram_addr_r = bus_waddr_d1;
            sram_din_r  = bus_wbuf;
        end else if (tpu_re) begin
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b1;     // WEN=1: read
            sram_addr_r = tpu_addr;
            sram_din_r  = '0;
        end else if (bus_re) begin
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b1;
            sram_addr_r = bus_word_addr;
            sram_din_r  = '0;
        end else begin
            sram_cen_r  = 1'b1;     // idle: chip disabled
            sram_wen_r  = 1'b1;
            sram_addr_r = '0;
            sram_din_r  = '0;
        end
    end

    // =========================================================================
    // Negedge output register before SRAM pins  <-- hold-time fix
    //
    // Arbitration result is registered at negedge so SRAM inputs are stable
    // from negedge to negedge, giving 50 ns of margin around every posedge.
    // =========================================================================
    reg        sram_cen_ff;
    reg        sram_wen_ff;
    reg [8:0]  sram_addr_ff;
    reg [63:0] sram_din_ff;

    always @(negedge clk or negedge rstn) begin
        if (!rstn) begin
            sram_cen_ff  <= 1'b1;
            sram_wen_ff  <= 1'b1;
            sram_addr_ff <= '0;
            sram_din_ff  <= '0;
        end else begin
            sram_cen_ff  <= sram_cen_r;
            sram_wen_ff  <= sram_wen_r;
            sram_addr_ff <= sram_addr_r;
            sram_din_ff  <= sram_din_r;
        end
    end

    // =========================================================================
    // SRAM Instance (512 x 64-bit)
    // =========================================================================
    wire [63:0] sram_q;

    sram00 u_sram (
        .CLK  (clk),
        .CEN  (sram_cen_ff),
        .WEN  (sram_wen_ff),
        .A    (sram_addr_ff),
        .D    (sram_din_ff),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_q)
    );

    // =========================================================================
    // tpu_core read output (1-cycle latency from tpu_re)
    // =========================================================================
    assign tpu_dout = sram_q;

    // =========================================================================
    // bus_slave read output (1-cycle latency from bus_re)
    // =========================================================================
    reg [2:0] bus_byte_sel_d1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bus_byte_sel_d1 <= '0;
            bus_dout_valid  <= 1'b0;
        end else begin
            bus_byte_sel_d1 <= bus_byte_sel;
            bus_dout_valid  <= bus_re;
        end
    end

    assign bus_dout = sram_q[bus_byte_sel_d1*8 +: 8];

endmodule