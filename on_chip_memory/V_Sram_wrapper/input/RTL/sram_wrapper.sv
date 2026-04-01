///////////////////////////////////////////////////////////////////////////////
// sram_wrapper.sv
//
// Dual-port wrapper for sram00 (512 x 64-bit)
// Used for Matrix A and Matrix B: bus writes (8-bit), TPU reads (64-bit).
//
// Port A: bus_slave (8-bit byte, write only)
// Port B: tpu_core  (64-bit word, read only)
//
// Hold-time fix: bus write path goes through negedge FF before SRAM pins,
// giving 50ns margin around posedge CLK.
// TPU read: purely combinational bypass of negedge FF, 1-cycle latency.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module sram_wrapper #(
    parameter AW = 9,       // Word address width (512 words)
    parameter DW = 8        // bus_slave data width (byte)
)(
    input  wire          clk,
    input  wire          rstn,

    //=========================================================================
    // Port A: bus_slave interface (8-bit byte, write only)
    //=========================================================================
    input  wire          bus_we,
    input  wire [AW+2:0] bus_addr,      // 12-bit byte address
    input  wire [DW-1:0] bus_din,

    //=========================================================================
    // Port B: tpu_core interface (64-bit word, read only)
    //=========================================================================
    input  wire          tpu_re,
    input  wire [AW-1:0] tpu_addr,      // 9-bit word address
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

    always @(posedge clk) begin
        if (bus_we)
            bus_wbuf[bus_byte_sel*8 +: 8] <= bus_din;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bus_we_d1    <= 1'b0;
            bus_waddr_d1 <= {AW{1'b0}};
        end else begin
            bus_we_d1    <= bus_we && (bus_byte_sel == 3'b111);
            bus_waddr_d1 <= bus_word_addr;
        end
    end

    // =========================================================================
    // Write path arbitration (combinational) -> negedge FF
    // =========================================================================
    reg        sram_cen_r;
    reg        sram_wen_r;
    reg [8:0]  sram_addr_r;
    reg [63:0] sram_din_r;

    always @(*) begin
        if (bus_we_d1) begin
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b0;         // write
            sram_addr_r = bus_waddr_d1;
            sram_din_r  = bus_wbuf;
        end else begin
            sram_cen_r  = 1'b1;         // idle
            sram_wen_r  = 1'b1;
            sram_addr_r = {9{1'b0}};
            sram_din_r  = {64{1'b0}};
        end
    end

    // =========================================================================
    // Negedge output register (hold-time fix for write path)
    // =========================================================================
    reg        sram_cen_ff;
    reg        sram_wen_ff;
    reg [8:0]  sram_addr_ff;
    reg [63:0] sram_din_ff;

    always @(negedge clk or negedge rstn) begin
        if (!rstn) begin
            sram_cen_ff  <= 1'b1;
            sram_wen_ff  <= 1'b1;
            sram_addr_ff <= {9{1'b0}};
            sram_din_ff  <= {64{1'b0}};
        end else begin
            sram_cen_ff  <= sram_cen_r;
            sram_wen_ff  <= sram_wen_r;
            sram_addr_ff <= sram_addr_r;
            sram_din_ff  <= sram_din_r;
        end
    end

    // =========================================================================
    // Final mux: TPU read bypasses negedge FF (purely combinational)
    //   tpu_re=1 -> SRAM driven by tpu_addr directly, 1-cycle read latency
    //   tpu_re=0 -> SRAM driven by write path (negedge FF)
    // =========================================================================
    wire        sram_cen  = tpu_re ? 1'b0       : sram_cen_ff;
    wire        sram_wen  = tpu_re ? 1'b1       : sram_wen_ff;
    wire [8:0]  sram_addr = tpu_re ? tpu_addr   : sram_addr_ff;
    wire [63:0] sram_din  = tpu_re ? {64{1'b0}} : sram_din_ff;

    // =========================================================================
    // SRAM Instance (512 x 64-bit)
    // =========================================================================
    wire [63:0] sram_q;

    sram00 u_sram (
        .CLK  (clk),
        .CEN  (sram_cen),
        .WEN  (sram_wen),
        .A    (sram_addr),
        .D    (sram_din),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_q)
    );

    // TPU read output: combinational, 1-cycle latency from tpu_re
    assign tpu_dout = sram_q;

endmodule
