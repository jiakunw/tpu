module output_idx_controller #(
    parameter   MAX_TILE = 64,
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1,
    parameter   BIG_MNK_IDX_WIDTH = MNK_IDX_WIDTH + 3,
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2
)(
    input   wire clk,
    input   wire rstn,
    input   wire alu_init,
    input   wire in_valid,

    input   wire [2:0] row_idx,
    input   wire [MNK_IDX_WIDTH-1:0] num_computation,

    input   wire [MNK_IDX_WIDTH-1:0]  m,
    input   wire [MNK_IDX_WIDTH-1:0]  k,

    output  wire [IDX_WIDTH-1:0] c_row_idx,
    output  wire [IDX_WIDTH-1:0] c_col_idx,

    output  reg  done_flag
);

    wire [BIG_MNK_IDX_WIDTH-1:0] big_k = {k, 3'b000};

    wire [IDX_WIDTH-1:0] c_col_idx_temp;
    reg  [IDX_WIDTH-1:0] c_col_os;

    reg  [MNK_IDX_WIDTH-1:0] num_computated;

    wire done_temp, done_pulse;

    assign done_pulse = alu_init && done_temp && (num_computated == (num_computation - {{(MNK_IDX_WIDTH-1){1'b0}}, 1'b1}));

    assign c_col_idx = c_col_idx_temp + c_col_os;

    always @(posedge clk) begin
        if(!rstn) begin
            done_flag <= 1'b0;
        end 
        else if(done_pulse) begin
            done_flag <= 1'b1;
        end
    end

    out_ac_mode_controller u_out_ac (
        .clk(clk),
        .rstn(rstn),
        .alu_init(alu_init),
        .in_valid(in_valid),

        .row_idx(row_idx),

        .m(m),
        .k(k),

        .c_row_idx(c_row_idx),
        .c_col_idx(c_col_idx_temp),

        .done(done_temp)
    );

    wire advance = alu_init && done_temp && (num_computated != (num_computation - {{(MNK_IDX_WIDTH-1){1'b0}}, 1'b1}));

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            c_col_os <= {IDX_WIDTH{1'b0}};
            num_computated <= {MNK_IDX_WIDTH{1'b0}};
        end 
        else if(advance) begin
            c_col_os <= c_col_os + big_k[IDX_WIDTH-1:0];
            num_computated <= num_computated + {{(MNK_IDX_WIDTH-1){1'b0}}, 1'b1};
        end
    end

endmodule