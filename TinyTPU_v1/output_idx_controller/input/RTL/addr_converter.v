module addr_converter #(
    parameter   MAX_TILE = 64,
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1,
    parameter   BIG_MNK_IDX_WIDTH = MNK_IDX_WIDTH + 3,
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2,
    parameter   SRAM_ADDR_WIDTH = 9

)(
    input   [MNK_IDX_WIDTH-1:0] m,
    input   [MNK_IDX_WIDTH-1:0] n,
    input   [MNK_IDX_WIDTH-1:0] k,
    input   [MNK_IDX_WIDTH-1:0] num_computation,

    input   [IDX_WIDTH-1:0] a_row_idx,
    input   [IDX_WIDTH-1:0] a_col_idx,
    input   [IDX_WIDTH-1:0] b_row_idx,
    input   [IDX_WIDTH-1:0] b_col_idx,
    input   [IDX_WIDTH-1:0] c_row_idx,
    input   [IDX_WIDTH-1:0] c_col_idx,

    output  [SRAM_ADDR_WIDTH-1:0] a_raddr,
    output  [SRAM_ADDR_WIDTH-1:0] b_raddr,
    output  [SRAM_ADDR_WIDTH-1:0] c_waddr
);

    // ----- A SRAM address calculation ----- //
    wire [11:0] a_row_idx_ext = {{(12-IDX_WIDTH){1'b0}}, a_row_idx};
    wire [11:0] m_ext         = {{(12-MNK_IDX_WIDTH){1'b0}}, m};
    wire [11:0] a_col_idx_ext = {{(12-IDX_WIDTH){1'b0}}, a_col_idx};

    wire [11:0] a_addr_step1 = a_row_idx_ext * m_ext * 12'd8 + a_col_idx_ext;
    wire [11:0] a_addr_step2 = a_addr_step1 >> 3;
    assign a_raddr = a_addr_step2 [SRAM_ADDR_WIDTH-1:0];



    // ----- B SRAM address calculation ----- //
    wire [11:0] b_row_idx_ext = {{(12-IDX_WIDTH){1'b0}}, b_row_idx};
    wire [11:0] k_ext         = {{(12-MNK_IDX_WIDTH){1'b0}}, k};
    wire [11:0] num_comp_ext  = {{(12-MNK_IDX_WIDTH){1'b0}}, num_computation};
    wire [11:0] b_col_idx_ext = {{(12-IDX_WIDTH){1'b0}}, b_col_idx};

    wire [11:0] b_addr_step1 = b_row_idx_ext * k_ext * 12'd8 * num_comp_ext + b_col_idx_ext;
    wire [11:0] b_addr_step2 = b_addr_step1 >> 3;
    assign b_raddr = b_addr_step2 [SRAM_ADDR_WIDTH-1:0];


    // ----- C SRAM address calculation ----- //
    wire [11:0] c_row_idx_ext = {{(12-IDX_WIDTH){1'b0}}, c_row_idx};
    wire [11:0] c_col_idx_ext = {{(12-IDX_WIDTH){1'b0}}, c_col_idx};

    wire [11:0] c_addr_step1 = c_row_idx_ext * k_ext * 12'd8 * num_comp_ext + c_col_idx_ext;
    wire [11:0] c_addr_step2 = c_addr_step1 >> 3;
    assign c_waddr = c_addr_step2 [SRAM_ADDR_WIDTH-1:0];
    

endmodule