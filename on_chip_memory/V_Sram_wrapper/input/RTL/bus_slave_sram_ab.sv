//------------------------------------------------------------------------------
// bus_sram_ab_top
//
// Top-level wrapper that combines the AB-channel bus slave with the two
// operand-matrix SRAM wrappers (A and B) into a single unit. The
// slave <-> SRAM handshake wires (we / addr / din) are kept internal; only
// the bus, TPU read ports, and debug counters are exposed.
//
//              +------------------+
//   bus  ---> |  bus_slave_ab    | --we/addr/din--> sram_wrapper (A)  --> TPU
//              |                  | --we/addr/din--> sram_wrapper (B)  --> TPU
//              +------------------+
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// bus_sram_ab_top
//
// Combines bus_slave_ab with the two operand-matrix SRAM wrappers (A, B).
// Slave <-> wrapper handshake (we / byte-address / byte-data) is internal;
// external ports are the AB-channel write bus, the two TPU read ports, and
// debug counters.
//
// Relationships fixed by the underlying RTL:
//   * sram_wrapper.bus_addr is [AW+2:0]  --> byte-level address = AW+3 bits
//       (upper AW bits = SRAM word address, lower 3 bits = byte-in-word)
//   * sram_wrapper.tpu_dout is hard-wired [63:0]  (sram00 is 512 x 64)
//   * bus_slave_ab.SRAM_AW must therefore equal AW+3
//
// So only AW, DW, DIM_W are externally tunable; SRAM_AW is derived.
//------------------------------------------------------------------------------

module bus_slave_sram_ab #(
    parameter int AW    = 9,     // TPU word-address width; SRAM depth = 2^AW
    parameter int DW    = 8,     // Byte/element width (INT8; fixed by sram00)
    parameter int DIM_W = 8      // Matrix-dimension register width
) (
    // --- Bus / clock ---
    input  logic               clk,
    input  logic               rstn,

    // --- Matrix dimensions ---
    input  logic [DIM_W-1:0]   mmio_dim_m,
    input  logic [DIM_W-1:0]   mmio_dim_n,
    input  logic [DIM_W-1:0]   mmio_dim_k,
    input  logic [DIM_W-1:0]   mmio_num_computation,

    // --- AB channel write interface ---
    input  logic               mmio_chab_start,
    input  logic [DW-1:0]      pin_chab_wdata_a,
    input  logic [DW-1:0]      pin_chab_wdata_b,
    input  logic               pin_chab_wr,

    // --- TPU read port, A-matrix SRAM (64-bit word, hardcoded in wrapper) ---
    input  logic               tpu_a_re,
    input  logic [AW-1:0]      tpu_a_addr,
    output logic [63:0]        tpu_a_dout,

    // --- TPU read port, B-matrix SRAM ---
    input  logic               tpu_b_re,
    input  logic [AW-1:0]      tpu_b_addr,
    output logic [63:0]        tpu_b_dout
);

    // Byte-level address width: AW word bits + 3 byte-select bits.
    localparam int SRAM_AW = AW + 3;

    //--------------------------------------------------------------------------
    // Internal slave <-> SRAM handshake (byte-level bus)
    //--------------------------------------------------------------------------
    logic                 sram_a_we;
    logic [SRAM_AW-1:0]   sram_a_addr;
    logic [DW-1:0]        sram_a_din;

    logic                 sram_b_we;
    logic [SRAM_AW-1:0]   sram_b_addr;
    logic [DW-1:0]        sram_b_din;

    //--------------------------------------------------------------------------
    // AB-channel bus slave
    //--------------------------------------------------------------------------
    bus_slave_ab u_slave_ab (
        .clk          (clk),
        .rstn         (rstn),

        .dim_m           (mmio_dim_m),
        .dim_n           (mmio_dim_n),
        .dim_k           (mmio_dim_k),
        .num_computation (mmio_num_computation),

        .chab_start   (mmio_chab_start),
        .chab_wdata_a (pin_chab_wdata_a),
        .chab_wdata_b (pin_chab_wdata_b),
        .chab_wr      (pin_chab_wr),

        .sram_a_we    (sram_a_we),
        .sram_a_addr  (sram_a_addr),
        .sram_a_din   (sram_a_din),

        .sram_b_we    (sram_b_we),
        .sram_b_addr  (sram_b_addr),
        .sram_b_din   (sram_b_din)
    );

    //--------------------------------------------------------------------------
    // A-matrix SRAM wrapper (sram00: 512 x 64)
    //--------------------------------------------------------------------------
    sram_wrapper_ab u_sram_a (
        .clk      (clk),
        .rstn     (rstn),

        .bus_we   (sram_a_we),
        .bus_addr (sram_a_addr),
        .bus_din  (sram_a_din),

        .tpu_re   (tpu_a_re),
        .tpu_addr (tpu_a_addr),
        .tpu_dout (tpu_a_dout)
    );

    //--------------------------------------------------------------------------
    // B-matrix SRAM wrapper
    //--------------------------------------------------------------------------
    sram_wrapper_ab u_sram_b (
        .clk      (clk),
        .rstn     (rstn),

        .bus_we   (sram_b_we),
        .bus_addr (sram_b_addr),
        .bus_din  (sram_b_din),

        .tpu_re   (tpu_b_re),
        .tpu_addr (tpu_b_addr),
        .tpu_dout (tpu_b_dout)
    );

endmodule
