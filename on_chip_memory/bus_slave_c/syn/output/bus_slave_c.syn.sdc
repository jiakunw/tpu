# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.16-s062_1 on Thu Apr 02 20:22:56 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design bus_slave_c

create_clock -name "Clk" -period 100.0 -waveform {0.0 50.0} [get_ports BUS_CLK]
set_clock_transition 0.2 [get_clocks Clk]
set_load -pin_load 0.5 [get_ports BUS_CLK]
set_load -pin_load 0.5 [get_ports BUS_RST_N]
set_load -pin_load 0.5 [get_ports CHC_START]
set_load -pin_load 0.5 [get_ports CHC_RD]
set_load -pin_load 0.5 [get_ports {sram_c_dout[7]}]
set_load -pin_load 0.5 [get_ports {sram_c_dout[6]}]
set_load -pin_load 0.5 [get_ports {sram_c_dout[5]}]
set_load -pin_load 0.5 [get_ports {sram_c_dout[4]}]
set_load -pin_load 0.5 [get_ports {sram_c_dout[3]}]
set_load -pin_load 0.5 [get_ports {sram_c_dout[2]}]
set_load -pin_load 0.5 [get_ports {sram_c_dout[1]}]
set_load -pin_load 0.5 [get_ports {sram_c_dout[0]}]
set_load -pin_load 0.5 [get_ports {CHC_RDATA[7]}]
set_load -pin_load 0.5 [get_ports {CHC_RDATA[6]}]
set_load -pin_load 0.5 [get_ports {CHC_RDATA[5]}]
set_load -pin_load 0.5 [get_ports {CHC_RDATA[4]}]
set_load -pin_load 0.5 [get_ports {CHC_RDATA[3]}]
set_load -pin_load 0.5 [get_ports {CHC_RDATA[2]}]
set_load -pin_load 0.5 [get_ports {CHC_RDATA[1]}]
set_load -pin_load 0.5 [get_ports {CHC_RDATA[0]}]
set_load -pin_load 0.5 [get_ports sram_c_re]
set_load -pin_load 0.5 [get_ports {sram_c_addr[11]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[10]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[9]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[8]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[7]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[6]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[5]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[4]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[3]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[2]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[1]}]
set_load -pin_load 0.5 [get_ports {sram_c_addr[0]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[11]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[10]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[9]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[8]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[7]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[6]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[5]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[4]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[3]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[2]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[1]}]
set_load -pin_load 0.5 [get_ports {debug_cnt_c[0]}]
group_path -weight 1.000000 -name C2O -from [list \
  [get_cells {cnt_c_reg[11]}]  \
  [get_cells {cnt_c_reg[10]}]  \
  [get_cells {cnt_c_reg[9]}]  \
  [get_cells {cnt_c_reg[8]}]  \
  [get_cells {cnt_c_reg[7]}]  \
  [get_cells {cnt_c_reg[6]}]  \
  [get_cells {cnt_c_reg[5]}]  \
  [get_cells {cnt_c_reg[4]}]  \
  [get_cells {cnt_c_reg[3]}]  \
  [get_cells {cnt_c_reg[2]}]  \
  [get_cells {cnt_c_reg[0]}]  \
  [get_cells {cnt_c_reg[1]}]  \
  [get_cells chc_rd_s_reg] ] -to [list \
  [get_ports {CHC_RDATA[7]}]  \
  [get_ports {CHC_RDATA[6]}]  \
  [get_ports {CHC_RDATA[5]}]  \
  [get_ports {CHC_RDATA[4]}]  \
  [get_ports {CHC_RDATA[3]}]  \
  [get_ports {CHC_RDATA[2]}]  \
  [get_ports {CHC_RDATA[1]}]  \
  [get_ports {CHC_RDATA[0]}]  \
  [get_ports sram_c_re]  \
  [get_ports {sram_c_addr[11]}]  \
  [get_ports {sram_c_addr[10]}]  \
  [get_ports {sram_c_addr[9]}]  \
  [get_ports {sram_c_addr[8]}]  \
  [get_ports {sram_c_addr[7]}]  \
  [get_ports {sram_c_addr[6]}]  \
  [get_ports {sram_c_addr[5]}]  \
  [get_ports {sram_c_addr[4]}]  \
  [get_ports {sram_c_addr[3]}]  \
  [get_ports {sram_c_addr[2]}]  \
  [get_ports {sram_c_addr[1]}]  \
  [get_ports {sram_c_addr[0]}]  \
  [get_ports {debug_cnt_c[11]}]  \
  [get_ports {debug_cnt_c[10]}]  \
  [get_ports {debug_cnt_c[9]}]  \
  [get_ports {debug_cnt_c[8]}]  \
  [get_ports {debug_cnt_c[7]}]  \
  [get_ports {debug_cnt_c[6]}]  \
  [get_ports {debug_cnt_c[5]}]  \
  [get_ports {debug_cnt_c[4]}]  \
  [get_ports {debug_cnt_c[3]}]  \
  [get_ports {debug_cnt_c[2]}]  \
  [get_ports {debug_cnt_c[1]}]  \
  [get_ports {debug_cnt_c[0]}] ]
