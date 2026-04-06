# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.16-s062_1 on Thu Apr 02 21:17:15 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design sram_wrapper_c

create_clock -name "Clk" -period 100.0 -waveform {0.0 50.0} [get_ports clk]
set_clock_transition 0.15 [get_clocks Clk]
set_load -pin_load 0.5 [get_ports clk]
set_load -pin_load 0.5 [get_ports rstn]
set_load -pin_load 0.5 [get_ports tpu_we]
set_load -pin_load 0.5 [get_ports {tpu_addr[8]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[7]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[6]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[5]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[4]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[3]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[2]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[1]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[0]}]
set_load -pin_load 0.5 [get_ports {tpu_din[63]}]
set_load -pin_load 0.5 [get_ports {tpu_din[62]}]
set_load -pin_load 0.5 [get_ports {tpu_din[61]}]
set_load -pin_load 0.5 [get_ports {tpu_din[60]}]
set_load -pin_load 0.5 [get_ports {tpu_din[59]}]
set_load -pin_load 0.5 [get_ports {tpu_din[58]}]
set_load -pin_load 0.5 [get_ports {tpu_din[57]}]
set_load -pin_load 0.5 [get_ports {tpu_din[56]}]
set_load -pin_load 0.5 [get_ports {tpu_din[55]}]
set_load -pin_load 0.5 [get_ports {tpu_din[54]}]
set_load -pin_load 0.5 [get_ports {tpu_din[53]}]
set_load -pin_load 0.5 [get_ports {tpu_din[52]}]
set_load -pin_load 0.5 [get_ports {tpu_din[51]}]
set_load -pin_load 0.5 [get_ports {tpu_din[50]}]
set_load -pin_load 0.5 [get_ports {tpu_din[49]}]
set_load -pin_load 0.5 [get_ports {tpu_din[48]}]
set_load -pin_load 0.5 [get_ports {tpu_din[47]}]
set_load -pin_load 0.5 [get_ports {tpu_din[46]}]
set_load -pin_load 0.5 [get_ports {tpu_din[45]}]
set_load -pin_load 0.5 [get_ports {tpu_din[44]}]
set_load -pin_load 0.5 [get_ports {tpu_din[43]}]
set_load -pin_load 0.5 [get_ports {tpu_din[42]}]
set_load -pin_load 0.5 [get_ports {tpu_din[41]}]
set_load -pin_load 0.5 [get_ports {tpu_din[40]}]
set_load -pin_load 0.5 [get_ports {tpu_din[39]}]
set_load -pin_load 0.5 [get_ports {tpu_din[38]}]
set_load -pin_load 0.5 [get_ports {tpu_din[37]}]
set_load -pin_load 0.5 [get_ports {tpu_din[36]}]
set_load -pin_load 0.5 [get_ports {tpu_din[35]}]
set_load -pin_load 0.5 [get_ports {tpu_din[34]}]
set_load -pin_load 0.5 [get_ports {tpu_din[33]}]
set_load -pin_load 0.5 [get_ports {tpu_din[32]}]
set_load -pin_load 0.5 [get_ports {tpu_din[31]}]
set_load -pin_load 0.5 [get_ports {tpu_din[30]}]
set_load -pin_load 0.5 [get_ports {tpu_din[29]}]
set_load -pin_load 0.5 [get_ports {tpu_din[28]}]
set_load -pin_load 0.5 [get_ports {tpu_din[27]}]
set_load -pin_load 0.5 [get_ports {tpu_din[26]}]
set_load -pin_load 0.5 [get_ports {tpu_din[25]}]
set_load -pin_load 0.5 [get_ports {tpu_din[24]}]
set_load -pin_load 0.5 [get_ports {tpu_din[23]}]
set_load -pin_load 0.5 [get_ports {tpu_din[22]}]
set_load -pin_load 0.5 [get_ports {tpu_din[21]}]
set_load -pin_load 0.5 [get_ports {tpu_din[20]}]
set_load -pin_load 0.5 [get_ports {tpu_din[19]}]
set_load -pin_load 0.5 [get_ports {tpu_din[18]}]
set_load -pin_load 0.5 [get_ports {tpu_din[17]}]
set_load -pin_load 0.5 [get_ports {tpu_din[16]}]
set_load -pin_load 0.5 [get_ports {tpu_din[15]}]
set_load -pin_load 0.5 [get_ports {tpu_din[14]}]
set_load -pin_load 0.5 [get_ports {tpu_din[13]}]
set_load -pin_load 0.5 [get_ports {tpu_din[12]}]
set_load -pin_load 0.5 [get_ports {tpu_din[11]}]
set_load -pin_load 0.5 [get_ports {tpu_din[10]}]
set_load -pin_load 0.5 [get_ports {tpu_din[9]}]
set_load -pin_load 0.5 [get_ports {tpu_din[8]}]
set_load -pin_load 0.5 [get_ports {tpu_din[7]}]
set_load -pin_load 0.5 [get_ports {tpu_din[6]}]
set_load -pin_load 0.5 [get_ports {tpu_din[5]}]
set_load -pin_load 0.5 [get_ports {tpu_din[4]}]
set_load -pin_load 0.5 [get_ports {tpu_din[3]}]
set_load -pin_load 0.5 [get_ports {tpu_din[2]}]
set_load -pin_load 0.5 [get_ports {tpu_din[1]}]
set_load -pin_load 0.5 [get_ports {tpu_din[0]}]
set_load -pin_load 0.5 [get_ports bus_re]
set_load -pin_load 0.5 [get_ports {bus_addr[11]}]
set_load -pin_load 0.5 [get_ports {bus_addr[10]}]
set_load -pin_load 0.5 [get_ports {bus_addr[9]}]
set_load -pin_load 0.5 [get_ports {bus_addr[8]}]
set_load -pin_load 0.5 [get_ports {bus_addr[7]}]
set_load -pin_load 0.5 [get_ports {bus_addr[6]}]
set_load -pin_load 0.5 [get_ports {bus_addr[5]}]
set_load -pin_load 0.5 [get_ports {bus_addr[4]}]
set_load -pin_load 0.5 [get_ports {bus_addr[3]}]
set_load -pin_load 0.5 [get_ports {bus_addr[2]}]
set_load -pin_load 0.5 [get_ports {bus_addr[1]}]
set_load -pin_load 0.5 [get_ports {bus_addr[0]}]
set_load -pin_load 0.5 [get_ports {bus_dout[7]}]
set_load -pin_load 0.5 [get_ports {bus_dout[6]}]
set_load -pin_load 0.5 [get_ports {bus_dout[5]}]
set_load -pin_load 0.5 [get_ports {bus_dout[4]}]
set_load -pin_load 0.5 [get_ports {bus_dout[3]}]
set_load -pin_load 0.5 [get_ports {bus_dout[2]}]
set_load -pin_load 0.5 [get_ports {bus_dout[1]}]
set_load -pin_load 0.5 [get_ports {bus_dout[0]}]
group_path -weight 1.000000 -name C2O -from [list \
  [get_cells u_sram]  \
  [get_cells {bus_byte_sel_d1_reg[2]}]  \
  [get_cells {bus_byte_sel_d1_reg[1]}]  \
  [get_cells {bus_byte_sel_d1_reg[0]}] ] -to [list \
  [get_ports {bus_dout[7]}]  \
  [get_ports {bus_dout[6]}]  \
  [get_ports {bus_dout[5]}]  \
  [get_ports {bus_dout[4]}]  \
  [get_ports {bus_dout[3]}]  \
  [get_ports {bus_dout[2]}]  \
  [get_ports {bus_dout[1]}]  \
  [get_ports {bus_dout[0]}] ]
