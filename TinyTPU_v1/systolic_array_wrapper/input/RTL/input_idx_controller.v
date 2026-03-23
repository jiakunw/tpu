module input_idx_controller#(
    parameter   MAX_TILE = 64,
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1,
    parameter   BIG_MNK_IDX_WIDTH = MNK_IDX_WIDTH + 3,
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2
)(
    input  wire clk,
    input  wire rstn,
    input  wire tpu_start,

    input  wire [MNK_IDX_WIDTH-1:0] num_computation,

    input  wire [MNK_IDX_WIDTH-1:0] m,
    input  wire [MNK_IDX_WIDTH-1:0] n,
    input  wire [MNK_IDX_WIDTH-1:0] k,

    output wire [IDX_WIDTH-1:0] a_row_idx,
    output wire [IDX_WIDTH-1:0] a_col_idx,
    output wire [IDX_WIDTH-1:0] b_row_idx,
    output wire [IDX_WIDTH-1:0] b_col_idx,

    output reg  alu_start,
    output wire sram_rd_en,
    output reg  done
);

    wire [BIG_MNK_IDX_WIDTH-1:0] big_n = {n, 3'b000};
    wire [BIG_MNK_IDX_WIDTH-1:0] big_k = {k, 3'b000};

    wire [IDX_WIDTH-1:0] a_row_idx_temp;
    wire [IDX_WIDTH-1:0] b_col_idx_temp;

    reg  [IDX_WIDTH-1:0] a_row_os;
    reg  [IDX_WIDTH-1:0] b_col_os;

    reg  [MNK_IDX_WIDTH-1:0] num_computated;

    wire done_sub_module;
    wire done_temp;

    assign a_row_idx = a_row_idx_temp + a_row_os;
    assign b_col_idx = b_col_idx_temp + b_col_os;

    reg last_data_read;

    // turn off the counter and sram read enable after the last data read request is sent
    always @(posedge clk) begin
        if(!rstn) begin
            last_data_read <= 1'b0;
        end
        else if(done_temp) begin
            last_data_read <= 1'b1;
        end
    end

    assign sram_rd_en = tpu_start && !last_data_read;

    // ----- done, alu_start ----- //
    // ----- are synchronized with data read from the SRAM ----- //

    // done generation
    assign done_temp = tpu_start && done_sub_module && (num_computated == (num_computation - {{(MNK_IDX_WIDTH-1){1'b0}}, 1'b1}));
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn)
            done <= 1'b0;
        else 
            done <= done_temp;
    end

    // alu_start generation
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn)
            alu_start <= 1'b0;
        else
            alu_start <= tpu_start;
    end


    // re-use the ac_mode module for non-ac mode use
    in_ac_mode_controller u_ac (
        .clk(clk),
        .rstn(rstn),
        .en(tpu_start && !last_data_read),

        .m(m),
        .n(n),
        .k(k),

        .a_row_idx(a_row_idx_temp),
        .a_col_idx(a_col_idx),
        .b_row_idx(b_row_idx),
        .b_col_idx(b_col_idx_temp),
        .done(done_sub_module)
    );

    wire advance = tpu_start && done_sub_module && (num_computated != (num_computation - {{(MNK_IDX_WIDTH-1){1'b0}}, 1'b1}));

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            a_row_os       <= {IDX_WIDTH{1'b0}};
            b_col_os       <= {IDX_WIDTH{1'b0}};
            num_computated <= {MNK_IDX_WIDTH{1'b0}};
        end
        else if(advance && !last_data_read) begin
            a_row_os       <= a_row_os + big_n[IDX_WIDTH-1:0];
            b_col_os       <= b_col_os + big_k[IDX_WIDTH-1:0];
            num_computated <= num_computated + {{(MNK_IDX_WIDTH-1){1'b0}}, 1'b1};
        end
    end

endmodule