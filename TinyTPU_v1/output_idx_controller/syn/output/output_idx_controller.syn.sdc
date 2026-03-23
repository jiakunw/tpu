# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.16-s062_1 on Sun Mar 22 14:07:19 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design output_idx_controller

create_clock -name "clk" -period 20.0 -waveform {0.0 10.0} [get_ports clk]
set_clock_transition 0.15 [get_clocks clk]
set_load -pin_load 0.5 [get_ports clk]
set_load -pin_load 0.5 [get_ports rstn]
set_load -pin_load 0.5 [get_ports alu_init]
set_load -pin_load 0.5 [get_ports in_valid]
set_load -pin_load 0.5 [get_ports {row_idx[2]}]
set_load -pin_load 0.5 [get_ports {row_idx[1]}]
set_load -pin_load 0.5 [get_ports {row_idx[0]}]
set_load -pin_load 0.5 [get_ports {num_computation[6]}]
set_load -pin_load 0.5 [get_ports {num_computation[5]}]
set_load -pin_load 0.5 [get_ports {num_computation[4]}]
set_load -pin_load 0.5 [get_ports {num_computation[3]}]
set_load -pin_load 0.5 [get_ports {num_computation[2]}]
set_load -pin_load 0.5 [get_ports {num_computation[1]}]
set_load -pin_load 0.5 [get_ports {num_computation[0]}]
set_load -pin_load 0.5 [get_ports {m[6]}]
set_load -pin_load 0.5 [get_ports {m[5]}]
set_load -pin_load 0.5 [get_ports {m[4]}]
set_load -pin_load 0.5 [get_ports {m[3]}]
set_load -pin_load 0.5 [get_ports {m[2]}]
set_load -pin_load 0.5 [get_ports {m[1]}]
set_load -pin_load 0.5 [get_ports {m[0]}]
set_load -pin_load 0.5 [get_ports {k[6]}]
set_load -pin_load 0.5 [get_ports {k[5]}]
set_load -pin_load 0.5 [get_ports {k[4]}]
set_load -pin_load 0.5 [get_ports {k[3]}]
set_load -pin_load 0.5 [get_ports {k[2]}]
set_load -pin_load 0.5 [get_ports {k[1]}]
set_load -pin_load 0.5 [get_ports {k[0]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[8]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[7]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[6]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[5]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[4]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[3]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[2]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[1]}]
set_load -pin_load 0.5 [get_ports {c_row_idx[0]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[8]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[7]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[6]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[5]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[4]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[3]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[2]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[1]}]
set_load -pin_load 0.5 [get_ports {c_col_idx[0]}]
set_load -pin_load 0.5 [get_ports done_flag]
group_path -weight 1.000000 -name C2O -from [list \
  [get_cells {c_col_os_reg[8]}]  \
  [get_cells {num_computated_reg[5]}]  \
  [get_cells {num_computated_reg[1]}]  \
  [get_cells {num_computated_reg[3]}]  \
  [get_cells {c_col_os_reg[3]}]  \
  [get_cells {num_computated_reg[0]}]  \
  [get_cells {num_computated_reg[6]}]  \
  [get_cells {c_col_os_reg[5]}]  \
  [get_cells {c_col_os_reg[4]}]  \
  [get_cells {c_col_os_reg[7]}]  \
  [get_cells {u_out_ac_j_reg[8]}]  \
  [get_cells {u_out_ac_j_reg[3]}]  \
  [get_cells {num_computated_reg[2]}]  \
  [get_cells {u_out_ac_j_reg[6]}]  \
  [get_cells {c_col_os_reg[6]}]  \
  [get_cells {u_out_ac_j_reg[5]}]  \
  [get_cells {u_out_ac_j_reg[4]}]  \
  [get_cells {u_out_ac_j_reg[7]}]  \
  [get_cells {num_computated_reg[4]}]  \
  [get_cells {u_out_ac_i_reg[5]}]  \
  [get_cells {u_out_ac_i_reg[6]}]  \
  [get_cells {u_out_ac_i_reg[7]}]  \
  [get_cells {u_out_ac_i_reg[3]}]  \
  [get_cells {u_out_ac_i_reg[4]}]  \
  [get_cells {u_out_ac_i_reg[8]}]  \
  [get_cells done_flag_reg] ] -to [list \
  [get_ports {c_row_idx[8]}]  \
  [get_ports {c_row_idx[7]}]  \
  [get_ports {c_row_idx[6]}]  \
  [get_ports {c_row_idx[5]}]  \
  [get_ports {c_row_idx[4]}]  \
  [get_ports {c_row_idx[3]}]  \
  [get_ports {c_row_idx[2]}]  \
  [get_ports {c_row_idx[1]}]  \
  [get_ports {c_row_idx[0]}]  \
  [get_ports {c_col_idx[8]}]  \
  [get_ports {c_col_idx[7]}]  \
  [get_ports {c_col_idx[6]}]  \
  [get_ports {c_col_idx[5]}]  \
  [get_ports {c_col_idx[4]}]  \
  [get_ports {c_col_idx[3]}]  \
  [get_ports {c_col_idx[2]}]  \
  [get_ports {c_col_idx[1]}]  \
  [get_ports {c_col_idx[0]}]  \
  [get_ports done_flag] ]