group_path -weight 1.000000 -name I2C -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports tpu_we]  \
  [get_ports {tpu_addr[8]}]  \
  [get_ports {tpu_addr[7]}]  \
  [get_ports {tpu_addr[6]}]  \
  [get_ports {tpu_addr[5]}]  \
  [get_ports {tpu_addr[4]}]  \
  [get_ports {tpu_addr[3]}]  \
  [get_ports {tpu_addr[2]}]  \
  [get_ports {tpu_addr[1]}]  \
  [get_ports {tpu_addr[0]}]  \
  [get_ports {tpu_din[63]}]  \
  [get_ports {tpu_din[62]}]  \
  [get_ports {tpu_din[61]}]  \
  [get_ports {tpu_din[60]}]  \
  [get_ports {tpu_din[59]}]  \
  [get_ports {tpu_din[58]}]  \
  [get_ports {tpu_din[57]}]  \
  [get_ports {tpu_din[56]}]  \
  [get_ports {tpu_din[55]}]  \
  [get_ports {tpu_din[54]}]  \
  [get_ports {tpu_din[53]}]  \
  [get_ports {tpu_din[52]}]  \
  [get_ports {tpu_din[51]}]  \
  [get_ports {tpu_din[50]}]  \
  [get_ports {tpu_din[49]}]  \
  [get_ports {tpu_din[48]}]  \
  [get_ports {tpu_din[47]}]  \
  [get_ports {tpu_din[46]}]  \
  [get_ports {tpu_din[45]}]  \
  [get_ports {tpu_din[44]}]  \
  [get_ports {tpu_din[43]}]  \
  [get_ports {tpu_din[42]}]  \
  [get_ports {tpu_din[41]}]  \
  [get_ports {tpu_din[40]}]  \
  [get_ports {tpu_din[39]}]  \
  [get_ports {tpu_din[38]}]  \
  [get_ports {tpu_din[37]}]  \
  [get_ports {tpu_din[36]}]  \
  [get_ports {tpu_din[35]}]  \
  [get_ports {tpu_din[34]}]  \
  [get_ports {tpu_din[33]}]  \
  [get_ports {tpu_din[32]}]  \
  [get_ports {tpu_din[31]}]  \
  [get_ports {tpu_din[30]}]  \
  [get_ports {tpu_din[29]}]  \
  [get_ports {tpu_din[28]}]  \
  [get_ports {tpu_din[27]}]  \
  [get_ports {tpu_din[26]}]  \
  [get_ports {tpu_din[25]}]  \
  [get_ports {tpu_din[24]}]  \
  [get_ports {tpu_din[23]}]  \
  [get_ports {tpu_din[22]}]  \
  [get_ports {tpu_din[21]}]  \
  [get_ports {tpu_din[20]}]  \
  [get_ports {tpu_din[19]}]  \
  [get_ports {tpu_din[18]}]  \
  [get_ports {tpu_din[17]}]  \
  [get_ports {tpu_din[16]}]  \
  [get_ports {tpu_din[15]}]  \
  [get_ports {tpu_din[14]}]  \
  [get_ports {tpu_din[13]}]  \
  [get_ports {tpu_din[12]}]  \
  [get_ports {tpu_din[11]}]  \
  [get_ports {tpu_din[10]}]  \
  [get_ports {tpu_din[9]}]  \
  [get_ports {tpu_din[8]}]  \
  [get_ports {tpu_din[7]}]  \
  [get_ports {tpu_din[6]}]  \
  [get_ports {tpu_din[5]}]  \
  [get_ports {tpu_din[4]}]  \
  [get_ports {tpu_din[3]}]  \
  [get_ports {tpu_din[2]}]  \
  [get_ports {tpu_din[1]}]  \
  [get_ports {tpu_din[0]}]  \
  [get_ports bus_re]  \
  [get_ports {bus_addr[11]}]  \
  [get_ports {bus_addr[10]}]  \
  [get_ports {bus_addr[9]}]  \
  [get_ports {bus_addr[8]}]  \
  [get_ports {bus_addr[7]}]  \
  [get_ports {bus_addr[6]}]  \
  [get_ports {bus_addr[5]}]  \
  [get_ports {bus_addr[4]}]  \
  [get_ports {bus_addr[3]}]  \
  [get_ports {bus_addr[2]}]  \
  [get_ports {bus_addr[1]}]  \
  [get_ports {bus_addr[0]}] ] -to [list \
  [get_cells u_sram]  \
  [get_cells {bus_byte_sel_d1_reg[2]}]  \
  [get_cells {bus_byte_sel_d1_reg[1]}]  \
  [get_cells {bus_byte_sel_d1_reg[0]}] ]
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports tpu_we]  \
  [get_ports {tpu_addr[8]}]  \
  [get_ports {tpu_addr[7]}]  \
  [get_ports {tpu_addr[6]}]  \
  [get_ports {tpu_addr[5]}]  \
  [get_ports {tpu_addr[4]}]  \
  [get_ports {tpu_addr[3]}]  \
  [get_ports {tpu_addr[2]}]  \
  [get_ports {tpu_addr[1]}]  \
  [get_ports {tpu_addr[0]}]  \
  [get_ports {tpu_din[63]}]  \
  [get_ports {tpu_din[62]}]  \
  [get_ports {tpu_din[61]}]  \
  [get_ports {tpu_din[60]}]  \
  [get_ports {tpu_din[59]}]  \
  [get_ports {tpu_din[58]}]  \
  [get_ports {tpu_din[57]}]  \
  [get_ports {tpu_din[56]}]  \
  [get_ports {tpu_din[55]}]  \
  [get_ports {tpu_din[54]}]  \
  [get_ports {tpu_din[53]}]  \
  [get_ports {tpu_din[52]}]  \
  [get_ports {tpu_din[51]}]  \
  [get_ports {tpu_din[50]}]  \
  [get_ports {tpu_din[49]}]  \
  [get_ports {tpu_din[48]}]  \
  [get_ports {tpu_din[47]}]  \
  [get_ports {tpu_din[46]}]  \
  [get_ports {tpu_din[45]}]  \
  [get_ports {tpu_din[44]}]  \
  [get_ports {tpu_din[43]}]  \
  [get_ports {tpu_din[42]}]  \
  [get_ports {tpu_din[41]}]  \
  [get_ports {tpu_din[40]}]  \
  [get_ports {tpu_din[39]}]  \
  [get_ports {tpu_din[38]}]  \
  [get_ports {tpu_din[37]}]  \
  [get_ports {tpu_din[36]}]  \
  [get_ports {tpu_din[35]}]  \
  [get_ports {tpu_din[34]}]  \
  [get_ports {tpu_din[33]}]  \
  [get_ports {tpu_din[32]}]  \
  [get_ports {tpu_din[31]}]  \
  [get_ports {tpu_din[30]}]  \
  [get_ports {tpu_din[29]}]  \
  [get_ports {tpu_din[28]}]  \
  [get_ports {tpu_din[27]}]  \
  [get_ports {tpu_din[26]}]  \
  [get_ports {tpu_din[25]}]  \
  [get_ports {tpu_din[24]}]  \
  [get_ports {tpu_din[23]}]  \
  [get_ports {tpu_din[22]}]  \
  [get_ports {tpu_din[21]}]  \
  [get_ports {tpu_din[20]}]  \
  [get_ports {tpu_din[19]}]  \
  [get_ports {tpu_din[18]}]  \
  [get_ports {tpu_din[17]}]  \
  [get_ports {tpu_din[16]}]  \
  [get_ports {tpu_din[15]}]  \
  [get_ports {tpu_din[14]}]  \
  [get_ports {tpu_din[13]}]  \
  [get_ports {tpu_din[12]}]  \
  [get_ports {tpu_din[11]}]  \
  [get_ports {tpu_din[10]}]  \
  [get_ports {tpu_din[9]}]  \
  [get_ports {tpu_din[8]}]  \
  [get_ports {tpu_din[7]}]  \
  [get_ports {tpu_din[6]}]  \
  [get_ports {tpu_din[5]}]  \
  [get_ports {tpu_din[4]}]  \
  [get_ports {tpu_din[3]}]  \
  [get_ports {tpu_din[2]}]  \
  [get_ports {tpu_din[1]}]  \
  [get_ports {tpu_din[0]}]  \
  [get_ports bus_re]  \
  [get_ports {bus_addr[11]}]  \
  [get_ports {bus_addr[10]}]  \
  [get_ports {bus_addr[9]}]  \
  [get_ports {bus_addr[8]}]  \
  [get_ports {bus_addr[7]}]  \
  [get_ports {bus_addr[6]}]  \
  [get_ports {bus_addr[5]}]  \
  [get_ports {bus_addr[4]}]  \
  [get_ports {bus_addr[3]}]  \
  [get_ports {bus_addr[2]}]  \
  [get_ports {bus_addr[1]}]  \
  [get_ports {bus_addr[0]}] ] -to [list \
  [get_ports {bus_dout[7]}]  \
  [get_ports {bus_dout[6]}]  \
  [get_ports {bus_dout[5]}]  \
  [get_ports {bus_dout[4]}]  \
  [get_ports {bus_dout[3]}]  \
  [get_ports {bus_dout[2]}]  \
  [get_ports {bus_dout[1]}]  \
  [get_ports {bus_dout[0]}] ]
group_path -weight 1.000000 -name C2C -from [list \
  [get_cells u_sram]  \
  [get_cells {bus_byte_sel_d1_reg[2]}]  \
  [get_cells {bus_byte_sel_d1_reg[1]}]  \
  [get_cells {bus_byte_sel_d1_reg[0]}] ] -to [list \
  [get_cells u_sram]  \
  [get_cells {bus_byte_sel_d1_reg[2]}]  \
  [get_cells {bus_byte_sel_d1_reg[1]}]  \
  [get_cells {bus_byte_sel_d1_reg[0]}] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports tpu_we]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports bus_re]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports tpu_we]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports bus_re]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_addr[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {bus_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {bus_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {bus_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {bus_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {bus_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {bus_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {bus_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {bus_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_dout[0]}]
set_wire_load_mode "segmented"
set_clock_uncertainty -setup 0.15 [get_clocks Clk]
set_clock_uncertainty -hold 0.15 [get_clocks Clk]
