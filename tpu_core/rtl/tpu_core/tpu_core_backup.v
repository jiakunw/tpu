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
    input       clk,
    input       rstn,

    input       tpu_start,
    input       keep_pe_value,

    input       [MNK_IDX_WIDTH-1:0] m,
    input       [MNK_IDX_WIDTH-1:0] n,
    input       [MNK_IDX_WIDTH-1:0] k,
    input       [MNK_IDX_WIDTH-1:0] num_computation,

    input       [SRAM_DATA_WIDTH-1:0] sram_rdata_a,
    input       [SRAM_DATA_WIDTH-1:0] sram_rdata_b,

    input       [OFFSET_WIDTH-1:0] zero_point_a,
    input       [OFFSET_WIDTH-1:0] zero_point_b,
    input       [OFFSET_WIDTH-1:0] zero_point_c,

    input       [BIAS_WIDTH-1:0] bias,
    input       [SCALE_FACTOR_WIDTH-1:0] scale_factor,
    input       [4:0] scale_shift,

    output reg  [ARRAY_SIZE*DATA_WIDTH-1:0] outcome_quantized,

    output      [SRAM_ADDR_WIDTH-1:0] a_raddr,
    output      [SRAM_ADDR_WIDTH-1:0] b_raddr,
    output reg  [SRAM_ADDR_WIDTH-1:0] c_waddr,

    output      [SRAM_ADDR_WIDTH-1:0] bias_addr,

    output      a_b_sram_rd_en,
    output      bias_sram_rd_en,
    output reg  c_sram_w_en,

    output reg  done_flag,

    output      [ARRAY_SIZE*OUTCOME_WIDTH-1:0] TEST_outcome_full_TEST, // TEST   
    output      [IDX_WIDTH-1:0] TEST_c_row_idx_TEST, // TEST
    output      [IDX_WIDTH-1:0] TEST_c_col_idx_TEST, // TEST 
    output      TEST_c_sram_w_en_TEST // TEST
);

    // ----- input_idx_controller ----- //
    wire input_idx_controller_tpu_start = tpu_start;

    wire [MNK_IDX_WIDTH-1:0] input_idx_controller_num_computation;

    wire [MNK_IDX_WIDTH-1:0] input_idx_controller_m;
    wire [MNK_IDX_WIDTH-1:0] input_idx_controller_n;
    wire [MNK_IDX_WIDTH-1:0] input_idx_controller_k;

    wire [IDX_WIDTH-1:0] input_idx_controller_a_row_idx;
    wire [IDX_WIDTH-1:0] input_idx_controller_a_col_idx;
    wire [IDX_WIDTH-1:0] input_idx_controller_b_row_idx;
    wire [IDX_WIDTH-1:0] input_idx_controller_b_col_idx;

    wire input_idx_controller_alu_start;
    wire input_idx_controller_sram_rd_en;
    wire input_idx_controller_done;
    // ----- end ----- //


    // ----- systolic_array_wrapper ----- //
    wire systolic_array_wrapper_alu_start;
    wire systolic_array_wrapper_all_input_are_fed;
    wire systolic_array_wrapper_keep_pe_value;
    wire [MNK_IDX_WIDTH-1:0] systolic_array_wrapper_tile_num;

    wire [4*DATA_WIDTH-1:0] systolic_array_wrapper_sram_rdata_a0;
    wire [4*DATA_WIDTH-1:0] systolic_array_wrapper_sram_rdata_a1;

    wire [4*DATA_WIDTH-1:0] systolic_array_wrapper_sram_rdata_b0;
    wire [4*DATA_WIDTH-1:0] systolic_array_wrapper_sram_rdata_b1;

    wire [OFFSET_WIDTH-1:0] systolic_array_wrapper_zero_point_a;
    wire [OFFSET_WIDTH-1:0] systolic_array_wrapper_zero_point_b;

    wire [ARRAY_SIZE*ACCUMULATOR_WIDTH-1:0] systolic_array_wrapper_sram_wdata_c;

    wire systolic_array_wrapper_out_ready;
    wire [2:0] systolic_array_wrapper_row_idx;
    // ----- end ----- //


    // ----- output_idx_controller ----- //   
    wire output_idx_controller_alu_init;
    wire output_idx_controller_in_valid;

    wire [2:0] output_idx_controller_row_idx;
    wire [MNK_IDX_WIDTH-1:0] output_idx_controller_num_computation;

    wire [MNK_IDX_WIDTH-1:0] output_idx_controller_m;
    wire [MNK_IDX_WIDTH-1:0] output_idx_controller_k;

    wire [IDX_WIDTH-1:0] output_idx_controller_c_row_idx;
    wire [IDX_WIDTH-1:0] output_idx_controller_c_col_idx;

    wire output_idx_controller_done_flag;
    // ----- end ----- //


    // ----- bias_adder ----- //
    wire bias_adder_alu_start;

    wire bias_adder_valid_in;
    wire [IDX_WIDTH-1:0] bias_adder_c_row_idx_in;
    wire [IDX_WIDTH-1:0] bias_adder_c_col_idx_in;
    wire bias_adder_done_in;

    wire signed [ARRAY_SIZE*ACCUMULATOR_WIDTH-1:0] bias_adder_data_in;
    wire signed [BIAS_WIDTH-1:0] bias_adder_bias;

    wire signed [ARRAY_SIZE*ACCUMULATOR_WIDTH-1:0] bias_adder_data_out;

    wire bias_adder_valid_out;
    wire [IDX_WIDTH-1:0] bias_adder_c_row_idx_out;
    wire [IDX_WIDTH-1:0] bias_adder_c_col_idx_out;
    wire bias_adder_done_out;
    // ----- end ----- //


    // ----- scale_multiplier ----- //
    wire scale_multiplier_alu_start;

    wire scale_multiplier_valid_in;
    wire [IDX_WIDTH-1:0] scale_multiplier_c_row_idx_in;
    wire [IDX_WIDTH-1:0] scale_multiplier_c_col_idx_in;
    wire scale_multiplier_done_in;

    wire signed [ARRAY_SIZE*ACCUMULATOR_WIDTH-1:0] scale_multiplier_data_in;
    wire signed [SCALE_FACTOR_WIDTH-1:0] scale_multiplier_b;
    wire [4:0] scale_multiplier_n;

    wire signed [ARRAY_SIZE*OUTCOME_WIDTH-1:0] scale_multiplier_data_out;

    wire scale_multiplier_valid_out;
    wire [IDX_WIDTH-1:0] scale_multiplier_c_row_idx_out;
    wire [IDX_WIDTH-1:0] scale_multiplier_c_col_idx_out;
    wire scale_multiplier_done_out;
    // ----- end ----- //


    // ----- output_offset_adder ----- //
    wire signed [ARRAY_SIZE*OUTCOME_WIDTH-1:0] output_offset_adder_data_in;
    wire [OFFSET_WIDTH-1:0] output_offset_adder_b;
    wire signed [ARRAY_SIZE*OUTCOME_WIDTH-1:0] output_offset_adder_data_out;
    // ----- end ----- //


    // ----- ReLU_clamping ----- //
    wire signed [ARRAY_SIZE*OUTCOME_WIDTH-1:0] ReLU_clamp_outcome_full;
    wire [ARRAY_SIZE*DATA_WIDTH-1:0] ReLU_clamp_relu_out;  
    // ----- end ----- //


    // ----- addr_converter ----- //
    wire [MNK_IDX_WIDTH-1:0] addr_converter_m;
    wire [MNK_IDX_WIDTH-1:0] addr_converter_n;
    wire [MNK_IDX_WIDTH-1:0] addr_converter_k;
    wire [MNK_IDX_WIDTH-1:0] addr_converter_num_computation;

    wire [IDX_WIDTH-1:0] addr_converter_a_row_idx;
    wire [IDX_WIDTH-1:0] addr_converter_a_col_idx;
    wire [IDX_WIDTH-1:0] addr_converter_b_row_idx;
    wire [IDX_WIDTH-1:0] addr_converter_b_col_idx;
    wire [IDX_WIDTH-1:0] addr_converter_c_row_idx;
    wire [IDX_WIDTH-1:0] addr_converter_c_col_idx;

    wire [SRAM_ADDR_WIDTH-1:0] addr_converter_a_raddr;
    wire [SRAM_ADDR_WIDTH-1:0] addr_converter_b_raddr;
    wire [SRAM_ADDR_WIDTH-1:0] addr_converter_c_waddr;
    // ----- end ----- //


    // ----- input_idx_controller ----- //
    assign input_idx_controller_num_computation = num_computation;
    assign input_idx_controller_m = m;
    assign input_idx_controller_n = n;
    assign input_idx_controller_k = k;

    input_idx_controller input_idx_controller_inst (
        .clk            (clk),
        .rstn           (rstn),
        .tpu_start      (input_idx_controller_tpu_start),

        .num_computation(input_idx_controller_num_computation),

        .m              (input_idx_controller_m),
        .n              (input_idx_controller_n),
        .k              (input_idx_controller_k),

        .a_row_idx      (input_idx_controller_a_row_idx),
        .a_col_idx      (input_idx_controller_a_col_idx),
        .b_row_idx      (input_idx_controller_b_row_idx),
        .b_col_idx      (input_idx_controller_b_col_idx),

        .alu_start      (input_idx_controller_alu_start),
        .sram_rd_en     (input_idx_controller_sram_rd_en),
        .done           (input_idx_controller_done)
    );

    assign a_b_sram_rd_en = input_idx_controller_sram_rd_en;
    // ----- end ----- //


    // ----- systolic_array_wrapper ----- //
    assign systolic_array_wrapper_alu_start = (input_idx_controller_alu_start && !output_idx_controller_done_flag);
    assign systolic_array_wrapper_all_input_are_fed = input_idx_controller_done;
    assign systolic_array_wrapper_keep_pe_value = keep_pe_value;
    assign systolic_array_wrapper_tile_num = n - {{(MNK_IDX_WIDTH-1){1'b0}}, 1'b1};

    assign systolic_array_wrapper_sram_rdata_a0 = sram_rdata_a[SRAM_DATA_WIDTH-1:SRAM_DATA_WIDTH/2];
    assign systolic_array_wrapper_sram_rdata_a1 = sram_rdata_a[SRAM_DATA_WIDTH/2-1:0];

    assign systolic_array_wrapper_sram_rdata_b0 = sram_rdata_b[SRAM_DATA_WIDTH-1:SRAM_DATA_WIDTH/2];
    assign systolic_array_wrapper_sram_rdata_b1 = sram_rdata_b[SRAM_DATA_WIDTH/2-1:0];

    assign systolic_array_wrapper_zero_point_a = zero_point_a;
    assign systolic_array_wrapper_zero_point_b = zero_point_b;

    systolic_array_wrapper systolic_array_wrapper_inst (
        .clk                (clk),
        .rstn               (rstn),
        .alu_start          (systolic_array_wrapper_alu_start),

        .all_input_are_fed  (systolic_array_wrapper_all_input_are_fed),
        .keep_pe_value      (systolic_array_wrapper_keep_pe_value),
        .tile_num           (systolic_array_wrapper_tile_num[MNK_IDX_WIDTH-2:0]),

        .sram_rdata_a0      (systolic_array_wrapper_sram_rdata_a0),
        .sram_rdata_a1      (systolic_array_wrapper_sram_rdata_a1),

        .sram_rdata_b0      (systolic_array_wrapper_sram_rdata_b0),
        .sram_rdata_b1      (systolic_array_wrapper_sram_rdata_b1),

        .zero_point_a       (systolic_array_wrapper_zero_point_a),
        .zero_point_b       (systolic_array_wrapper_zero_point_b),

        .sram_wdata_c       (systolic_array_wrapper_sram_wdata_c),
        
        .out_ready          (systolic_array_wrapper_out_ready),
        .row_idx            (systolic_array_wrapper_row_idx)
    );
    // ----- end ----- //  


    // ----- output_idx_controller ----- //   
    assign output_idx_controller_alu_init = input_idx_controller_alu_start;
    assign output_idx_controller_in_valid = systolic_array_wrapper_out_ready;

    assign output_idx_controller_row_idx = systolic_array_wrapper_row_idx;
    assign output_idx_controller_num_computation = num_computation;

    assign output_idx_controller_m = m;
    assign output_idx_controller_k = k;

    output_idx_controller output_idx_controller_inst (
        .clk            (clk),
        .rstn           (rstn),
        .alu_init       (output_idx_controller_alu_init),
        .in_valid       (output_idx_controller_in_valid),

        .row_idx        (output_idx_controller_row_idx),

        .num_computation(output_idx_controller_num_computation),

        .m              (output_idx_controller_m),
        .k              (output_idx_controller_k),

        .c_row_idx      (output_idx_controller_c_row_idx),
        .c_col_idx      (output_idx_controller_c_col_idx),

        .done_flag      (output_idx_controller_done_flag)
    );

    assign bias_addr = output_idx_controller_c_row_idx;
    // ----- end ----- //  


    // ----- bias_adder ----- //
    assign bias_adder_alu_start = input_idx_controller_alu_start;

    assign bias_adder_valid_in = systolic_array_wrapper_out_ready;
    assign bias_adder_c_row_idx_in = output_idx_controller_c_row_idx;
    assign bias_adder_c_col_idx_in = output_idx_controller_c_col_idx;
    assign bias_adder_done_in = output_idx_controller_done_flag;

    assign bias_adder_data_in = systolic_array_wrapper_sram_wdata_c;
    assign bias_adder_bias = bias;

    bias_adder bias_adder_inst (
        .clk            (clk),
        .rstn           (rstn),
        .alu_start      (bias_adder_alu_start),

        .valid_in       (bias_adder_valid_in),
        .c_row_idx_in   (bias_adder_c_row_idx_in),
        .c_col_idx_in   (bias_adder_c_col_idx_in),
        .done_in        (bias_adder_done_in),

        .data_in        (bias_adder_data_in),
        .bias           (bias_adder_bias),

        .data_out       (bias_adder_data_out),

        .valid_out      (bias_adder_valid_out),
        .c_row_idx_out  (bias_adder_c_row_idx_out),
        .c_col_idx_out  (bias_adder_c_col_idx_out),
        .done_out       (bias_adder_done_out)
    );

    assign bias_sram_rd_en = systolic_array_wrapper_out_ready;
    // ----- end ----- //


    // ----- scale_multiplier ----- //

    assign scale_multiplier_alu_start = input_idx_controller_alu_start;

    assign scale_multiplier_valid_in = bias_adder_valid_out;
    assign scale_multiplier_c_row_idx_in = bias_adder_c_row_idx_out;
    assign scale_multiplier_c_col_idx_in = bias_adder_c_col_idx_out;
    assign scale_multiplier_done_in = bias_adder_done_out;

    assign scale_multiplier_data_in = bias_adder_data_out;
    assign scale_multiplier_b = scale_factor;
    assign scale_multiplier_n = scale_shift;

    scale_multiplier scale_multiplier_inst (
        .clk            (clk),
        .rstn           (rstn),
        .alu_start      (scale_multiplier_alu_start),

        .valid_in       (scale_multiplier_valid_in),
        .c_row_idx_in   (scale_multiplier_c_row_idx_in),
        .c_col_idx_in   (scale_multiplier_c_col_idx_in),
        .done_in        (scale_multiplier_done_in),

        .data_in        (scale_multiplier_data_in),
        .b              (scale_multiplier_b),
        .n              (scale_multiplier_n),

        .data_out       (scale_multiplier_data_out),

        .valid_out      (scale_multiplier_valid_out),
        .c_row_idx_out  (scale_multiplier_c_row_idx_out),
        .c_col_idx_out  (scale_multiplier_c_col_idx_out),
        .done_out       (scale_multiplier_done_out)
    );

    assign TEST_c_sram_w_en_TEST = scale_multiplier_valid_out; // TEST

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            done_flag <= 1'b0;
            c_sram_w_en <= 1'b0;
        end
        else begin
            done_flag <= scale_multiplier_done_out;
            c_sram_w_en <= scale_multiplier_valid_out;
        end
    end
    // ----- end ----- //


    // ----- output_offset_adder ----- //
    assign output_offset_adder_data_in = scale_multiplier_data_out;
    assign output_offset_adder_b = zero_point_c;

    output_offset_adder output_offset_adder_inst (
        .data_in    (output_offset_adder_data_in),
        .b          (output_offset_adder_b),
        .data_out   (output_offset_adder_data_out)
    );
    // ----- end ----- //



    // ----- ReLU_clamping ----- //
    assign ReLU_clamp_outcome_full = output_offset_adder_data_out;

    ReLU_clamp ReLU_clamp_inst(
        .outcome_full (ReLU_clamp_outcome_full),
        .relu_out     (ReLU_clamp_relu_out)
    );

    assign TEST_outcome_full_TEST = output_offset_adder_data_out; // TEST

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            outcome_quantized <= {(ARRAY_SIZE*DATA_WIDTH){1'b0}};
        end
        else begin
            outcome_quantized <= ReLU_clamp_relu_out;
        end
    end
    // ----- end ----- //



    // ----- addr_converter ----- //
    assign addr_converter_m = m;
    assign addr_converter_n = n;
    assign addr_converter_k = k;
    assign addr_converter_num_computation = num_computation;

    assign addr_converter_a_row_idx = input_idx_controller_a_row_idx;
    assign addr_converter_a_col_idx = input_idx_controller_a_col_idx;
    assign addr_converter_b_row_idx = input_idx_controller_b_row_idx;
    assign addr_converter_b_col_idx = input_idx_controller_b_col_idx;
    assign addr_converter_c_row_idx = scale_multiplier_c_row_idx_out;
    assign addr_converter_c_col_idx = scale_multiplier_c_col_idx_out;

    addr_converter addr_converter_inst(
        .m                  (addr_converter_m),
        .n                  (addr_converter_n),
        .k                  (addr_converter_k),
        .num_computation    (addr_converter_num_computation),

        .a_row_idx          (addr_converter_a_row_idx),
        .a_col_idx          (addr_converter_a_col_idx),
        .b_row_idx          (addr_converter_b_row_idx),
        .b_col_idx          (addr_converter_b_col_idx),
        .c_row_idx          (addr_converter_c_row_idx),
        .c_col_idx          (addr_converter_c_col_idx),

        .a_raddr            (addr_converter_a_raddr),
        .b_raddr            (addr_converter_b_raddr),
        .c_waddr            (addr_converter_c_waddr)
    );

    assign a_raddr = addr_converter_a_raddr;
    assign b_raddr = addr_converter_b_raddr;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            c_waddr <= {SRAM_ADDR_WIDTH{1'b0}};
        end
        else begin
            c_waddr <= addr_converter_c_waddr;
        end
    end

    assign TEST_c_row_idx_TEST = scale_multiplier_c_row_idx_out; // TEST
    assign TEST_c_col_idx_TEST = scale_multiplier_c_col_idx_out; // TEST
    // ----- end ----- //

endmodule