group_path -weight 1.000000 -name I2C -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports alu_init]  \
  [get_ports in_valid]  \
  [get_ports {row_idx[2]}]  \
  [get_ports {row_idx[1]}]  \
  [get_ports {row_idx[0]}]  \
  [get_ports {num_computation[6]}]  \
  [get_ports {num_computation[5]}]  \
  [get_ports {num_computation[4]}]  \
  [get_ports {num_computation[3]}]  \
  [get_ports {num_computation[2]}]  \
  [get_ports {num_computation[1]}]  \
  [get_ports {num_computation[0]}]  \
  [get_ports {m[6]}]  \
  [get_ports {m[5]}]  \
  [get_ports {m[4]}]  \
  [get_ports {m[3]}]  \
  [get_ports {m[2]}]  \
  [get_ports {m[1]}]  \
  [get_ports {m[0]}]  \
  [get_ports {k[6]}]  \
  [get_ports {k[5]}]  \
  [get_ports {k[4]}]  \
  [get_ports {k[3]}]  \
  [get_ports {k[2]}]  \
  [get_ports {k[1]}]  \
  [get_ports {k[0]}] ] -to [list \
  [get_cells {c_col_os_reg[8]}]  \
  [get_cells {num_computated_reg[5]}]  \
  [get_cells {num_computated_reg[1]}]  \
  [get_cells {num_computated_reg[3]}]  \
  [get_cells {c_col_os_reg[3]}]  \
  [get_cells {num_computated_reg[0]}]  \
  [get_cells {num_computated_reg[6]}]  \
  [get_cells {c_col_os_reg[5]}]  \
  [get_cells {c_col_os_reg[4]}]  \
  [get_cells {c_col_os_reg[7]}]  \
  [get_cells {u_out_ac_j_reg[8]}]  \
  [get_cells {u_out_ac_j_reg[3]}]  \
  [get_cells {num_computated_reg[2]}]  \
  [get_cells {u_out_ac_j_reg[6]}]  \
  [get_cells {c_col_os_reg[6]}]  \
  [get_cells {u_out_ac_j_reg[5]}]  \
  [get_cells {u_out_ac_j_reg[4]}]  \
  [get_cells {u_out_ac_j_reg[7]}]  \
  [get_cells {num_computated_reg[4]}]  \
  [get_cells {u_out_ac_i_reg[5]}]  \
  [get_cells {u_out_ac_i_reg[6]}]  \
  [get_cells {u_out_ac_i_reg[7]}]  \
  [get_cells {u_out_ac_i_reg[3]}]  \
  [get_cells {u_out_ac_i_reg[4]}]  \
  [get_cells {u_out_ac_i_reg[8]}]  \
  [get_cells done_flag_reg] ]
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports alu_init]  \
  [get_ports in_valid]  \
  [get_ports {row_idx[2]}]  \
  [get_ports {row_idx[1]}]  \
  [get_ports {row_idx[0]}]  \
  [get_ports {num_computation[6]}]  \
  [get_ports {num_computation[5]}]  \
  [get_ports {num_computation[4]}]  \
  [get_ports {num_computation[3]}]  \
  [get_ports {num_computation[2]}]  \
  [get_ports {num_computation[1]}]  \
  [get_ports {num_computation[0]}]  \
  [get_ports {m[6]}]  \
  [get_ports {m[5]}]  \
  [get_ports {m[4]}]  \
  [get_ports {m[3]}]  \
  [get_ports {m[2]}]  \
  [get_ports {m[1]}]  \
  [get_ports {m[0]}]  \
  [get_ports {k[6]}]  \
  [get_ports {k[5]}]  \
  [get_ports {k[4]}]  \
  [get_ports {k[3]}]  \
  [get_ports {k[2]}]  \
  [get_ports {k[1]}]  \
  [get_ports {k[0]}] ] -to [list \
  [get_ports {c_row_idx[8]}]  \
  [get_ports {c_row_idx[7]}]  \
  [get_ports {c_row_idx[6]}]  \
  [get_ports {c_row_idx[5]}]  \
  [get_ports {c_row_idx[4]}]  \
  [get_ports {c_row_idx[3]}]  \
  [get_ports {c_row_idx[2]}]  \
  [get_ports {c_row_idx[1]}]  \
  [get_ports {c_row_idx[0]}]  \
  [get_ports {c_col_idx[8]}]  \
  [get_ports {c_col_idx[7]}]  \
  [get_ports {c_col_idx[6]}]  \
  [get_ports {c_col_idx[5]}]  \
  [get_ports {c_col_idx[4]}]  \
  [get_ports {c_col_idx[3]}]  \
  [get_ports {c_col_idx[2]}]  \
  [get_ports {c_col_idx[1]}]  \
  [get_ports {c_col_idx[0]}]  \
  [get_ports done_flag] ]
