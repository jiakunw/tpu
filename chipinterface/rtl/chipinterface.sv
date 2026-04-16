///////////////////////////////////////////////////////////////////////////////
// top.sv
//
// TPU Chip Top Level
//
// Subsystems:
//   - SPI slave       : FPGA -> TPU register access
//   - MMIO regfile    : M/N/K dimensions, control/status
//   - bus_slave_ab    : FPGA -> SRAM_A / SRAM_B (write path)
//   - bus_slave_c     : SRAM_C -> FPGA (read path)
//   - sram_wrapper    : SRAM_A (bus write, TPU read)
//   - sram_wrapper    : SRAM_B (bus write, TPU read)
//   - sram_wrapper_c  : SRAM_C (TPU write, bus read)
//   - tpu_core        : systolic array engine
//
// Clock domains:
//   clk     = 10 MHz chip clock (= BUS_CLK from FPGA)
//   spi_sck = SPI clock from FPGA (slower, sampled by clk)
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module chipinterface (
    //=========================================================================
    // Chip Clock & Reset
    //=========================================================================
    input  logic        clk,        // 10 MHz chip clock
    input  logic        rstn,       // active-low async reset

    //=========================================================================
    // SPI Interface (FPGA -> TPU register access)
    //=========================================================================
    input  logic        spi_sck,
    input  logic        spi_cs_n,
    input  logic        spi_mosi,
    output logic        spi_miso,

    //=========================================================================
    // Parallel Bus Interface (FPGA bus_master -> TPU bus_slave)
    //=========================================================================
    // AB channel (FPGA writes matrices A and B)
    input  logic        CHAB_START,
    input  logic [7:0]  CHAB_WDATA_A,
    input  logic [7:0]  CHAB_WDATA_B,
    input  logic        CHAB_WR,

    // C channel (FPGA reads matrix C)
    input  logic        CHC_START,
    input  logic        CHC_RD,
    output logic [7:0]  CHC_RDATA
);

    //=========================================================================
    // SPI Slave <-> MMIO Register File
    //=========================================================================
    logic [3:0] reg_addr;
    logic       reg_rd;
    logic       reg_wr;
    logic [7:0] reg_wdata;
    logic [7:0] reg_rdata;
    logic       reg_addr_valid;
    logic       reg_writable;

    tpu_spi_slave u_spi_slave (
        .clk            (clk),
        .rst_n          (rstn),
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

    logic       tpu_start;
    logic [5:0] dim_m_6, dim_n_6, dim_k_6;
    logic       tpu_idle, tpu_working, tpu_done;

    // Quantization parameters from MMIO regfile — must be declared
    // BEFORE the instantiation so VCS doesn't infer them as 1-bit wires
    logic [7:0]  zero_point_a, zero_point_b, zero_point_c;
    logic [15:0] scale_factor;
    logic [4:0]  scale_shift;

    tpu_mmio_regfile u_regfile (
        .clk            (clk),
        .rst_n          (rstn),
        .reg_addr       (reg_addr),
        .reg_rd         (reg_rd),
        .reg_wr         (reg_wr),
        .reg_wdata      (reg_wdata),
        .reg_rdata      (reg_rdata),
        .reg_addr_valid (reg_addr_valid),
        .reg_writable   (reg_writable),
        .tpu_start      (tpu_start),
        .tpu_idle       (tpu_idle),
        .tpu_working    (tpu_working),
        .tpu_done       (tpu_done),
        .dim_m          (dim_m_6),
        .dim_n          (dim_n_6),
        .dim_k          (dim_k_6),
        .zero_point_a   (zero_point_a),
        .zero_point_b   (zero_point_b),
        .zero_point_c   (zero_point_c),
        .scale_factor   (scale_factor),
        .scale_shift    (scale_shift)
    );

    // Zero-extend to MNK_IDX_WIDTH=7
    logic [6:0] dim_m, dim_n, dim_k;
    assign dim_m = {1'b0, dim_m_6};
    assign dim_n = {1'b0, dim_n_6};
    assign dim_k = {1'b0, dim_k_6};

    //=========================================================================
    // Bus Slave AB: receives byte-pairs from FPGA bus_master
    //=========================================================================
    logic        sram_a_we;
    logic [11:0] sram_a_addr;
    logic [7:0]  sram_a_din;
    logic        sram_b_we;
    logic [11:0] sram_b_addr;
    logic [7:0]  sram_b_din;
    logic [11:0] debug_cnt_a, debug_cnt_b;

    bus_slave_ab #(.SRAM_AW(12), .DW(8)) u_bus_slave_ab (
        .BUS_CLK        (clk),
        .BUS_RST_N      (rstn),
        .DIM_M          (dim_m),
        .DIM_N          (dim_n),
        .DIM_K          (dim_k),
        .CHAB_START     (CHAB_START),
        .CHAB_WDATA_A   (CHAB_WDATA_A),
        .CHAB_WDATA_B   (CHAB_WDATA_B),
        .CHAB_WR        (CHAB_WR),
        .sram_a_we      (sram_a_we),
        .sram_a_addr    (sram_a_addr),
        .sram_a_din     (sram_a_din),
        .sram_b_we      (sram_b_we),
        .sram_b_addr    (sram_b_addr),
        .sram_b_din     (sram_b_din),
        .debug_cnt_a    (debug_cnt_a),
        .debug_cnt_b    (debug_cnt_b)
    );

    //=========================================================================
    // SRAM_A: bus write (8-bit), TPU read (64-bit)
    //=========================================================================
    logic        tpu_a_re;
    logic [8:0]  tpu_a_addr;
    logic [63:0] tpu_a_dout;

    sram_wrapper #(.AW(9), .DW(8)) u_sram_a (
        .clk        (clk),
        .rstn       (rstn),
        .bus_we     (sram_a_we),
        .bus_addr   (sram_a_addr),
        .bus_din    (sram_a_din),
        .tpu_re     (tpu_a_re),
        .tpu_addr   (tpu_a_addr),
        .tpu_dout   (tpu_a_dout)
    );

    //=========================================================================
    // SRAM_B: bus write (8-bit), TPU read (64-bit)
    //=========================================================================
    logic        tpu_b_re;
    logic [8:0]  tpu_b_addr;
    logic [63:0] tpu_b_dout;

    sram_wrapper #(.AW(9), .DW(8)) u_sram_b (
        .clk        (clk),
        .rstn       (rstn),
        .bus_we     (sram_b_we),
        .bus_addr   (sram_b_addr),
        .bus_din    (sram_b_din),
        .tpu_re     (tpu_b_re),
        .tpu_addr   (tpu_b_addr),
        .tpu_dout   (tpu_b_dout)
    );

    //=========================================================================
    // SRAM_C: TPU write (64-bit), bus read (8-bit)
    //=========================================================================
    logic        tpu_c_we;
    logic [8:0]  tpu_c_waddr;
    logic [63:0] tpu_c_din;
    logic        sram_c_re;
    logic [11:0] sram_c_addr;
    logic [7:0]  sram_c_dout;

    sram_wrapper_c #(.AW(9), .DW(8)) u_sram_c (
        .clk        (clk),
        .rstn       (rstn),
        .tpu_we     (tpu_c_we),
        .tpu_addr   (tpu_c_waddr),
        .tpu_din    (tpu_c_din),
        .bus_re     (sram_c_re),
        .bus_addr   (sram_c_addr),
        .bus_dout   (sram_c_dout)
    );

    //=========================================================================
    // Bus Slave C: SRAM_C -> FPGA bus_master
    //=========================================================================
    logic [11:0] debug_cnt_c;

    bus_slave_c #(.SRAM_AW(12), .DW(8)) u_bus_slave_c (
        .BUS_CLK        (clk),
        .BUS_RST_N      (rstn),
        .CHC_START      (CHC_START),
        .CHC_RD         (CHC_RD),
        .CHC_RDATA      (CHC_RDATA),
        .sram_c_re      (sram_c_re),
        .sram_c_addr    (sram_c_addr),
        .sram_c_dout    (sram_c_dout),
        .debug_cnt_c    (debug_cnt_c)
    );

    //=========================================================================
    // TPU Core
    //=========================================================================
    // tpu_core outputs
    logic [8:0]  a_raddr, b_raddr, bias_addr;
    logic [8:0]  c_waddr;
    logic        a_b_sram_rd_en;
    logic        bias_sram_rd_en;
    logic        c_sram_w_en;
    logic        done_flag;
    logic [63:0] outcome_quantized;  // 8 bytes = ARRAY_SIZE*DATA_WIDTH

    // Connect TPU read enables and addresses to SRAM wrappers
    assign tpu_a_re   = a_b_sram_rd_en;
    assign tpu_b_re   = a_b_sram_rd_en;
    assign tpu_a_addr = a_raddr;
    assign tpu_b_addr = b_raddr;

    // Connect TPU write to SRAM_C
    assign tpu_c_we    = c_sram_w_en;
    assign tpu_c_waddr = c_waddr;
    assign tpu_c_din   = outcome_quantized;

    // TPU status back to MMIO regfile
    // done_flag is a level signal from tpu_core; detect rising edge for pulse
    logic tpu_working_int;
    logic done_flag_prev;
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) done_flag_prev <= 1'b0;
        else       done_flag_prev <= done_flag;
    end
    assign tpu_done    = done_flag & ~done_flag_prev;  // rising edge pulse
    assign tpu_idle    = ~done_flag & ~tpu_working_int;
    assign tpu_working = tpu_working_int;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn)          tpu_working_int <= 1'b0;
        else if (tpu_start) tpu_working_int <= 1'b1;
        else if (done_flag) tpu_working_int <= 1'b0;
    end

    tpu_core #(
        .ARRAY_SIZE         (8),
        .SRAM_DATA_WIDTH    (64),
        .DATA_WIDTH         (8),
        .ACCUMULATOR_WIDTH  (32),
        .OUTCOME_WIDTH      (33),
        .SCALE_FACTOR_WIDTH (16),
        .OFFSET_WIDTH       (8),
        .BIAS_WIDTH         (32),
        .MAX_TILE           (64),
        .SRAM_ADDR_WIDTH    (9)
    ) u_tpu_core (
        .clk                    (clk),
        .rstn                   (rstn),
        .tpu_start              (tpu_start),
        .keep_pe_value          (1'b0),
        .m                      (7'(dim_m >> 3)),   // tile count = actual_dim / 8
        .n                      (7'(dim_n >> 3)),
        .k                      (7'(dim_k >> 3)),
        .num_computation        (7'(dim_k >> 3)),   // inner loop tile count = K/8
        .sram_rdata_a           (tpu_a_dout),
        .sram_rdata_b           (tpu_b_dout),
        .zero_point_a           (zero_point_a),
        .zero_point_b           (zero_point_b),
        .zero_point_c           (zero_point_c),
        .bias                   (32'h0),
        .scale_factor           (scale_factor),
        .scale_shift            (scale_shift),
        .outcome_quantized      (outcome_quantized),
        .a_raddr                (a_raddr),
        .b_raddr                (b_raddr),
        .c_waddr                (c_waddr),
        .bias_addr              (bias_addr),
        .a_b_sram_rd_en         (a_b_sram_rd_en),
        .bias_sram_rd_en        (bias_sram_rd_en),
        .c_sram_w_en            (c_sram_w_en),
        .done_flag              (done_flag),
        .TEST_outcome_full_TEST (),
        .TEST_c_row_idx_TEST    (),
        .TEST_c_col_idx_TEST    (),
        .TEST_c_sram_w_en_TEST  ()
    );

endmodule
