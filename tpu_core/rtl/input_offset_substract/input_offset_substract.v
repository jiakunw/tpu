module input_offset_substract #(
    parameter   INPUT_WIDTH  = 8,
    parameter   OUTPUT_WIDTH = 9
)(
    input  wire [4*INPUT_WIDTH-1:0]  uint8_a0,
    input  wire [4*INPUT_WIDTH-1:0]  uint8_a1,
    input  wire [4*INPUT_WIDTH-1:0]  uint8_b0,
    input  wire [4*INPUT_WIDTH-1:0]  uint8_b1,
    input  wire [INPUT_WIDTH-1:0]    zero_point_a,
    input  wire [INPUT_WIDTH-1:0]    zero_point_b,

    output wire [4*OUTPUT_WIDTH-1:0] int9_a0,
    output wire [4*OUTPUT_WIDTH-1:0] int9_a1,
    output wire [4*OUTPUT_WIDTH-1:0] int9_b0,
    output wire [4*OUTPUT_WIDTH-1:0] int9_b1
);

    // zero-points extended to OUTPUT_WIDTH (signed)
    wire signed [OUTPUT_WIDTH-1:0] zp_a_s = $signed({1'b0, zero_point_a});
    wire signed [OUTPUT_WIDTH-1:0] zp_b_s = $signed({1'b0, zero_point_b});

    genvar k;
    generate
        for (k=0; k<4; k=k+1) begin : GEN_ZP_SUB
            // MSB-first lane extract: [31:24],[23:16],[15:8],[7:0] when INPUT_WIDTH=8
            wire [INPUT_WIDTH-1:0] a0_u = uint8_a0[4*INPUT_WIDTH-1 - INPUT_WIDTH*k -: INPUT_WIDTH];
            wire [INPUT_WIDTH-1:0] a1_u = uint8_a1[4*INPUT_WIDTH-1 - INPUT_WIDTH*k -: INPUT_WIDTH];
            wire [INPUT_WIDTH-1:0] b0_u = uint8_b0[4*INPUT_WIDTH-1 - INPUT_WIDTH*k -: INPUT_WIDTH];
            wire [INPUT_WIDTH-1:0] b1_u = uint8_b1[4*INPUT_WIDTH-1 - INPUT_WIDTH*k -: INPUT_WIDTH];

            wire signed [OUTPUT_WIDTH-1:0] a0_s = $signed({1'b0, a0_u}) - zp_a_s;
            wire signed [OUTPUT_WIDTH-1:0] a1_s = $signed({1'b0, a1_u}) - zp_a_s;
            wire signed [OUTPUT_WIDTH-1:0] b0_s = $signed({1'b0, b0_u}) - zp_b_s;
            wire signed [OUTPUT_WIDTH-1:0] b1_s = $signed({1'b0, b1_u}) - zp_b_s;

            // Pack back MSB-first into 4*OUTPUT_WIDTH
            assign int9_a0[OUTPUT_WIDTH*(4-1-k) +: OUTPUT_WIDTH] = a0_s;
            assign int9_a1[OUTPUT_WIDTH*(4-1-k) +: OUTPUT_WIDTH] = a1_s;
            assign int9_b0[OUTPUT_WIDTH*(4-1-k) +: OUTPUT_WIDTH] = b0_s;
            assign int9_b1[OUTPUT_WIDTH*(4-1-k) +: OUTPUT_WIDTH] = b1_s;
        end
    endgenerate

endmodule