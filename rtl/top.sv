//////////////////////////////////////////////////////////////////////////////
// TPU SPI Interface Top
// 
// Combines SPI Slave + MMIO Register File
//
//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module top (
    // System
    input  logic        clk,
    input  logic        rst_n,
    
    // SPI pins (directly to pads)
    input  logic        spi_sck,
    input  logic        spi_cs_n,
    input  logic        spi_mosi,
    output logic        spi_miso,
    
    // TPU control interface
    output logic        tpu_start,
    input  logic        tpu_idle,
    input  logic        tpu_working,
    input  logic        tpu_done,
    
    // Dimension outputs to TPU
    output logic [5:0]  dim_m,
    output logic [5:0]  dim_n,
    output logic [5:0]  dim_k
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
    // SPI Slave instance
    //=========================================================================
    tpu_spi_slave u_spi_slave (
        .clk            (clk),
        .rst_n          (rst_n),
        
        // SPI interface
        .spi_sck        (spi_sck),
        .spi_cs_n       (spi_cs_n),
        .spi_mosi       (spi_mosi),
        .spi_miso       (spi_miso),
        
        // Register interface
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
    tpu_mmio_regfile u_regfile (
        .clk            (clk),
        .rst_n          (rst_n),
        
        // SPI Slave interface
        .reg_addr       (reg_addr),
        .reg_rd         (reg_rd),
        .reg_wr         (reg_wr),
        .reg_wdata      (reg_wdata),
        .reg_rdata      (reg_rdata),
        .reg_addr_valid (reg_addr_valid),
        .reg_writable   (reg_writable),
        
        // TPU control interface
        .tpu_start      (tpu_start),
        .tpu_idle       (tpu_idle),
        .tpu_working    (tpu_working),
        .tpu_done       (tpu_done),
        
        // Dimension outputs
        .dim_m          (dim_m),
        .dim_n          (dim_n),
        .dim_k          (dim_k)
    );

endmodule