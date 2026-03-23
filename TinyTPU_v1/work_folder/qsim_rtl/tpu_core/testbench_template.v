`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD #10
`define SD #1

`define HW_RESULT_TXT   "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/HW.txt"
`define HW_CLAMPED_TXT   "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/HW_clamped.txt"
`define A_TXT           "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/A.txt"
`define B_TXT           "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/B.txt"
`define C_TXT           "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/C.txt"
`define C_clamped_TXT           "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/C_clamped.txt"
`define Bias_TXT        "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/bias.txt"
`define OUT_Bias_TXT    "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/out_bias.txt"
`define OUT_SCALE_TXT       "./@M_DIM_@N_DIM_@K_DIM_@NUM_COMPUTATION/out_scale.txt"

module testbench;

    parameter   ARRAY_SIZE      = 8;
    parameter   SRAM_DATA_WIDTH  = 64;

    parameter   DATA_WIDTH = 8;
    parameter   ACCUMULATOR_WIDTH = 32;
    parameter   OUTCOME_WIDTH = 33;

    parameter   SCALE_FACTOR_WIDTH = 16;
    parameter   OFFSET_WIDTH = 8;
    parameter   BIAS_WIDTH = 32;

    parameter   MAX_TILE = 64;
    parameter   MNK_IDX_WIDTH = $clog2(MAX_TILE) + 1;
    parameter   IDX_WIDTH = MNK_IDX_WIDTH + 2;

    parameter   SRAM_ADDR_WIDTH = 9;
    // --- wires --- //
    reg clk;
    reg rstn;

    reg tpu_start;
    reg keep_pe_value;

    reg [MNK_IDX_WIDTH-1:0] m;
    reg [MNK_IDX_WIDTH-1:0] n;
    reg [MNK_IDX_WIDTH-1:0] k;
    reg [MNK_IDX_WIDTH-1:0] num_computation;

    wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a;
    wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b;

    reg [OFFSET_WIDTH-1:0] zero_point_a;
    reg [OFFSET_WIDTH-1:0] zero_point_b;
    reg [OFFSET_WIDTH-1:0] zero_point_c;

    reg [BIAS_WIDTH-1:0] bias;
    reg [SCALE_FACTOR_WIDTH-1:0] scale_factor;
    reg [4:0] scale_shift;

    wire [ARRAY_SIZE*OUTCOME_WIDTH-1:0] outcome;
    wire [SRAM_DATA_WIDTH-1:0] relu_out;

    wire [SRAM_ADDR_WIDTH-1:0] a_raddr;
    wire [SRAM_ADDR_WIDTH-1:0] b_raddr;
    wire [SRAM_ADDR_WIDTH-1:0] c_waddr;

    wire [IDX_WIDTH-1:0] c_row_idx;
    wire [IDX_WIDTH-1:0] c_col_idx;

    wire [IDX_WIDTH-1:0] bias_addr;

    wire a_b_sram_rd_en;
    wire bias_sram_rd_en;
    wire c_sram_w_en;

    wire done_flag;

    // ----- A_SRAM wires ----- //
    reg a_wr_en;
    reg [SRAM_ADDR_WIDTH-1:0] a_waddr;
    reg [SRAM_DATA_WIDTH-1:0] a_wdata;

    // ----- B_SRAM wires ----- //
    reg b_wr_en;
    reg [SRAM_ADDR_WIDTH-1:0] b_waddr;
    reg [SRAM_DATA_WIDTH-1:0] b_wdata;

    // ----- C_SRAM wires ----- //
    reg  c_rd_en;
    reg [SRAM_ADDR_WIDTH-1:0] c_raddr;
    wire [SRAM_DATA_WIDTH-1:0] c_rdata;

    // --- DUT instantiation --- //
    tpu_core DUT (
        .clk            (clk),
        .rstn           (rstn),

        .tpu_start      (tpu_start),
        .keep_pe_value  (keep_pe_value),

        .m              (m),
        .n              (n),
        .k              (k),
        .num_computation(num_computation),

        .sram_rdata_a   (sram_rdata_a),
        .sram_rdata_b   (sram_rdata_b),

        .zero_point_a   (zero_point_a),
        .zero_point_b   (zero_point_b),
        .zero_point_c   (zero_point_c),

        .bias           (bias),
        .scale_factor   (scale_factor),
        .scale_shift    (scale_shift),

        .outcome_full_TEST  (outcome),
        .outcome_quantized  (relu_out),

        .a_raddr        (a_raddr),
        .b_raddr        (b_raddr),
        .c_waddr        (c_waddr),

        .c_row_idx_TEST       (c_row_idx),
        .c_col_idx_TEST       (c_col_idx),

        .bias_addr      (bias_addr),

        .a_b_sram_rd_en (a_b_sram_rd_en),
        .bias_sram_rd_en(bias_sram_rd_en),
        .c_sram_w_en    (c_sram_w_en),

        .done_flag      (done_flag)
    );

    // ----- A SRAM -----//
    sram_wrapper A_SRAM (
        .clk(clk),
        .wr_en(a_wr_en),
        .rd_en(a_b_sram_rd_en),
        .waddr(a_waddr),
        .raddr(a_raddr),
        .wdata(a_wdata),
        .rdata(sram_rdata_a)
    );

    // ----- B SRAM -----//
    sram_wrapper B_SRAM (
        .clk(clk),
        .wr_en(b_wr_en),
        .rd_en(a_b_sram_rd_en),
        .waddr(b_waddr),
        .raddr(b_raddr),
        .wdata(b_wdata),
        .rdata(sram_rdata_b)
    );

    // ----- C SRAM -----//
    sram_wrapper C_SRAM (
        .clk(clk),
        .wr_en(c_sram_w_en),
        .rd_en(c_rd_en),
        .waddr(c_waddr),
        .raddr(c_raddr),
        .wdata(relu_out),
        .rdata(c_rdata)
    );

    reg [DATA_WIDTH-1:0] DATA_SRAM [0:511][0:511];
    reg [DATA_WIDTH-1:0] WEIGHT_SRAM [0:511][0:511];
    reg [33-1:0] OUT_SRAM [0:511][0:511];
    reg [8-1:0] OUT_CLAMPED_SRAM [0:511][0:511];
    reg [OUTCOME_WIDTH-1:0] OUT_BIAS_SRAM [0:511];

    integer i, j, z;
    integer i_c, j_c;

    always @(posedge clk) begin
        if(!rstn) begin
            bias <= 0;
        end
        else if (bias_sram_rd_en) begin
            bias <= OUT_BIAS_SRAM[bias_addr];
        end
    end

    always @(posedge clk) begin
        `SD
        if(!rstn) begin
            for(i_c = 0; i_c < 512; i_c = i_c + 1) begin
            for(j_c = 0; j_c < 512; j_c = j_c + 1) begin
                OUT_SRAM[i_c][j_c] <= 33'd0;
            end
            end
        end
        else if(c_sram_w_en) begin
            OUT_SRAM[c_row_idx][c_col_idx  ] <= outcome[(8*33)-1 -: 33];
            OUT_SRAM[c_row_idx][c_col_idx+1] <= outcome[(7*33)-1 -: 33];
            OUT_SRAM[c_row_idx][c_col_idx+2] <= outcome[(6*33)-1 -: 33];
            OUT_SRAM[c_row_idx][c_col_idx+3] <= outcome[(5*33)-1 -: 33];
            OUT_SRAM[c_row_idx][c_col_idx+4] <= outcome[(4*33)-1 -: 33];
            OUT_SRAM[c_row_idx][c_col_idx+5] <= outcome[(3*33)-1 -: 33];
            OUT_SRAM[c_row_idx][c_col_idx+6] <= outcome[(2*33)-1 -: 33];
            OUT_SRAM[c_row_idx][c_col_idx+7] <= outcome[(1*33)-1 -: 33];
        end
    end

    integer a_file, b_file, c_file, hw_result_file, bias_file, out_bias_file, out_scale_file;
    integer c_clamped_file, hw_clamped_file;
    integer ret_read;

    integer temp_a, temp_b, temp_out_bias;
    reg [33-1:0] temp_c;
    reg [8-1:0] temp_clamped_c;

    integer a_row_temp, a_col_temp;
    integer b_row_temp, b_col_temp;
    integer c_row_temp, c_col_temp;

    integer error_count = 0;

    // ---------------- Clock Generators ----------------
    initial begin
        clk = 1;
        forever `HALF_CLOCK_PERIOD clk = ~clk;
    end
    
    // ---------------- Test Sequence ----------------
    initial begin

        rstn = 0;
        tpu_start = 0;
        keep_pe_value = 0;
        m = 0;
        n = 0;
        k = 0;
        num_computation = 0;

        scale_factor = 0;
        scale_shift = 0;

        a_wr_en = 0;
        a_waddr = 0;
        a_wdata = 0;
        b_wr_en = 0;
        b_waddr = 0;
        b_wdata = 0;
        c_rd_en = 0;

        // ------------- testing ---------------- //
        @(posedge clk);
        `SD
        m = @M_DIM / 8;
        n = @N_DIM / 8;
        k = @K_DIM / 8;
        num_computation = @NUM_COMPUTATION;
        keep_pe_value = 0;

        a_file = $fopen(`A_TXT, "r");
        b_file = $fopen(`B_TXT, "r");
        c_file = $fopen(`C_TXT, "r");
        c_clamped_file = $fopen(`C_clamped_TXT, "r");
        bias_file = $fopen(`Bias_TXT, "r");
        out_bias_file = $fopen(`OUT_Bias_TXT, "r");
        hw_result_file = $fopen(`HW_RESULT_TXT, "w");
        hw_clamped_file = $fopen(`HW_CLAMPED_TXT, "w");
        out_scale_file = $fopen(`OUT_SCALE_TXT, "r");

        if(!a_file || !b_file || !c_file || !c_clamped_file || !hw_result_file || !hw_clamped_file || !bias_file || !out_bias_file || !out_scale_file ) begin
            $display("Error opening files.");
            $finish;
        end

        // ----------------- Initialize SRAMs ----------------
        for(z = 0; z < num_computation; z = z+1) begin
            for(i = 0; i < m*8; i = i+1) begin
                for(j = 0; j < n*8; j = j+1) begin
                    ret_read = $fscanf(a_file, "%h\n", temp_a);
                    if(ret_read != 1) $fatal("A read error");
                    DATA_SRAM[j+z*n*8][i] = temp_a;
                end
            end
        end

        for(z = 0; z < num_computation; z = z+1) begin
            for(i = 0; i < n*8; i = i+1) begin
                for(j = 0; j < k*8; j = j+1) begin
                    ret_read = $fscanf(b_file, "%h\n", temp_b);
                    if(ret_read != 1) $fatal("B read error");
                    WEIGHT_SRAM[i][j+z*k*8] = temp_b;
                end
            end
        end

        for(i = 0; i < m*8; i = i+1) begin
            ret_read = $fscanf(out_bias_file, "%h\n", temp_out_bias);
            if(ret_read != 1) $fatal("Output bias read error");
            OUT_BIAS_SRAM[i] = temp_out_bias;
        end

        // ----- write data into SRAM ----- //
        for(z = 0; z < num_computation; z = z+1) begin
            for(j = 0; j < n*8; j = j+1) begin
                for(i = 0; i < m*8; i = i+8) begin
                    @(posedge clk); 
                    `SD
                    a_wr_en = 1;
                    a_row_temp = z*n*8 + j;
                    a_col_temp = i;
                    a_waddr = a_row_temp * (m*8) / 8 + a_col_temp / 8;
                    a_wdata = {DATA_SRAM[a_row_temp][a_col_temp],
                               DATA_SRAM[a_row_temp][a_col_temp+1],
                               DATA_SRAM[a_row_temp][a_col_temp+2],
                               DATA_SRAM[a_row_temp][a_col_temp+3],
                               DATA_SRAM[a_row_temp][a_col_temp+4],
                               DATA_SRAM[a_row_temp][a_col_temp+5],
                               DATA_SRAM[a_row_temp][a_col_temp+6],
                               DATA_SRAM[a_row_temp][a_col_temp+7]};
                end
            end
        end
        @(posedge clk);
        `SD
        a_wr_en = 0;

        for(z = 0; z < num_computation; z = z+1) begin
            for(i = 0; i < n*8; i = i+1) begin
                for(j = 0; j < k*8; j = j+8) begin
                    @(posedge clk);
                    `SD
                    b_wr_en = 1;
                    b_row_temp = i;
                    b_col_temp = j + z*k*8;
                    b_waddr = b_row_temp * (k*8*num_computation) / 8 + b_col_temp / 8;
                    b_wdata = {WEIGHT_SRAM[b_row_temp][b_col_temp],
                               WEIGHT_SRAM[b_row_temp][b_col_temp+1],
                               WEIGHT_SRAM[b_row_temp][b_col_temp+2],
                               WEIGHT_SRAM[b_row_temp][b_col_temp+3],
                               WEIGHT_SRAM[b_row_temp][b_col_temp+4],
                               WEIGHT_SRAM[b_row_temp][b_col_temp+5],
                               WEIGHT_SRAM[b_row_temp][b_col_temp+6],
                               WEIGHT_SRAM[b_row_temp][b_col_temp+7]};
                end
            end
        end
        @(posedge clk);
        `SD
        b_wr_en = 0;

        ret_read = $fscanf(bias_file, "%h\n", zero_point_a);
        if(ret_read != 1) $fatal("Zero point A read error");
        ret_read = $fscanf(bias_file, "%h\n", zero_point_b);
        if(ret_read != 1) $fatal("Zero point B read error");
        ret_read = $fscanf(bias_file, "%h\n", zero_point_c);
        if(ret_read != 1) $fatal("Output offset read error");

        ret_read = $fscanf(out_scale_file, "%b\n", scale_factor);
        if(ret_read != 1) $fatal("Scale factor read error");
        ret_read = $fscanf(out_scale_file, "%b\n", scale_shift);
        if(ret_read != 1) $fatal("Scale shift read error");

        @(posedge clk); 
        `SD
        rstn = 1;
        tpu_start = 1;

        // pause for test
        repeat (15) @(posedge clk);
        `SD
        tpu_start = 0;
        repeat (20) @(posedge clk);
        `SD
        tpu_start = 1;


        while(!done_flag) begin
            @(posedge clk); 
        end

        `SD
        tpu_start = 0;

        // ----- read out results and compare ----- //
        for(z = 0; z < num_computation; z = z+1) begin
            for(i=0; i<m*8; i=i+1) begin
                for(j=0; j<k*8; j=j+8) begin
                    
                    @(posedge clk);
                    `SD
                    c_rd_en = 1;
                    c_row_temp = i;
                    c_col_temp = j + z*k*8;
                    c_raddr = c_row_temp * (k*8*num_computation) / 8 + c_col_temp / 8;

                    @(posedge clk);
                    `SD
                    OUT_CLAMPED_SRAM[c_row_temp][c_col_temp  ] = c_rdata[(8*8)-1 -: 8];
                    OUT_CLAMPED_SRAM[c_row_temp][c_col_temp+1] = c_rdata[(7*8)-1 -: 8];
                    OUT_CLAMPED_SRAM[c_row_temp][c_col_temp+2] = c_rdata[(6*8)-1 -: 8];
                    OUT_CLAMPED_SRAM[c_row_temp][c_col_temp+3] = c_rdata[(5*8)-1 -: 8];
                    OUT_CLAMPED_SRAM[c_row_temp][c_col_temp+4] = c_rdata[(4*8)-1 -: 8];
                    OUT_CLAMPED_SRAM[c_row_temp][c_col_temp+5] = c_rdata[(3*8)-1 -: 8];
                    OUT_CLAMPED_SRAM[c_row_temp][c_col_temp+6] = c_rdata[(2*8)-1 -: 8];
                    OUT_CLAMPED_SRAM[c_row_temp][c_col_temp+7] = c_rdata[(1*8)-1 -: 8];
                end
            end
        end

        @(posedge clk);
        `SD
        rstn = 0;
        c_rd_en = 0;
        

        for(z = 0; z < num_computation; z = z+1) begin
            for(i=0; i<m*8; i=i+1) begin
                for(j=0; j<k*8; j=j+1) begin

                    $fwrite(hw_result_file, "%b", OUT_SRAM[i][j+z*k*8]);
                    $fwrite(hw_clamped_file, "%h", OUT_CLAMPED_SRAM[i][j+z*k*8]);

                    ret_read = $fscanf(c_file, "%b\n", temp_c);
                    if(ret_read != 1) $fatal("C read error");

                    ret_read = $fscanf(c_clamped_file, "%h\n", temp_clamped_c);
                    if(ret_read != 1) $fatal("C clamped read error");

                    if(temp_c !== OUT_SRAM[i][j+z*k*8]) begin
                        $fwrite(hw_result_file, "mismatch");
                        error_count = error_count + 1;
                    end

                    if(temp_clamped_c !== OUT_CLAMPED_SRAM[i][j+z*k*8]) begin
                        $fwrite(hw_clamped_file, "mismatch");
                        error_count = error_count + 1;
                    end

                    $fwrite(hw_result_file, "\n");
                    $fwrite(hw_clamped_file, "\n");
                end
            end
        end

        if(error_count == 0) begin
            $fwrite(hw_result_file, "All outputs match expected results. Test PASSED.\n");
            $display("All outputs match expected results. Test PASSED.\n");
        end

        $fclose(a_file);
        $fclose(b_file);
        $fclose(c_file);
        $fclose(c_clamped_file);
        $fclose(bias_file);
        $fclose(out_bias_file);
        $fclose(out_scale_file);
        $fclose(hw_result_file);
        $fclose(hw_clamped_file);

        $finish;

    end

endmodule