group_path -weight 1.000000 -name I2C -from [list \
  [get_ports BUS_CLK]  \
  [get_ports BUS_RST_N]  \
  [get_ports CHC_START]  \
  [get_ports CHC_RD]  \
  [get_ports {sram_c_dout[7]}]  \
  [get_ports {sram_c_dout[6]}]  \
  [get_ports {sram_c_dout[5]}]  \
  [get_ports {sram_c_dout[4]}]  \
  [get_ports {sram_c_dout[3]}]  \
  [get_ports {sram_c_dout[2]}]  \
  [get_ports {sram_c_dout[1]}]  \
  [get_ports {sram_c_dout[0]}] ] -to [list \
  [get_cells {cnt_c_reg[11]}]  \
  [get_cells {cnt_c_reg[10]}]  \
  [get_cells {cnt_c_reg[9]}]  \
  [get_cells {cnt_c_reg[8]}]  \
  [get_cells {cnt_c_reg[7]}]  \
  [get_cells {cnt_c_reg[6]}]  \
  [get_cells {cnt_c_reg[5]}]  \
  [get_cells {cnt_c_reg[4]}]  \
  [get_cells {cnt_c_reg[3]}]  \
  [get_cells {cnt_c_reg[2]}]  \
  [get_cells {cnt_c_reg[0]}]  \
  [get_cells {cnt_c_reg[1]}]  \
  [get_cells chc_rd_s_reg] ]
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports BUS_CLK]  \
  [get_ports BUS_RST_N]  \
  [get_ports CHC_START]  \
  [get_ports CHC_RD]  \
  [get_ports {sram_c_dout[7]}]  \
  [get_ports {sram_c_dout[6]}]  \
  [get_ports {sram_c_dout[5]}]  \
  [get_ports {sram_c_dout[4]}]  \
  [get_ports {sram_c_dout[3]}]  \
  [get_ports {sram_c_dout[2]}]  \
  [get_ports {sram_c_dout[1]}]  \
  [get_ports {sram_c_dout[0]}] ] -to [list \
  [get_ports {CHC_RDATA[7]}]  \
  [get_ports {CHC_RDATA[6]}]  \
  [get_ports {CHC_RDATA[5]}]  \
  [get_ports {CHC_RDATA[4]}]  \
  [get_ports {CHC_RDATA[3]}]  \
  [get_ports {CHC_RDATA[2]}]  \
  [get_ports {CHC_RDATA[1]}]  \
  [get_ports {CHC_RDATA[0]}]  \
  [get_ports sram_c_re]  \
  [get_ports {sram_c_addr[11]}]  \
  [get_ports {sram_c_addr[10]}]  \
  [get_ports {sram_c_addr[9]}]  \
  [get_ports {sram_c_addr[8]}]  \
  [get_ports {sram_c_addr[7]}]  \
  [get_ports {sram_c_addr[6]}]  \
  [get_ports {sram_c_addr[5]}]  \
  [get_ports {sram_c_addr[4]}]  \
  [get_ports {sram_c_addr[3]}]  \
  [get_ports {sram_c_addr[2]}]  \
  [get_ports {sram_c_addr[1]}]  \
  [get_ports {sram_c_addr[0]}]  \
  [get_ports {debug_cnt_c[11]}]  \
  [get_ports {debug_cnt_c[10]}]  \
  [get_ports {debug_cnt_c[9]}]  \
  [get_ports {debug_cnt_c[8]}]  \
  [get_ports {debug_cnt_c[7]}]  \
  [get_ports {debug_cnt_c[6]}]  \
  [get_ports {debug_cnt_c[5]}]  \
  [get_ports {debug_cnt_c[4]}]  \
  [get_ports {debug_cnt_c[3]}]  \
  [get_ports {debug_cnt_c[2]}]  \
  [get_ports {debug_cnt_c[1]}]  \
  [get_ports {debug_cnt_c[0]}] ]
