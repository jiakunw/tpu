# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.16-s062_1 on Mon Apr 27 20:53:19 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design bus_slave_sram_c

create_clock -name "Clk" -period 25.0 -waveform {0.0 12.5} [get_ports clk]
set_clock_transition 0.15 [get_clocks Clk]
set_load -pin_load 0.5 [get_ports clk]
set_load -pin_load 0.5 [get_ports rstn]
set_load -pin_load 0.5 [get_ports chip_chc_start]
set_load -pin_load 0.5 [get_ports chip_chc_rd]
set_load -pin_load 0.5 [get_ports tpu_c_we]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[8]}]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[7]}]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[6]}]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[5]}]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[4]}]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[3]}]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[2]}]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[1]}]
set_load -pin_load 0.5 [get_ports {tpu_c_addr[0]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[63]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[62]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[61]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[60]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[59]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[58]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[57]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[56]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[55]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[54]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[53]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[52]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[51]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[50]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[49]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[48]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[47]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[46]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[45]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[44]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[43]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[42]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[41]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[40]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[39]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[38]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[37]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[36]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[35]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[34]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[33]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[32]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[31]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[30]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[29]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[28]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[27]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[26]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[25]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[24]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[23]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[22]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[21]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[20]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[19]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[18]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[17]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[16]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[15]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[14]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[13]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[12]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[11]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[10]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[9]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[8]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[7]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[6]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[5]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[4]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[3]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[2]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[1]}]
set_load -pin_load 0.5 [get_ports {tpu_c_din[0]}]
set_load -pin_load 0.5 [get_ports sc_mem_ctrl]
set_load -pin_load 0.5 [get_ports sc_cen]
set_load -pin_load 0.5 [get_ports sc_wen]
set_load -pin_load 0.5 [get_ports {sc_addr[8]}]
set_load -pin_load 0.5 [get_ports {sc_addr[7]}]
set_load -pin_load 0.5 [get_ports {sc_addr[6]}]
set_load -pin_load 0.5 [get_ports {sc_addr[5]}]
set_load -pin_load 0.5 [get_ports {sc_addr[4]}]
set_load -pin_load 0.5 [get_ports {sc_addr[3]}]
set_load -pin_load 0.5 [get_ports {sc_addr[2]}]
set_load -pin_load 0.5 [get_ports {sc_addr[1]}]
set_load -pin_load 0.5 [get_ports {sc_addr[0]}]
set_load -pin_load 0.5 [get_ports {sc_din[63]}]
set_load -pin_load 0.5 [get_ports {sc_din[62]}]
set_load -pin_load 0.5 [get_ports {sc_din[61]}]
set_load -pin_load 0.5 [get_ports {sc_din[60]}]
set_load -pin_load 0.5 [get_ports {sc_din[59]}]
set_load -pin_load 0.5 [get_ports {sc_din[58]}]
set_load -pin_load 0.5 [get_ports {sc_din[57]}]
set_load -pin_load 0.5 [get_ports {sc_din[56]}]
set_load -pin_load 0.5 [get_ports {sc_din[55]}]
set_load -pin_load 0.5 [get_ports {sc_din[54]}]
set_load -pin_load 0.5 [get_ports {sc_din[53]}]
set_load -pin_load 0.5 [get_ports {sc_din[52]}]
set_load -pin_load 0.5 [get_ports {sc_din[51]}]
set_load -pin_load 0.5 [get_ports {sc_din[50]}]
set_load -pin_load 0.5 [get_ports {sc_din[49]}]
set_load -pin_load 0.5 [get_ports {sc_din[48]}]
set_load -pin_load 0.5 [get_ports {sc_din[47]}]
set_load -pin_load 0.5 [get_ports {sc_din[46]}]
set_load -pin_load 0.5 [get_ports {sc_din[45]}]
set_load -pin_load 0.5 [get_ports {sc_din[44]}]
set_load -pin_load 0.5 [get_ports {sc_din[43]}]
set_load -pin_load 0.5 [get_ports {sc_din[42]}]
set_load -pin_load 0.5 [get_ports {sc_din[41]}]
set_load -pin_load 0.5 [get_ports {sc_din[40]}]
set_load -pin_load 0.5 [get_ports {sc_din[39]}]
set_load -pin_load 0.5 [get_ports {sc_din[38]}]
set_load -pin_load 0.5 [get_ports {sc_din[37]}]
set_load -pin_load 0.5 [get_ports {sc_din[36]}]
set_load -pin_load 0.5 [get_ports {sc_din[35]}]
set_load -pin_load 0.5 [get_ports {sc_din[34]}]
set_load -pin_load 0.5 [get_ports {sc_din[33]}]
set_load -pin_load 0.5 [get_ports {sc_din[32]}]
set_load -pin_load 0.5 [get_ports {sc_din[31]}]
set_load -pin_load 0.5 [get_ports {sc_din[30]}]
set_load -pin_load 0.5 [get_ports {sc_din[29]}]
set_load -pin_load 0.5 [get_ports {sc_din[28]}]
set_load -pin_load 0.5 [get_ports {sc_din[27]}]
set_load -pin_load 0.5 [get_ports {sc_din[26]}]
set_load -pin_load 0.5 [get_ports {sc_din[25]}]
set_load -pin_load 0.5 [get_ports {sc_din[24]}]
set_load -pin_load 0.5 [get_ports {sc_din[23]}]
set_load -pin_load 0.5 [get_ports {sc_din[22]}]
set_load -pin_load 0.5 [get_ports {sc_din[21]}]
set_load -pin_load 0.5 [get_ports {sc_din[20]}]
set_load -pin_load 0.5 [get_ports {sc_din[19]}]
set_load -pin_load 0.5 [get_ports {sc_din[18]}]
set_load -pin_load 0.5 [get_ports {sc_din[17]}]
set_load -pin_load 0.5 [get_ports {sc_din[16]}]
set_load -pin_load 0.5 [get_ports {sc_din[15]}]
set_load -pin_load 0.5 [get_ports {sc_din[14]}]
set_load -pin_load 0.5 [get_ports {sc_din[13]}]
set_load -pin_load 0.5 [get_ports {sc_din[12]}]
set_load -pin_load 0.5 [get_ports {sc_din[11]}]
set_load -pin_load 0.5 [get_ports {sc_din[10]}]
set_load -pin_load 0.5 [get_ports {sc_din[9]}]
set_load -pin_load 0.5 [get_ports {sc_din[8]}]
set_load -pin_load 0.5 [get_ports {sc_din[7]}]
set_load -pin_load 0.5 [get_ports {sc_din[6]}]
set_load -pin_load 0.5 [get_ports {sc_din[5]}]
set_load -pin_load 0.5 [get_ports {sc_din[4]}]
set_load -pin_load 0.5 [get_ports {sc_din[3]}]
set_load -pin_load 0.5 [get_ports {sc_din[2]}]
set_load -pin_load 0.5 [get_ports {sc_din[1]}]
set_load -pin_load 0.5 [get_ports {sc_din[0]}]
set_load -pin_load 0.5 [get_ports {chip_chc_rdata[7]}]
set_load -pin_load 0.5 [get_ports {chip_chc_rdata[6]}]
set_load -pin_load 0.5 [get_ports {chip_chc_rdata[5]}]
set_load -pin_load 0.5 [get_ports {chip_chc_rdata[4]}]
set_load -pin_load 0.5 [get_ports {chip_chc_rdata[3]}]
set_load -pin_load 0.5 [get_ports {chip_chc_rdata[2]}]
set_load -pin_load 0.5 [get_ports {chip_chc_rdata[1]}]
set_load -pin_load 0.5 [get_ports {chip_chc_rdata[0]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[63]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[62]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[61]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[60]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[59]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[58]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[57]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[56]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[55]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[54]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[53]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[52]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[51]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[50]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[49]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[48]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[47]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[46]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[45]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[44]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[43]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[42]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[41]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[40]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[39]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[38]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[37]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[36]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[35]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[34]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[33]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[32]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[31]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[30]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[29]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[28]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[27]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[26]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[25]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[24]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[23]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[22]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[21]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[20]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[19]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[18]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[17]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[16]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[15]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[14]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[13]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[12]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[11]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[10]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[9]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[8]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[7]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[6]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[5]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[4]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[3]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[2]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[1]}]
set_load -pin_load 0.5 [get_ports {sc_mem_dout[0]}]
group_path -weight 1.000000 -name C2O -from [list \
  [get_cells u_sram_c_u_sram]  \
  [get_cells {u_slave_c_cnt_c_reg[11]}]  \
  [get_cells {u_slave_c_cnt_c_reg[10]}]  \
  [get_cells {u_slave_c_cnt_c_reg[9]}]  \
  [get_cells {u_slave_c_cnt_c_reg[8]}]  \
  [get_cells {u_slave_c_cnt_c_reg[7]}]  \
  [get_cells {u_slave_c_cnt_c_reg[6]}]  \
  [get_cells {u_slave_c_cnt_c_reg[5]}]  \
  [get_cells {u_slave_c_cnt_c_reg[4]}]  \
  [get_cells {u_slave_c_cnt_c_reg[3]}]  \
  [get_cells {u_slave_c_cnt_c_reg[2]}]  \
  [get_cells {u_slave_c_cnt_c_reg[1]}]  \
  [get_cells {u_slave_c_cnt_c_reg[0]}]  \
  [get_cells u_slave_c_chc_rd_s_reg]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[0]}]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[1]}]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[2]}] ] -to [list \
  [get_ports {chip_chc_rdata[7]}]  \
  [get_ports {chip_chc_rdata[6]}]  \
  [get_ports {chip_chc_rdata[5]}]  \
  [get_ports {chip_chc_rdata[4]}]  \
  [get_ports {chip_chc_rdata[3]}]  \
  [get_ports {chip_chc_rdata[2]}]  \
  [get_ports {chip_chc_rdata[1]}]  \
  [get_ports {chip_chc_rdata[0]}]  \
  [get_ports {sc_mem_dout[63]}]  \
  [get_ports {sc_mem_dout[62]}]  \
  [get_ports {sc_mem_dout[61]}]  \
  [get_ports {sc_mem_dout[60]}]  \
  [get_ports {sc_mem_dout[59]}]  \
  [get_ports {sc_mem_dout[58]}]  \
  [get_ports {sc_mem_dout[57]}]  \
  [get_ports {sc_mem_dout[56]}]  \
  [get_ports {sc_mem_dout[55]}]  \
  [get_ports {sc_mem_dout[54]}]  \
  [get_ports {sc_mem_dout[53]}]  \
  [get_ports {sc_mem_dout[52]}]  \
  [get_ports {sc_mem_dout[51]}]  \
  [get_ports {sc_mem_dout[50]}]  \
  [get_ports {sc_mem_dout[49]}]  \
  [get_ports {sc_mem_dout[48]}]  \
  [get_ports {sc_mem_dout[47]}]  \
  [get_ports {sc_mem_dout[46]}]  \
  [get_ports {sc_mem_dout[45]}]  \
  [get_ports {sc_mem_dout[44]}]  \
  [get_ports {sc_mem_dout[43]}]  \
  [get_ports {sc_mem_dout[42]}]  \
  [get_ports {sc_mem_dout[41]}]  \
  [get_ports {sc_mem_dout[40]}]  \
  [get_ports {sc_mem_dout[39]}]  \
  [get_ports {sc_mem_dout[38]}]  \
  [get_ports {sc_mem_dout[37]}]  \
  [get_ports {sc_mem_dout[36]}]  \
  [get_ports {sc_mem_dout[35]}]  \
  [get_ports {sc_mem_dout[34]}]  \
  [get_ports {sc_mem_dout[33]}]  \
  [get_ports {sc_mem_dout[32]}]  \
  [get_ports {sc_mem_dout[31]}]  \
  [get_ports {sc_mem_dout[30]}]  \
  [get_ports {sc_mem_dout[29]}]  \
  [get_ports {sc_mem_dout[28]}]  \
  [get_ports {sc_mem_dout[27]}]  \
  [get_ports {sc_mem_dout[26]}]  \
  [get_ports {sc_mem_dout[25]}]  \
  [get_ports {sc_mem_dout[24]}]  \
  [get_ports {sc_mem_dout[23]}]  \
  [get_ports {sc_mem_dout[22]}]  \
  [get_ports {sc_mem_dout[21]}]  \
  [get_ports {sc_mem_dout[20]}]  \
  [get_ports {sc_mem_dout[19]}]  \
  [get_ports {sc_mem_dout[18]}]  \
  [get_ports {sc_mem_dout[17]}]  \
  [get_ports {sc_mem_dout[16]}]  \
  [get_ports {sc_mem_dout[15]}]  \
  [get_ports {sc_mem_dout[14]}]  \
  [get_ports {sc_mem_dout[13]}]  \
  [get_ports {sc_mem_dout[12]}]  \
  [get_ports {sc_mem_dout[11]}]  \
  [get_ports {sc_mem_dout[10]}]  \
  [get_ports {sc_mem_dout[9]}]  \
  [get_ports {sc_mem_dout[8]}]  \
  [get_ports {sc_mem_dout[7]}]  \
  [get_ports {sc_mem_dout[6]}]  \
  [get_ports {sc_mem_dout[5]}]  \
  [get_ports {sc_mem_dout[4]}]  \
  [get_ports {sc_mem_dout[3]}]  \
  [get_ports {sc_mem_dout[2]}]  \
  [get_ports {sc_mem_dout[1]}]  \
  [get_ports {sc_mem_dout[0]}] ]
