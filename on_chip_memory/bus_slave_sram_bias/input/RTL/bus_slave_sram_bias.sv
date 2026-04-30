///////////////////////////////////////////////////////////////////////////////
// bus_slave_sram_bias.sv
//
// Top-level wrapper: bias-channel bus slave + bias_wrapper (sram01).
//
// The slave writes a bias vector of (dim_m << 3) x INT32 entries via an
// 8-bit byte bus (4 byte writes accumulate into one 32-bit word inside
// bias_wrapper). Internal handshake wires are hidden; only the bus
// interface, TPU read port, and SC test port are exposed.
//
//            +-------------------+
//  bus  ---> |  bus_slave_bias   | --we/addr/din--> bias_wrapper --> TPU
//            +-------------------+
///////////////////////////////////////////////////////////////////////////////
module bus_slave_sram_bias #(
    parameter int AW    = 9,    // SRAM word-address width; depth = 2^AW = 512
    parameter int DW    = 8,    // External bus data width (8-bit byte)
    parameter int DIM_W = 7     // Matrix-dimension register width
) (
    // --- Clock / reset ---
    input  logic               clk,
    input  logic               rstn,

    // --- Dimensions (M = mmio_dim_m << 3 elements; bias is M x INT32) ---
    input  logic [DIM_W-1:0]   mmio_dim_m,
    input  logic [DIM_W-1:0]   mmio_num_computation,

    // --- Bias write interface (rides on AB channel from master) ---
    input  logic               chip_chab_start,
    input  logic [DW-1:0]      chip_chab_wdata_bias,
    input  logic               chip_chab_wr,

    // --- TPU read port (32-bit word) ---
    input  logic               tpu_bias_re,
    input  logic [AW-1:0]      tpu_bias_addr,
    output logic [31:0]        tpu_bias_dout,

    // --- Scan-chain / test override ---
    input  logic               sc_mem_ctrl,
    input  logic               sc_cen,
    input  logic               sc_wen,
    input  logic [AW-1:0]      sc_addr,
    input  logic [31:0]        sc_din,
    output logic [31:0]        sc_mem_dout
);

    // Byte-level address width: AW word bits + 2 byte-select bits.
    localparam int SRAM_AW = AW + 2;

    //--------------------------------------------------------------------------
    // Internal slave <-> wrapper handshake (byte-level bus)
    //--------------------------------------------------------------------------
    logic                sram_we;
    logic [SRAM_AW-1:0]  sram_addr;
    logic [DW-1:0]       sram_din;

    //--------------------------------------------------------------------------
    // Bias-channel bus slave
    //--------------------------------------------------------------------------
    bus_slave_bias #(
        .SRAM_AW (SRAM_AW),
        .DW      (DW)
    ) u_slave_bias (
        .clk             (clk),
        .rstn            (rstn),

        .dim_m           (mmio_dim_m),
        .num_computation (mmio_num_computation),

        .chab_start      (chip_chab_start),
        .chab_wdata_bias (chip_chab_wdata_bias),
        .chab_wr         (chip_chab_wr),

        .sram_bias_we    (sram_we),
        .sram_bias_addr  (sram_addr),
        .sram_bias_din   (sram_din)
    );

    //--------------------------------------------------------------------------
    // Bias SRAM wrapper (sram01: 512 x 32-bit)
    //--------------------------------------------------------------------------
    bias_wrapper #(
        .AW (AW),
        .DW (DW)
    ) u_sram_bias (
        .clk          (clk),
        .rstn         (rstn),

        .bus_we       (sram_we),
        .bus_addr     (sram_addr),
        .bus_din      (sram_din),

        .tpu_re       (tpu_bias_re),
        .tpu_addr     (tpu_bias_addr),
        .tpu_dout     (tpu_bias_dout),

        .sc_mem_ctrl  (sc_mem_ctrl),
        .sc_cen       (sc_cen),
        .sc_wen       (sc_wen),
        .sc_addr      (sc_addr),
        .sc_din       (sc_din),
        .sc_mem_dout  (sc_mem_dout)
    );

endmodule
