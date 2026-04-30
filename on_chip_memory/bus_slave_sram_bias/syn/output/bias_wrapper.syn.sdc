# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.16-s062_1 on Thu Apr 23 22:19:48 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design bias_wrapper

create_clock -name "Clk" -period 25.0 -waveform {0.0 12.5} [get_ports clk]
set_clock_transition 0.15 [get_clocks Clk]
set_load -pin_load 0.5 [get_ports clk]
set_load -pin_load 0.5 [get_ports rstn]
set_load -pin_load 0.5 [get_ports bus_we]
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
set_load -pin_load 0.5 [get_ports {bus_din[7]}]
set_load -pin_load 0.5 [get_ports {bus_din[6]}]
set_load -pin_load 0.5 [get_ports {bus_din[5]}]
set_load -pin_load 0.5 [get_ports {bus_din[4]}]
set_load -pin_load 0.5 [get_ports {bus_din[3]}]
set_load -pin_load 0.5 [get_ports {bus_din[2]}]
set_load -pin_load 0.5 [get_ports {bus_din[1]}]
set_load -pin_load 0.5 [get_ports {bus_din[0]}]
set_load -pin_load 0.5 [get_ports tpu_re]
set_load -pin_load 0.5 [get_ports {tpu_addr[8]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[7]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[6]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[5]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[4]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[3]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[2]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[1]}]
set_load -pin_load 0.5 [get_ports {tpu_addr[0]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[31]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[30]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[29]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[28]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[27]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[26]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[25]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[24]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[23]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[22]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[21]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[20]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[19]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[18]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[17]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[16]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[15]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[14]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[13]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[12]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[11]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[10]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[9]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[8]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[7]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[6]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[5]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[4]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[3]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[2]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[1]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[0]}]
group_path -weight 1.000000 -name C2O -from [list \
  [get_cells u_sram]  \
  [get_cells {bus_wbuf_reg[26]}]  \
  [get_cells {bus_wbuf_reg[25]}]  \
  [get_cells {bus_wbuf_reg[24]}]  \
  [get_cells {bus_wbuf_reg[27]}]  \
  [get_cells {bus_wbuf_reg[30]}]  \
  [get_cells {bus_wbuf_reg[29]}]  \
  [get_cells {bus_wbuf_reg[28]}]  \
  [get_cells {bus_wbuf_reg[31]}]  \
  [get_cells {bus_wbuf_reg[2]}]  \
  [get_cells {bus_wbuf_reg[13]}]  \
  [get_cells {bus_wbuf_reg[14]}]  \
  [get_cells {bus_wbuf_reg[15]}]  \
  [get_cells {bus_wbuf_reg[0]}]  \
  [get_cells {bus_wbuf_reg[1]}]  \
  [get_cells {bus_wbuf_reg[12]}]  \
  [get_cells {bus_wbuf_reg[4]}]  \
  [get_cells {bus_wbuf_reg[3]}]  \
  [get_cells {bus_wbuf_reg[6]}]  \
  [get_cells {bus_wbuf_reg[5]}]  \
  [get_cells {bus_wbuf_reg[7]}]  \
  [get_cells {bus_wbuf_reg[10]}]  \
  [get_cells {bus_wbuf_reg[11]}]  \
  [get_cells {bus_wbuf_reg[8]}]  \
  [get_cells {bus_wbuf_reg[9]}]  \
  [get_cells {bus_wbuf_reg[20]}]  \
  [get_cells {bus_wbuf_reg[21]}]  \
  [get_cells {bus_wbuf_reg[16]}]  \
  [get_cells {bus_wbuf_reg[23]}]  \
  [get_cells {bus_wbuf_reg[22]}]  \
  [get_cells {bus_wbuf_reg[17]}]  \
  [get_cells {bus_wbuf_reg[18]}]  \
  [get_cells {bus_wbuf_reg[19]}]  \
  [get_cells {last_word_addr_reg[8]}]  \
  [get_cells {last_word_addr_reg[0]}]  \
  [get_cells {last_word_addr_reg[1]}]  \
  [get_cells {last_word_addr_reg[2]}]  \
  [get_cells {last_word_addr_reg[3]}]  \
  [get_cells {last_word_addr_reg[4]}]  \
  [get_cells {last_word_addr_reg[5]}]  \
  [get_cells {last_word_addr_reg[6]}]  \
  [get_cells {last_word_addr_reg[7]}]  \
  [get_cells {last_byte_sel_reg[0]}]  \
  [get_cells {last_byte_sel_reg[1]}]  \
  [get_cells flush_d1_reg]  \
  [get_cells bus_we_d1_reg]  \
  [get_cells {bus_waddr_d1_reg[1]}]  \
  [get_cells {flush_addr_reg[1]}]  \
  [get_cells {bus_waddr_d1_reg[5]}]  \
  [get_cells {flush_addr_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[8]}]  \
  [get_cells {flush_addr_reg[4]}]  \
  [get_cells {flush_addr_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[4]}]  \
  [get_cells {flush_addr_reg[3]}]  \
  [get_cells {flush_addr_reg[8]}]  \
  [get_cells {bus_waddr_d1_reg[3]}]  \
  [get_cells bus_we_prev_reg]  \
  [get_cells {bus_waddr_d1_reg[6]}]  \
  [get_cells {flush_addr_reg[2]}]  \
  [get_cells {flush_addr_reg[6]}]  \
  [get_cells {bus_waddr_d1_reg[2]}]  \
  [get_cells {flush_addr_reg[5]}] ] -to [list \
  [get_ports {tpu_dout[31]}]  \
  [get_ports {tpu_dout[30]}]  \
  [get_ports {tpu_dout[29]}]  \
  [get_ports {tpu_dout[28]}]  \
  [get_ports {tpu_dout[27]}]  \
  [get_ports {tpu_dout[26]}]  \
  [get_ports {tpu_dout[25]}]  \
  [get_ports {tpu_dout[24]}]  \
  [get_ports {tpu_dout[23]}]  \
  [get_ports {tpu_dout[22]}]  \
  [get_ports {tpu_dout[21]}]  \
  [get_ports {tpu_dout[20]}]  \
  [get_ports {tpu_dout[19]}]  \
  [get_ports {tpu_dout[18]}]  \
  [get_ports {tpu_dout[17]}]  \
  [get_ports {tpu_dout[16]}]  \
  [get_ports {tpu_dout[15]}]  \
  [get_ports {tpu_dout[14]}]  \
  [get_ports {tpu_dout[13]}]  \
  [get_ports {tpu_dout[12]}]  \
  [get_ports {tpu_dout[11]}]  \
  [get_ports {tpu_dout[10]}]  \
  [get_ports {tpu_dout[9]}]  \
  [get_ports {tpu_dout[8]}]  \
  [get_ports {tpu_dout[7]}]  \
  [get_ports {tpu_dout[6]}]  \
  [get_ports {tpu_dout[5]}]  \
  [get_ports {tpu_dout[4]}]  \
  [get_ports {tpu_dout[3]}]  \
  [get_ports {tpu_dout[2]}]  \
  [get_ports {tpu_dout[1]}]  \
  [get_ports {tpu_dout[0]}] ]
