module in_ac_mode_controller #(
    parameter   MAX_TILE = 64,
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1,
    parameter   BIG_MNK_IDX_WIDTH = MNK_IDX_WIDTH + 3,
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2
)(
    input  wire                      clk,
    input  wire                      rstn,
    input  wire                      en,

    input  wire [MNK_IDX_WIDTH-1:0]  m,
    input  wire [MNK_IDX_WIDTH-1:0]  n,
    input  wire [MNK_IDX_WIDTH-1:0]  k,

    output wire [IDX_WIDTH-1:0]      a_row_idx,
    output wire [IDX_WIDTH-1:0]      a_col_idx,
    output wire [IDX_WIDTH-1:0]      b_row_idx,
    output wire [IDX_WIDTH-1:0]      b_col_idx,

    output wire                      done
);

    wire [BIG_MNK_IDX_WIDTH-1:0] big_m = {m, 3'b000}; // multiply by 8
    wire [BIG_MNK_IDX_WIDTH-1:0] big_n = {n, 3'b000};
    wire [BIG_MNK_IDX_WIDTH-1:0] big_k = {k, 3'b000};

    reg  [IDX_WIDTH-1:0] i, j, z;
    reg  [IDX_WIDTH-1:0] i_nx, j_nx, z_nx;
    
    wire z_last = ({1'b0, z} == (big_n - {{(BIG_MNK_IDX_WIDTH-1){1'b0}}, 1'b1}));
    wire j_last = ({1'b0, j} == (big_k - {{(BIG_MNK_IDX_WIDTH-4){1'b0}}, 4'd8}));
    wire i_last = ({1'b0, i} == (big_m - {{(BIG_MNK_IDX_WIDTH-4){1'b0}}, 4'd8}));

    assign done = en & i_last & j_last & z_last;

    assign a_row_idx = z;
    assign b_row_idx = z;
    assign a_col_idx = i;
    assign b_col_idx = j;


    // z loop
    always @(*) begin
        if (z_last) z_nx = {IDX_WIDTH{1'b0}};
        else        z_nx = z + {{(IDX_WIDTH-1){1'b0}}, 1'b1};
    end
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn)      z <= {IDX_WIDTH{1'b0}};
        else if (en)    z <= z_nx;
    end


    // j loop
    always @(*) begin
        if (j_last) j_nx = {IDX_WIDTH{1'b0}};
        else        j_nx = j + {{(IDX_WIDTH-4){1'b0}}, 4'd8};
    end
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn)              j <= {IDX_WIDTH{1'b0}};
        else if (en && z_last)  j <= j_nx;
    end


    // i loop
    always @(*) begin
        if (i_last) i_nx = {IDX_WIDTH{1'b0}};
        else        i_nx = i + {{(IDX_WIDTH-4){1'b0}}, 4'd8};
    end
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn)                      i <= {IDX_WIDTH{1'b0}};
        else if (en && z_last && j_last) i <= i_nx;
    end

endmodule