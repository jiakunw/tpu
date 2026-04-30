//////////////////////////////////////////////////////////////////////////////
// TPU SPI Interface Top
//
// Combines SPI Slave + MMIO Register File
//
//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module spi_slave_mmio_register_file (
    // System
    input  logic        clk,
    input  logic        arstn,

    // Synchronized reset output for other modules
    output logic        rstn,

    // SPI pins (directly to pads)
    input  logic        spi_sck,
    input  logic        spi_cs_n,
    input  logic        spi_mosi,
    output logic        spi_miso,

    // FSM control interface
    output logic        fsm_start,
    output logic [1:0]  fsm_keep_pe_value,
    output logic        fsm_tpu_full_percision,
    input  logic        fsm_idle,
    input  logic        fsm_working,
    input  logic        fsm_done,

    // Dimension outputs to TPU
    output logic [6:0]  tpu_dim_m,
    output logic [6:0]  tpu_dim_n,
    output logic [6:0]  tpu_dim_k,
    output logic [6:0]  tpu_num_computation,

    // Zero point outputs
    output logic [7:0]  tpu_zero_point_a,
    output logic [7:0]  tpu_zero_point_b,
    output logic [7:0]  tpu_zero_point_c,

    // Scale outputs
    output logic [15:0] tpu_scale_factor,
    output logic [4:0]  tpu_scale_shift,

    // Scan chain interface
    input  logic        sc_mmio_ctrl,
    input  logic [3:0]  sc_mmio_reg_addr,
    input  logic        sc_mmio_reg_rd,
    input  logic        sc_mmio_reg_wr,
    input  logic [7:0]  sc_mmio_reg_wdata,
    output logic [7:0]  sc_mmio_reg_rdata,
    output logic        sc_mmio_reg_addr_valid,
    output logic        sc_mmio_reg_writable
);

    //=========================================================================
    // Internal signals between SPI Slave and Register File
    //=========================================================================
    logic [3:0]  reg_addr;
    logic        reg_rd;
    logic        reg_wr;
    logic [7:0]  reg_wdata;
    logic [7:0]  reg_rdata;
    logic        reg_addr_valid;
    logic        reg_writable;

    //=========================================================================
    // Reset Synchronizer
    //=========================================================================
    reset_synchronizer u_reset_sync (
        .clk        (clk),
        .chip_arstn (arstn),
        .rstn       (rstn)
    );

    //=========================================================================
    // SPI Slave instance
    //=========================================================================
    spi_slave u_spi_slave (
        .clk            (clk),
        .rstn           (rstn),
        .spi_sck        (spi_sck),
        .spi_cs_n       (spi_cs_n),
        .spi_mosi       (spi_mosi),
        .spi_miso       (spi_miso),
        .reg_addr       (reg_addr),
        .reg_rd         (reg_rd),
        .reg_wr         (reg_wr),
        .reg_wdata      (reg_wdata),
        .reg_rdata      (reg_rdata),
        .reg_addr_valid (reg_addr_valid),
        .reg_writable   (reg_writable)
    );

    //=========================================================================
    // MMIO Register File instance
    //=========================================================================
    mmio_register_file u_regfile (
        .clk              (clk),
        .rstn             (rstn),
        .reg_addr         (reg_addr),
        .reg_rd           (reg_rd),
        .reg_wr           (reg_wr),
        .reg_wdata        (reg_wdata),
        .reg_rdata        (reg_rdata),
        .reg_addr_valid         (reg_addr_valid),
        .reg_writable           (reg_writable),
        .sc_mmio_ctrl           (sc_mmio_ctrl),
        .sc_mmio_reg_addr       (sc_mmio_reg_addr),
        .sc_mmio_reg_rd         (sc_mmio_reg_rd),
        .sc_mmio_reg_wr         (sc_mmio_reg_wr),
        .sc_mmio_reg_wdata      (sc_mmio_reg_wdata),
        .sc_mmio_reg_rdata      (sc_mmio_reg_rdata),
        .sc_mmio_reg_addr_valid (sc_mmio_reg_addr_valid),
        .sc_mmio_reg_writable   (sc_mmio_reg_writable),
        .fsm_start              (fsm_start),
        .fsm_keep_pe_value      (fsm_keep_pe_value),
        .fsm_tpu_full_percision (fsm_tpu_full_percision),
        .fsm_idle               (fsm_idle),
        .fsm_working            (fsm_working),
        .fsm_done               (fsm_done),
        .tpu_dim_m              (tpu_dim_m),
        .tpu_dim_n              (tpu_dim_n),
        .tpu_dim_k              (tpu_dim_k),
        .tpu_num_computation    (tpu_num_computation),
        .tpu_zero_point_a (tpu_zero_point_a),
        .tpu_zero_point_b (tpu_zero_point_b),
        .tpu_zero_point_c (tpu_zero_point_c),
        .tpu_scale_factor (tpu_scale_factor),
        .tpu_scale_shift  (tpu_scale_shift)
    );

endmodule