group_path -weight 1.000000 -name I2C -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports bus_we]  \
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
  [get_ports {bus_addr[0]}]  \
  [get_ports {bus_din[7]}]  \
  [get_ports {bus_din[6]}]  \
  [get_ports {bus_din[5]}]  \
  [get_ports {bus_din[4]}]  \
  [get_ports {bus_din[3]}]  \
  [get_ports {bus_din[2]}]  \
  [get_ports {bus_din[1]}]  \
  [get_ports {bus_din[0]}]  \
  [get_ports tpu_re]  \
  [get_ports {tpu_addr[8]}]  \
  [get_ports {tpu_addr[7]}]  \
  [get_ports {tpu_addr[6]}]  \
  [get_ports {tpu_addr[5]}]  \
  [get_ports {tpu_addr[4]}]  \
  [get_ports {tpu_addr[3]}]  \
  [get_ports {tpu_addr[2]}]  \
  [get_ports {tpu_addr[1]}]  \
  [get_ports {tpu_addr[0]}] ] -to [list \
  [get_cells u_sram]  \
  [get_cells {bus_wbuf_reg[26]}]  \
  [get_cells {bus_wbuf_reg[25]}]  \
  [get_cells {bus_wbuf_reg[24]}]  \
  [get_cells {bus_wbuf_reg[27]}]  \
  [get_cells {bus_wbuf_reg[30]}]  \
  [get_cells {bus_wbuf_reg[29]}]  \
  [get_cells {bus_wbuf_reg[28]}]  \
  [get_cells {bus_wbuf_reg[31]}]  \
  [get_cells {bus_wbuf_reg[2]}]  \
  [get_cells {bus_wbuf_reg[13]}]  \
  [get_cells {bus_wbuf_reg[14]}]  \
  [get_cells {bus_wbuf_reg[15]}]  \
  [get_cells {bus_wbuf_reg[0]}]  \
  [get_cells {bus_wbuf_reg[1]}]  \
  [get_cells {bus_wbuf_reg[12]}]  \
  [get_cells {bus_wbuf_reg[4]}]  \
  [get_cells {bus_wbuf_reg[3]}]  \
  [get_cells {bus_wbuf_reg[6]}]  \
  [get_cells {bus_wbuf_reg[5]}]  \
  [get_cells {bus_wbuf_reg[7]}]  \
  [get_cells {bus_wbuf_reg[10]}]  \
  [get_cells {bus_wbuf_reg[11]}]  \
  [get_cells {bus_wbuf_reg[8]}]  \
  [get_cells {bus_wbuf_reg[9]}]  \
  [get_cells {bus_wbuf_reg[20]}]  \
  [get_cells {bus_wbuf_reg[21]}]  \
  [get_cells {bus_wbuf_reg[16]}]  \
  [get_cells {bus_wbuf_reg[23]}]  \
  [get_cells {bus_wbuf_reg[22]}]  \
  [get_cells {bus_wbuf_reg[17]}]  \
  [get_cells {bus_wbuf_reg[18]}]  \
  [get_cells {bus_wbuf_reg[19]}]  \
  [get_cells {last_word_addr_reg[8]}]  \
  [get_cells {last_word_addr_reg[0]}]  \
  [get_cells {last_word_addr_reg[1]}]  \
  [get_cells {last_word_addr_reg[2]}]  \
  [get_cells {last_word_addr_reg[3]}]  \
  [get_cells {last_word_addr_reg[4]}]  \
  [get_cells {last_word_addr_reg[5]}]  \
  [get_cells {last_word_addr_reg[6]}]  \
  [get_cells {last_word_addr_reg[7]}]  \
  [get_cells {last_byte_sel_reg[0]}]  \
  [get_cells {last_byte_sel_reg[1]}]  \
  [get_cells flush_d1_reg]  \
  [get_cells bus_we_d1_reg]  \
  [get_cells {bus_waddr_d1_reg[1]}]  \
  [get_cells {flush_addr_reg[1]}]  \
  [get_cells {bus_waddr_d1_reg[5]}]  \
  [get_cells {flush_addr_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[8]}]  \
  [get_cells {flush_addr_reg[4]}]  \
  [get_cells {flush_addr_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[4]}]  \
  [get_cells {flush_addr_reg[3]}]  \
  [get_cells {flush_addr_reg[8]}]  \
  [get_cells {bus_waddr_d1_reg[3]}]  \
  [get_cells bus_we_prev_reg]  \
  [get_cells {bus_waddr_d1_reg[6]}]  \
  [get_cells {flush_addr_reg[2]}]  \
  [get_cells {flush_addr_reg[6]}]  \
  [get_cells {bus_waddr_d1_reg[2]}]  \
  [get_cells {flush_addr_reg[5]}] ]
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports bus_we]  \
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
  [get_ports {bus_addr[0]}]  \
  [get_ports {bus_din[7]}]  \
  [get_ports {bus_din[6]}]  \
  [get_ports {bus_din[5]}]  \
  [get_ports {bus_din[4]}]  \
  [get_ports {bus_din[3]}]  \
  [get_ports {bus_din[2]}]  \
  [get_ports {bus_din[1]}]  \
  [get_ports {bus_din[0]}]  \
  [get_ports tpu_re]  \
  [get_ports {tpu_addr[8]}]  \
  [get_ports {tpu_addr[7]}]  \
  [get_ports {tpu_addr[6]}]  \
  [get_ports {tpu_addr[5]}]  \
  [get_ports {tpu_addr[4]}]  \
  [get_ports {tpu_addr[3]}]  \
  [get_ports {tpu_addr[2]}]  \
  [get_ports {tpu_addr[1]}]  \
  [get_ports {tpu_addr[0]}] ] -to [list \
  [get_ports {tpu_dout[31]}]  \
  [get_ports {tpu_dout[30]}]  \
  [get_ports {tpu_dout[29]}]  \
  [get_ports {tpu_dout[28]}]  \
  [get_ports {tpu_dout[27]}]  \
  [get_ports {tpu_dout[26]}]  \
  [get_ports {tpu_dout[25]}]  \
  [get_ports {tpu_dout[24]}]  \
  [get_ports {tpu_dout[23]}]  \
  [get_ports {tpu_dout[22]}]  \
  [get_ports {tpu_dout[21]}]  \
  [get_ports {tpu_dout[20]}]  \
  [get_ports {tpu_dout[19]}]  \
  [get_ports {tpu_dout[18]}]  \
  [get_ports {tpu_dout[17]}]  \
  [get_ports {tpu_dout[16]}]  \
  [get_ports {tpu_dout[15]}]  \
  [get_ports {tpu_dout[14]}]  \
  [get_ports {tpu_dout[13]}]  \
  [get_ports {tpu_dout[12]}]  \
  [get_ports {tpu_dout[11]}]  \
  [get_ports {tpu_dout[10]}]  \
  [get_ports {tpu_dout[9]}]  \
  [get_ports {tpu_dout[8]}]  \
  [get_ports {tpu_dout[7]}]  \
  [get_ports {tpu_dout[6]}]  \
  [get_ports {tpu_dout[5]}]  \
  [get_ports {tpu_dout[4]}]  \
  [get_ports {tpu_dout[3]}]  \
  [get_ports {tpu_dout[2]}]  \
  [get_ports {tpu_dout[1]}]  \
  [get_ports {tpu_dout[0]}] ]
