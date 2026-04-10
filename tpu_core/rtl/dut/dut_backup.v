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
    output      [IDX_WIDTH-1:0] TEST_c_col_idx_TEST,
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
    wire [IDX_WIDTH-1:0] tpu_core_inst_TEST_c_col_idx_TEST;
    wire tpu_core_inst_TEST_c_sram_w_en_TEST;
    // ----- end ----- //


    // ----- sram_a_inst ----- //
    wire sram_a_inst_wr_en;
    wire sram_a_inst_rd_en;
    wire [SRAM_ADDR_WIDTH-1:0] sram_a_inst_waddr;
    wire [SRAM_ADDR_WIDTH-1:0] sram_a_inst_raddr;
    wire [SRAM_DATA_WIDTH-1:0] sram_a_inst_wdata;
    wire [SRAM_DATA_WIDTH-1:0] sram_a_inst_rdata;
    // ----- end ----- //


    // ----- sram_b_inst ----- //
    wire sram_b_inst_wr_en;
    wire sram_b_inst_rd_en;
    wire [SRAM_ADDR_WIDTH-1:0] sram_b_inst_waddr;
    wire [SRAM_ADDR_WIDTH-1:0] sram_b_inst_raddr;
    wire [SRAM_DATA_WIDTH-1:0] sram_b_inst_wdata;
    wire [SRAM_DATA_WIDTH-1:0] sram_b_inst_rdata;
    // ----- end ----- //


    // ----- sram_c_inst ----- //
    wire sram_c_inst_wr_en;
    wire sram_c_inst_rd_en;
    wire [SRAM_ADDR_WIDTH-1:0] sram_c_inst_waddr;
    wire [SRAM_ADDR_WIDTH-1:0] sram_c_inst_raddr;
    wire [SRAM_DATA_WIDTH-1:0] sram_c_inst_wdata;
    wire [SRAM_DATA_WIDTH-1:0] sram_c_inst_rdata;
    // ----- end ----- //


    // ----- tpu_core_inst ----- //
    assign tpu_core_inst_tpu_start      = tpu_start;
    assign tpu_core_inst_keep_pe_value  = keep_pe_value;

    assign tpu_core_inst_m              = m;
    assign tpu_core_inst_n              = n;
    assign tpu_core_inst_k              = k;
    assign tpu_core_inst_num_computation= num_computation;

    assign tpu_core_inst_sram_rdata_a   = sram_a_inst_rdata;
    assign tpu_core_inst_sram_rdata_b   = sram_b_inst_rdata;

    assign tpu_core_inst_zero_point_a   = zero_point_a;
    assign tpu_core_inst_zero_point_b   = zero_point_b;
    assign tpu_core_inst_zero_point_c   = zero_point_c;

    assign tpu_core_inst_bias           = sram_bias_rdata;
    assign tpu_core_inst_scale_factor   = scale_factor;
    assign tpu_core_inst_scale_shift    = scale_shift;

    assign bias_addr                    = tpu_core_inst_bias_addr;
    assign bias_sram_rd_en              = tpu_core_inst_bias_sram_rd_en;
    assign done_flag                    = tpu_core_inst_done_flag;

    assign TEST_outcome_full_TEST       = tpu_core_inst_TEST_outcome_full_TEST;
    assign TEST_c_row_idx_TEST          = tpu_core_inst_TEST_c_row_idx_TEST;
    assign TEST_c_col_idx_TEST          = tpu_core_inst_TEST_c_col_idx_TEST;
    assign TEST_c_sram_w_en_TEST        = tpu_core_inst_TEST_c_sram_w_en_TEST;

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


    // ----- sram_a_inst ----- //
    assign sram_a_inst_wr_en    = sram_a_wr_en;
    assign sram_a_inst_rd_en    = tpu_core_inst_a_b_sram_rd_en;
    assign sram_a_inst_waddr    = sram_a_waddr;
    assign sram_a_inst_raddr    = tpu_core_inst_a_raddr;
    assign sram_a_inst_wdata    = sram_a_wdata;

    sram_wrapper sram_a_inst (
        .clk    (clk),
        .wr_en  (sram_a_inst_wr_en),
        .rd_en  (sram_a_inst_rd_en),
        .waddr  (sram_a_inst_waddr),
        .raddr  (sram_a_inst_raddr),
        .wdata  (sram_a_inst_wdata),
        .rdata  (sram_a_inst_rdata)
    );
    // ----- end ----- //


    // ----- sram_b_inst ----- //
    assign sram_b_inst_wr_en    = sram_b_wr_en;
    assign sram_b_inst_rd_en    = tpu_core_inst_a_b_sram_rd_en;
    assign sram_b_inst_waddr    = sram_b_waddr;
    assign sram_b_inst_raddr    = tpu_core_inst_b_raddr;
    assign sram_b_inst_wdata    = sram_b_wdata;

    sram_wrapper sram_b_inst (
        .clk    (clk),
        .wr_en  (sram_b_inst_wr_en),
        .rd_en  (sram_b_inst_rd_en),
        .waddr  (sram_b_inst_waddr),
        .raddr  (sram_b_inst_raddr),
        .wdata  (sram_b_inst_wdata),
        .rdata  (sram_b_inst_rdata)
    );
    // ----- end ----- //


    // ----- sram_c_inst ----- //
    assign sram_c_inst_wr_en    = tpu_core_inst_c_sram_w_en;
    assign sram_c_inst_rd_en    = sram_c_rd_en;
    assign sram_c_inst_waddr    = tpu_core_inst_c_waddr;
    assign sram_c_inst_raddr    = sram_c_raddr;
    assign sram_c_inst_wdata    = tpu_core_inst_outcome_quantized;

    assign sram_c_rdata         = sram_c_inst_rdata;

    sram_wrapper sram_c_inst (
        .clk    (clk),
        .wr_en  (sram_c_inst_wr_en),
        .rd_en  (sram_c_inst_rd_en),
        .waddr  (sram_c_inst_waddr),
        .raddr  (sram_c_inst_raddr),
        .wdata  (sram_c_inst_wdata),
        .rdata  (sram_c_inst_rdata)
    );
    // ----- end ----- //

endmodule