group_path -weight 1.000000 -name I2C -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports chip_chc_start]  \
  [get_ports chip_chc_rd]  \
  [get_ports tpu_c_we]  \
  [get_ports {tpu_c_addr[8]}]  \
  [get_ports {tpu_c_addr[7]}]  \
  [get_ports {tpu_c_addr[6]}]  \
  [get_ports {tpu_c_addr[5]}]  \
  [get_ports {tpu_c_addr[4]}]  \
  [get_ports {tpu_c_addr[3]}]  \
  [get_ports {tpu_c_addr[2]}]  \
  [get_ports {tpu_c_addr[1]}]  \
  [get_ports {tpu_c_addr[0]}]  \
  [get_ports {tpu_c_din[63]}]  \
  [get_ports {tpu_c_din[62]}]  \
  [get_ports {tpu_c_din[61]}]  \
  [get_ports {tpu_c_din[60]}]  \
  [get_ports {tpu_c_din[59]}]  \
  [get_ports {tpu_c_din[58]}]  \
  [get_ports {tpu_c_din[57]}]  \
  [get_ports {tpu_c_din[56]}]  \
  [get_ports {tpu_c_din[55]}]  \
  [get_ports {tpu_c_din[54]}]  \
  [get_ports {tpu_c_din[53]}]  \
  [get_ports {tpu_c_din[52]}]  \
  [get_ports {tpu_c_din[51]}]  \
  [get_ports {tpu_c_din[50]}]  \
  [get_ports {tpu_c_din[49]}]  \
  [get_ports {tpu_c_din[48]}]  \
  [get_ports {tpu_c_din[47]}]  \
  [get_ports {tpu_c_din[46]}]  \
  [get_ports {tpu_c_din[45]}]  \
  [get_ports {tpu_c_din[44]}]  \
  [get_ports {tpu_c_din[43]}]  \
  [get_ports {tpu_c_din[42]}]  \
  [get_ports {tpu_c_din[41]}]  \
  [get_ports {tpu_c_din[40]}]  \
  [get_ports {tpu_c_din[39]}]  \
  [get_ports {tpu_c_din[38]}]  \
  [get_ports {tpu_c_din[37]}]  \
  [get_ports {tpu_c_din[36]}]  \
  [get_ports {tpu_c_din[35]}]  \
  [get_ports {tpu_c_din[34]}]  \
  [get_ports {tpu_c_din[33]}]  \
  [get_ports {tpu_c_din[32]}]  \
  [get_ports {tpu_c_din[31]}]  \
  [get_ports {tpu_c_din[30]}]  \
  [get_ports {tpu_c_din[29]}]  \
  [get_ports {tpu_c_din[28]}]  \
  [get_ports {tpu_c_din[27]}]  \
  [get_ports {tpu_c_din[26]}]  \
  [get_ports {tpu_c_din[25]}]  \
  [get_ports {tpu_c_din[24]}]  \
  [get_ports {tpu_c_din[23]}]  \
  [get_ports {tpu_c_din[22]}]  \
  [get_ports {tpu_c_din[21]}]  \
  [get_ports {tpu_c_din[20]}]  \
  [get_ports {tpu_c_din[19]}]  \
  [get_ports {tpu_c_din[18]}]  \
  [get_ports {tpu_c_din[17]}]  \
  [get_ports {tpu_c_din[16]}]  \
  [get_ports {tpu_c_din[15]}]  \
  [get_ports {tpu_c_din[14]}]  \
  [get_ports {tpu_c_din[13]}]  \
  [get_ports {tpu_c_din[12]}]  \
  [get_ports {tpu_c_din[11]}]  \
  [get_ports {tpu_c_din[10]}]  \
  [get_ports {tpu_c_din[9]}]  \
  [get_ports {tpu_c_din[8]}]  \
  [get_ports {tpu_c_din[7]}]  \
  [get_ports {tpu_c_din[6]}]  \
  [get_ports {tpu_c_din[5]}]  \
  [get_ports {tpu_c_din[4]}]  \
  [get_ports {tpu_c_din[3]}]  \
  [get_ports {tpu_c_din[2]}]  \
  [get_ports {tpu_c_din[1]}]  \
  [get_ports {tpu_c_din[0]}]  \
  [get_ports sc_mem_ctrl]  \
  [get_ports sc_cen]  \
  [get_ports sc_wen]  \
  [get_ports {sc_addr[8]}]  \
  [get_ports {sc_addr[7]}]  \
  [get_ports {sc_addr[6]}]  \
  [get_ports {sc_addr[5]}]  \
  [get_ports {sc_addr[4]}]  \
  [get_ports {sc_addr[3]}]  \
  [get_ports {sc_addr[2]}]  \
  [get_ports {sc_addr[1]}]  \
  [get_ports {sc_addr[0]}]  \
  [get_ports {sc_din[63]}]  \
  [get_ports {sc_din[62]}]  \
  [get_ports {sc_din[61]}]  \
  [get_ports {sc_din[60]}]  \
  [get_ports {sc_din[59]}]  \
  [get_ports {sc_din[58]}]  \
  [get_ports {sc_din[57]}]  \
  [get_ports {sc_din[56]}]  \
  [get_ports {sc_din[55]}]  \
  [get_ports {sc_din[54]}]  \
  [get_ports {sc_din[53]}]  \
  [get_ports {sc_din[52]}]  \
  [get_ports {sc_din[51]}]  \
  [get_ports {sc_din[50]}]  \
  [get_ports {sc_din[49]}]  \
  [get_ports {sc_din[48]}]  \
  [get_ports {sc_din[47]}]  \
  [get_ports {sc_din[46]}]  \
  [get_ports {sc_din[45]}]  \
  [get_ports {sc_din[44]}]  \
  [get_ports {sc_din[43]}]  \
  [get_ports {sc_din[42]}]  \
  [get_ports {sc_din[41]}]  \
  [get_ports {sc_din[40]}]  \
  [get_ports {sc_din[39]}]  \
  [get_ports {sc_din[38]}]  \
  [get_ports {sc_din[37]}]  \
  [get_ports {sc_din[36]}]  \
  [get_ports {sc_din[35]}]  \
  [get_ports {sc_din[34]}]  \
  [get_ports {sc_din[33]}]  \
  [get_ports {sc_din[32]}]  \
  [get_ports {sc_din[31]}]  \
  [get_ports {sc_din[30]}]  \
  [get_ports {sc_din[29]}]  \
  [get_ports {sc_din[28]}]  \
  [get_ports {sc_din[27]}]  \
  [get_ports {sc_din[26]}]  \
  [get_ports {sc_din[25]}]  \
  [get_ports {sc_din[24]}]  \
  [get_ports {sc_din[23]}]  \
  [get_ports {sc_din[22]}]  \
  [get_ports {sc_din[21]}]  \
  [get_ports {sc_din[20]}]  \
  [get_ports {sc_din[19]}]  \
  [get_ports {sc_din[18]}]  \
  [get_ports {sc_din[17]}]  \
  [get_ports {sc_din[16]}]  \
  [get_ports {sc_din[15]}]  \
  [get_ports {sc_din[14]}]  \
  [get_ports {sc_din[13]}]  \
  [get_ports {sc_din[12]}]  \
  [get_ports {sc_din[11]}]  \
  [get_ports {sc_din[10]}]  \
  [get_ports {sc_din[9]}]  \
  [get_ports {sc_din[8]}]  \
  [get_ports {sc_din[7]}]  \
  [get_ports {sc_din[6]}]  \
  [get_ports {sc_din[5]}]  \
  [get_ports {sc_din[4]}]  \
  [get_ports {sc_din[3]}]  \
  [get_ports {sc_din[2]}]  \
  [get_ports {sc_din[1]}]  \
  [get_ports {sc_din[0]}] ] -to [list \
  [get_cells u_sram_c_u_sram]  \
  [get_cells {u_slave_c_cnt_c_reg[11]}]  \
  [get_cells {u_slave_c_cnt_c_reg[10]}]  \
  [get_cells {u_slave_c_cnt_c_reg[9]}]  \
  [get_cells {u_slave_c_cnt_c_reg[8]}]  \
  [get_cells {u_slave_c_cnt_c_reg[7]}]  \
  [get_cells {u_slave_c_cnt_c_reg[6]}]  \
  [get_cells {u_slave_c_cnt_c_reg[5]}]  \
  [get_cells {u_slave_c_cnt_c_reg[4]}]  \
  [get_cells {u_slave_c_cnt_c_reg[3]}]  \
  [get_cells {u_slave_c_cnt_c_reg[2]}]  \
  [get_cells {u_slave_c_cnt_c_reg[1]}]  \
  [get_cells {u_slave_c_cnt_c_reg[0]}]  \
  [get_cells u_slave_c_chc_rd_s_reg]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[0]}]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[1]}]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[2]}] ]
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports chip_chc_start]  \
  [get_ports chip_chc_rd]  \
  [get_ports tpu_c_we]  \
  [get_ports {tpu_c_addr[8]}]  \
  [get_ports {tpu_c_addr[7]}]  \
  [get_ports {tpu_c_addr[6]}]  \
  [get_ports {tpu_c_addr[5]}]  \
  [get_ports {tpu_c_addr[4]}]  \
  [get_ports {tpu_c_addr[3]}]  \
  [get_ports {tpu_c_addr[2]}]  \
  [get_ports {tpu_c_addr[1]}]  \
  [get_ports {tpu_c_addr[0]}]  \
  [get_ports {tpu_c_din[63]}]  \
  [get_ports {tpu_c_din[62]}]  \
  [get_ports {tpu_c_din[61]}]  \
  [get_ports {tpu_c_din[60]}]  \
  [get_ports {tpu_c_din[59]}]  \
  [get_ports {tpu_c_din[58]}]  \
  [get_ports {tpu_c_din[57]}]  \
  [get_ports {tpu_c_din[56]}]  \
  [get_ports {tpu_c_din[55]}]  \
  [get_ports {tpu_c_din[54]}]  \
  [get_ports {tpu_c_din[53]}]  \
  [get_ports {tpu_c_din[52]}]  \
  [get_ports {tpu_c_din[51]}]  \
  [get_ports {tpu_c_din[50]}]  \
  [get_ports {tpu_c_din[49]}]  \
  [get_ports {tpu_c_din[48]}]  \
  [get_ports {tpu_c_din[47]}]  \
  [get_ports {tpu_c_din[46]}]  \
  [get_ports {tpu_c_din[45]}]  \
  [get_ports {tpu_c_din[44]}]  \
  [get_ports {tpu_c_din[43]}]  \
  [get_ports {tpu_c_din[42]}]  \
  [get_ports {tpu_c_din[41]}]  \
  [get_ports {tpu_c_din[40]}]  \
  [get_ports {tpu_c_din[39]}]  \
  [get_ports {tpu_c_din[38]}]  \
  [get_ports {tpu_c_din[37]}]  \
  [get_ports {tpu_c_din[36]}]  \
  [get_ports {tpu_c_din[35]}]  \
  [get_ports {tpu_c_din[34]}]  \
  [get_ports {tpu_c_din[33]}]  \
  [get_ports {tpu_c_din[32]}]  \
  [get_ports {tpu_c_din[31]}]  \
  [get_ports {tpu_c_din[30]}]  \
  [get_ports {tpu_c_din[29]}]  \
  [get_ports {tpu_c_din[28]}]  \
  [get_ports {tpu_c_din[27]}]  \
  [get_ports {tpu_c_din[26]}]  \
  [get_ports {tpu_c_din[25]}]  \
  [get_ports {tpu_c_din[24]}]  \
  [get_ports {tpu_c_din[23]}]  \
  [get_ports {tpu_c_din[22]}]  \
  [get_ports {tpu_c_din[21]}]  \
  [get_ports {tpu_c_din[20]}]  \
  [get_ports {tpu_c_din[19]}]  \
  [get_ports {tpu_c_din[18]}]  \
  [get_ports {tpu_c_din[17]}]  \
  [get_ports {tpu_c_din[16]}]  \
  [get_ports {tpu_c_din[15]}]  \
  [get_ports {tpu_c_din[14]}]  \
  [get_ports {tpu_c_din[13]}]  \
  [get_ports {tpu_c_din[12]}]  \
  [get_ports {tpu_c_din[11]}]  \
  [get_ports {tpu_c_din[10]}]  \
  [get_ports {tpu_c_din[9]}]  \
  [get_ports {tpu_c_din[8]}]  \
  [get_ports {tpu_c_din[7]}]  \
  [get_ports {tpu_c_din[6]}]  \
  [get_ports {tpu_c_din[5]}]  \
  [get_ports {tpu_c_din[4]}]  \
  [get_ports {tpu_c_din[3]}]  \
  [get_ports {tpu_c_din[2]}]  \
  [get_ports {tpu_c_din[1]}]  \
  [get_ports {tpu_c_din[0]}]  \
  [get_ports sc_mem_ctrl]  \
  [get_ports sc_cen]  \
  [get_ports sc_wen]  \
  [get_ports {sc_addr[8]}]  \
  [get_ports {sc_addr[7]}]  \
  [get_ports {sc_addr[6]}]  \
  [get_ports {sc_addr[5]}]  \
  [get_ports {sc_addr[4]}]  \
  [get_ports {sc_addr[3]}]  \
  [get_ports {sc_addr[2]}]  \
  [get_ports {sc_addr[1]}]  \
  [get_ports {sc_addr[0]}]  \
  [get_ports {sc_din[63]}]  \
  [get_ports {sc_din[62]}]  \
  [get_ports {sc_din[61]}]  \
  [get_ports {sc_din[60]}]  \
  [get_ports {sc_din[59]}]  \
  [get_ports {sc_din[58]}]  \
  [get_ports {sc_din[57]}]  \
  [get_ports {sc_din[56]}]  \
  [get_ports {sc_din[55]}]  \
  [get_ports {sc_din[54]}]  \
  [get_ports {sc_din[53]}]  \
  [get_ports {sc_din[52]}]  \
  [get_ports {sc_din[51]}]  \
  [get_ports {sc_din[50]}]  \
  [get_ports {sc_din[49]}]  \
  [get_ports {sc_din[48]}]  \
  [get_ports {sc_din[47]}]  \
  [get_ports {sc_din[46]}]  \
  [get_ports {sc_din[45]}]  \
  [get_ports {sc_din[44]}]  \
  [get_ports {sc_din[43]}]  \
  [get_ports {sc_din[42]}]  \
  [get_ports {sc_din[41]}]  \
  [get_ports {sc_din[40]}]  \
  [get_ports {sc_din[39]}]  \
  [get_ports {sc_din[38]}]  \
  [get_ports {sc_din[37]}]  \
  [get_ports {sc_din[36]}]  \
  [get_ports {sc_din[35]}]  \
  [get_ports {sc_din[34]}]  \
  [get_ports {sc_din[33]}]  \
  [get_ports {sc_din[32]}]  \
  [get_ports {sc_din[31]}]  \
  [get_ports {sc_din[30]}]  \
  [get_ports {sc_din[29]}]  \
  [get_ports {sc_din[28]}]  \
  [get_ports {sc_din[27]}]  \
  [get_ports {sc_din[26]}]  \
  [get_ports {sc_din[25]}]  \
  [get_ports {sc_din[24]}]  \
  [get_ports {sc_din[23]}]  \
  [get_ports {sc_din[22]}]  \
  [get_ports {sc_din[21]}]  \
  [get_ports {sc_din[20]}]  \
  [get_ports {sc_din[19]}]  \
  [get_ports {sc_din[18]}]  \
  [get_ports {sc_din[17]}]  \
  [get_ports {sc_din[16]}]  \
  [get_ports {sc_din[15]}]  \
  [get_ports {sc_din[14]}]  \
  [get_ports {sc_din[13]}]  \
  [get_ports {sc_din[12]}]  \
  [get_ports {sc_din[11]}]  \
  [get_ports {sc_din[10]}]  \
  [get_ports {sc_din[9]}]  \
  [get_ports {sc_din[8]}]  \
  [get_ports {sc_din[7]}]  \
  [get_ports {sc_din[6]}]  \
  [get_ports {sc_din[5]}]  \
  [get_ports {sc_din[4]}]  \
  [get_ports {sc_din[3]}]  \
  [get_ports {sc_din[2]}]  \
  [get_ports {sc_din[1]}]  \
  [get_ports {sc_din[0]}] ] -to [list \
  [get_ports {chip_chc_rdata[7]}]  \
  [get_ports {chip_chc_rdata[6]}]  \
  [get_ports {chip_chc_rdata[5]}]  \
  [get_ports {chip_chc_rdata[4]}]  \
  [get_ports {chip_chc_rdata[3]}]  \
  [get_ports {chip_chc_rdata[2]}]  \
  [get_ports {chip_chc_rdata[1]}]  \
  [get_ports {chip_chc_rdata[0]}]  \
  [get_ports {sc_mem_dout[63]}]  \
  [get_ports {sc_mem_dout[62]}]  \
  [get_ports {sc_mem_dout[61]}]  \
  [get_ports {sc_mem_dout[60]}]  \
  [get_ports {sc_mem_dout[59]}]  \
  [get_ports {sc_mem_dout[58]}]  \
  [get_ports {sc_mem_dout[57]}]  \
  [get_ports {sc_mem_dout[56]}]  \
  [get_ports {sc_mem_dout[55]}]  \
  [get_ports {sc_mem_dout[54]}]  \
  [get_ports {sc_mem_dout[53]}]  \
  [get_ports {sc_mem_dout[52]}]  \
  [get_ports {sc_mem_dout[51]}]  \
  [get_ports {sc_mem_dout[50]}]  \
  [get_ports {sc_mem_dout[49]}]  \
  [get_ports {sc_mem_dout[48]}]  \
  [get_ports {sc_mem_dout[47]}]  \
  [get_ports {sc_mem_dout[46]}]  \
  [get_ports {sc_mem_dout[45]}]  \
  [get_ports {sc_mem_dout[44]}]  \
  [get_ports {sc_mem_dout[43]}]  \
  [get_ports {sc_mem_dout[42]}]  \
  [get_ports {sc_mem_dout[41]}]  \
  [get_ports {sc_mem_dout[40]}]  \
  [get_ports {sc_mem_dout[39]}]  \
  [get_ports {sc_mem_dout[38]}]  \
  [get_ports {sc_mem_dout[37]}]  \
  [get_ports {sc_mem_dout[36]}]  \
  [get_ports {sc_mem_dout[35]}]  \
  [get_ports {sc_mem_dout[34]}]  \
  [get_ports {sc_mem_dout[33]}]  \
  [get_ports {sc_mem_dout[32]}]  \
  [get_ports {sc_mem_dout[31]}]  \
  [get_ports {sc_mem_dout[30]}]  \
  [get_ports {sc_mem_dout[29]}]  \
  [get_ports {sc_mem_dout[28]}]  \
  [get_ports {sc_mem_dout[27]}]  \
  [get_ports {sc_mem_dout[26]}]  \
  [get_ports {sc_mem_dout[25]}]  \
  [get_ports {sc_mem_dout[24]}]  \
  [get_ports {sc_mem_dout[23]}]  \
  [get_ports {sc_mem_dout[22]}]  \
  [get_ports {sc_mem_dout[21]}]  \
  [get_ports {sc_mem_dout[20]}]  \
  [get_ports {sc_mem_dout[19]}]  \
  [get_ports {sc_mem_dout[18]}]  \
  [get_ports {sc_mem_dout[17]}]  \
  [get_ports {sc_mem_dout[16]}]  \
  [get_ports {sc_mem_dout[15]}]  \
  [get_ports {sc_mem_dout[14]}]  \
  [get_ports {sc_mem_dout[13]}]  \
  [get_ports {sc_mem_dout[12]}]  \
  [get_ports {sc_mem_dout[11]}]  \
  [get_ports {sc_mem_dout[10]}]  \
  [get_ports {sc_mem_dout[9]}]  \
  [get_ports {sc_mem_dout[8]}]  \
  [get_ports {sc_mem_dout[7]}]  \
  [get_ports {sc_mem_dout[6]}]  \
  [get_ports {sc_mem_dout[5]}]  \
  [get_ports {sc_mem_dout[4]}]  \
  [get_ports {sc_mem_dout[3]}]  \
  [get_ports {sc_mem_dout[2]}]  \
  [get_ports {sc_mem_dout[1]}]  \
  [get_ports {sc_mem_dout[0]}] ]
