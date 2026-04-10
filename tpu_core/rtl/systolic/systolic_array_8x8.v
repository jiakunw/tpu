
module systolic_array_8X8#(
	parameter	ARRAY_SIZE = 8,
	parameter 	DATA_WIDTH = 9,
	parameter 	OUTCOME_WIDTH = 32,

	parameter 	INPUT_DATA_WIDTH 	= 4 * DATA_WIDTH,
	parameter 	OUTPUT_DATA_WIDTH 	= ARRAY_SIZE * OUTCOME_WIDTH,
	parameter 	ACC_PAD_WIDTH 		= OUTCOME_WIDTH - (DATA_WIDTH + DATA_WIDTH)
)
(
	input 			clk,
	input 			rstn,
	input 			alu_start,

	input 			keep_pe_value,										
	input [15:0] 	cycle_num,
	input [5:0] 	tile_num, // from 0 - 63, max 64 tiles		

	input [INPUT_DATA_WIDTH-1:0] 	rdata_a0,
	input [INPUT_DATA_WIDTH-1:0] 	rdata_a1,

	input [INPUT_DATA_WIDTH-1:0] 	rdata_b0,
	input [INPUT_DATA_WIDTH-1:0] 	rdata_b1,			

	output reg [3:0] 							matrix_index,
	output reg 									out_valid,
	output reg signed [OUTPUT_DATA_WIDTH-1:0] 	mul_outcome
);

	// Implicit Accumulation Control
	wire [6:0] TILE_NUM_EXT 				= {1'b0, tile_num} + 7'd1;
	wire [10:0] FIRST_OUT      				= 11'd1 + ( {4'd0, TILE_NUM_EXT} << 3 );
	wire [10:0] PARALLEL_START 				= 11'd1 + ( {4'd0, TILE_NUM_EXT} << 4 );
	wire [15:0] DIFF_FIRST 					= $unsigned(cycle_num) - $unsigned({5'd0, FIRST_OUT});
	wire [15:0] DIFF_PARALLEL  				= $unsigned(cycle_num) - $unsigned({5'd0, PARALLEL_START});
	wire [15:0] FIRST_OUT_COMP_FULL      	= DIFF_FIRST % ({4'd0, TILE_NUM_EXT} << 4);
	wire [15:0] PARALLEL_START_COMP_FULL 	= DIFF_PARALLEL % ({4'd0, TILE_NUM_EXT} << 4);
	wire [9:0]  FIRST_OUT_COMP           	= FIRST_OUT_COMP_FULL[9:0];
	wire [9:0]  PARALLEL_START_COMP      	= PARALLEL_START_COMP_FULL[9:0];
	wire FIRST_OUT_REACHED      			= (cycle_num >= FIRST_OUT);
	wire PARALLEL_START_REACHED 			= (cycle_num >= PARALLEL_START);

	// Internal Registers
	reg signed [OUTCOME_WIDTH-1:0] matrix_mul_2D [0:ARRAY_SIZE-1] [0:ARRAY_SIZE-1]; 		
	reg signed [OUTCOME_WIDTH-1:0] matrix_mul_2D_nx [0:ARRAY_SIZE-1] [0:ARRAY_SIZE-1]; 		
	reg signed [DATA_WIDTH-1:0] a_queue [0:ARRAY_SIZE-1] [0:ARRAY_SIZE-1];
	reg signed [DATA_WIDTH-1:0] b_queue [0:ARRAY_SIZE-1] [0:ARRAY_SIZE-1];
	reg signed [DATA_WIDTH + DATA_WIDTH-1:0] mul_result;

	// Other wires and signals
	wire pe_rstn = keep_pe_value || rstn;

	// Integers
	integer i,j;

	// ----- Data Propoagation in the systolic array ----- //
	// synopsys sync_set_reset "rstn"
	always@(posedge clk) begin
		if(~rstn) begin
			for(i=0; i<ARRAY_SIZE; i=i+1) begin
				for(j=0; j<ARRAY_SIZE; j=j+1) begin
					a_queue[i][j] <= {DATA_WIDTH{1'b0}};
					b_queue[i][j] <= {DATA_WIDTH{1'b0}};
				end
			end
		end
		else begin
			if(alu_start) begin

				for (i=0; i<4; i=i+1) begin
					a_queue[i][0]   <= $signed(rdata_a0[INPUT_DATA_WIDTH-1-DATA_WIDTH*i-:DATA_WIDTH]);
					a_queue[i+4][0] <= $signed(rdata_a1[INPUT_DATA_WIDTH-1-DATA_WIDTH*i-:DATA_WIDTH]);
				end

				for (i=0; i<ARRAY_SIZE; i=i+1)
					for (j=1; j<ARRAY_SIZE; j=j+1)
						a_queue[i][j] <= a_queue[i][j-1];

				for (i=0; i<4; i=i+1) begin
					b_queue[0][i]   <= $signed(rdata_b0[INPUT_DATA_WIDTH-1-DATA_WIDTH*i-:DATA_WIDTH]);
					b_queue[0][i+4] <= $signed(rdata_b1[INPUT_DATA_WIDTH-1-DATA_WIDTH*i-:DATA_WIDTH]);
				end

				for (i=1; i<ARRAY_SIZE; i=i+1)
					for (j=0; j<ARRAY_SIZE; j=j+1)
						b_queue[i][j] <= b_queue[i-1][j];
			end
		end
	end
	

	// ----- Output Register Update ----- //
	// synopsys sync_set_reset "pe_rstn"
	always@(posedge clk) begin
		if(!pe_rstn) begin
			for(i=0; i<ARRAY_SIZE; i=i+1) 
				for(j=0; j<ARRAY_SIZE; j=j+1)  
					matrix_mul_2D[i][j] <= {OUTCOME_WIDTH{1'b0}};
		end
		else begin
			for(i=0; i<ARRAY_SIZE; i=i+1) 
				for(j=0; j<ARRAY_SIZE; j=j+1) 
					matrix_mul_2D[i][j] <= matrix_mul_2D_nx[i][j];
		end
	end

	// ----- Systolic Array ----- //
	always@(*) begin
		if(alu_start) begin	
			for(i=0; i<ARRAY_SIZE; i=i+1) begin
				for(j=0; j<ARRAY_SIZE; j=j+1) begin
					if((FIRST_OUT_REACHED && (i+j)==FIRST_OUT_COMP) || (PARALLEL_START_REACHED && (i+j)==PARALLEL_START_COMP)) begin

						mul_result =
    						$signed({{DATA_WIDTH{a_queue[i][j][DATA_WIDTH-1]}}, a_queue[i][j]}) *
    						$signed({{DATA_WIDTH{b_queue[i][j][DATA_WIDTH-1]}}, b_queue[i][j]});

						if(!keep_pe_value) begin
							matrix_mul_2D_nx[i][j] =  { {ACC_PAD_WIDTH{mul_result[DATA_WIDTH + DATA_WIDTH-1]}} , mul_result };
						end
						else begin
							matrix_mul_2D_nx[i][j] = matrix_mul_2D[i][j] + { {ACC_PAD_WIDTH{mul_result[DATA_WIDTH + DATA_WIDTH-1]}} , mul_result };
						end
					end
					else if( cycle_num>=1 && i+j<=(cycle_num-1) ) begin

						mul_result =
    						$signed({{DATA_WIDTH{a_queue[i][j][DATA_WIDTH-1]}}, a_queue[i][j]}) *
    						$signed({{DATA_WIDTH{b_queue[i][j][DATA_WIDTH-1]}}, b_queue[i][j]});

						matrix_mul_2D_nx[i][j] = matrix_mul_2D[i][j] + { {ACC_PAD_WIDTH{mul_result[DATA_WIDTH + DATA_WIDTH-1]}} , mul_result };
					end
					else begin
						mul_result = {(2*DATA_WIDTH){1'b0}};
						matrix_mul_2D_nx[i][j] = matrix_mul_2D[i][j];
					end
				end
			end
		end
		else begin
			mul_result = {(2*DATA_WIDTH){1'b0}};
			for(i=0; i<ARRAY_SIZE; i=i+1) 
				for(j=0; j<ARRAY_SIZE; j=j+1) begin
					matrix_mul_2D_nx[i][j] = matrix_mul_2D[i][j];
				end
		end		
	end


	// ----- Valid Control ----- //
	always @(*) begin
		if(alu_start) begin
			if((FIRST_OUT_REACHED   && FIRST_OUT_COMP    	<= 10'd14) || 
			(PARALLEL_START_REACHED && PARALLEL_START_COMP 	<= 10'd14)) begin
				out_valid = 1'b1;
			end
			else begin
				out_valid = 1'b0;
			end
		end
		else begin
			out_valid = 1'b0;
		end
	end


	// ----- Matrix IDX Counter ----- //
	// synopsys sync_set_reset "rstn"
	always @(posedge clk) begin
	if(!rstn) begin
		matrix_index <= 4'd0;
	end else if(alu_start && (matrix_index == 4'd15)) begin
		matrix_index <= 4'd0;             
	end else if(alu_start && out_valid) begin
		matrix_index <= matrix_index + 4'd1;
	end
	end


	// ----- Output Muxing ----- //
	always@(*) begin	
		
		case(matrix_index)
			0: mul_outcome = $signed({matrix_mul_2D[0][0], matrix_mul_2D[7][1], matrix_mul_2D[6][2], matrix_mul_2D[5][3], matrix_mul_2D[4][4], matrix_mul_2D[3][5], matrix_mul_2D[2][6], matrix_mul_2D[1][7]});
			1: mul_outcome = $signed({matrix_mul_2D[1][0], matrix_mul_2D[0][1], matrix_mul_2D[7][2], matrix_mul_2D[6][3], matrix_mul_2D[5][4], matrix_mul_2D[4][5], matrix_mul_2D[3][6], matrix_mul_2D[2][7]});
			2: mul_outcome = $signed({matrix_mul_2D[2][0], matrix_mul_2D[1][1], matrix_mul_2D[0][2], matrix_mul_2D[7][3], matrix_mul_2D[6][4], matrix_mul_2D[5][5], matrix_mul_2D[4][6], matrix_mul_2D[3][7]});
			3: mul_outcome = $signed({matrix_mul_2D[3][0], matrix_mul_2D[2][1], matrix_mul_2D[1][2], matrix_mul_2D[0][3], matrix_mul_2D[7][4], matrix_mul_2D[6][5], matrix_mul_2D[5][6], matrix_mul_2D[4][7]});
			4: mul_outcome = $signed({matrix_mul_2D[4][0], matrix_mul_2D[3][1], matrix_mul_2D[2][2], matrix_mul_2D[1][3], matrix_mul_2D[0][4], matrix_mul_2D[7][5], matrix_mul_2D[6][6], matrix_mul_2D[5][7]});
			5: mul_outcome = $signed({matrix_mul_2D[5][0], matrix_mul_2D[4][1], matrix_mul_2D[3][2], matrix_mul_2D[2][3], matrix_mul_2D[1][4], matrix_mul_2D[0][5], matrix_mul_2D[7][6], matrix_mul_2D[6][7]});
			6: mul_outcome = $signed({matrix_mul_2D[6][0], matrix_mul_2D[5][1], matrix_mul_2D[4][2], matrix_mul_2D[3][3], matrix_mul_2D[2][4], matrix_mul_2D[1][5], matrix_mul_2D[0][6], matrix_mul_2D[7][7]});
			7: mul_outcome = $signed({matrix_mul_2D[7][0], matrix_mul_2D[6][1], matrix_mul_2D[5][2], matrix_mul_2D[4][3], matrix_mul_2D[3][4], matrix_mul_2D[2][5], matrix_mul_2D[1][6], matrix_mul_2D[0][7]});
			8: mul_outcome = $signed({matrix_mul_2D[0][0], matrix_mul_2D[7][1], matrix_mul_2D[6][2], matrix_mul_2D[5][3], matrix_mul_2D[4][4], matrix_mul_2D[3][5], matrix_mul_2D[2][6], matrix_mul_2D[1][7]});
			9: mul_outcome = $signed({matrix_mul_2D[1][0], matrix_mul_2D[0][1], matrix_mul_2D[7][2], matrix_mul_2D[6][3], matrix_mul_2D[5][4], matrix_mul_2D[4][5], matrix_mul_2D[3][6], matrix_mul_2D[2][7]});
			10: mul_outcome = $signed({matrix_mul_2D[2][0], matrix_mul_2D[1][1], matrix_mul_2D[0][2], matrix_mul_2D[7][3], matrix_mul_2D[6][4], matrix_mul_2D[5][5], matrix_mul_2D[4][6], matrix_mul_2D[3][7]});
			11: mul_outcome = $signed({matrix_mul_2D[3][0], matrix_mul_2D[2][1], matrix_mul_2D[1][2], matrix_mul_2D[0][3], matrix_mul_2D[7][4], matrix_mul_2D[6][5], matrix_mul_2D[5][6], matrix_mul_2D[4][7]});
			12: mul_outcome = $signed({matrix_mul_2D[4][0], matrix_mul_2D[3][1], matrix_mul_2D[2][2], matrix_mul_2D[1][3], matrix_mul_2D[0][4], matrix_mul_2D[7][5], matrix_mul_2D[6][6], matrix_mul_2D[5][7]});
			13: mul_outcome = $signed({matrix_mul_2D[5][0], matrix_mul_2D[4][1], matrix_mul_2D[3][2], matrix_mul_2D[2][3], matrix_mul_2D[1][4], matrix_mul_2D[0][5], matrix_mul_2D[7][6], matrix_mul_2D[6][7]});
			14: mul_outcome = $signed({matrix_mul_2D[6][0], matrix_mul_2D[5][1], matrix_mul_2D[4][2], matrix_mul_2D[3][3], matrix_mul_2D[2][4], matrix_mul_2D[1][5], matrix_mul_2D[0][6], matrix_mul_2D[7][7]});
			15: mul_outcome = $signed({matrix_mul_2D[7][0], matrix_mul_2D[6][1], matrix_mul_2D[5][2], matrix_mul_2D[4][3], matrix_mul_2D[3][4], matrix_mul_2D[2][5], matrix_mul_2D[1][6], matrix_mul_2D[0][7]});
			default: mul_outcome = $signed({OUTPUT_DATA_WIDTH{1'b0}});
		endcase
	end

endmodule

