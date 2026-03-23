module out_ac_mode_controller#(
    parameter   MAX_TILE = 64,
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1,
    parameter   BIG_MNK_IDX_WIDTH = MNK_IDX_WIDTH + 3,
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2
)(
    input wire clk,
    input wire rstn,
    input wire alu_init,
    input wire in_valid,

    input wire [2:0] row_idx,

    input  wire [MNK_IDX_WIDTH-1:0]  m,
    input  wire [MNK_IDX_WIDTH-1:0]  k,

    output wire [IDX_WIDTH-1:0] c_row_idx,
    output wire [IDX_WIDTH-1:0] c_col_idx,

    output wire done
);
    reg  [IDX_WIDTH-1:0] i, j;
    reg  [IDX_WIDTH-1:0] i_nx, j_nx;

    wire [BIG_MNK_IDX_WIDTH-1:0] big_m = {m, 3'b000};
    wire [BIG_MNK_IDX_WIDTH-1:0] big_k = {k, 3'b000};

    wire i_last = ({1'b0, i} == (big_m - {{(BIG_MNK_IDX_WIDTH-4){1'b0}}, 4'd8}));
    wire j_last = ({1'b0, j} == (big_k - {{(BIG_MNK_IDX_WIDTH-4){1'b0}}, 4'd8}));

    assign done = alu_init && i_last && j_last && in_valid && (row_idx == 3'd7);

    assign c_row_idx = i + {{(IDX_WIDTH-3){1'b0}}, row_idx};
    assign c_col_idx = j;

    wire advanced = alu_init && in_valid && (row_idx==3'd7);

    always @(*) begin
        if(j_last) j_nx = {IDX_WIDTH{1'b0}};
        else       j_nx = j + {{(IDX_WIDTH-4){1'b0}}, 4'd8};
    end
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn)      j <= {IDX_WIDTH{1'b0}};
        else if(advanced) j <= j_nx;
    end

    always @(*) begin
        if(i_last) i_nx = {IDX_WIDTH{1'b0}};
        else       i_nx = i + {{(IDX_WIDTH-4){1'b0}}, 4'd8};
    end
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn)           i <= {IDX_WIDTH{1'b0}};
        else if(advanced && j_last) i <= i_nx;
    end

endmodule