group_path -weight 1.000000 -name C2C -from [list \
  [get_cells {c_col_os_reg[8]}]  \
  [get_cells {num_computated_reg[5]}]  \
  [get_cells {num_computated_reg[1]}]  \
  [get_cells {num_computated_reg[3]}]  \
  [get_cells {c_col_os_reg[3]}]  \
  [get_cells {num_computated_reg[0]}]  \
  [get_cells {num_computated_reg[6]}]  \
  [get_cells {c_col_os_reg[5]}]  \
  [get_cells {c_col_os_reg[4]}]  \
  [get_cells {c_col_os_reg[7]}]  \
  [get_cells {u_out_ac_j_reg[8]}]  \
  [get_cells {u_out_ac_j_reg[3]}]  \
  [get_cells {num_computated_reg[2]}]  \
  [get_cells {u_out_ac_j_reg[6]}]  \
  [get_cells {c_col_os_reg[6]}]  \
  [get_cells {u_out_ac_j_reg[5]}]  \
  [get_cells {u_out_ac_j_reg[4]}]  \
  [get_cells {u_out_ac_j_reg[7]}]  \
  [get_cells {num_computated_reg[4]}]  \
  [get_cells {u_out_ac_i_reg[5]}]  \
  [get_cells {u_out_ac_i_reg[6]}]  \
  [get_cells {u_out_ac_i_reg[7]}]  \
  [get_cells {u_out_ac_i_reg[3]}]  \
  [get_cells {u_out_ac_i_reg[4]}]  \
  [get_cells {u_out_ac_i_reg[8]}]  \
  [get_cells done_flag_reg] ] -to [list \
  [get_cells {c_col_os_reg[8]}]  \
  [get_cells {num_computated_reg[5]}]  \
  [get_cells {num_computated_reg[1]}]  \
  [get_cells {num_computated_reg[3]}]  \
  [get_cells {c_col_os_reg[3]}]  \
  [get_cells {num_computated_reg[0]}]  \
  [get_cells {num_computated_reg[6]}]  \
  [get_cells {c_col_os_reg[5]}]  \
  [get_cells {c_col_os_reg[4]}]  \
  [get_cells {c_col_os_reg[7]}]  \
  [get_cells {u_out_ac_j_reg[8]}]  \
  [get_cells {u_out_ac_j_reg[3]}]  \
  [get_cells {num_computated_reg[2]}]  \
  [get_cells {u_out_ac_j_reg[6]}]  \
  [get_cells {c_col_os_reg[6]}]  \
  [get_cells {u_out_ac_j_reg[5]}]  \
  [get_cells {u_out_ac_j_reg[4]}]  \
  [get_cells {u_out_ac_j_reg[7]}]  \
  [get_cells {num_computated_reg[4]}]  \
  [get_cells {u_out_ac_i_reg[5]}]  \
  [get_cells {u_out_ac_i_reg[6]}]  \
  [get_cells {u_out_ac_i_reg[7]}]  \
  [get_cells {u_out_ac_i_reg[3]}]  \
  [get_cells {u_out_ac_i_reg[4]}]  \
  [get_cells {u_out_ac_i_reg[8]}]  \
  [get_cells done_flag_reg] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports rstn]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports alu_init]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports in_valid]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {row_idx[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {row_idx[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {row_idx[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {num_computation[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {num_computation[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {num_computation[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {num_computation[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {num_computation[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {num_computation[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {num_computation[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {m[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {m[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {m[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {m[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {m[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {m[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {m[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {k[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {k[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {k[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {k[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {k[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {k[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.25 [get_ports {k[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports rstn]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports alu_init]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports in_valid]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {row_idx[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {row_idx[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {row_idx[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {num_computation[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {num_computation[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {num_computation[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {num_computation[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {num_computation[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {num_computation[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {num_computation[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {m[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {m[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {m[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {m[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {m[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {m[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {m[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {k[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {k[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {k[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {k[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {k[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {k[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {k[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_row_idx[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports {c_col_idx[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 5.0 [get_ports done_flag]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_row_idx[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_col_idx[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports done_flag]
set_wire_load_mode "segmented"
set_clock_uncertainty -setup 0.15 [get_clocks clk]
set_clock_uncertainty -hold 0.15 [get_clocks clk]
