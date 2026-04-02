///////////////////////////////////////////////////////////////////////////////
// sram_wrapper.sv
//
// Dual-port wrapper for sram00 (512 x 64-bit)
// Used for Matrix A and Matrix B: bus writes (8-bit), TPU reads (64-bit).
//
// bus_slave_ab drives all bus signals at negedge BUS_CLK, so they are
// stable 50ns before the next posedge. No extra hold-time fix needed here.
// All FFs are posedge triggered, SRAM inputs are stable well before posedge.
//
// Port A: bus_slave (8-bit byte, write only)
// Port B: tpu_core  (64-bit word, read only, purely combinational path)
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module sram_wrapper #(
    parameter AW = 9,
    parameter DW = 8
)(
    input  wire          clk,
    input  wire          rstn,

    // Port A: bus_slave (write only)
    input  wire          bus_we,
    input  wire [AW+2:0] bus_addr,
    input  wire [DW-1:0] bus_din,

    // Port B: tpu_core (read only)
    input  wire          tpu_re,
    input  wire [AW-1:0] tpu_addr,
    output wire [63:0]   tpu_dout
);

    wire [2:0]    bus_byte_sel  = bus_addr[2:0];
    wire [AW-1:0] bus_word_addr = bus_addr[AW+2:3];

    // =========================================================================
    // Byte accumulator (posedge)
    // bus_we/bus_addr are driven by bus_slave_ab at negedge, stable at posedge
    // =========================================================================
    reg [63:0]   bus_wbuf;
    reg          bus_we_d1;
    reg [AW-1:0] bus_waddr_d1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            bus_wbuf <= 64'b0;
        else if (bus_we)
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
    // SRAM control (combinational, driven directly to SRAM)
    // bus_we_d1 is a posedge FF output.
    // bus_slave_ab drives bus_we at negedge, so bus_we_d1 captures it at
    // the following posedge and then stays stable until the next posedge.
    // tpu_re is driven by TPU at posedge (NBA), effective next posedge.
    // Both meet SRAM hold time naturally.
    // =========================================================================
    wire        sram_cen  = tpu_re ? 1'b0       : (bus_we_d1 ? 1'b0 : 1'b1);
    wire        sram_wen  = tpu_re ? 1'b1       : (bus_we_d1 ? 1'b0 : 1'b1);
    wire [8:0]  sram_addr = tpu_re ? tpu_addr   : bus_waddr_d1;
    wire [63:0] sram_din  = tpu_re ? {64{1'b0}} : bus_wbuf;

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

    assign tpu_dout = sram_q;

endmodule
