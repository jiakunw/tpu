module scale_multiplier_32x16 (
    input  wire signed  [31:0] a,          // INT 32
    input  wire         [15:0] b,          // UINT 16 Q0.16
    input  wire         [4:0]  n,          // 16+n <= 47
    output wire signed  [32:0] result      // INT 33
);

    wire signed [47:0] a_ext = {{16{a[31]}}, a};
    wire signed [47:0] b_ext = {{32{1'b0}}, b};

    wire signed [47:0] full_prod = a_ext * b_ext;

    wire [5:0] shift = 6'd16 + {1'b0, n};

    wire [47:0] half = (48'd1 << (shift - 1)) - {47'b0, full_prod[47]};

    wire signed [48:0] round_prod = $signed({full_prod[47], full_prod}) + $signed({1'b0, half});

    wire signed [48:0] shifted = round_prod >>> shift;

    assign result = shifted[32:0];

endmodule