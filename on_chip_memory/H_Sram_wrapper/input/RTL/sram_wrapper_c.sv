///////////////////////////////////////////////////////////////////////////////
// sram_wrapper_c.sv
//
// Dual-port wrapper for sram00 (512 x 64-bit) - Matrix C
// TPU writes (64-bit), bus reads (8-bit).
//
// Port A: tpu_core  (64-bit word, write only)
// Port B: bus_slave_c (8-bit byte, read only)
//
// bus_slave_c drives bus_re/bus_addr at negedge, stable 50ns before posedge.
// SRAM reads at posedge; Q valid 0.01ns later (combinational output).
// bus_byte_sel_d1 registered to match Q timing.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module sram_wrapper_c #(
    parameter AW = 9,
    parameter DW = 8
)(
    input  wire          clk,
    input  wire          rstn,

    // Port A: tpu_core (write only)
    input  wire          tpu_we,
    input  wire [AW-1:0] tpu_addr,
    input  wire [63:0]   tpu_din,

    // Port B: bus_slave_c (read only)
    input  wire          bus_re,
    input  wire [AW+2:0] bus_addr,
    output wire [DW-1:0] bus_dout       // combinational from SRAM Q
);

    wire [2:0]    bus_byte_sel  = bus_addr[2:0];
    wire [AW-1:0] bus_word_addr = bus_addr[AW+2:3];

    // Delay byte_sel by 1 posedge to align with SRAM Q output
    reg [2:0] bus_byte_sel_d1;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            bus_byte_sel_d1 <= 3'b0;
        else
            bus_byte_sel_d1 <= bus_byte_sel;
    end

    // SRAM control
    wire        sram_cen  = (tpu_we || bus_re) ? 1'b0 : 1'b1;
    wire        sram_wen  = tpu_we ? 1'b0 : 1'b1;
    wire [8:0]  sram_addr = tpu_we ? tpu_addr   : bus_word_addr;
    wire [63:0] sram_din  = tpu_we ? tpu_din    : {64{1'b0}};

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

    // Combinational byte output - valid 0.01ns after posedge
    // bus_slave_c samples CHC_RDATA at C_CAPTURE (1 posedge later), safe
    assign bus_dout = sram_q[bus_byte_sel_d1*8 +: 8];

endmodule