group_path -weight 1.000000 -name C2C -from [list \
  [get_cells u_sram_c_u_sram]  \
  [get_cells {u_slave_c_cnt_c_reg[11]}]  \
  [get_cells {u_slave_c_cnt_c_reg[10]}]  \
  [get_cells {u_slave_c_cnt_c_reg[9]}]  \
  [get_cells {u_slave_c_cnt_c_reg[8]}]  \
  [get_cells {u_slave_c_cnt_c_reg[7]}]  \
  [get_cells {u_slave_c_cnt_c_reg[6]}]  \
  [get_cells {u_slave_c_cnt_c_reg[5]}]  \
  [get_cells {u_slave_c_cnt_c_reg[4]}]  \
  [get_cells {u_slave_c_cnt_c_reg[3]}]  \
  [get_cells {u_slave_c_cnt_c_reg[2]}]  \
  [get_cells {u_slave_c_cnt_c_reg[1]}]  \
  [get_cells {u_slave_c_cnt_c_reg[0]}]  \
  [get_cells u_slave_c_chc_rd_s_reg]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[0]}]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[1]}]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[2]}] ] -to [list \
  [get_cells u_sram_c_u_sram]  \
  [get_cells {u_slave_c_cnt_c_reg[11]}]  \
  [get_cells {u_slave_c_cnt_c_reg[10]}]  \
  [get_cells {u_slave_c_cnt_c_reg[9]}]  \
  [get_cells {u_slave_c_cnt_c_reg[8]}]  \
  [get_cells {u_slave_c_cnt_c_reg[7]}]  \
  [get_cells {u_slave_c_cnt_c_reg[6]}]  \
  [get_cells {u_slave_c_cnt_c_reg[5]}]  \
  [get_cells {u_slave_c_cnt_c_reg[4]}]  \
  [get_cells {u_slave_c_cnt_c_reg[3]}]  \
  [get_cells {u_slave_c_cnt_c_reg[2]}]  \
  [get_cells {u_slave_c_cnt_c_reg[1]}]  \
  [get_cells {u_slave_c_cnt_c_reg[0]}]  \
  [get_cells u_slave_c_chc_rd_s_reg]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[0]}]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[1]}]  \
  [get_cells {u_sram_c_bus_byte_sel_d1_reg[2]}] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports chip_chc_start]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports chip_chc_rd]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports tpu_c_we]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_c_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_mem_ctrl]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_cen]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_wen]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports chip_chc_start]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports chip_chc_rd]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports tpu_c_we]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_c_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_mem_ctrl]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_cen]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_wen]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_din[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {chip_chc_rdata[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {chip_chc_rdata[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {chip_chc_rdata[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {chip_chc_rdata[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {chip_chc_rdata[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {chip_chc_rdata[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {chip_chc_rdata[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {chip_chc_rdata[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_mem_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chc_rdata[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chc_rdata[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chc_rdata[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chc_rdata[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chc_rdata[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chc_rdata[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chc_rdata[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chc_rdata[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_mem_dout[0]}]
set_wire_load_mode "segmented"
set_clock_uncertainty -setup 0.15 [get_clocks Clk]
set_clock_uncertainty -hold 0.15 [get_clocks Clk]
