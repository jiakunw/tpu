module systolic_array_wrapper #(
    parameter   ARRAY_SIZE      = 8,
    parameter   SRAM_DATA_WIDTH  = 32,
    parameter   OUTCOME_WIDTH    = 32,

    parameter   DATA_WIDTH = 8,
    parameter   SYSTOLIC_ARRAY_DATA_WIDTH = 9
)(
    input   clk,
    input   rstn,
    input   alu_start,

    input   all_input_are_fed,
    input   keep_pe_value,
    input   [5:0] tile_num,

    input   [SRAM_DATA_WIDTH-1:0] sram_rdata_a0,
    input   [SRAM_DATA_WIDTH-1:0] sram_rdata_a1,

    input   [SRAM_DATA_WIDTH-1:0] sram_rdata_b0,
    input   [SRAM_DATA_WIDTH-1:0] sram_rdata_b1,

    input   [DATA_WIDTH-1:0] zero_point_a,
    input   [DATA_WIDTH-1:0] zero_point_b,

    output  [ARRAY_SIZE*OUTCOME_WIDTH-1:0] sram_wdata_c,

    output  out_ready,
    output  [2:0] row_idx
);

    wire [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] systolic_a0, systolic_a1;
    wire [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] systolic_b0, systolic_b1;


    reg  [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] a0_buffer;
    wire [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] substracted_a0;

    reg  [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] a1_buffer;
    wire [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] substracted_a1;
    
    reg  [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] b0_buffer;
    wire [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] substracted_b0;

    reg  [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] b1_buffer;
    wire [4*SYSTOLIC_ARRAY_DATA_WIDTH-1:0] substracted_b1;


    wire [ARRAY_SIZE*OUTCOME_WIDTH-1:0] mul_outcome;
    wire array_out_valid;
    wire [3:0] matrix_index;

    reg hold;
    reg [15:0] cycle_num;

    // ***** cycle number generator ***** //
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            cycle_num    <= 16'd0;
        end 
        else if(alu_start) begin
            cycle_num    <= cycle_num + 16'd1;    
        end
    end

    // ***** input MUX ***** //
    //synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn)
            hold <= 1'b0;
        else if(alu_start && all_input_are_fed)
            hold <= 1'b1;
    end

    always @(*) begin
        if (hold) begin
            a0_buffer = { (4*SYSTOLIC_ARRAY_DATA_WIDTH){1'b0} };
            a1_buffer = { (4*SYSTOLIC_ARRAY_DATA_WIDTH){1'b0} };
            b0_buffer = { (4*SYSTOLIC_ARRAY_DATA_WIDTH){1'b0} };
            b1_buffer = { (4*SYSTOLIC_ARRAY_DATA_WIDTH){1'b0} };
        end 
        else begin
            a0_buffer = substracted_a0;
            a1_buffer = substracted_a1;
            b0_buffer = substracted_b0;
            b1_buffer = substracted_b1;
        end
    end

    // ***** systolic core ***** //
    systolic_array_8X8 systolic_array_8X8 (
        .clk(clk),
        .rstn(rstn),
        .alu_start(alu_start),

        .keep_pe_value(keep_pe_value),
        .cycle_num(cycle_num),
        .tile_num(tile_num),

        .rdata_a0(systolic_a0),
        .rdata_a1(systolic_a1),

        .rdata_b0(systolic_b0),
        .rdata_b1(systolic_b1),

        .matrix_index(matrix_index),
        .out_valid(array_out_valid),
        .mul_outcome(mul_outcome)
    );

    // ***** input offset substractor ***** //
    input_offset_substract input_offset_substract (
        .uint8_a0(sram_rdata_a0),
        .uint8_a1(sram_rdata_a1),
        .uint8_b0(sram_rdata_b0),
        .uint8_b1(sram_rdata_b1),
        .zero_point_a(zero_point_a),
        .zero_point_b(zero_point_b),

        .int9_a0(substracted_a0),
        .int9_a1(substracted_a1),
        .int9_b0(substracted_b0),
        .int9_b1(substracted_b1)
    );

    // ***** a_buffer ***** //
    input_buffer a_buffer (
        .clk(clk),
        .rstn(rstn),
        .alu_start(alu_start),

        .data0(a0_buffer),
        .data1(a1_buffer),
        .systolic_data0(systolic_a0),
        .systolic_data1(systolic_a1)
    );

    // ***** b_buffer ***** //
    input_buffer b_buffer (
        .clk(clk),
        .rstn(rstn),
        .alu_start(alu_start),

        .data0(b0_buffer),
        .data1(b1_buffer),
        .systolic_data0(systolic_b0),
        .systolic_data1(systolic_b1)
    );

    // ***** output_buffer ***** //
    output_buffer output_buffer (
        .clk(clk),
        .rstn(rstn),
        .alu_start(alu_start),
        .input_valid(array_out_valid),
        .matrix_index(matrix_index),
        .mul_outcome(mul_outcome),
        .sram_wdata(sram_wdata_c),
        .out_valid(out_ready),
        .row_idx(row_idx)
    );

endmodule