group_path -weight 1.000000 -name C2C -from [list \
  [get_cells {cnt_c_reg[11]}]  \
  [get_cells {cnt_c_reg[10]}]  \
  [get_cells {cnt_c_reg[9]}]  \
  [get_cells {cnt_c_reg[8]}]  \
  [get_cells {cnt_c_reg[7]}]  \
  [get_cells {cnt_c_reg[6]}]  \
  [get_cells {cnt_c_reg[5]}]  \
  [get_cells {cnt_c_reg[4]}]  \
  [get_cells {cnt_c_reg[3]}]  \
  [get_cells {cnt_c_reg[2]}]  \
  [get_cells {cnt_c_reg[0]}]  \
  [get_cells {cnt_c_reg[1]}]  \
  [get_cells chc_rd_s_reg] ] -to [list \
  [get_cells {cnt_c_reg[11]}]  \
  [get_cells {cnt_c_reg[10]}]  \
  [get_cells {cnt_c_reg[9]}]  \
  [get_cells {cnt_c_reg[8]}]  \
  [get_cells {cnt_c_reg[7]}]  \
  [get_cells {cnt_c_reg[6]}]  \
  [get_cells {cnt_c_reg[5]}]  \
  [get_cells {cnt_c_reg[4]}]  \
  [get_cells {cnt_c_reg[3]}]  \
  [get_cells {cnt_c_reg[2]}]  \
  [get_cells {cnt_c_reg[0]}]  \
  [get_cells {cnt_c_reg[1]}]  \
  [get_cells chc_rd_s_reg] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports BUS_RST_N]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports CHC_START]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports CHC_RD]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports {sram_c_dout[7]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports {sram_c_dout[6]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports {sram_c_dout[5]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports {sram_c_dout[4]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports {sram_c_dout[3]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports {sram_c_dout[2]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports {sram_c_dout[1]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -max 0.25 [get_ports {sram_c_dout[0]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports BUS_RST_N]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports CHC_START]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports CHC_RD]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports {sram_c_dout[7]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports {sram_c_dout[6]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports {sram_c_dout[5]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports {sram_c_dout[4]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports {sram_c_dout[3]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports {sram_c_dout[2]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports {sram_c_dout[1]}]
set_input_delay -clock [get_clocks Clk] -clock_fall -add_delay -min 0.2 [get_ports {sram_c_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {CHC_RDATA[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {CHC_RDATA[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {CHC_RDATA[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {CHC_RDATA[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {CHC_RDATA[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {CHC_RDATA[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {CHC_RDATA[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {CHC_RDATA[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports sram_c_re]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {sram_c_addr[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 25.0 [get_ports {debug_cnt_c[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {CHC_RDATA[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {CHC_RDATA[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {CHC_RDATA[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {CHC_RDATA[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {CHC_RDATA[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {CHC_RDATA[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {CHC_RDATA[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {CHC_RDATA[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sram_c_re]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sram_c_addr[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {debug_cnt_c[0]}]
set_wire_load_mode "segmented"
set_clock_uncertainty -setup 0.2 [get_clocks Clk]
set_clock_uncertainty -hold 0.2 [get_clocks Clk]
