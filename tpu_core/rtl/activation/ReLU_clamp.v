module ReLU_clamp #(
    parameter   ARRAY_SIZE = 8,
    parameter   OUTCOME_WIDTH = 33,
    parameter   QUANTIZED_WIDTH = 8
)(
    input signed    [ARRAY_SIZE*OUTCOME_WIDTH-1:0] outcome_full,
    output          [ARRAY_SIZE*QUANTIZED_WIDTH-1:0] relu_out
);

    wire signed [OUTCOME_WIDTH-1:0] in_val [ARRAY_SIZE-1:0];
    reg        [QUANTIZED_WIDTH-1:0] out_val [ARRAY_SIZE-1:0];

    genvar k;
    generate
        for (k = 0; k < ARRAY_SIZE; k = k + 1) begin : relu_gen

            assign in_val[k] = outcome_full[(k+1)*OUTCOME_WIDTH-1 : k*OUTCOME_WIDTH];

            always @(*) begin
                if (in_val[k] < 0) begin
                    out_val[k] = {QUANTIZED_WIDTH{1'b0}};
                end
                else if (in_val[k] > $signed(33'd255)) begin
                    out_val[k] = 8'd255;
                end
                else begin
                    out_val[k] = in_val[k][QUANTIZED_WIDTH-1:0];
                end
            end

            assign relu_out[(k+1)*QUANTIZED_WIDTH-1 : k*QUANTIZED_WIDTH] = out_val[k];

        end
    endgenerate

endmodule