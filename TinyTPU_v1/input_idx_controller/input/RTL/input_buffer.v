module input_buffer#(
    parameter   ARRAY_SIZE = 8,
    parameter   DATA_WIDTH = 9
)
(
    input   clk,
    input   rstn,
    input   alu_start,

    input [4*DATA_WIDTH-1:0]         data0,
    input [4*DATA_WIDTH-1:0]         data1,
    output wire [4*DATA_WIDTH-1:0]   systolic_data0,
    output wire [4*DATA_WIDTH-1:0]   systolic_data1
);

    reg [DATA_WIDTH-1 : 0] pipe_1;
    reg [DATA_WIDTH-1 : 0] pipe_2 [0:1];
    reg [DATA_WIDTH-1 : 0] pipe_3 [0:2];
    reg [DATA_WIDTH-1 : 0] pipe_4 [0:3];
    reg [DATA_WIDTH-1 : 0] pipe_5 [0:4];
    reg [DATA_WIDTH-1 : 0] pipe_6 [0:5];
    reg [DATA_WIDTH-1 : 0] pipe_7 [0:6];

    assign systolic_data0 = {data0[4*DATA_WIDTH-1:3*DATA_WIDTH], pipe_1, pipe_2[1], pipe_3[2]};
    assign systolic_data1 = {pipe_4[3], pipe_5[4], pipe_6[5], pipe_7[6]};

    integer k;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if(~rstn) begin
            pipe_1 <= {DATA_WIDTH{1'b0}};
            for(k=0;k<2;k=k+1) pipe_2[k] <= {DATA_WIDTH{1'b0}};
            for(k=0;k<3;k=k+1) pipe_3[k] <= {DATA_WIDTH{1'b0}};
            for(k=0;k<4;k=k+1) pipe_4[k] <= {DATA_WIDTH{1'b0}};
            for(k=0;k<5;k=k+1) pipe_5[k] <= {DATA_WIDTH{1'b0}};
            for(k=0;k<6;k=k+1) pipe_6[k] <= {DATA_WIDTH{1'b0}};
            for(k=0;k<7;k=k+1) pipe_7[k] <= {DATA_WIDTH{1'b0}};
        end
        else if(alu_start) begin
            for(k=1;k<2;k=k+1) pipe_2[k] <= pipe_2[k-1];
            for(k=1;k<3;k=k+1) pipe_3[k] <= pipe_3[k-1];
            for(k=1;k<4;k=k+1) pipe_4[k] <= pipe_4[k-1];
            for(k=1;k<5;k=k+1) pipe_5[k] <= pipe_5[k-1];
            for(k=1;k<6;k=k+1) pipe_6[k] <= pipe_6[k-1];
            for(k=1;k<7;k=k+1) pipe_7[k] <= pipe_7[k-1];

            pipe_1    <= data0[3*DATA_WIDTH-1:2*DATA_WIDTH];
            pipe_2[0] <= data0[2*DATA_WIDTH-1:1*DATA_WIDTH];
            pipe_3[0] <= data0[1*DATA_WIDTH-1:0];
            pipe_4[0] <= data1[4*DATA_WIDTH-1:3*DATA_WIDTH];
            pipe_5[0] <= data1[3*DATA_WIDTH-1:2*DATA_WIDTH];
            pipe_6[0] <= data1[2*DATA_WIDTH-1:1*DATA_WIDTH];
            pipe_7[0] <= data1[1*DATA_WIDTH-1:0];
        end
    end

endmodule