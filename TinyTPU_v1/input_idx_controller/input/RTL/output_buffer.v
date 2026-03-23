module output_buffer#(
    parameter ARRAY_SIZE = 8,
    parameter OUTPUT_DATA_WIDTH = 32
)
(
    input           clk,
    input           rstn,
    input           alu_start,
    input           input_valid,
    input [3:0]     matrix_index,

    input [ARRAY_SIZE*OUTPUT_DATA_WIDTH-1:0]        mul_outcome,

    output wire [ARRAY_SIZE*OUTPUT_DATA_WIDTH-1:0]  sram_wdata,

    output wire         out_valid,
    output wire [2:0]   row_idx //0-7 rows
);

    reg [OUTPUT_DATA_WIDTH-1 : 0] pipe_0 [0:6];
    reg [OUTPUT_DATA_WIDTH-1 : 0] pipe_1 [0:5];
    reg [OUTPUT_DATA_WIDTH-1 : 0] pipe_2 [0:4];
    reg [OUTPUT_DATA_WIDTH-1 : 0] pipe_3 [0:3];
    reg [OUTPUT_DATA_WIDTH-1 : 0] pipe_4 [0:2];
    reg [OUTPUT_DATA_WIDTH-1 : 0] pipe_5 [0:1];
    reg [OUTPUT_DATA_WIDTH-1 : 0] pipe_6;

    reg out_valid_pipe [0:6];

    wire [4:0] matrix_index_extend = {1'b0, matrix_index} + 5'd1;
    wire [4:0] row_idx_full = matrix_index_extend % 5'd8;

    assign sram_wdata = {pipe_0[6], pipe_1[5], pipe_2[4], pipe_3[3], pipe_4[2], pipe_5[1], pipe_6, mul_outcome[OUTPUT_DATA_WIDTH-1:0]};
    assign out_valid = out_valid_pipe[6] && input_valid;
    assign row_idx = row_idx_full[2:0];
    wire frame_end = ((matrix_index==4'hf) && (input_valid==0));

    integer k;

    // synopsys sync_set_reset rstn
    always @(posedge clk) begin
        if(!rstn) begin
            for(k=0;k<7;k=k+1) out_valid_pipe[k] <= 1'b0;
        end
        else if(alu_start) begin
            if(input_valid) begin
                for(k=1;k<7;k=k+1) out_valid_pipe[k] <= out_valid_pipe[k-1];
                out_valid_pipe[0] <= input_valid;
            end
            else if(frame_end) begin
                for(k=0;k<7;k=k+1) out_valid_pipe[k] <= 1'b0;
            end
        end
    end

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(~rstn) begin
            for(k=0;k<7;k=k+1) pipe_0[k] <= {OUTPUT_DATA_WIDTH{1'b0}};
            for(k=0;k<6;k=k+1) pipe_1[k] <= {OUTPUT_DATA_WIDTH{1'b0}};
            for(k=0;k<5;k=k+1) pipe_2[k] <= {OUTPUT_DATA_WIDTH{1'b0}};
            for(k=0;k<4;k=k+1) pipe_3[k] <= {OUTPUT_DATA_WIDTH{1'b0}};
            for(k=0;k<3;k=k+1) pipe_4[k] <= {OUTPUT_DATA_WIDTH{1'b0}};
            for(k=0;k<2;k=k+1) pipe_5[k] <= {OUTPUT_DATA_WIDTH{1'b0}};
            pipe_6 <= {OUTPUT_DATA_WIDTH{1'b0}};
        end
        else if(input_valid && alu_start) begin
            for(k=1;k<7;k=k+1) pipe_0[k] <= pipe_0[k-1];
            for(k=1;k<6;k=k+1) pipe_1[k] <= pipe_1[k-1];
            for(k=1;k<5;k=k+1) pipe_2[k] <= pipe_2[k-1];
            for(k=1;k<4;k=k+1) pipe_3[k] <= pipe_3[k-1];
            for(k=1;k<3;k=k+1) pipe_4[k] <= pipe_4[k-1];
            for(k=1;k<2;k=k+1) pipe_5[k] <= pipe_5[k-1];

            pipe_0[0] <= mul_outcome[ARRAY_SIZE*OUTPUT_DATA_WIDTH-1 -: OUTPUT_DATA_WIDTH];
            pipe_1[0] <= mul_outcome[ARRAY_SIZE*OUTPUT_DATA_WIDTH-1 -OUTPUT_DATA_WIDTH -: OUTPUT_DATA_WIDTH];
            pipe_2[0] <= mul_outcome[ARRAY_SIZE*OUTPUT_DATA_WIDTH-1 -OUTPUT_DATA_WIDTH*2 -: OUTPUT_DATA_WIDTH];
            pipe_3[0] <= mul_outcome[ARRAY_SIZE*OUTPUT_DATA_WIDTH-1 -OUTPUT_DATA_WIDTH*3 -: OUTPUT_DATA_WIDTH];
            pipe_4[0] <= mul_outcome[ARRAY_SIZE*OUTPUT_DATA_WIDTH-1 -OUTPUT_DATA_WIDTH*4 -: OUTPUT_DATA_WIDTH];
            pipe_5[0] <= mul_outcome[ARRAY_SIZE*OUTPUT_DATA_WIDTH-1 -OUTPUT_DATA_WIDTH*5 -: OUTPUT_DATA_WIDTH];
            pipe_6 <= mul_outcome[ARRAY_SIZE*OUTPUT_DATA_WIDTH-1 -OUTPUT_DATA_WIDTH*6 -: OUTPUT_DATA_WIDTH];
        end
    end

endmodule