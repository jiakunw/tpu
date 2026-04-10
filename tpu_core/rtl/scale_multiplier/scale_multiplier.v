module scale_multiplier#(
    parameter   ARRAY_SIZE = 8,
    parameter   OUTPUT_DATA_WIDTH = 32,
    parameter   MAX_NEURON = 256,

    parameter   MAX_TILE = 64,
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1,
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2
)(
    input   clk,
    input   rstn,
    input   alu_start,

    input   valid_in,
    input   [IDX_WIDTH-1:0] c_row_idx_in,
    input   [IDX_WIDTH-1:0] c_col_idx_in,
    input   done_in,

    input signed    [ARRAY_SIZE*OUTPUT_DATA_WIDTH-1:0] data_in,
    input signed    [15:0] b,
    input           [4:0]  n, 

    output reg signed  [ARRAY_SIZE*33-1:0] data_out,

    output reg  valid_out,
    output reg  [IDX_WIDTH-1:0] c_row_idx_out,
    output reg  [IDX_WIDTH-1:0] c_col_idx_out,
    output reg  done_out
);

    wire signed [32:0] scaled_data [ARRAY_SIZE-1:0];

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            valid_out <= 1'b0;
            c_row_idx_out <= {IDX_WIDTH{1'b0}};
            c_col_idx_out <= {IDX_WIDTH{1'b0}};
            done_out <= 1'b0;
        end
        else if(alu_start) begin
            valid_out <= valid_in;
            c_row_idx_out <= c_row_idx_in;
            c_col_idx_out <= c_col_idx_in;
            done_out <= done_in;
        end
    end
    
    genvar k;
    generate
        for(k=0; k<ARRAY_SIZE; k=k+1) begin : GEN_SCALE
            scale_multiplier_32x16 u_scale (
                .a(data_in[OUTPUT_DATA_WIDTH*(ARRAY_SIZE-1-k) +: OUTPUT_DATA_WIDTH]),
                .b(b),
                .n(n),
                .result(scaled_data[k])
            );
        end
    endgenerate

    always @(posedge clk) begin
        if(!rstn) begin
            data_out <= {(ARRAY_SIZE*33){1'b0}};
        end
        else if(alu_start) begin
            data_out <= {scaled_data[0], scaled_data[1], scaled_data[2], scaled_data[3], 
                         scaled_data[4], scaled_data[5], scaled_data[6], scaled_data[7]};
        end
    end

endmodule