group_path -weight 1.000000 -name C2C -from [list \
  [get_cells u_sram]  \
  [get_cells {bus_wbuf_reg[26]}]  \
  [get_cells {bus_wbuf_reg[25]}]  \
  [get_cells {bus_wbuf_reg[24]}]  \
  [get_cells {bus_wbuf_reg[27]}]  \
  [get_cells {bus_wbuf_reg[30]}]  \
  [get_cells {bus_wbuf_reg[29]}]  \
  [get_cells {bus_wbuf_reg[28]}]  \
  [get_cells {bus_wbuf_reg[31]}]  \
  [get_cells {bus_wbuf_reg[2]}]  \
  [get_cells {bus_wbuf_reg[13]}]  \
  [get_cells {bus_wbuf_reg[14]}]  \
  [get_cells {bus_wbuf_reg[15]}]  \
  [get_cells {bus_wbuf_reg[0]}]  \
  [get_cells {bus_wbuf_reg[1]}]  \
  [get_cells {bus_wbuf_reg[12]}]  \
  [get_cells {bus_wbuf_reg[4]}]  \
  [get_cells {bus_wbuf_reg[3]}]  \
  [get_cells {bus_wbuf_reg[6]}]  \
  [get_cells {bus_wbuf_reg[5]}]  \
  [get_cells {bus_wbuf_reg[7]}]  \
  [get_cells {bus_wbuf_reg[10]}]  \
  [get_cells {bus_wbuf_reg[11]}]  \
  [get_cells {bus_wbuf_reg[8]}]  \
  [get_cells {bus_wbuf_reg[9]}]  \
  [get_cells {bus_wbuf_reg[20]}]  \
  [get_cells {bus_wbuf_reg[21]}]  \
  [get_cells {bus_wbuf_reg[16]}]  \
  [get_cells {bus_wbuf_reg[23]}]  \
  [get_cells {bus_wbuf_reg[22]}]  \
  [get_cells {bus_wbuf_reg[17]}]  \
  [get_cells {bus_wbuf_reg[18]}]  \
  [get_cells {bus_wbuf_reg[19]}]  \
  [get_cells {last_word_addr_reg[8]}]  \
  [get_cells {last_word_addr_reg[0]}]  \
  [get_cells {last_word_addr_reg[1]}]  \
  [get_cells {last_word_addr_reg[2]}]  \
  [get_cells {last_word_addr_reg[3]}]  \
  [get_cells {last_word_addr_reg[4]}]  \
  [get_cells {last_word_addr_reg[5]}]  \
  [get_cells {last_word_addr_reg[6]}]  \
  [get_cells {last_word_addr_reg[7]}]  \
  [get_cells {last_byte_sel_reg[0]}]  \
  [get_cells {last_byte_sel_reg[1]}]  \
  [get_cells flush_d1_reg]  \
  [get_cells bus_we_d1_reg]  \
  [get_cells {bus_waddr_d1_reg[1]}]  \
  [get_cells {flush_addr_reg[1]}]  \
  [get_cells {bus_waddr_d1_reg[5]}]  \
  [get_cells {flush_addr_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[8]}]  \
  [get_cells {flush_addr_reg[4]}]  \
  [get_cells {flush_addr_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[4]}]  \
  [get_cells {flush_addr_reg[3]}]  \
  [get_cells {flush_addr_reg[8]}]  \
  [get_cells {bus_waddr_d1_reg[3]}]  \
  [get_cells bus_we_prev_reg]  \
  [get_cells {bus_waddr_d1_reg[6]}]  \
  [get_cells {flush_addr_reg[2]}]  \
  [get_cells {flush_addr_reg[6]}]  \
  [get_cells {bus_waddr_d1_reg[2]}]  \
  [get_cells {flush_addr_reg[5]}] ] -to [list \
  [get_cells u_sram]  \
  [get_cells {bus_wbuf_reg[26]}]  \
  [get_cells {bus_wbuf_reg[25]}]  \
  [get_cells {bus_wbuf_reg[24]}]  \
  [get_cells {bus_wbuf_reg[27]}]  \
  [get_cells {bus_wbuf_reg[30]}]  \
  [get_cells {bus_wbuf_reg[29]}]  \
  [get_cells {bus_wbuf_reg[28]}]  \
  [get_cells {bus_wbuf_reg[31]}]  \
  [get_cells {bus_wbuf_reg[2]}]  \
  [get_cells {bus_wbuf_reg[13]}]  \
  [get_cells {bus_wbuf_reg[14]}]  \
  [get_cells {bus_wbuf_reg[15]}]  \
  [get_cells {bus_wbuf_reg[0]}]  \
  [get_cells {bus_wbuf_reg[1]}]  \
  [get_cells {bus_wbuf_reg[12]}]  \
  [get_cells {bus_wbuf_reg[4]}]  \
  [get_cells {bus_wbuf_reg[3]}]  \
  [get_cells {bus_wbuf_reg[6]}]  \
  [get_cells {bus_wbuf_reg[5]}]  \
  [get_cells {bus_wbuf_reg[7]}]  \
  [get_cells {bus_wbuf_reg[10]}]  \
  [get_cells {bus_wbuf_reg[11]}]  \
  [get_cells {bus_wbuf_reg[8]}]  \
  [get_cells {bus_wbuf_reg[9]}]  \
  [get_cells {bus_wbuf_reg[20]}]  \
  [get_cells {bus_wbuf_reg[21]}]  \
  [get_cells {bus_wbuf_reg[16]}]  \
  [get_cells {bus_wbuf_reg[23]}]  \
  [get_cells {bus_wbuf_reg[22]}]  \
  [get_cells {bus_wbuf_reg[17]}]  \
  [get_cells {bus_wbuf_reg[18]}]  \
  [get_cells {bus_wbuf_reg[19]}]  \
  [get_cells {last_word_addr_reg[8]}]  \
  [get_cells {last_word_addr_reg[0]}]  \
  [get_cells {last_word_addr_reg[1]}]  \
  [get_cells {last_word_addr_reg[2]}]  \
  [get_cells {last_word_addr_reg[3]}]  \
  [get_cells {last_word_addr_reg[4]}]  \
  [get_cells {last_word_addr_reg[5]}]  \
  [get_cells {last_word_addr_reg[6]}]  \
  [get_cells {last_word_addr_reg[7]}]  \
  [get_cells {last_byte_sel_reg[0]}]  \
  [get_cells {last_byte_sel_reg[1]}]  \
  [get_cells flush_d1_reg]  \
  [get_cells bus_we_d1_reg]  \
  [get_cells {bus_waddr_d1_reg[1]}]  \
  [get_cells {flush_addr_reg[1]}]  \
  [get_cells {bus_waddr_d1_reg[5]}]  \
  [get_cells {flush_addr_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[8]}]  \
  [get_cells {flush_addr_reg[4]}]  \
  [get_cells {flush_addr_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[4]}]  \
  [get_cells {flush_addr_reg[3]}]  \
  [get_cells {flush_addr_reg[8]}]  \
  [get_cells {bus_waddr_d1_reg[3]}]  \
  [get_cells bus_we_prev_reg]  \
  [get_cells {bus_waddr_d1_reg[6]}]  \
  [get_cells {flush_addr_reg[2]}]  \
  [get_cells {flush_addr_reg[6]}]  \
  [get_cells {bus_waddr_d1_reg[2]}]  \
  [get_cells {flush_addr_reg[5]}] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports bus_we]
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
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {bus_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports tpu_re]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports bus_we]
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
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {bus_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports tpu_re]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_addr[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[0]}]
set_wire_load_mode "segmented"
set_clock_uncertainty -setup 0.15 [get_clocks Clk]
set_clock_uncertainty -hold 0.15 [get_clocks Clk]
