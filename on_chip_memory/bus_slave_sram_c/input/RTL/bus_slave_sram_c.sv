//------------------------------------------------------------------------------
// bus_slave_sram_c.sv
//
// Top-level wrapper that combines the C-channel bus slave with the result-
// matrix SRAM wrapper (sram_wrapper_c) into a single unit. The
// slave <-> SRAM handshake wires (re / addr / dout) are kept internal; only
// the bus, TPU write port, scan-chain, and debug counter are exposed.
//
//              +------------------+
//   TPU  ---> |  sram_wrapper_c  | <--re/addr/dout-- |  bus_slave_c  | ---> bus
//              +------------------+                   +---------------+
//
// Relationships fixed by the underlying RTL:
//   * sram_wrapper_c.bus_addr is [AW+2:0]  --> byte-level address = AW+3 bits
//       (upper AW bits = SRAM word address, lower 3 bits = byte-in-word)
//   * sram_wrapper_c.tpu_din is hard-wired [63:0]  (sram00 is 512 x 64)
//   * bus_slave_c.SRAM_AW must therefore equal AW+3
//
// So only AW and DW are externally tunable; SRAM_AW is derived.
//------------------------------------------------------------------------------

module bus_slave_sram_c #(
    parameter int AW = 9,        // TPU word-address width; SRAM depth = 2^AW
    parameter int DW = 8         // Byte/element width (INT8; fixed by sram00)
) (
    // --- Bus / clock ---
    input  logic               clk,
    input  logic               rstn,

    // --- C channel read interface ---
    input  logic               chip_chc_start,
    input  logic               chip_chc_rd,
    output logic [DW-1:0]      chip_chc_rdata,

    // --- TPU write port, C-matrix SRAM (64-bit word, hardcoded in wrapper) ---
    input  logic               tpu_c_we,
    input  logic [AW-1:0]      tpu_c_addr,
    input  logic [63:0]        tpu_c_din,

    // --- Scan-chain / test override for C-matrix SRAM ---
    input  logic               sc_mem_ctrl,
    input  logic               sc_cen,
    input  logic               sc_wen,
    input  logic [AW-1:0]      sc_addr,
    input  logic [63:0]        sc_din,
    output logic [63:0]        sc_mem_dout
);

    // Byte-level address width: AW word bits + 3 byte-select bits.
    localparam int SRAM_AW = AW + 3;

    //--------------------------------------------------------------------------
    // Internal slave <-> SRAM handshake (byte-level bus)
    //--------------------------------------------------------------------------
    logic                 sram_c_re;
    logic [SRAM_AW-1:0]   sram_c_addr;
    logic [DW-1:0]        sram_c_dout;

    //--------------------------------------------------------------------------
    // C-channel bus slave
    //--------------------------------------------------------------------------
    bus_slave_c u_slave_c (
        .clk          (clk),
        .rstn         (rstn),

        .chc_start    (chip_chc_start),
        .chc_rd       (chip_chc_rd),
        .chc_rdata    (chip_chc_rdata),

        .sram_c_re    (sram_c_re),
        .sram_c_addr  (sram_c_addr),
        .sram_c_dout  (sram_c_dout)
    );

    //--------------------------------------------------------------------------
    // C-matrix SRAM wrapper (sram00: 512 x 64)
    //--------------------------------------------------------------------------
    sram_wrapper_c u_sram_c (
        .clk          (clk),
        .rstn         (rstn),

        .tpu_we       (tpu_c_we),
        .tpu_addr     (tpu_c_addr),
        .tpu_din      (tpu_c_din),

        .bus_re       (sram_c_re),
        .bus_addr     (sram_c_addr),
        .bus_dout     (sram_c_dout),

        .sc_mem_ctrl  (sc_mem_ctrl),
        .sc_cen       (sc_cen),
        .sc_wen       (sc_wen),
        .sc_addr      (sc_addr),
        .sc_din       (sc_din),
        .sc_mem_dout  (sc_mem_dout)
    );

endmodule

