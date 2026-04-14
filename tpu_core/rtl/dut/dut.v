module dut #(
    parameter   ARRAY_SIZE      = 8,
    parameter   SRAM_DATA_WIDTH  = 64,

    parameter   DATA_WIDTH = 8,
    parameter   ACCUMULATOR_WIDTH = 32,
    parameter   OUTCOME_WIDTH = 33,

    parameter   SCALE_FACTOR_WIDTH = 16,
    parameter   OFFSET_WIDTH = 8,
    parameter   BIAS_WIDTH = 32,

    parameter   MAX_TILE = 64,
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1,
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2,

    parameter   SRAM_ADDR_WIDTH = 9
)(
    input       clk,
    input       rstn,

    input       tpu_start,
    input       keep_pe_value,

    input       [MNK_IDX_WIDTH-1:0] m,
    input       [MNK_IDX_WIDTH-1:0] n,
    input       [MNK_IDX_WIDTH-1:0] k,
    input       [MNK_IDX_WIDTH-1:0] num_computation,

    input       [OFFSET_WIDTH-1:0] zero_point_a,
    input       [OFFSET_WIDTH-1:0] zero_point_b,
    input       [OFFSET_WIDTH-1:0] zero_point_c,

    input       [SCALE_FACTOR_WIDTH-1:0] scale_factor,
    input       [4:0] scale_shift,

    // ----- A SRAM external write port ----- //
    input       sram_a_wr_en,
    input       [SRAM_ADDR_WIDTH-1:0] sram_a_waddr,
    input       [SRAM_DATA_WIDTH-1:0] sram_a_wdata,

    // ----- B SRAM external write port ----- //
    input       sram_b_wr_en,
    input       [SRAM_ADDR_WIDTH-1:0] sram_b_waddr,
    input       [SRAM_DATA_WIDTH-1:0] sram_b_wdata,

    // ----- C SRAM external read port ----- //
    input       sram_c_rd_en,
    input       [SRAM_ADDR_WIDTH-1:0] sram_c_raddr,
    output      [SRAM_DATA_WIDTH-1:0] sram_c_rdata,

    // ----- bias SRAM interface (external) ----- //
    output      bias_sram_rd_en,
    output      [IDX_WIDTH-1:0] bias_addr,
    input       [BIAS_WIDTH-1:0] sram_bias_rdata,

    output      done_flag,

    output      [ARRAY_SIZE*OUTCOME_WIDTH-1:0] TEST_outcome_full_TEST,
    output      [IDX_WIDTH-1:0] TEST_c_row_idx_TEST,
    output      [IDX_WIDTH-4:0] TEST_c_col_idx_TEST,
    output      TEST_c_sram_w_en_TEST
);

    // ----- tpu_core_inst ----- //
    wire tpu_core_inst_tpu_start;
    wire tpu_core_inst_keep_pe_value;

    wire [MNK_IDX_WIDTH-1:0] tpu_core_inst_m;
    wire [MNK_IDX_WIDTH-1:0] tpu_core_inst_n;
    wire [MNK_IDX_WIDTH-1:0] tpu_core_inst_k;
    wire [MNK_IDX_WIDTH-1:0] tpu_core_inst_num_computation;

    wire [SRAM_DATA_WIDTH-1:0] tpu_core_inst_sram_rdata_a;
    wire [SRAM_DATA_WIDTH-1:0] tpu_core_inst_sram_rdata_b;

    wire [OFFSET_WIDTH-1:0] tpu_core_inst_zero_point_a;
    wire [OFFSET_WIDTH-1:0] tpu_core_inst_zero_point_b;
    wire [OFFSET_WIDTH-1:0] tpu_core_inst_zero_point_c;

    wire [BIAS_WIDTH-1:0] tpu_core_inst_bias;
    wire [SCALE_FACTOR_WIDTH-1:0] tpu_core_inst_scale_factor;
    wire [4:0] tpu_core_inst_scale_shift;

    wire [ARRAY_SIZE*DATA_WIDTH-1:0] tpu_core_inst_outcome_quantized;

    wire [SRAM_ADDR_WIDTH-1:0] tpu_core_inst_a_raddr;
    wire [SRAM_ADDR_WIDTH-1:0] tpu_core_inst_b_raddr;
    wire [SRAM_ADDR_WIDTH-1:0] tpu_core_inst_c_waddr;

    wire [IDX_WIDTH-1:0] tpu_core_inst_bias_addr;

    wire tpu_core_inst_a_b_sram_rd_en;
    wire tpu_core_inst_bias_sram_rd_en;
    wire tpu_core_inst_c_sram_w_en;

    wire tpu_core_inst_done_flag;

    wire [ARRAY_SIZE*OUTCOME_WIDTH-1:0] tpu_core_inst_TEST_outcome_full_TEST;
    wire [IDX_WIDTH-1:0] tpu_core_inst_TEST_c_row_idx_TEST;
    wire [IDX_WIDTH-4:0] tpu_core_inst_TEST_c_col_idx_TEST;
    wire tpu_core_inst_TEST_c_sram_w_en_TEST;
    // ----- end ----- //


    // ----- input_sram_inst ----- //
    wire input_sram_inst_wr_en_a;
    wire input_sram_inst_rd_en_a;
    wire [SRAM_ADDR_WIDTH-1:0] input_sram_inst_waddr_a;
    wire [SRAM_ADDR_WIDTH-1:0] input_sram_inst_raddr_a;
    wire [SRAM_DATA_WIDTH-1:0] input_sram_inst_wdata_a;
    wire [SRAM_DATA_WIDTH-1:0] input_sram_inst_rdata_a;

    wire input_sram_inst_wr_en_b;
    wire input_sram_inst_rd_en_b;
    wire [SRAM_ADDR_WIDTH-1:0] input_sram_inst_waddr_b;
    wire [SRAM_ADDR_WIDTH-1:0] input_sram_inst_raddr_b;
    wire [SRAM_DATA_WIDTH-1:0] input_sram_inst_wdata_b;
    wire [SRAM_DATA_WIDTH-1:0] input_sram_inst_rdata_b;
    // ----- end ----- //


    // ----- output_sram_inst ----- //
    wire output_sram_inst_wr_en_c;
    wire output_sram_inst_rd_en_c;
    wire [SRAM_ADDR_WIDTH-1:0] output_sram_inst_waddr_c;
    wire [SRAM_ADDR_WIDTH-1:0] output_sram_inst_raddr_c;
    wire [SRAM_DATA_WIDTH-1:0] output_sram_inst_wdata_c;
    wire [SRAM_DATA_WIDTH-1:0] output_sram_inst_rdata_c;
    // ----- end ----- //


    // ----- tpu_core_inst ----- //
    assign tpu_core_inst_tpu_start       = tpu_start;
    assign tpu_core_inst_keep_pe_value   = keep_pe_value;

    assign tpu_core_inst_m               = m;
    assign tpu_core_inst_n               = n;
    assign tpu_core_inst_k               = k;
    assign tpu_core_inst_num_computation = num_computation;

    assign tpu_core_inst_sram_rdata_a    = input_sram_inst_rdata_a;
    assign tpu_core_inst_sram_rdata_b    = input_sram_inst_rdata_b;

    assign tpu_core_inst_zero_point_a    = zero_point_a;
    assign tpu_core_inst_zero_point_b    = zero_point_b;
    assign tpu_core_inst_zero_point_c    = zero_point_c;

    assign tpu_core_inst_bias            = sram_bias_rdata;
    assign tpu_core_inst_scale_factor    = scale_factor;
    assign tpu_core_inst_scale_shift     = scale_shift;

    assign bias_addr                     = tpu_core_inst_bias_addr;
    assign bias_sram_rd_en               = tpu_core_inst_bias_sram_rd_en;
    assign done_flag                     = tpu_core_inst_done_flag;

    assign TEST_outcome_full_TEST        = tpu_core_inst_TEST_outcome_full_TEST;
    assign TEST_c_row_idx_TEST           = tpu_core_inst_TEST_c_row_idx_TEST;
    assign TEST_c_col_idx_TEST           = tpu_core_inst_TEST_c_col_idx_TEST;
    assign TEST_c_sram_w_en_TEST         = tpu_core_inst_TEST_c_sram_w_en_TEST;

    tpu_core tpu_core_inst (
        .clk                (clk),
        .rstn               (rstn),

        .tpu_start          (tpu_core_inst_tpu_start),
        .keep_pe_value      (tpu_core_inst_keep_pe_value),

        .m                  (tpu_core_inst_m),
        .n                  (tpu_core_inst_n),
        .k                  (tpu_core_inst_k),
        .num_computation    (tpu_core_inst_num_computation),

        .sram_rdata_a       (tpu_core_inst_sram_rdata_a),
        .sram_rdata_b       (tpu_core_inst_sram_rdata_b),

        .zero_point_a       (tpu_core_inst_zero_point_a),
        .zero_point_b       (tpu_core_inst_zero_point_b),
        .zero_point_c       (tpu_core_inst_zero_point_c),

        .bias               (tpu_core_inst_bias),
        .scale_factor       (tpu_core_inst_scale_factor),
        .scale_shift        (tpu_core_inst_scale_shift),

        .outcome_quantized  (tpu_core_inst_outcome_quantized),

        .a_raddr            (tpu_core_inst_a_raddr),
        .b_raddr            (tpu_core_inst_b_raddr),
        .c_waddr            (tpu_core_inst_c_waddr),

        .bias_addr          (tpu_core_inst_bias_addr),

        .a_b_sram_rd_en     (tpu_core_inst_a_b_sram_rd_en),
        .bias_sram_rd_en    (tpu_core_inst_bias_sram_rd_en),
        .c_sram_w_en        (tpu_core_inst_c_sram_w_en),

        .done_flag          (tpu_core_inst_done_flag),

        .TEST_outcome_full_TEST (tpu_core_inst_TEST_outcome_full_TEST),
        .TEST_c_row_idx_TEST    (tpu_core_inst_TEST_c_row_idx_TEST),
        .TEST_c_col_idx_TEST    (tpu_core_inst_TEST_c_col_idx_TEST),
        .TEST_c_sram_w_en_TEST  (tpu_core_inst_TEST_c_sram_w_en_TEST)
    );
    // ----- end ----- //


    // ----- input_sram_inst ----- //
    assign input_sram_inst_wr_en_a  = sram_a_wr_en;
    assign input_sram_inst_rd_en_a  = tpu_core_inst_a_b_sram_rd_en;
    assign input_sram_inst_waddr_a  = sram_a_waddr;
    assign input_sram_inst_raddr_a  = tpu_core_inst_a_raddr;
    assign input_sram_inst_wdata_a  = sram_a_wdata;

    assign input_sram_inst_wr_en_b  = sram_b_wr_en;
    assign input_sram_inst_rd_en_b  = tpu_core_inst_a_b_sram_rd_en;
    assign input_sram_inst_waddr_b  = sram_b_waddr;
    assign input_sram_inst_raddr_b  = tpu_core_inst_b_raddr;
    assign input_sram_inst_wdata_b  = sram_b_wdata;

    input_sram input_sram_inst (
        .clk        (clk),

        .wr_en_a    (input_sram_inst_wr_en_a),
        .rd_en_a    (input_sram_inst_rd_en_a),
        .waddr_a    (input_sram_inst_waddr_a),
        .raddr_a    (input_sram_inst_raddr_a),
        .wdata_a    (input_sram_inst_wdata_a),
        .rdata_a    (input_sram_inst_rdata_a),

        .wr_en_b    (input_sram_inst_wr_en_b),
        .rd_en_b    (input_sram_inst_rd_en_b),
        .waddr_b    (input_sram_inst_waddr_b),
        .raddr_b    (input_sram_inst_raddr_b),
        .wdata_b    (input_sram_inst_wdata_b),
        .rdata_b    (input_sram_inst_rdata_b)
    );
    // ----- end ----- //


    // ----- output_sram_inst ----- //
    assign output_sram_inst_wr_en_c  = tpu_core_inst_c_sram_w_en;
    assign output_sram_inst_rd_en_c  = sram_c_rd_en;
    assign output_sram_inst_waddr_c  = tpu_core_inst_c_waddr;
    assign output_sram_inst_raddr_c  = sram_c_raddr;
    assign output_sram_inst_wdata_c  = tpu_core_inst_outcome_quantized;

    assign sram_c_rdata              = output_sram_inst_rdata_c;

    output_sram output_sram_inst (
        .clk        (clk),

        .wr_en_c    (output_sram_inst_wr_en_c),
        .rd_en_c    (output_sram_inst_rd_en_c),
        .waddr_c    (output_sram_inst_waddr_c),
        .raddr_c    (output_sram_inst_raddr_c),
        .wdata_c    (output_sram_inst_wdata_c),
        .rdata_c    (output_sram_inst_rdata_c)
    );
    // ----- end ----- //

endmodule