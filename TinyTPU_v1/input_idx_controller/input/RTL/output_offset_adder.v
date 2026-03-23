module output_offset_adder#(
    parameter ARRAY_SIZE = 8,
    parameter SCALED_DATA_WIDTH = 33,
    parameter OFFSET_DATA_WIDTH = 8
)(
    input  signed [ARRAY_SIZE*SCALED_DATA_WIDTH-1:0] data_in,
    input         [OFFSET_DATA_WIDTH-1:0] b,
    output wire signed [ARRAY_SIZE*SCALED_DATA_WIDTH-1:0] data_out
);

    wire signed [SCALED_DATA_WIDTH-1:0] offset;
    assign offset = {{(SCALED_DATA_WIDTH-OFFSET_DATA_WIDTH){1'b0}}, b};

    genvar k;
    generate
        for (k = 0; k < ARRAY_SIZE; k = k + 1) begin : GEN_ADD
            assign data_out[(k+1)*SCALED_DATA_WIDTH-1 : k*SCALED_DATA_WIDTH] =
                $signed(data_in[(k+1)*SCALED_DATA_WIDTH-1 : k*SCALED_DATA_WIDTH]) + offset;
        end
    endgenerate

endmodule