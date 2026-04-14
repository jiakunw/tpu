module bias_adder#(
    parameter   ARRAY_SIZE = 8,
    parameter   OUTPUT_DATA_WIDTH = 32,
    parameter   MAX_NEURON = 256,

    parameter   MAX_TILE = 64,
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1,
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2,

    parameter   SRAM_ADDR_WIDTH = 9
)(
    input   clk,
    input   rstn,
    input   alu_start,

    input   valid_in,
    input   [IDX_WIDTH-1:0] c_row_idx_in,
    input   [IDX_WIDTH-1:0] c_col_idx_in,
    input   done_in,

    input signed    [ARRAY_SIZE*OUTPUT_DATA_WIDTH-1:0] data_in,
    input signed    [OUTPUT_DATA_WIDTH-1:0] bias,

    output reg signed   [ARRAY_SIZE*OUTPUT_DATA_WIDTH-1:0] data_out,

    output      bias_sram_rd_en,
    output      [SRAM_ADDR_WIDTH-1:0] bias_sram_rd_addr,

    output reg  valid_out,
    output reg  [IDX_WIDTH-1:0] c_row_idx_out,
    output reg  [IDX_WIDTH-1:0] c_col_idx_out,
    output reg  done_out
);

    // stage 1
    reg signed  [ARRAY_SIZE*OUTPUT_DATA_WIDTH-1:0] data_in_d1;
    reg valid_d1;
    reg [IDX_WIDTH-1:0] c_row_idx_d1;
    reg [IDX_WIDTH-1:0] c_col_idx_d1;
    reg done_d1;

    // stage 2
    reg signed  [ARRAY_SIZE*OUTPUT_DATA_WIDTH-1:0] data_in_d2;
    reg valid_d2;
    reg [IDX_WIDTH-1:0] c_row_idx_d2;
    reg [IDX_WIDTH-1:0] c_col_idx_d2;
    reg done_d2;

    // combinational add after 2-cycle delay
    wire signed [ARRAY_SIZE*OUTPUT_DATA_WIDTH-1:0] sum;

    assign bias_sram_rd_en = valid_d1;
    assign bias_sram_rd_addr = c_row_idx_d1;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            data_in_d1   <= $signed({(ARRAY_SIZE*OUTPUT_DATA_WIDTH){1'b0}});
            valid_d1     <= 1'b0;
            c_row_idx_d1 <= {IDX_WIDTH{1'b0}};
            c_col_idx_d1 <= {IDX_WIDTH{1'b0}};
            done_d1      <= 1'b0;

            data_in_d2   <= $signed({(ARRAY_SIZE*OUTPUT_DATA_WIDTH){1'b0}});
            valid_d2     <= 1'b0;
            c_row_idx_d2 <= {IDX_WIDTH{1'b0}};
            c_col_idx_d2 <= {IDX_WIDTH{1'b0}};
            done_d2      <= 1'b0;
        end
        else if(alu_start) begin
            // stage 1
            data_in_d1   <= data_in;
            valid_d1     <= valid_in;
            c_row_idx_d1 <= c_row_idx_in;
            c_col_idx_d1 <= c_col_idx_in;
            done_d1      <= done_in;

            // stage 2
            data_in_d2   <= data_in_d1;
            valid_d2     <= valid_d1;
            c_row_idx_d2 <= c_row_idx_d1;
            c_col_idx_d2 <= c_col_idx_d1;
            done_d2      <= done_d1;
        end
    end

    genvar k;
    generate
        for(k=0; k<ARRAY_SIZE; k=k+1) begin : GEN_BIAS_ADD
            assign sum[(k+1)*OUTPUT_DATA_WIDTH-1:k*OUTPUT_DATA_WIDTH] =
                $signed(data_in_d2[(k+1)*OUTPUT_DATA_WIDTH-1:k*OUTPUT_DATA_WIDTH]) + bias;
        end
    endgenerate

    // output register: 1 more cycle after bias add
    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(!rstn) begin
            data_out      <= $signed({(ARRAY_SIZE*OUTPUT_DATA_WIDTH){1'b0}});
            valid_out     <= 1'b0;
            c_row_idx_out <= {IDX_WIDTH{1'b0}};
            c_col_idx_out <= {IDX_WIDTH{1'b0}};
            done_out      <= 1'b0;
        end
        else if(alu_start) begin
            data_out      <= sum;
            valid_out     <= valid_d2;
            c_row_idx_out <= c_row_idx_d2;
            c_col_idx_out <= c_col_idx_d2;
            done_out      <= done_d2;
        end
    end

endmodule