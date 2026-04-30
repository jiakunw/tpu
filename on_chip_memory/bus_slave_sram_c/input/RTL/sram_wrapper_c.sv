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
`define SD #1

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
    output wire [DW-1:0] bus_dout,      // combinational from SRAM Q

    // Scan-chain / test override (sc_mem_ctrl=1 selects sc_ inputs)
    input  wire          sc_mem_ctrl,
    input  wire          sc_cen,
    input  wire          sc_wen,
    input  wire [AW-1:0] sc_addr,
    input  wire [63:0]   sc_din,
    output wire [63:0]   sc_mem_dout
);

    wire [2:0]    bus_byte_sel  = bus_addr[2:0];
    wire [AW-1:0] bus_word_addr = bus_addr[AW+2:3];

    // Delay byte_sel by 1 posedge to align with SRAM Q output
    reg [2:0] bus_byte_sel_d1;
    always @(posedge clk) begin
        if (!rstn)
            bus_byte_sel_d1 <= 3'b0;
        else
            bus_byte_sel_d1 <= bus_byte_sel;
    end

    // SRAM control (combinational)
    wire        sram_cen  = (tpu_we || bus_re) ? 1'b0 : 1'b1;
    wire        sram_wen  = tpu_we ? 1'b0 : 1'b1;
    wire [8:0]  sram_addr = tpu_we ? tpu_addr   : bus_word_addr;
    wire [63:0] sram_din  = tpu_we ? tpu_din    : {64{1'b0}};

    // System-path delayed signals
    wire        sys_cen;
    wire        sys_wen;
    wire [8:0]  sys_addr;
    wire [63:0] sys_din;

    assign `SD sys_cen  = sram_cen;
    assign `SD sys_wen  = sram_wen;
    assign `SD sys_addr = sram_addr;
    assign `SD sys_din  = sram_din;

    // Scan-chain path delayed signals (symmetric with sys_ path)
    wire        sc_cen_delayed;
    wire        sc_wen_delayed;
    wire [8:0]  sc_addr_delayed;
    wire [63:0] sc_din_delayed;

    assign `SD sc_cen_delayed  = sc_cen;
    assign `SD sc_wen_delayed  = sc_wen;
    assign `SD sc_addr_delayed = sc_addr;
    assign `SD sc_din_delayed  = sc_din;

    // =========================================================================
    // sc_mem_ctrl mux: 1 = scan-chain (sc_*), 0 = system (sys_*)
    // =========================================================================
    wire        mux_cen  = sc_mem_ctrl ? sc_cen_delayed  : sys_cen;
    wire        mux_wen  = sc_mem_ctrl ? sc_wen_delayed  : sys_wen;
    wire [8:0]  mux_addr = sc_mem_ctrl ? sc_addr_delayed : sys_addr;
    wire [63:0] mux_din  = sc_mem_ctrl ? sc_din_delayed  : sys_din;

    wire [63:0] sram_q;

    sram00 u_sram (
        .CLK  (clk),
        .CEN  (mux_cen),
        .WEN  (mux_wen),
        .A    (mux_addr),
        .D    (mux_din),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_q)
    );

    // Combinational byte output - valid 0.01ns after posedge
    // bus_slave_c samples CHC_RDATA at C_CAPTURE (1 posedge later), safe
    assign bus_dout    = sram_q[(7 - bus_byte_sel_d1)*8 +: 8];
    assign sc_mem_dout = sram_q;

endmodule

