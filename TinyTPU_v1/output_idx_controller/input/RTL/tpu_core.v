module tpu_core#(
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
    input   clk,
    input   rstn,

    input   tpu_start,
    input   keep_pe_value,

    input   [MNK_IDX_WIDTH-1:0] m,
    input   [MNK_IDX_WIDTH-1:0] n,
    input   [MNK_IDX_WIDTH-1:0] k,
    input   [MNK_IDX_WIDTH-1:0] num_computation,

    input   [SRAM_DATA_WIDTH-1:0] sram_rdata_a,
    input   [SRAM_DATA_WIDTH-1:0] sram_rdata_b,

    input   [OFFSET_WIDTH-1:0] zero_point_a,
    input   [OFFSET_WIDTH-1:0] zero_point_b,
    input   [OFFSET_WIDTH-1:0] zero_point_c,

    input   [BIAS_WIDTH-1:0] bias,
    input   [SCALE_FACTOR_WIDTH-1:0] scale_factor,
    input   [4:0] scale_shift,

    output  [ARRAY_SIZE*OUTCOME_WIDTH-1:0] outcome_full_TEST,
    output  [ARRAY_SIZE*DATA_WIDTH-1:0] outcome_quantized,

    output  [SRAM_ADDR_WIDTH-1:0] a_raddr,
    output  [SRAM_ADDR_WIDTH-1:0] b_raddr,
    output  [SRAM_ADDR_WIDTH-1:0] c_waddr,

    output  [IDX_WIDTH-1:0] c_row_idx_TEST,
    output  [IDX_WIDTH-1:0] c_col_idx_TEST,

    output  [SRAM_ADDR_WIDTH-1:0] bias_addr,

    output  a_b_sram_rd_en,
    output  bias_sram_rd_en,
    output  c_sram_w_en,

    output  done_flag
);

    wire  [IDX_WIDTH-1:0] a_row_idx;
    wire  [IDX_WIDTH-1:0] a_col_idx;
    wire  [IDX_WIDTH-1:0] b_row_idx;
    wire  [IDX_WIDTH-1:0] b_col_idx;
    wire  [IDX_WIDTH-1:0] c_row_idx;
    wire  [IDX_WIDTH-1:0] c_col_idx;
    wire  [ARRAY_SIZE*OUTCOME_WIDTH-1:0] outcome_full;

    assign c_row_idx_TEST = c_row_idx;
    assign c_col_idx_TEST = c_col_idx;
    assign outcome_full_TEST = outcome_full;

    // input idx controller wire
    wire input_idx_done;
    wire alu_start;

    // systolic array wire
    wire [MNK_IDX_WIDTH-1:0] tile_num = n - {{(MNK_IDX_WIDTH-1){1'b0}}, 1'b1};
    wire [ARRAY_SIZE*ACCUMULATOR_WIDTH-1:0] outcome_systolic;
    wire out_ready_systolic;
    wire [2:0] row_idx_systolic;

    // output idx controller wire
    wire [IDX_WIDTH-1:0] c_row_idx_ctrl;
    wire [IDX_WIDTH-1:0] c_col_idx_ctrl;
    wire out_done_ctrl;

    // bias adder wire
    wire [ARRAY_SIZE*ACCUMULATOR_WIDTH-1:0] outcome_baddr;
    wire out_ready_baddr;
    wire [IDX_WIDTH-1:0] c_row_idx_baddr;
    wire [IDX_WIDTH-1:0] c_col_idx_baddr;
    wire out_done_baddr;

    // scale multiplier wire
    wire [ARRAY_SIZE*OUTCOME_WIDTH-1:0] outcome_scaled;

    // --- input index controller --- //
    input_idx_controller input_idx_controller (
        .clk            (clk),
        .rstn           (rstn),
        .tpu_start      (tpu_start),

        .num_computation(num_computation),

        .m              (m),
        .n              (n),
        .k              (k),

        .a_row_idx      (a_row_idx),
        .a_col_idx      (a_col_idx),
        .b_row_idx      (b_row_idx),
        .b_col_idx      (b_col_idx),

        .alu_start      (alu_start),
        .sram_rd_en     (a_b_sram_rd_en),
        .done           (input_idx_done)
    );

    // --- systolic array wrapper --- //
    systolic_array_wrapper systolic_array_wrapper (
        .clk                (clk),
        .rstn               (rstn),
        .alu_start          (alu_start && !out_done_ctrl),

        .all_input_are_fed  (input_idx_done),
        .keep_pe_value      (keep_pe_value),
        .tile_num           (tile_num[MNK_IDX_WIDTH-2:0]),

        .sram_rdata_a0      (sram_rdata_a[SRAM_DATA_WIDTH-1:SRAM_DATA_WIDTH/2]),
        .sram_rdata_a1      (sram_rdata_a[SRAM_DATA_WIDTH/2-1:0]),

        .sram_rdata_b0      (sram_rdata_b[SRAM_DATA_WIDTH-1:SRAM_DATA_WIDTH/2]),
        .sram_rdata_b1      (sram_rdata_b[SRAM_DATA_WIDTH/2-1:0]),

        .zero_point_a       (zero_point_a),
        .zero_point_b       (zero_point_b),

        .sram_wdata_c       (outcome_systolic),
        
        .out_ready          (out_ready_systolic),
        .row_idx            (row_idx_systolic)
    );

    // --- output index controller --- //
    output_idx_controller output_idx_controller (
        .clk            (clk),
        .rstn           (rstn),
        .alu_init       (alu_start),
        .in_valid       (out_ready_systolic),

        .row_idx        (row_idx_systolic),

        .num_computation(num_computation),

        .m              (m),
        .k              (k),

        .c_row_idx      (c_row_idx_ctrl),
        .c_col_idx      (c_col_idx_ctrl),

        .done_flag      (out_done_ctrl)
    );
    assign bias_addr = c_row_idx_ctrl[SRAM_ADDR_WIDTH-1:0];

    // --- output bias adder --- //
    bias_adder bias_adder (
        .clk            (clk),
        .rstn           (rstn),
        .alu_start      (alu_start),

        .valid_in       (out_ready_systolic),
        .c_row_idx_in   (c_row_idx_ctrl),
        .c_col_idx_in   (c_col_idx_ctrl),
        .done_in        (out_done_ctrl),

        .data_in        (outcome_systolic),
        .bias           (bias),

        .data_out       (outcome_baddr),

        .valid_out      (out_ready_baddr),
        .c_row_idx_out  (c_row_idx_baddr),
        .c_col_idx_out  (c_col_idx_baddr),
        .done_out       (out_done_baddr)
    );
    assign bias_sram_rd_en = out_ready_systolic;

    // --- scale_multiplier --- //
    scale_multiplier scale_multiplier(
        .clk            (clk),
        .rstn           (rstn),
        .alu_start      (alu_start),

        .valid_in       (out_ready_baddr),
        .c_row_idx_in   (c_row_idx_baddr),
        .c_col_idx_in   (c_col_idx_baddr),
        .done_in        (out_done_baddr),

        .data_in        (outcome_baddr),
        .b              (scale_factor),
        .n              (scale_shift),

        .data_out       (outcome_scaled),

        .valid_out      (c_sram_w_en),
        .c_row_idx_out  (c_row_idx),
        .c_col_idx_out  (c_col_idx),
        .done_out       (done_flag)
    );

    // --- output_offset_adder --- //
    output_offset_adder output_offset_adder (
        .data_in    (outcome_scaled),
        .b          (zero_point_c),
        .data_out   (outcome_full)
    );

    // ----- RELU ----- //
    ReLU_clamp ReLU_clamp(
        .outcome_full(outcome_full),
        .relu_out(outcome_quantized)
    );

    // ----- Addr Converter ----- //
    addr_converter ADDR_CONVERTER(
        .m(m),
        .n(n),
        .k(k),
        .num_computation(num_computation),

        .a_row_idx(a_row_idx),
        .a_col_idx(a_col_idx),
        .b_row_idx(b_row_idx),
        .b_col_idx(b_col_idx),
        .c_row_idx(c_row_idx),
        .c_col_idx(c_col_idx),

        .a_raddr(a_raddr),
        .b_raddr(b_raddr),
        .c_waddr(c_waddr)
    );

endmodule