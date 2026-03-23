
//input ports
add mapped point clk clk -type PI PI
add mapped point rstn rstn -type PI PI
add mapped point alu_init alu_init -type PI PI
add mapped point in_valid in_valid -type PI PI
add mapped point row_idx[2] row_idx[2] -type PI PI
add mapped point row_idx[1] row_idx[1] -type PI PI
add mapped point row_idx[0] row_idx[0] -type PI PI
add mapped point num_computation[6] num_computation[6] -type PI PI
add mapped point num_computation[5] num_computation[5] -type PI PI
add mapped point num_computation[4] num_computation[4] -type PI PI
add mapped point num_computation[3] num_computation[3] -type PI PI
add mapped point num_computation[2] num_computation[2] -type PI PI
add mapped point num_computation[1] num_computation[1] -type PI PI
add mapped point num_computation[0] num_computation[0] -type PI PI
add mapped point m[6] m[6] -type PI PI
add mapped point m[5] m[5] -type PI PI
add mapped point m[4] m[4] -type PI PI
add mapped point m[3] m[3] -type PI PI
add mapped point m[2] m[2] -type PI PI
add mapped point m[1] m[1] -type PI PI
add mapped point m[0] m[0] -type PI PI
add mapped point k[6] k[6] -type PI PI
add mapped point k[5] k[5] -type PI PI
add mapped point k[4] k[4] -type PI PI
add mapped point k[3] k[3] -type PI PI
add mapped point k[2] k[2] -type PI PI
add mapped point k[1] k[1] -type PI PI
add mapped point k[0] k[0] -type PI PI

//output ports
add mapped point c_row_idx[8] c_row_idx[8] -type PO PO
add mapped point c_row_idx[7] c_row_idx[7] -type PO PO
add mapped point c_row_idx[6] c_row_idx[6] -type PO PO
add mapped point c_row_idx[5] c_row_idx[5] -type PO PO
add mapped point c_row_idx[4] c_row_idx[4] -type PO PO
add mapped point c_row_idx[3] c_row_idx[3] -type PO PO
add mapped point c_row_idx[2] c_row_idx[2] -type PO PO
add mapped point c_row_idx[1] c_row_idx[1] -type PO PO
add mapped point c_row_idx[0] c_row_idx[0] -type PO PO
add mapped point c_col_idx[8] c_col_idx[8] -type PO PO
add mapped point c_col_idx[7] c_col_idx[7] -type PO PO
add mapped point c_col_idx[6] c_col_idx[6] -type PO PO
add mapped point c_col_idx[5] c_col_idx[5] -type PO PO
add mapped point c_col_idx[4] c_col_idx[4] -type PO PO
add mapped point c_col_idx[3] c_col_idx[3] -type PO PO
add mapped point c_col_idx[2] c_col_idx[2] -type PO PO
add mapped point c_col_idx[1] c_col_idx[1] -type PO PO
add mapped point c_col_idx[0] c_col_idx[0] -type PO PO
add mapped point done_flag done_flag -type PO PO

//inout ports




//Sequential Pins
add mapped point c_col_os[8]/q c_col_os_reg[8]/Q -type DFF DFF
add mapped point c_col_os[7]/q c_col_os_reg[7]/Q -type DFF DFF
add mapped point num_computated[5]/q num_computated_reg[5]/Q -type DFF DFF
add mapped point num_computated[1]/q num_computated_reg[1]/Q -type DFF DFF
add mapped point num_computated[3]/q num_computated_reg[3]/Q -type DFF DFF
add mapped point c_col_os[3]/q c_col_os_reg[3]/Q -type DFF DFF
add mapped point num_computated[0]/q num_computated_reg[0]/Q -type DFF DFF
add mapped point done_flag/q done_flag_reg/Q -type DFF DFF
add mapped point u_out_ac/i[4]/q u_out_ac_i_reg[4]/Q -type DFF DFF
add mapped point u_out_ac/j[4]/q u_out_ac_j_reg[4]/Q -type DFF DFF
add mapped point u_out_ac/i[8]/q u_out_ac_i_reg[8]/Q -type DFF DFF
add mapped point u_out_ac/i[5]/q u_out_ac_i_reg[5]/Q -type DFF DFF
add mapped point u_out_ac/i[7]/q u_out_ac_i_reg[7]/Q -type DFF DFF
add mapped point u_out_ac/j[8]/q u_out_ac_j_reg[8]/Q -type DFF DFF
add mapped point u_out_ac/i[3]/q u_out_ac_i_reg[3]/Q -type DFF DFF
add mapped point u_out_ac/j[6]/q u_out_ac_j_reg[6]/Q -type DFF DFF
add mapped point u_out_ac/j[7]/q u_out_ac_j_reg[7]/Q -type DFF DFF
add mapped point u_out_ac/j[5]/q u_out_ac_j_reg[5]/Q -type DFF DFF
add mapped point u_out_ac/i[6]/q u_out_ac_i_reg[6]/Q -type DFF DFF
add mapped point num_computated[6]/q num_computated_reg[6]/Q -type DFF DFF
add mapped point num_computated[4]/q num_computated_reg[4]/Q -type DFF DFF
add mapped point num_computated[2]/q num_computated_reg[2]/Q -type DFF DFF
add mapped point c_col_os[5]/q c_col_os_reg[5]/Q -type DFF DFF
add mapped point c_col_os[6]/q c_col_os_reg[6]/Q -type DFF DFF
add mapped point c_col_os[4]/q c_col_os_reg[4]/Q -type DFF DFF
add mapped point u_out_ac/j[3]/q u_out_ac_j_reg[3]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
