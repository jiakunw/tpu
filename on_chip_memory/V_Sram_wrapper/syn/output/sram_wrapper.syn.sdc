# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.16-s062_1 on Tue Mar 31 23:32:31 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design sram_wrapper

create_clock -name "Clk" -period 25.0 -waveform {0.0 12.5} [get_ports clk]
set_clock_transition 0.15 [get_clocks Clk]
set_load -pin_load 0.5 [get_ports clk]
set_load -pin_load 0.5 [get_ports rstn]
set_load -pin_load 0.5 [get_ports bus_we]
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
set_load -pin_load 0.5 [get_ports {tpu_dout[63]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[62]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[61]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[60]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[59]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[58]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[57]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[56]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[55]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[54]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[53]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[52]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[51]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[50]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[49]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[48]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[47]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[46]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[45]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[44]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[43]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[42]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[41]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[40]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[39]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[38]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[37]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[36]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[35]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[34]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[33]}]
set_load -pin_load 0.5 [get_ports {tpu_dout[32]}]
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
  [get_cells {bus_wbuf_reg[0]}]  \
  [get_cells {bus_wbuf_reg[1]}]  \
  [get_cells {bus_wbuf_reg[2]}]  \
  [get_cells {bus_wbuf_reg[3]}]  \
  [get_cells {bus_wbuf_reg[4]}]  \
  [get_cells {bus_wbuf_reg[5]}]  \
  [get_cells {bus_wbuf_reg[6]}]  \
  [get_cells {bus_wbuf_reg[7]}]  \
  [get_cells {bus_wbuf_reg[8]}]  \
  [get_cells {bus_wbuf_reg[9]}]  \
  [get_cells {bus_wbuf_reg[10]}]  \
  [get_cells {bus_wbuf_reg[11]}]  \
  [get_cells {bus_wbuf_reg[12]}]  \
  [get_cells {bus_wbuf_reg[13]}]  \
  [get_cells {bus_wbuf_reg[14]}]  \
  [get_cells {bus_wbuf_reg[15]}]  \
  [get_cells {bus_wbuf_reg[16]}]  \
  [get_cells {bus_wbuf_reg[17]}]  \
  [get_cells {bus_wbuf_reg[18]}]  \
  [get_cells {bus_wbuf_reg[19]}]  \
  [get_cells {bus_wbuf_reg[20]}]  \
  [get_cells {bus_wbuf_reg[21]}]  \
  [get_cells {bus_wbuf_reg[22]}]  \
  [get_cells {bus_wbuf_reg[23]}]  \
  [get_cells {bus_wbuf_reg[24]}]  \
  [get_cells {bus_wbuf_reg[25]}]  \
  [get_cells {bus_wbuf_reg[26]}]  \
  [get_cells {bus_wbuf_reg[27]}]  \
  [get_cells {bus_wbuf_reg[28]}]  \
  [get_cells {bus_wbuf_reg[29]}]  \
  [get_cells {bus_wbuf_reg[30]}]  \
  [get_cells {bus_wbuf_reg[31]}]  \
  [get_cells {bus_wbuf_reg[32]}]  \
  [get_cells {bus_wbuf_reg[33]}]  \
  [get_cells {bus_wbuf_reg[34]}]  \
  [get_cells {bus_wbuf_reg[35]}]  \
  [get_cells {bus_wbuf_reg[36]}]  \
  [get_cells {bus_wbuf_reg[37]}]  \
  [get_cells {bus_wbuf_reg[38]}]  \
  [get_cells {bus_wbuf_reg[39]}]  \
  [get_cells {bus_wbuf_reg[40]}]  \
  [get_cells {bus_wbuf_reg[41]}]  \
  [get_cells {bus_wbuf_reg[42]}]  \
  [get_cells {bus_wbuf_reg[43]}]  \
  [get_cells {bus_wbuf_reg[44]}]  \
  [get_cells {bus_wbuf_reg[45]}]  \
  [get_cells {bus_wbuf_reg[46]}]  \
  [get_cells {bus_wbuf_reg[47]}]  \
  [get_cells {bus_wbuf_reg[48]}]  \
  [get_cells {bus_wbuf_reg[49]}]  \
  [get_cells {bus_wbuf_reg[50]}]  \
  [get_cells {bus_wbuf_reg[51]}]  \
  [get_cells {bus_wbuf_reg[52]}]  \
  [get_cells {bus_wbuf_reg[53]}]  \
  [get_cells {bus_wbuf_reg[54]}]  \
  [get_cells {bus_wbuf_reg[55]}]  \
  [get_cells {bus_wbuf_reg[56]}]  \
  [get_cells {bus_wbuf_reg[57]}]  \
  [get_cells {bus_wbuf_reg[58]}]  \
  [get_cells {bus_wbuf_reg[59]}]  \
  [get_cells {bus_wbuf_reg[60]}]  \
  [get_cells {bus_wbuf_reg[61]}]  \
  [get_cells {bus_wbuf_reg[62]}]  \
  [get_cells {bus_wbuf_reg[63]}]  \
  [get_cells sram_cen_ff_reg]  \
  [get_cells {bus_waddr_d1_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[1]}]  \
  [get_cells {bus_waddr_d1_reg[2]}]  \
  [get_cells {bus_waddr_d1_reg[3]}]  \
  [get_cells {bus_waddr_d1_reg[4]}]  \
  [get_cells {bus_waddr_d1_reg[5]}]  \
  [get_cells {bus_waddr_d1_reg[6]}]  \
  [get_cells {bus_waddr_d1_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[8]}]  \
  [get_cells {sram_addr_ff_reg[0]}]  \
  [get_cells {sram_addr_ff_reg[1]}]  \
  [get_cells {sram_addr_ff_reg[2]}]  \
  [get_cells {sram_addr_ff_reg[3]}]  \
  [get_cells {sram_addr_ff_reg[4]}]  \
  [get_cells {sram_addr_ff_reg[5]}]  \
  [get_cells {sram_addr_ff_reg[6]}]  \
  [get_cells {sram_addr_ff_reg[7]}]  \
  [get_cells {sram_addr_ff_reg[8]}]  \
  [get_cells {sram_din_ff_reg[0]}]  \
  [get_cells {sram_din_ff_reg[1]}]  \
  [get_cells {sram_din_ff_reg[2]}]  \
  [get_cells {sram_din_ff_reg[3]}]  \
  [get_cells {sram_din_ff_reg[4]}]  \
  [get_cells {sram_din_ff_reg[5]}]  \
  [get_cells {sram_din_ff_reg[6]}]  \
  [get_cells {sram_din_ff_reg[7]}]  \
  [get_cells {sram_din_ff_reg[8]}]  \
  [get_cells {sram_din_ff_reg[9]}]  \
  [get_cells {sram_din_ff_reg[10]}]  \
  [get_cells {sram_din_ff_reg[11]}]  \
  [get_cells {sram_din_ff_reg[12]}]  \
  [get_cells {sram_din_ff_reg[13]}]  \
  [get_cells {sram_din_ff_reg[14]}]  \
  [get_cells {sram_din_ff_reg[15]}]  \
  [get_cells {sram_din_ff_reg[16]}]  \
  [get_cells {sram_din_ff_reg[17]}]  \
  [get_cells {sram_din_ff_reg[18]}]  \
  [get_cells {sram_din_ff_reg[19]}]  \
  [get_cells {sram_din_ff_reg[20]}]  \
  [get_cells {sram_din_ff_reg[21]}]  \
  [get_cells {sram_din_ff_reg[22]}]  \
  [get_cells {sram_din_ff_reg[23]}]  \
  [get_cells {sram_din_ff_reg[24]}]  \
  [get_cells {sram_din_ff_reg[25]}]  \
  [get_cells {sram_din_ff_reg[26]}]  \
  [get_cells {sram_din_ff_reg[27]}]  \
  [get_cells {sram_din_ff_reg[28]}]  \
  [get_cells {sram_din_ff_reg[29]}]  \
  [get_cells {sram_din_ff_reg[30]}]  \
  [get_cells {sram_din_ff_reg[31]}]  \
  [get_cells {sram_din_ff_reg[32]}]  \
  [get_cells {sram_din_ff_reg[33]}]  \
  [get_cells {sram_din_ff_reg[34]}]  \
  [get_cells {sram_din_ff_reg[35]}]  \
  [get_cells {sram_din_ff_reg[36]}]  \
  [get_cells {sram_din_ff_reg[37]}]  \
  [get_cells {sram_din_ff_reg[38]}]  \
  [get_cells {sram_din_ff_reg[39]}]  \
  [get_cells {sram_din_ff_reg[40]}]  \
  [get_cells {sram_din_ff_reg[41]}]  \
  [get_cells {sram_din_ff_reg[42]}]  \
  [get_cells {sram_din_ff_reg[43]}]  \
  [get_cells {sram_din_ff_reg[44]}]  \
  [get_cells {sram_din_ff_reg[45]}]  \
  [get_cells {sram_din_ff_reg[46]}]  \
  [get_cells {sram_din_ff_reg[47]}]  \
  [get_cells {sram_din_ff_reg[48]}]  \
  [get_cells {sram_din_ff_reg[49]}]  \
  [get_cells {sram_din_ff_reg[50]}]  \
  [get_cells {sram_din_ff_reg[51]}]  \
  [get_cells {sram_din_ff_reg[52]}]  \
  [get_cells {sram_din_ff_reg[53]}]  \
  [get_cells {sram_din_ff_reg[54]}]  \
  [get_cells {sram_din_ff_reg[55]}]  \
  [get_cells {sram_din_ff_reg[56]}]  \
  [get_cells {sram_din_ff_reg[57]}]  \
  [get_cells {sram_din_ff_reg[58]}]  \
  [get_cells {sram_din_ff_reg[59]}]  \
  [get_cells {sram_din_ff_reg[60]}]  \
  [get_cells {sram_din_ff_reg[61]}]  \
  [get_cells {sram_din_ff_reg[62]}]  \
  [get_cells {sram_din_ff_reg[63]}]  \
  [get_cells bus_we_d1_reg] ] -to [list \
  [get_ports {tpu_dout[63]}]  \
  [get_ports {tpu_dout[62]}]  \
  [get_ports {tpu_dout[61]}]  \
  [get_ports {tpu_dout[60]}]  \
  [get_ports {tpu_dout[59]}]  \
  [get_ports {tpu_dout[58]}]  \
  [get_ports {tpu_dout[57]}]  \
  [get_ports {tpu_dout[56]}]  \
  [get_ports {tpu_dout[55]}]  \
  [get_ports {tpu_dout[54]}]  \
  [get_ports {tpu_dout[53]}]  \
  [get_ports {tpu_dout[52]}]  \
  [get_ports {tpu_dout[51]}]  \
  [get_ports {tpu_dout[50]}]  \
  [get_ports {tpu_dout[49]}]  \
  [get_ports {tpu_dout[48]}]  \
  [get_ports {tpu_dout[47]}]  \
  [get_ports {tpu_dout[46]}]  \
  [get_ports {tpu_dout[45]}]  \
  [get_ports {tpu_dout[44]}]  \
  [get_ports {tpu_dout[43]}]  \
  [get_ports {tpu_dout[42]}]  \
  [get_ports {tpu_dout[41]}]  \
  [get_ports {tpu_dout[40]}]  \
  [get_ports {tpu_dout[39]}]  \
  [get_ports {tpu_dout[38]}]  \
  [get_ports {tpu_dout[37]}]  \
  [get_ports {tpu_dout[36]}]  \
  [get_ports {tpu_dout[35]}]  \
  [get_ports {tpu_dout[34]}]  \
  [get_ports {tpu_dout[33]}]  \
  [get_ports {tpu_dout[32]}]  \
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
  [get_cells {bus_wbuf_reg[0]}]  \
  [get_cells {bus_wbuf_reg[1]}]  \
  [get_cells {bus_wbuf_reg[2]}]  \
  [get_cells {bus_wbuf_reg[3]}]  \
  [get_cells {bus_wbuf_reg[4]}]  \
  [get_cells {bus_wbuf_reg[5]}]  \
  [get_cells {bus_wbuf_reg[6]}]  \
  [get_cells {bus_wbuf_reg[7]}]  \
  [get_cells {bus_wbuf_reg[8]}]  \
  [get_cells {bus_wbuf_reg[9]}]  \
  [get_cells {bus_wbuf_reg[10]}]  \
  [get_cells {bus_wbuf_reg[11]}]  \
  [get_cells {bus_wbuf_reg[12]}]  \
  [get_cells {bus_wbuf_reg[13]}]  \
  [get_cells {bus_wbuf_reg[14]}]  \
  [get_cells {bus_wbuf_reg[15]}]  \
  [get_cells {bus_wbuf_reg[16]}]  \
  [get_cells {bus_wbuf_reg[17]}]  \
  [get_cells {bus_wbuf_reg[18]}]  \
  [get_cells {bus_wbuf_reg[19]}]  \
  [get_cells {bus_wbuf_reg[20]}]  \
  [get_cells {bus_wbuf_reg[21]}]  \
  [get_cells {bus_wbuf_reg[22]}]  \
  [get_cells {bus_wbuf_reg[23]}]  \
  [get_cells {bus_wbuf_reg[24]}]  \
  [get_cells {bus_wbuf_reg[25]}]  \
  [get_cells {bus_wbuf_reg[26]}]  \
  [get_cells {bus_wbuf_reg[27]}]  \
  [get_cells {bus_wbuf_reg[28]}]  \
  [get_cells {bus_wbuf_reg[29]}]  \
  [get_cells {bus_wbuf_reg[30]}]  \
  [get_cells {bus_wbuf_reg[31]}]  \
  [get_cells {bus_wbuf_reg[32]}]  \
  [get_cells {bus_wbuf_reg[33]}]  \
  [get_cells {bus_wbuf_reg[34]}]  \
  [get_cells {bus_wbuf_reg[35]}]  \
  [get_cells {bus_wbuf_reg[36]}]  \
  [get_cells {bus_wbuf_reg[37]}]  \
  [get_cells {bus_wbuf_reg[38]}]  \
  [get_cells {bus_wbuf_reg[39]}]  \
  [get_cells {bus_wbuf_reg[40]}]  \
  [get_cells {bus_wbuf_reg[41]}]  \
  [get_cells {bus_wbuf_reg[42]}]  \
  [get_cells {bus_wbuf_reg[43]}]  \
  [get_cells {bus_wbuf_reg[44]}]  \
  [get_cells {bus_wbuf_reg[45]}]  \
  [get_cells {bus_wbuf_reg[46]}]  \
  [get_cells {bus_wbuf_reg[47]}]  \
  [get_cells {bus_wbuf_reg[48]}]  \
  [get_cells {bus_wbuf_reg[49]}]  \
  [get_cells {bus_wbuf_reg[50]}]  \
  [get_cells {bus_wbuf_reg[51]}]  \
  [get_cells {bus_wbuf_reg[52]}]  \
  [get_cells {bus_wbuf_reg[53]}]  \
  [get_cells {bus_wbuf_reg[54]}]  \
  [get_cells {bus_wbuf_reg[55]}]  \
  [get_cells {bus_wbuf_reg[56]}]  \
  [get_cells {bus_wbuf_reg[57]}]  \
  [get_cells {bus_wbuf_reg[58]}]  \
  [get_cells {bus_wbuf_reg[59]}]  \
  [get_cells {bus_wbuf_reg[60]}]  \
  [get_cells {bus_wbuf_reg[61]}]  \
  [get_cells {bus_wbuf_reg[62]}]  \
  [get_cells {bus_wbuf_reg[63]}]  \
  [get_cells sram_cen_ff_reg]  \
  [get_cells {bus_waddr_d1_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[1]}]  \
  [get_cells {bus_waddr_d1_reg[2]}]  \
  [get_cells {bus_waddr_d1_reg[3]}]  \
  [get_cells {bus_waddr_d1_reg[4]}]  \
  [get_cells {bus_waddr_d1_reg[5]}]  \
  [get_cells {bus_waddr_d1_reg[6]}]  \
  [get_cells {bus_waddr_d1_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[8]}]  \
  [get_cells {sram_addr_ff_reg[0]}]  \
  [get_cells {sram_addr_ff_reg[1]}]  \
  [get_cells {sram_addr_ff_reg[2]}]  \
  [get_cells {sram_addr_ff_reg[3]}]  \
  [get_cells {sram_addr_ff_reg[4]}]  \
  [get_cells {sram_addr_ff_reg[5]}]  \
  [get_cells {sram_addr_ff_reg[6]}]  \
  [get_cells {sram_addr_ff_reg[7]}]  \
  [get_cells {sram_addr_ff_reg[8]}]  \
  [get_cells {sram_din_ff_reg[0]}]  \
  [get_cells {sram_din_ff_reg[1]}]  \
  [get_cells {sram_din_ff_reg[2]}]  \
  [get_cells {sram_din_ff_reg[3]}]  \
  [get_cells {sram_din_ff_reg[4]}]  \
  [get_cells {sram_din_ff_reg[5]}]  \
  [get_cells {sram_din_ff_reg[6]}]  \
  [get_cells {sram_din_ff_reg[7]}]  \
  [get_cells {sram_din_ff_reg[8]}]  \
  [get_cells {sram_din_ff_reg[9]}]  \
  [get_cells {sram_din_ff_reg[10]}]  \
  [get_cells {sram_din_ff_reg[11]}]  \
  [get_cells {sram_din_ff_reg[12]}]  \
  [get_cells {sram_din_ff_reg[13]}]  \
  [get_cells {sram_din_ff_reg[14]}]  \
  [get_cells {sram_din_ff_reg[15]}]  \
  [get_cells {sram_din_ff_reg[16]}]  \
  [get_cells {sram_din_ff_reg[17]}]  \
  [get_cells {sram_din_ff_reg[18]}]  \
  [get_cells {sram_din_ff_reg[19]}]  \
  [get_cells {sram_din_ff_reg[20]}]  \
  [get_cells {sram_din_ff_reg[21]}]  \
  [get_cells {sram_din_ff_reg[22]}]  \
  [get_cells {sram_din_ff_reg[23]}]  \
  [get_cells {sram_din_ff_reg[24]}]  \
  [get_cells {sram_din_ff_reg[25]}]  \
  [get_cells {sram_din_ff_reg[26]}]  \
  [get_cells {sram_din_ff_reg[27]}]  \
  [get_cells {sram_din_ff_reg[28]}]  \
  [get_cells {sram_din_ff_reg[29]}]  \
  [get_cells {sram_din_ff_reg[30]}]  \
  [get_cells {sram_din_ff_reg[31]}]  \
  [get_cells {sram_din_ff_reg[32]}]  \
  [get_cells {sram_din_ff_reg[33]}]  \
  [get_cells {sram_din_ff_reg[34]}]  \
  [get_cells {sram_din_ff_reg[35]}]  \
  [get_cells {sram_din_ff_reg[36]}]  \
  [get_cells {sram_din_ff_reg[37]}]  \
  [get_cells {sram_din_ff_reg[38]}]  \
  [get_cells {sram_din_ff_reg[39]}]  \
  [get_cells {sram_din_ff_reg[40]}]  \
  [get_cells {sram_din_ff_reg[41]}]  \
  [get_cells {sram_din_ff_reg[42]}]  \
  [get_cells {sram_din_ff_reg[43]}]  \
  [get_cells {sram_din_ff_reg[44]}]  \
  [get_cells {sram_din_ff_reg[45]}]  \
  [get_cells {sram_din_ff_reg[46]}]  \
  [get_cells {sram_din_ff_reg[47]}]  \
  [get_cells {sram_din_ff_reg[48]}]  \
  [get_cells {sram_din_ff_reg[49]}]  \
  [get_cells {sram_din_ff_reg[50]}]  \
  [get_cells {sram_din_ff_reg[51]}]  \
  [get_cells {sram_din_ff_reg[52]}]  \
  [get_cells {sram_din_ff_reg[53]}]  \
  [get_cells {sram_din_ff_reg[54]}]  \
  [get_cells {sram_din_ff_reg[55]}]  \
  [get_cells {sram_din_ff_reg[56]}]  \
  [get_cells {sram_din_ff_reg[57]}]  \
  [get_cells {sram_din_ff_reg[58]}]  \
  [get_cells {sram_din_ff_reg[59]}]  \
  [get_cells {sram_din_ff_reg[60]}]  \
  [get_cells {sram_din_ff_reg[61]}]  \
  [get_cells {sram_din_ff_reg[62]}]  \
  [get_cells {sram_din_ff_reg[63]}]  \
  [get_cells bus_we_d1_reg] ]
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports bus_we]  \
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
  [get_ports {tpu_dout[63]}]  \
  [get_ports {tpu_dout[62]}]  \
  [get_ports {tpu_dout[61]}]  \
  [get_ports {tpu_dout[60]}]  \
  [get_ports {tpu_dout[59]}]  \
  [get_ports {tpu_dout[58]}]  \
  [get_ports {tpu_dout[57]}]  \
  [get_ports {tpu_dout[56]}]  \
  [get_ports {tpu_dout[55]}]  \
  [get_ports {tpu_dout[54]}]  \
  [get_ports {tpu_dout[53]}]  \
  [get_ports {tpu_dout[52]}]  \
  [get_ports {tpu_dout[51]}]  \
  [get_ports {tpu_dout[50]}]  \
  [get_ports {tpu_dout[49]}]  \
  [get_ports {tpu_dout[48]}]  \
  [get_ports {tpu_dout[47]}]  \
  [get_ports {tpu_dout[46]}]  \
  [get_ports {tpu_dout[45]}]  \
  [get_ports {tpu_dout[44]}]  \
  [get_ports {tpu_dout[43]}]  \
  [get_ports {tpu_dout[42]}]  \
  [get_ports {tpu_dout[41]}]  \
  [get_ports {tpu_dout[40]}]  \
  [get_ports {tpu_dout[39]}]  \
  [get_ports {tpu_dout[38]}]  \
  [get_ports {tpu_dout[37]}]  \
  [get_ports {tpu_dout[36]}]  \
  [get_ports {tpu_dout[35]}]  \
  [get_ports {tpu_dout[34]}]  \
  [get_ports {tpu_dout[33]}]  \
  [get_ports {tpu_dout[32]}]  \
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
  [get_cells {bus_wbuf_reg[0]}]  \
  [get_cells {bus_wbuf_reg[1]}]  \
  [get_cells {bus_wbuf_reg[2]}]  \
  [get_cells {bus_wbuf_reg[3]}]  \
  [get_cells {bus_wbuf_reg[4]}]  \
  [get_cells {bus_wbuf_reg[5]}]  \
  [get_cells {bus_wbuf_reg[6]}]  \
  [get_cells {bus_wbuf_reg[7]}]  \
  [get_cells {bus_wbuf_reg[8]}]  \
  [get_cells {bus_wbuf_reg[9]}]  \
  [get_cells {bus_wbuf_reg[10]}]  \
  [get_cells {bus_wbuf_reg[11]}]  \
  [get_cells {bus_wbuf_reg[12]}]  \
  [get_cells {bus_wbuf_reg[13]}]  \
  [get_cells {bus_wbuf_reg[14]}]  \
  [get_cells {bus_wbuf_reg[15]}]  \
  [get_cells {bus_wbuf_reg[16]}]  \
  [get_cells {bus_wbuf_reg[17]}]  \
  [get_cells {bus_wbuf_reg[18]}]  \
  [get_cells {bus_wbuf_reg[19]}]  \
  [get_cells {bus_wbuf_reg[20]}]  \
  [get_cells {bus_wbuf_reg[21]}]  \
  [get_cells {bus_wbuf_reg[22]}]  \
  [get_cells {bus_wbuf_reg[23]}]  \
  [get_cells {bus_wbuf_reg[24]}]  \
  [get_cells {bus_wbuf_reg[25]}]  \
  [get_cells {bus_wbuf_reg[26]}]  \
  [get_cells {bus_wbuf_reg[27]}]  \
  [get_cells {bus_wbuf_reg[28]}]  \
  [get_cells {bus_wbuf_reg[29]}]  \
  [get_cells {bus_wbuf_reg[30]}]  \
  [get_cells {bus_wbuf_reg[31]}]  \
  [get_cells {bus_wbuf_reg[32]}]  \
  [get_cells {bus_wbuf_reg[33]}]  \
  [get_cells {bus_wbuf_reg[34]}]  \
  [get_cells {bus_wbuf_reg[35]}]  \
  [get_cells {bus_wbuf_reg[36]}]  \
  [get_cells {bus_wbuf_reg[37]}]  \
  [get_cells {bus_wbuf_reg[38]}]  \
  [get_cells {bus_wbuf_reg[39]}]  \
  [get_cells {bus_wbuf_reg[40]}]  \
  [get_cells {bus_wbuf_reg[41]}]  \
  [get_cells {bus_wbuf_reg[42]}]  \
  [get_cells {bus_wbuf_reg[43]}]  \
  [get_cells {bus_wbuf_reg[44]}]  \
  [get_cells {bus_wbuf_reg[45]}]  \
  [get_cells {bus_wbuf_reg[46]}]  \
  [get_cells {bus_wbuf_reg[47]}]  \
  [get_cells {bus_wbuf_reg[48]}]  \
  [get_cells {bus_wbuf_reg[49]}]  \
  [get_cells {bus_wbuf_reg[50]}]  \
  [get_cells {bus_wbuf_reg[51]}]  \
  [get_cells {bus_wbuf_reg[52]}]  \
  [get_cells {bus_wbuf_reg[53]}]  \
  [get_cells {bus_wbuf_reg[54]}]  \
  [get_cells {bus_wbuf_reg[55]}]  \
  [get_cells {bus_wbuf_reg[56]}]  \
  [get_cells {bus_wbuf_reg[57]}]  \
  [get_cells {bus_wbuf_reg[58]}]  \
  [get_cells {bus_wbuf_reg[59]}]  \
  [get_cells {bus_wbuf_reg[60]}]  \
  [get_cells {bus_wbuf_reg[61]}]  \
  [get_cells {bus_wbuf_reg[62]}]  \
  [get_cells {bus_wbuf_reg[63]}]  \
  [get_cells sram_cen_ff_reg]  \
  [get_cells {bus_waddr_d1_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[1]}]  \
  [get_cells {bus_waddr_d1_reg[2]}]  \
  [get_cells {bus_waddr_d1_reg[3]}]  \
  [get_cells {bus_waddr_d1_reg[4]}]  \
  [get_cells {bus_waddr_d1_reg[5]}]  \
  [get_cells {bus_waddr_d1_reg[6]}]  \
  [get_cells {bus_waddr_d1_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[8]}]  \
  [get_cells {sram_addr_ff_reg[0]}]  \
  [get_cells {sram_addr_ff_reg[1]}]  \
  [get_cells {sram_addr_ff_reg[2]}]  \
  [get_cells {sram_addr_ff_reg[3]}]  \
  [get_cells {sram_addr_ff_reg[4]}]  \
  [get_cells {sram_addr_ff_reg[5]}]  \
  [get_cells {sram_addr_ff_reg[6]}]  \
  [get_cells {sram_addr_ff_reg[7]}]  \
  [get_cells {sram_addr_ff_reg[8]}]  \
  [get_cells {sram_din_ff_reg[0]}]  \
  [get_cells {sram_din_ff_reg[1]}]  \
  [get_cells {sram_din_ff_reg[2]}]  \
  [get_cells {sram_din_ff_reg[3]}]  \
  [get_cells {sram_din_ff_reg[4]}]  \
  [get_cells {sram_din_ff_reg[5]}]  \
  [get_cells {sram_din_ff_reg[6]}]  \
  [get_cells {sram_din_ff_reg[7]}]  \
  [get_cells {sram_din_ff_reg[8]}]  \
  [get_cells {sram_din_ff_reg[9]}]  \
  [get_cells {sram_din_ff_reg[10]}]  \
  [get_cells {sram_din_ff_reg[11]}]  \
  [get_cells {sram_din_ff_reg[12]}]  \
  [get_cells {sram_din_ff_reg[13]}]  \
  [get_cells {sram_din_ff_reg[14]}]  \
  [get_cells {sram_din_ff_reg[15]}]  \
  [get_cells {sram_din_ff_reg[16]}]  \
  [get_cells {sram_din_ff_reg[17]}]  \
  [get_cells {sram_din_ff_reg[18]}]  \
  [get_cells {sram_din_ff_reg[19]}]  \
  [get_cells {sram_din_ff_reg[20]}]  \
  [get_cells {sram_din_ff_reg[21]}]  \
  [get_cells {sram_din_ff_reg[22]}]  \
  [get_cells {sram_din_ff_reg[23]}]  \
  [get_cells {sram_din_ff_reg[24]}]  \
  [get_cells {sram_din_ff_reg[25]}]  \
  [get_cells {sram_din_ff_reg[26]}]  \
  [get_cells {sram_din_ff_reg[27]}]  \
  [get_cells {sram_din_ff_reg[28]}]  \
  [get_cells {sram_din_ff_reg[29]}]  \
  [get_cells {sram_din_ff_reg[30]}]  \
  [get_cells {sram_din_ff_reg[31]}]  \
  [get_cells {sram_din_ff_reg[32]}]  \
  [get_cells {sram_din_ff_reg[33]}]  \
  [get_cells {sram_din_ff_reg[34]}]  \
  [get_cells {sram_din_ff_reg[35]}]  \
  [get_cells {sram_din_ff_reg[36]}]  \
  [get_cells {sram_din_ff_reg[37]}]  \
  [get_cells {sram_din_ff_reg[38]}]  \
  [get_cells {sram_din_ff_reg[39]}]  \
  [get_cells {sram_din_ff_reg[40]}]  \
  [get_cells {sram_din_ff_reg[41]}]  \
  [get_cells {sram_din_ff_reg[42]}]  \
  [get_cells {sram_din_ff_reg[43]}]  \
  [get_cells {sram_din_ff_reg[44]}]  \
  [get_cells {sram_din_ff_reg[45]}]  \
  [get_cells {sram_din_ff_reg[46]}]  \
  [get_cells {sram_din_ff_reg[47]}]  \
  [get_cells {sram_din_ff_reg[48]}]  \
  [get_cells {sram_din_ff_reg[49]}]  \
  [get_cells {sram_din_ff_reg[50]}]  \
  [get_cells {sram_din_ff_reg[51]}]  \
  [get_cells {sram_din_ff_reg[52]}]  \
  [get_cells {sram_din_ff_reg[53]}]  \
  [get_cells {sram_din_ff_reg[54]}]  \
  [get_cells {sram_din_ff_reg[55]}]  \
  [get_cells {sram_din_ff_reg[56]}]  \
  [get_cells {sram_din_ff_reg[57]}]  \
  [get_cells {sram_din_ff_reg[58]}]  \
  [get_cells {sram_din_ff_reg[59]}]  \
  [get_cells {sram_din_ff_reg[60]}]  \
  [get_cells {sram_din_ff_reg[61]}]  \
  [get_cells {sram_din_ff_reg[62]}]  \
  [get_cells {sram_din_ff_reg[63]}]  \
  [get_cells bus_we_d1_reg] ] -to [list \
  [get_cells u_sram]  \
  [get_cells {bus_wbuf_reg[0]}]  \
  [get_cells {bus_wbuf_reg[1]}]  \
  [get_cells {bus_wbuf_reg[2]}]  \
  [get_cells {bus_wbuf_reg[3]}]  \
  [get_cells {bus_wbuf_reg[4]}]  \
  [get_cells {bus_wbuf_reg[5]}]  \
  [get_cells {bus_wbuf_reg[6]}]  \
  [get_cells {bus_wbuf_reg[7]}]  \
  [get_cells {bus_wbuf_reg[8]}]  \
  [get_cells {bus_wbuf_reg[9]}]  \
  [get_cells {bus_wbuf_reg[10]}]  \
  [get_cells {bus_wbuf_reg[11]}]  \
  [get_cells {bus_wbuf_reg[12]}]  \
  [get_cells {bus_wbuf_reg[13]}]  \
  [get_cells {bus_wbuf_reg[14]}]  \
  [get_cells {bus_wbuf_reg[15]}]  \
  [get_cells {bus_wbuf_reg[16]}]  \
  [get_cells {bus_wbuf_reg[17]}]  \
  [get_cells {bus_wbuf_reg[18]}]  \
  [get_cells {bus_wbuf_reg[19]}]  \
  [get_cells {bus_wbuf_reg[20]}]  \
  [get_cells {bus_wbuf_reg[21]}]  \
  [get_cells {bus_wbuf_reg[22]}]  \
  [get_cells {bus_wbuf_reg[23]}]  \
  [get_cells {bus_wbuf_reg[24]}]  \
  [get_cells {bus_wbuf_reg[25]}]  \
  [get_cells {bus_wbuf_reg[26]}]  \
  [get_cells {bus_wbuf_reg[27]}]  \
  [get_cells {bus_wbuf_reg[28]}]  \
  [get_cells {bus_wbuf_reg[29]}]  \
  [get_cells {bus_wbuf_reg[30]}]  \
  [get_cells {bus_wbuf_reg[31]}]  \
  [get_cells {bus_wbuf_reg[32]}]  \
  [get_cells {bus_wbuf_reg[33]}]  \
  [get_cells {bus_wbuf_reg[34]}]  \
  [get_cells {bus_wbuf_reg[35]}]  \
  [get_cells {bus_wbuf_reg[36]}]  \
  [get_cells {bus_wbuf_reg[37]}]  \
  [get_cells {bus_wbuf_reg[38]}]  \
  [get_cells {bus_wbuf_reg[39]}]  \
  [get_cells {bus_wbuf_reg[40]}]  \
  [get_cells {bus_wbuf_reg[41]}]  \
  [get_cells {bus_wbuf_reg[42]}]  \
  [get_cells {bus_wbuf_reg[43]}]  \
  [get_cells {bus_wbuf_reg[44]}]  \
  [get_cells {bus_wbuf_reg[45]}]  \
  [get_cells {bus_wbuf_reg[46]}]  \
  [get_cells {bus_wbuf_reg[47]}]  \
  [get_cells {bus_wbuf_reg[48]}]  \
  [get_cells {bus_wbuf_reg[49]}]  \
  [get_cells {bus_wbuf_reg[50]}]  \
  [get_cells {bus_wbuf_reg[51]}]  \
  [get_cells {bus_wbuf_reg[52]}]  \
  [get_cells {bus_wbuf_reg[53]}]  \
  [get_cells {bus_wbuf_reg[54]}]  \
  [get_cells {bus_wbuf_reg[55]}]  \
  [get_cells {bus_wbuf_reg[56]}]  \
  [get_cells {bus_wbuf_reg[57]}]  \
  [get_cells {bus_wbuf_reg[58]}]  \
  [get_cells {bus_wbuf_reg[59]}]  \
  [get_cells {bus_wbuf_reg[60]}]  \
  [get_cells {bus_wbuf_reg[61]}]  \
  [get_cells {bus_wbuf_reg[62]}]  \
  [get_cells {bus_wbuf_reg[63]}]  \
  [get_cells sram_cen_ff_reg]  \
  [get_cells {bus_waddr_d1_reg[0]}]  \
  [get_cells {bus_waddr_d1_reg[1]}]  \
  [get_cells {bus_waddr_d1_reg[2]}]  \
  [get_cells {bus_waddr_d1_reg[3]}]  \
  [get_cells {bus_waddr_d1_reg[4]}]  \
  [get_cells {bus_waddr_d1_reg[5]}]  \
  [get_cells {bus_waddr_d1_reg[6]}]  \
  [get_cells {bus_waddr_d1_reg[7]}]  \
  [get_cells {bus_waddr_d1_reg[8]}]  \
  [get_cells {sram_addr_ff_reg[0]}]  \
  [get_cells {sram_addr_ff_reg[1]}]  \
  [get_cells {sram_addr_ff_reg[2]}]  \
  [get_cells {sram_addr_ff_reg[3]}]  \
  [get_cells {sram_addr_ff_reg[4]}]  \
  [get_cells {sram_addr_ff_reg[5]}]  \
  [get_cells {sram_addr_ff_reg[6]}]  \
  [get_cells {sram_addr_ff_reg[7]}]  \
  [get_cells {sram_addr_ff_reg[8]}]  \
  [get_cells {sram_din_ff_reg[0]}]  \
  [get_cells {sram_din_ff_reg[1]}]  \
  [get_cells {sram_din_ff_reg[2]}]  \
  [get_cells {sram_din_ff_reg[3]}]  \
  [get_cells {sram_din_ff_reg[4]}]  \
  [get_cells {sram_din_ff_reg[5]}]  \
  [get_cells {sram_din_ff_reg[6]}]  \
  [get_cells {sram_din_ff_reg[7]}]  \
  [get_cells {sram_din_ff_reg[8]}]  \
  [get_cells {sram_din_ff_reg[9]}]  \
  [get_cells {sram_din_ff_reg[10]}]  \
  [get_cells {sram_din_ff_reg[11]}]  \
  [get_cells {sram_din_ff_reg[12]}]  \
  [get_cells {sram_din_ff_reg[13]}]  \
  [get_cells {sram_din_ff_reg[14]}]  \
  [get_cells {sram_din_ff_reg[15]}]  \
  [get_cells {sram_din_ff_reg[16]}]  \
  [get_cells {sram_din_ff_reg[17]}]  \
  [get_cells {sram_din_ff_reg[18]}]  \
  [get_cells {sram_din_ff_reg[19]}]  \
  [get_cells {sram_din_ff_reg[20]}]  \
  [get_cells {sram_din_ff_reg[21]}]  \
  [get_cells {sram_din_ff_reg[22]}]  \
  [get_cells {sram_din_ff_reg[23]}]  \
  [get_cells {sram_din_ff_reg[24]}]  \
  [get_cells {sram_din_ff_reg[25]}]  \
  [get_cells {sram_din_ff_reg[26]}]  \
  [get_cells {sram_din_ff_reg[27]}]  \
  [get_cells {sram_din_ff_reg[28]}]  \
  [get_cells {sram_din_ff_reg[29]}]  \
  [get_cells {sram_din_ff_reg[30]}]  \
  [get_cells {sram_din_ff_reg[31]}]  \
  [get_cells {sram_din_ff_reg[32]}]  \
  [get_cells {sram_din_ff_reg[33]}]  \
  [get_cells {sram_din_ff_reg[34]}]  \
  [get_cells {sram_din_ff_reg[35]}]  \
  [get_cells {sram_din_ff_reg[36]}]  \
  [get_cells {sram_din_ff_reg[37]}]  \
  [get_cells {sram_din_ff_reg[38]}]  \
  [get_cells {sram_din_ff_reg[39]}]  \
  [get_cells {sram_din_ff_reg[40]}]  \
  [get_cells {sram_din_ff_reg[41]}]  \
  [get_cells {sram_din_ff_reg[42]}]  \
  [get_cells {sram_din_ff_reg[43]}]  \
  [get_cells {sram_din_ff_reg[44]}]  \
  [get_cells {sram_din_ff_reg[45]}]  \
  [get_cells {sram_din_ff_reg[46]}]  \
  [get_cells {sram_din_ff_reg[47]}]  \
  [get_cells {sram_din_ff_reg[48]}]  \
  [get_cells {sram_din_ff_reg[49]}]  \
  [get_cells {sram_din_ff_reg[50]}]  \
  [get_cells {sram_din_ff_reg[51]}]  \
  [get_cells {sram_din_ff_reg[52]}]  \
  [get_cells {sram_din_ff_reg[53]}]  \
  [get_cells {sram_din_ff_reg[54]}]  \
  [get_cells {sram_din_ff_reg[55]}]  \
  [get_cells {sram_din_ff_reg[56]}]  \
  [get_cells {sram_din_ff_reg[57]}]  \
  [get_cells {sram_din_ff_reg[58]}]  \
  [get_cells {sram_din_ff_reg[59]}]  \
  [get_cells {sram_din_ff_reg[60]}]  \
  [get_cells {sram_din_ff_reg[61]}]  \
  [get_cells {sram_din_ff_reg[62]}]  \
  [get_cells {sram_din_ff_reg[63]}]  \
  [get_cells bus_we_d1_reg] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports bus_we]
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
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_dout[32]}]
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
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_dout[32]}]
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
