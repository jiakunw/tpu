# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.16-s062_1 on Mon Apr 27 17:30:48 EDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design bus_slave_sram_ab

create_clock -name "Clk" -period 25.0 -waveform {0.0 12.5} [get_ports clk]
set_clock_transition 0.15 [get_clocks Clk]
set_load -pin_load 0.5 [get_ports clk]
set_load -pin_load 0.5 [get_ports rstn]
set_load -pin_load 0.5 [get_ports {mmio_dim_m[6]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_m[5]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_m[4]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_m[3]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_m[2]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_m[1]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_m[0]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_n[6]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_n[5]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_n[4]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_n[3]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_n[2]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_n[1]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_n[0]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_k[6]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_k[5]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_k[4]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_k[3]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_k[2]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_k[1]}]
set_load -pin_load 0.5 [get_ports {mmio_dim_k[0]}]
set_load -pin_load 0.5 [get_ports {mmio_num_computation[6]}]
set_load -pin_load 0.5 [get_ports {mmio_num_computation[5]}]
set_load -pin_load 0.5 [get_ports {mmio_num_computation[4]}]
set_load -pin_load 0.5 [get_ports {mmio_num_computation[3]}]
set_load -pin_load 0.5 [get_ports {mmio_num_computation[2]}]
set_load -pin_load 0.5 [get_ports {mmio_num_computation[1]}]
set_load -pin_load 0.5 [get_ports {mmio_num_computation[0]}]
set_load -pin_load 0.5 [get_ports chip_chab_start]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_a[7]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_a[6]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_a[5]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_a[4]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_a[3]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_a[2]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_a[1]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_a[0]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_b[7]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_b[6]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_b[5]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_b[4]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_b[3]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_b[2]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_b[1]}]
set_load -pin_load 0.5 [get_ports {chip_chab_wdata_b[0]}]
set_load -pin_load 0.5 [get_ports chip_chab_wr]
set_load -pin_load 0.5 [get_ports tpu_a_re]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[8]}]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[7]}]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[6]}]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[5]}]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[4]}]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[3]}]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[2]}]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[1]}]
set_load -pin_load 0.5 [get_ports {tpu_a_addr[0]}]
set_load -pin_load 0.5 [get_ports tpu_b_re]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[8]}]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[7]}]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[6]}]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[5]}]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[4]}]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[3]}]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[2]}]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[1]}]
set_load -pin_load 0.5 [get_ports {tpu_b_addr[0]}]
set_load -pin_load 0.5 [get_ports sc_a_mem_ctrl]
set_load -pin_load 0.5 [get_ports sc_a_cen]
set_load -pin_load 0.5 [get_ports sc_a_wen]
set_load -pin_load 0.5 [get_ports {sc_a_addr[8]}]
set_load -pin_load 0.5 [get_ports {sc_a_addr[7]}]
set_load -pin_load 0.5 [get_ports {sc_a_addr[6]}]
set_load -pin_load 0.5 [get_ports {sc_a_addr[5]}]
set_load -pin_load 0.5 [get_ports {sc_a_addr[4]}]
set_load -pin_load 0.5 [get_ports {sc_a_addr[3]}]
set_load -pin_load 0.5 [get_ports {sc_a_addr[2]}]
set_load -pin_load 0.5 [get_ports {sc_a_addr[1]}]
set_load -pin_load 0.5 [get_ports {sc_a_addr[0]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[63]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[62]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[61]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[60]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[59]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[58]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[57]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[56]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[55]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[54]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[53]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[52]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[51]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[50]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[49]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[48]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[47]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[46]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[45]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[44]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[43]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[42]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[41]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[40]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[39]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[38]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[37]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[36]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[35]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[34]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[33]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[32]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[31]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[30]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[29]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[28]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[27]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[26]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[25]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[24]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[23]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[22]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[21]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[20]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[19]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[18]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[17]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[16]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[15]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[14]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[13]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[12]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[11]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[10]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[9]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[8]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[7]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[6]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[5]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[4]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[3]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[2]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[1]}]
set_load -pin_load 0.5 [get_ports {sc_a_din[0]}]
set_load -pin_load 0.5 [get_ports sc_b_mem_ctrl]
set_load -pin_load 0.5 [get_ports sc_b_cen]
set_load -pin_load 0.5 [get_ports sc_b_wen]
set_load -pin_load 0.5 [get_ports {sc_b_addr[8]}]
set_load -pin_load 0.5 [get_ports {sc_b_addr[7]}]
set_load -pin_load 0.5 [get_ports {sc_b_addr[6]}]
set_load -pin_load 0.5 [get_ports {sc_b_addr[5]}]
set_load -pin_load 0.5 [get_ports {sc_b_addr[4]}]
set_load -pin_load 0.5 [get_ports {sc_b_addr[3]}]
set_load -pin_load 0.5 [get_ports {sc_b_addr[2]}]
set_load -pin_load 0.5 [get_ports {sc_b_addr[1]}]
set_load -pin_load 0.5 [get_ports {sc_b_addr[0]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[63]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[62]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[61]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[60]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[59]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[58]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[57]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[56]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[55]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[54]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[53]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[52]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[51]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[50]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[49]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[48]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[47]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[46]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[45]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[44]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[43]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[42]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[41]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[40]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[39]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[38]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[37]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[36]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[35]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[34]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[33]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[32]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[31]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[30]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[29]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[28]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[27]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[26]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[25]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[24]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[23]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[22]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[21]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[20]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[19]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[18]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[17]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[16]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[15]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[14]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[13]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[12]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[11]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[10]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[9]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[8]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[7]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[6]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[5]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[4]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[3]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[2]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[1]}]
set_load -pin_load 0.5 [get_ports {sc_b_din[0]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[63]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[62]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[61]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[60]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[59]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[58]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[57]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[56]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[55]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[54]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[53]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[52]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[51]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[50]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[49]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[48]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[47]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[46]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[45]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[44]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[43]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[42]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[41]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[40]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[39]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[38]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[37]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[36]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[35]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[34]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[33]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[32]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[31]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[30]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[29]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[28]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[27]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[26]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[25]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[24]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[23]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[22]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[21]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[20]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[19]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[18]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[17]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[16]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[15]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[14]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[13]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[12]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[11]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[10]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[9]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[8]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[7]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[6]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[5]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[4]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[3]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[2]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[1]}]
set_load -pin_load 0.5 [get_ports {tpu_a_dout[0]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[63]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[62]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[61]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[60]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[59]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[58]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[57]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[56]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[55]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[54]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[53]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[52]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[51]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[50]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[49]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[48]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[47]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[46]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[45]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[44]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[43]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[42]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[41]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[40]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[39]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[38]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[37]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[36]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[35]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[34]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[33]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[32]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[31]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[30]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[29]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[28]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[27]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[26]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[25]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[24]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[23]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[22]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[21]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[20]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[19]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[18]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[17]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[16]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[15]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[14]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[13]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[12]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[11]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[10]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[9]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[8]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[7]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[6]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[5]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[4]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[3]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[2]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[1]}]
set_load -pin_load 0.5 [get_ports {tpu_b_dout[0]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[63]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[62]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[61]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[60]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[59]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[58]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[57]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[56]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[55]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[54]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[53]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[52]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[51]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[50]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[49]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[48]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[47]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[46]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[45]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[44]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[43]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[42]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[41]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[40]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[39]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[38]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[37]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[36]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[35]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[34]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[33]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[32]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[31]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[30]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[29]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[28]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[27]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[26]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[25]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[24]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[23]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[22]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[21]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[20]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[19]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[18]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[17]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[16]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[15]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[14]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[13]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[12]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[11]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[10]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[9]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[8]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[7]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[6]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[5]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[4]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[3]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[2]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[1]}]
set_load -pin_load 0.5 [get_ports {sc_a_mem_dout[0]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[63]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[62]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[61]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[60]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[59]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[58]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[57]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[56]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[55]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[54]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[53]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[52]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[51]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[50]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[49]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[48]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[47]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[46]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[45]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[44]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[43]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[42]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[41]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[40]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[39]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[38]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[37]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[36]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[35]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[34]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[33]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[32]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[31]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[30]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[29]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[28]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[27]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[26]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[25]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[24]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[23]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[22]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[21]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[20]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[19]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[18]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[17]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[16]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[15]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[14]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[13]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[12]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[11]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[10]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[9]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[8]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[7]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[6]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[5]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[4]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[3]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[2]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[1]}]
set_load -pin_load 0.5 [get_ports {sc_b_mem_dout[0]}]
group_path -weight 1.000000 -name C2O -from [list \
  [get_cells u_sram_a_u_sram]  \
  [get_cells u_sram_b_u_sram]  \
  [get_cells {u_slave_ab_cnt_a_reg[0]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[1]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[2]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[3]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[4]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[5]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[6]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[7]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[8]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[9]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[10]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[11]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[12]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[0]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[1]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[2]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[3]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[4]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[5]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[6]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[7]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[8]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[9]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[10]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[11]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[12]}]  \
  [get_cells {u_slave_ab_max_a_reg[6]}]  \
  [get_cells {u_slave_ab_max_a_reg[7]}]  \
  [get_cells {u_slave_ab_max_a_reg[8]}]  \
  [get_cells {u_slave_ab_max_a_reg[9]}]  \
  [get_cells {u_slave_ab_max_a_reg[10]}]  \
  [get_cells {u_slave_ab_max_a_reg[11]}]  \
  [get_cells {u_slave_ab_max_a_reg[12]}]  \
  [get_cells {u_slave_ab_max_b_reg[6]}]  \
  [get_cells {u_slave_ab_max_b_reg[7]}]  \
  [get_cells {u_slave_ab_max_b_reg[8]}]  \
  [get_cells {u_slave_ab_max_b_reg[9]}]  \
  [get_cells {u_slave_ab_max_b_reg[10]}]  \
  [get_cells {u_slave_ab_max_b_reg[11]}]  \
  [get_cells {u_slave_ab_max_b_reg[12]}]  \
  [get_cells u_slave_ab_we_a_en_reg]  \
  [get_cells u_slave_ab_we_b_en_reg]  \
  [get_cells {u_sram_a_bus_wbuf_reg[0]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[1]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[2]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[3]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[4]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[5]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[6]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[7]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[8]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[9]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[10]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[11]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[12]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[13]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[14]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[15]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[16]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[17]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[18]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[19]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[20]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[21]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[22]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[23]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[24]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[25]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[26]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[27]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[28]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[29]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[30]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[31]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[32]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[33]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[34]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[35]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[36]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[37]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[38]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[39]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[40]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[41]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[42]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[43]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[44]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[45]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[46]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[47]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[48]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[49]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[50]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[51]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[52]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[53]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[54]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[55]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[56]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[57]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[58]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[59]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[60]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[61]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[62]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[63]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[0]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[1]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[2]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[0]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[1]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[2]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[3]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[4]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[5]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[6]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[7]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[8]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[0]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[1]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[2]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[3]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[4]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[5]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[6]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[7]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[8]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[9]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[10]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[11]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[12]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[13]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[14]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[15]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[16]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[17]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[18]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[19]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[20]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[21]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[22]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[23]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[24]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[25]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[26]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[27]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[28]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[29]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[30]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[31]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[32]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[33]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[34]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[35]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[36]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[37]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[38]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[39]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[40]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[41]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[42]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[43]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[44]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[45]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[46]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[47]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[48]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[49]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[50]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[51]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[52]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[53]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[54]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[55]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[56]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[57]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[58]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[59]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[60]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[61]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[62]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[63]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[0]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[1]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[2]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[0]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[1]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[2]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[3]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[4]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[5]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[6]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[7]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[8]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[0]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[1]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[2]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[3]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[4]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[5]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[6]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[7]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[0]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[1]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[2]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[3]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[4]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[5]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[6]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[7]}]  \
  [get_cells u_slave_ab_chab_wr_s_reg]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[0]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[1]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[2]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[3]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[4]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[5]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[6]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[7]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[8]}]  \
  [get_cells u_sram_a_bus_we_d1_reg]  \
  [get_cells u_sram_a_bus_we_prev_reg]  \
  [get_cells {u_sram_a_flush_addr_reg[0]}]  \
  [get_cells {u_sram_a_flush_addr_reg[1]}]  \
  [get_cells {u_sram_a_flush_addr_reg[2]}]  \
  [get_cells {u_sram_a_flush_addr_reg[3]}]  \
  [get_cells {u_sram_a_flush_addr_reg[4]}]  \
  [get_cells {u_sram_a_flush_addr_reg[5]}]  \
  [get_cells {u_sram_a_flush_addr_reg[6]}]  \
  [get_cells {u_sram_a_flush_addr_reg[7]}]  \
  [get_cells {u_sram_a_flush_addr_reg[8]}]  \
  [get_cells u_sram_a_flush_d1_reg]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[0]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[1]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[2]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[3]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[4]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[5]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[6]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[7]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[8]}]  \
  [get_cells u_sram_b_bus_we_d1_reg]  \
  [get_cells u_sram_b_bus_we_prev_reg]  \
  [get_cells {u_sram_b_flush_addr_reg[0]}]  \
  [get_cells {u_sram_b_flush_addr_reg[1]}]  \
  [get_cells {u_sram_b_flush_addr_reg[2]}]  \
  [get_cells {u_sram_b_flush_addr_reg[3]}]  \
  [get_cells {u_sram_b_flush_addr_reg[4]}]  \
  [get_cells {u_sram_b_flush_addr_reg[5]}]  \
  [get_cells {u_sram_b_flush_addr_reg[6]}]  \
  [get_cells {u_sram_b_flush_addr_reg[7]}]  \
  [get_cells {u_sram_b_flush_addr_reg[8]}]  \
  [get_cells u_sram_b_flush_d1_reg] ] -to [list \
  [get_ports {tpu_a_dout[63]}]  \
  [get_ports {tpu_a_dout[62]}]  \
  [get_ports {tpu_a_dout[61]}]  \
  [get_ports {tpu_a_dout[60]}]  \
  [get_ports {tpu_a_dout[59]}]  \
  [get_ports {tpu_a_dout[58]}]  \
  [get_ports {tpu_a_dout[57]}]  \
  [get_ports {tpu_a_dout[56]}]  \
  [get_ports {tpu_a_dout[55]}]  \
  [get_ports {tpu_a_dout[54]}]  \
  [get_ports {tpu_a_dout[53]}]  \
  [get_ports {tpu_a_dout[52]}]  \
  [get_ports {tpu_a_dout[51]}]  \
  [get_ports {tpu_a_dout[50]}]  \
  [get_ports {tpu_a_dout[49]}]  \
  [get_ports {tpu_a_dout[48]}]  \
  [get_ports {tpu_a_dout[47]}]  \
  [get_ports {tpu_a_dout[46]}]  \
  [get_ports {tpu_a_dout[45]}]  \
  [get_ports {tpu_a_dout[44]}]  \
  [get_ports {tpu_a_dout[43]}]  \
  [get_ports {tpu_a_dout[42]}]  \
  [get_ports {tpu_a_dout[41]}]  \
  [get_ports {tpu_a_dout[40]}]  \
  [get_ports {tpu_a_dout[39]}]  \
  [get_ports {tpu_a_dout[38]}]  \
  [get_ports {tpu_a_dout[37]}]  \
  [get_ports {tpu_a_dout[36]}]  \
  [get_ports {tpu_a_dout[35]}]  \
  [get_ports {tpu_a_dout[34]}]  \
  [get_ports {tpu_a_dout[33]}]  \
  [get_ports {tpu_a_dout[32]}]  \
  [get_ports {tpu_a_dout[31]}]  \
  [get_ports {tpu_a_dout[30]}]  \
  [get_ports {tpu_a_dout[29]}]  \
  [get_ports {tpu_a_dout[28]}]  \
  [get_ports {tpu_a_dout[27]}]  \
  [get_ports {tpu_a_dout[26]}]  \
  [get_ports {tpu_a_dout[25]}]  \
  [get_ports {tpu_a_dout[24]}]  \
  [get_ports {tpu_a_dout[23]}]  \
  [get_ports {tpu_a_dout[22]}]  \
  [get_ports {tpu_a_dout[21]}]  \
  [get_ports {tpu_a_dout[20]}]  \
  [get_ports {tpu_a_dout[19]}]  \
  [get_ports {tpu_a_dout[18]}]  \
  [get_ports {tpu_a_dout[17]}]  \
  [get_ports {tpu_a_dout[16]}]  \
  [get_ports {tpu_a_dout[15]}]  \
  [get_ports {tpu_a_dout[14]}]  \
  [get_ports {tpu_a_dout[13]}]  \
  [get_ports {tpu_a_dout[12]}]  \
  [get_ports {tpu_a_dout[11]}]  \
  [get_ports {tpu_a_dout[10]}]  \
  [get_ports {tpu_a_dout[9]}]  \
  [get_ports {tpu_a_dout[8]}]  \
  [get_ports {tpu_a_dout[7]}]  \
  [get_ports {tpu_a_dout[6]}]  \
  [get_ports {tpu_a_dout[5]}]  \
  [get_ports {tpu_a_dout[4]}]  \
  [get_ports {tpu_a_dout[3]}]  \
  [get_ports {tpu_a_dout[2]}]  \
  [get_ports {tpu_a_dout[1]}]  \
  [get_ports {tpu_a_dout[0]}]  \
  [get_ports {tpu_b_dout[63]}]  \
  [get_ports {tpu_b_dout[62]}]  \
  [get_ports {tpu_b_dout[61]}]  \
  [get_ports {tpu_b_dout[60]}]  \
  [get_ports {tpu_b_dout[59]}]  \
  [get_ports {tpu_b_dout[58]}]  \
  [get_ports {tpu_b_dout[57]}]  \
  [get_ports {tpu_b_dout[56]}]  \
  [get_ports {tpu_b_dout[55]}]  \
  [get_ports {tpu_b_dout[54]}]  \
  [get_ports {tpu_b_dout[53]}]  \
  [get_ports {tpu_b_dout[52]}]  \
  [get_ports {tpu_b_dout[51]}]  \
  [get_ports {tpu_b_dout[50]}]  \
  [get_ports {tpu_b_dout[49]}]  \
  [get_ports {tpu_b_dout[48]}]  \
  [get_ports {tpu_b_dout[47]}]  \
  [get_ports {tpu_b_dout[46]}]  \
  [get_ports {tpu_b_dout[45]}]  \
  [get_ports {tpu_b_dout[44]}]  \
  [get_ports {tpu_b_dout[43]}]  \
  [get_ports {tpu_b_dout[42]}]  \
  [get_ports {tpu_b_dout[41]}]  \
  [get_ports {tpu_b_dout[40]}]  \
  [get_ports {tpu_b_dout[39]}]  \
  [get_ports {tpu_b_dout[38]}]  \
  [get_ports {tpu_b_dout[37]}]  \
  [get_ports {tpu_b_dout[36]}]  \
  [get_ports {tpu_b_dout[35]}]  \
  [get_ports {tpu_b_dout[34]}]  \
  [get_ports {tpu_b_dout[33]}]  \
  [get_ports {tpu_b_dout[32]}]  \
  [get_ports {tpu_b_dout[31]}]  \
  [get_ports {tpu_b_dout[30]}]  \
  [get_ports {tpu_b_dout[29]}]  \
  [get_ports {tpu_b_dout[28]}]  \
  [get_ports {tpu_b_dout[27]}]  \
  [get_ports {tpu_b_dout[26]}]  \
  [get_ports {tpu_b_dout[25]}]  \
  [get_ports {tpu_b_dout[24]}]  \
  [get_ports {tpu_b_dout[23]}]  \
  [get_ports {tpu_b_dout[22]}]  \
  [get_ports {tpu_b_dout[21]}]  \
  [get_ports {tpu_b_dout[20]}]  \
  [get_ports {tpu_b_dout[19]}]  \
  [get_ports {tpu_b_dout[18]}]  \
  [get_ports {tpu_b_dout[17]}]  \
  [get_ports {tpu_b_dout[16]}]  \
  [get_ports {tpu_b_dout[15]}]  \
  [get_ports {tpu_b_dout[14]}]  \
  [get_ports {tpu_b_dout[13]}]  \
  [get_ports {tpu_b_dout[12]}]  \
  [get_ports {tpu_b_dout[11]}]  \
  [get_ports {tpu_b_dout[10]}]  \
  [get_ports {tpu_b_dout[9]}]  \
  [get_ports {tpu_b_dout[8]}]  \
  [get_ports {tpu_b_dout[7]}]  \
  [get_ports {tpu_b_dout[6]}]  \
  [get_ports {tpu_b_dout[5]}]  \
  [get_ports {tpu_b_dout[4]}]  \
  [get_ports {tpu_b_dout[3]}]  \
  [get_ports {tpu_b_dout[2]}]  \
  [get_ports {tpu_b_dout[1]}]  \
  [get_ports {tpu_b_dout[0]}]  \
  [get_ports {sc_a_mem_dout[63]}]  \
  [get_ports {sc_a_mem_dout[62]}]  \
  [get_ports {sc_a_mem_dout[61]}]  \
  [get_ports {sc_a_mem_dout[60]}]  \
  [get_ports {sc_a_mem_dout[59]}]  \
  [get_ports {sc_a_mem_dout[58]}]  \
  [get_ports {sc_a_mem_dout[57]}]  \
  [get_ports {sc_a_mem_dout[56]}]  \
  [get_ports {sc_a_mem_dout[55]}]  \
  [get_ports {sc_a_mem_dout[54]}]  \
  [get_ports {sc_a_mem_dout[53]}]  \
  [get_ports {sc_a_mem_dout[52]}]  \
  [get_ports {sc_a_mem_dout[51]}]  \
  [get_ports {sc_a_mem_dout[50]}]  \
  [get_ports {sc_a_mem_dout[49]}]  \
  [get_ports {sc_a_mem_dout[48]}]  \
  [get_ports {sc_a_mem_dout[47]}]  \
  [get_ports {sc_a_mem_dout[46]}]  \
  [get_ports {sc_a_mem_dout[45]}]  \
  [get_ports {sc_a_mem_dout[44]}]  \
  [get_ports {sc_a_mem_dout[43]}]  \
  [get_ports {sc_a_mem_dout[42]}]  \
  [get_ports {sc_a_mem_dout[41]}]  \
  [get_ports {sc_a_mem_dout[40]}]  \
  [get_ports {sc_a_mem_dout[39]}]  \
  [get_ports {sc_a_mem_dout[38]}]  \
  [get_ports {sc_a_mem_dout[37]}]  \
  [get_ports {sc_a_mem_dout[36]}]  \
  [get_ports {sc_a_mem_dout[35]}]  \
  [get_ports {sc_a_mem_dout[34]}]  \
  [get_ports {sc_a_mem_dout[33]}]  \
  [get_ports {sc_a_mem_dout[32]}]  \
  [get_ports {sc_a_mem_dout[31]}]  \
  [get_ports {sc_a_mem_dout[30]}]  \
  [get_ports {sc_a_mem_dout[29]}]  \
  [get_ports {sc_a_mem_dout[28]}]  \
  [get_ports {sc_a_mem_dout[27]}]  \
  [get_ports {sc_a_mem_dout[26]}]  \
  [get_ports {sc_a_mem_dout[25]}]  \
  [get_ports {sc_a_mem_dout[24]}]  \
  [get_ports {sc_a_mem_dout[23]}]  \
  [get_ports {sc_a_mem_dout[22]}]  \
  [get_ports {sc_a_mem_dout[21]}]  \
  [get_ports {sc_a_mem_dout[20]}]  \
  [get_ports {sc_a_mem_dout[19]}]  \
  [get_ports {sc_a_mem_dout[18]}]  \
  [get_ports {sc_a_mem_dout[17]}]  \
  [get_ports {sc_a_mem_dout[16]}]  \
  [get_ports {sc_a_mem_dout[15]}]  \
  [get_ports {sc_a_mem_dout[14]}]  \
  [get_ports {sc_a_mem_dout[13]}]  \
  [get_ports {sc_a_mem_dout[12]}]  \
  [get_ports {sc_a_mem_dout[11]}]  \
  [get_ports {sc_a_mem_dout[10]}]  \
  [get_ports {sc_a_mem_dout[9]}]  \
  [get_ports {sc_a_mem_dout[8]}]  \
  [get_ports {sc_a_mem_dout[7]}]  \
  [get_ports {sc_a_mem_dout[6]}]  \
  [get_ports {sc_a_mem_dout[5]}]  \
  [get_ports {sc_a_mem_dout[4]}]  \
  [get_ports {sc_a_mem_dout[3]}]  \
  [get_ports {sc_a_mem_dout[2]}]  \
  [get_ports {sc_a_mem_dout[1]}]  \
  [get_ports {sc_a_mem_dout[0]}]  \
  [get_ports {sc_b_mem_dout[63]}]  \
  [get_ports {sc_b_mem_dout[62]}]  \
  [get_ports {sc_b_mem_dout[61]}]  \
  [get_ports {sc_b_mem_dout[60]}]  \
  [get_ports {sc_b_mem_dout[59]}]  \
  [get_ports {sc_b_mem_dout[58]}]  \
  [get_ports {sc_b_mem_dout[57]}]  \
  [get_ports {sc_b_mem_dout[56]}]  \
  [get_ports {sc_b_mem_dout[55]}]  \
  [get_ports {sc_b_mem_dout[54]}]  \
  [get_ports {sc_b_mem_dout[53]}]  \
  [get_ports {sc_b_mem_dout[52]}]  \
  [get_ports {sc_b_mem_dout[51]}]  \
  [get_ports {sc_b_mem_dout[50]}]  \
  [get_ports {sc_b_mem_dout[49]}]  \
  [get_ports {sc_b_mem_dout[48]}]  \
  [get_ports {sc_b_mem_dout[47]}]  \
  [get_ports {sc_b_mem_dout[46]}]  \
  [get_ports {sc_b_mem_dout[45]}]  \
  [get_ports {sc_b_mem_dout[44]}]  \
  [get_ports {sc_b_mem_dout[43]}]  \
  [get_ports {sc_b_mem_dout[42]}]  \
  [get_ports {sc_b_mem_dout[41]}]  \
  [get_ports {sc_b_mem_dout[40]}]  \
  [get_ports {sc_b_mem_dout[39]}]  \
  [get_ports {sc_b_mem_dout[38]}]  \
  [get_ports {sc_b_mem_dout[37]}]  \
  [get_ports {sc_b_mem_dout[36]}]  \
  [get_ports {sc_b_mem_dout[35]}]  \
  [get_ports {sc_b_mem_dout[34]}]  \
  [get_ports {sc_b_mem_dout[33]}]  \
  [get_ports {sc_b_mem_dout[32]}]  \
  [get_ports {sc_b_mem_dout[31]}]  \
  [get_ports {sc_b_mem_dout[30]}]  \
  [get_ports {sc_b_mem_dout[29]}]  \
  [get_ports {sc_b_mem_dout[28]}]  \
  [get_ports {sc_b_mem_dout[27]}]  \
  [get_ports {sc_b_mem_dout[26]}]  \
  [get_ports {sc_b_mem_dout[25]}]  \
  [get_ports {sc_b_mem_dout[24]}]  \
  [get_ports {sc_b_mem_dout[23]}]  \
  [get_ports {sc_b_mem_dout[22]}]  \
  [get_ports {sc_b_mem_dout[21]}]  \
  [get_ports {sc_b_mem_dout[20]}]  \
  [get_ports {sc_b_mem_dout[19]}]  \
  [get_ports {sc_b_mem_dout[18]}]  \
  [get_ports {sc_b_mem_dout[17]}]  \
  [get_ports {sc_b_mem_dout[16]}]  \
  [get_ports {sc_b_mem_dout[15]}]  \
  [get_ports {sc_b_mem_dout[14]}]  \
  [get_ports {sc_b_mem_dout[13]}]  \
  [get_ports {sc_b_mem_dout[12]}]  \
  [get_ports {sc_b_mem_dout[11]}]  \
  [get_ports {sc_b_mem_dout[10]}]  \
  [get_ports {sc_b_mem_dout[9]}]  \
  [get_ports {sc_b_mem_dout[8]}]  \
  [get_ports {sc_b_mem_dout[7]}]  \
  [get_ports {sc_b_mem_dout[6]}]  \
  [get_ports {sc_b_mem_dout[5]}]  \
  [get_ports {sc_b_mem_dout[4]}]  \
  [get_ports {sc_b_mem_dout[3]}]  \
  [get_ports {sc_b_mem_dout[2]}]  \
  [get_ports {sc_b_mem_dout[1]}]  \
  [get_ports {sc_b_mem_dout[0]}] ]
group_path -weight 1.000000 -name I2C -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports {mmio_dim_m[6]}]  \
  [get_ports {mmio_dim_m[5]}]  \
  [get_ports {mmio_dim_m[4]}]  \
  [get_ports {mmio_dim_m[3]}]  \
  [get_ports {mmio_dim_m[2]}]  \
  [get_ports {mmio_dim_m[1]}]  \
  [get_ports {mmio_dim_m[0]}]  \
  [get_ports {mmio_dim_n[6]}]  \
  [get_ports {mmio_dim_n[5]}]  \
  [get_ports {mmio_dim_n[4]}]  \
  [get_ports {mmio_dim_n[3]}]  \
  [get_ports {mmio_dim_n[2]}]  \
  [get_ports {mmio_dim_n[1]}]  \
  [get_ports {mmio_dim_n[0]}]  \
  [get_ports {mmio_dim_k[6]}]  \
  [get_ports {mmio_dim_k[5]}]  \
  [get_ports {mmio_dim_k[4]}]  \
  [get_ports {mmio_dim_k[3]}]  \
  [get_ports {mmio_dim_k[2]}]  \
  [get_ports {mmio_dim_k[1]}]  \
  [get_ports {mmio_dim_k[0]}]  \
  [get_ports {mmio_num_computation[6]}]  \
  [get_ports {mmio_num_computation[5]}]  \
  [get_ports {mmio_num_computation[4]}]  \
  [get_ports {mmio_num_computation[3]}]  \
  [get_ports {mmio_num_computation[2]}]  \
  [get_ports {mmio_num_computation[1]}]  \
  [get_ports {mmio_num_computation[0]}]  \
  [get_ports chip_chab_start]  \
  [get_ports {chip_chab_wdata_a[7]}]  \
  [get_ports {chip_chab_wdata_a[6]}]  \
  [get_ports {chip_chab_wdata_a[5]}]  \
  [get_ports {chip_chab_wdata_a[4]}]  \
  [get_ports {chip_chab_wdata_a[3]}]  \
  [get_ports {chip_chab_wdata_a[2]}]  \
  [get_ports {chip_chab_wdata_a[1]}]  \
  [get_ports {chip_chab_wdata_a[0]}]  \
  [get_ports {chip_chab_wdata_b[7]}]  \
  [get_ports {chip_chab_wdata_b[6]}]  \
  [get_ports {chip_chab_wdata_b[5]}]  \
  [get_ports {chip_chab_wdata_b[4]}]  \
  [get_ports {chip_chab_wdata_b[3]}]  \
  [get_ports {chip_chab_wdata_b[2]}]  \
  [get_ports {chip_chab_wdata_b[1]}]  \
  [get_ports {chip_chab_wdata_b[0]}]  \
  [get_ports chip_chab_wr]  \
  [get_ports tpu_a_re]  \
  [get_ports {tpu_a_addr[8]}]  \
  [get_ports {tpu_a_addr[7]}]  \
  [get_ports {tpu_a_addr[6]}]  \
  [get_ports {tpu_a_addr[5]}]  \
  [get_ports {tpu_a_addr[4]}]  \
  [get_ports {tpu_a_addr[3]}]  \
  [get_ports {tpu_a_addr[2]}]  \
  [get_ports {tpu_a_addr[1]}]  \
  [get_ports {tpu_a_addr[0]}]  \
  [get_ports tpu_b_re]  \
  [get_ports {tpu_b_addr[8]}]  \
  [get_ports {tpu_b_addr[7]}]  \
  [get_ports {tpu_b_addr[6]}]  \
  [get_ports {tpu_b_addr[5]}]  \
  [get_ports {tpu_b_addr[4]}]  \
  [get_ports {tpu_b_addr[3]}]  \
  [get_ports {tpu_b_addr[2]}]  \
  [get_ports {tpu_b_addr[1]}]  \
  [get_ports {tpu_b_addr[0]}]  \
  [get_ports sc_a_mem_ctrl]  \
  [get_ports sc_a_cen]  \
  [get_ports sc_a_wen]  \
  [get_ports {sc_a_addr[8]}]  \
  [get_ports {sc_a_addr[7]}]  \
  [get_ports {sc_a_addr[6]}]  \
  [get_ports {sc_a_addr[5]}]  \
  [get_ports {sc_a_addr[4]}]  \
  [get_ports {sc_a_addr[3]}]  \
  [get_ports {sc_a_addr[2]}]  \
  [get_ports {sc_a_addr[1]}]  \
  [get_ports {sc_a_addr[0]}]  \
  [get_ports {sc_a_din[63]}]  \
  [get_ports {sc_a_din[62]}]  \
  [get_ports {sc_a_din[61]}]  \
  [get_ports {sc_a_din[60]}]  \
  [get_ports {sc_a_din[59]}]  \
  [get_ports {sc_a_din[58]}]  \
  [get_ports {sc_a_din[57]}]  \
  [get_ports {sc_a_din[56]}]  \
  [get_ports {sc_a_din[55]}]  \
  [get_ports {sc_a_din[54]}]  \
  [get_ports {sc_a_din[53]}]  \
  [get_ports {sc_a_din[52]}]  \
  [get_ports {sc_a_din[51]}]  \
  [get_ports {sc_a_din[50]}]  \
  [get_ports {sc_a_din[49]}]  \
  [get_ports {sc_a_din[48]}]  \
  [get_ports {sc_a_din[47]}]  \
  [get_ports {sc_a_din[46]}]  \
  [get_ports {sc_a_din[45]}]  \
  [get_ports {sc_a_din[44]}]  \
  [get_ports {sc_a_din[43]}]  \
  [get_ports {sc_a_din[42]}]  \
  [get_ports {sc_a_din[41]}]  \
  [get_ports {sc_a_din[40]}]  \
  [get_ports {sc_a_din[39]}]  \
  [get_ports {sc_a_din[38]}]  \
  [get_ports {sc_a_din[37]}]  \
  [get_ports {sc_a_din[36]}]  \
  [get_ports {sc_a_din[35]}]  \
  [get_ports {sc_a_din[34]}]  \
  [get_ports {sc_a_din[33]}]  \
  [get_ports {sc_a_din[32]}]  \
  [get_ports {sc_a_din[31]}]  \
  [get_ports {sc_a_din[30]}]  \
  [get_ports {sc_a_din[29]}]  \
  [get_ports {sc_a_din[28]}]  \
  [get_ports {sc_a_din[27]}]  \
  [get_ports {sc_a_din[26]}]  \
  [get_ports {sc_a_din[25]}]  \
  [get_ports {sc_a_din[24]}]  \
  [get_ports {sc_a_din[23]}]  \
  [get_ports {sc_a_din[22]}]  \
  [get_ports {sc_a_din[21]}]  \
  [get_ports {sc_a_din[20]}]  \
  [get_ports {sc_a_din[19]}]  \
  [get_ports {sc_a_din[18]}]  \
  [get_ports {sc_a_din[17]}]  \
  [get_ports {sc_a_din[16]}]  \
  [get_ports {sc_a_din[15]}]  \
  [get_ports {sc_a_din[14]}]  \
  [get_ports {sc_a_din[13]}]  \
  [get_ports {sc_a_din[12]}]  \
  [get_ports {sc_a_din[11]}]  \
  [get_ports {sc_a_din[10]}]  \
  [get_ports {sc_a_din[9]}]  \
  [get_ports {sc_a_din[8]}]  \
  [get_ports {sc_a_din[7]}]  \
  [get_ports {sc_a_din[6]}]  \
  [get_ports {sc_a_din[5]}]  \
  [get_ports {sc_a_din[4]}]  \
  [get_ports {sc_a_din[3]}]  \
  [get_ports {sc_a_din[2]}]  \
  [get_ports {sc_a_din[1]}]  \
  [get_ports {sc_a_din[0]}]  \
  [get_ports sc_b_mem_ctrl]  \
  [get_ports sc_b_cen]  \
  [get_ports sc_b_wen]  \
  [get_ports {sc_b_addr[8]}]  \
  [get_ports {sc_b_addr[7]}]  \
  [get_ports {sc_b_addr[6]}]  \
  [get_ports {sc_b_addr[5]}]  \
  [get_ports {sc_b_addr[4]}]  \
  [get_ports {sc_b_addr[3]}]  \
  [get_ports {sc_b_addr[2]}]  \
  [get_ports {sc_b_addr[1]}]  \
  [get_ports {sc_b_addr[0]}]  \
  [get_ports {sc_b_din[63]}]  \
  [get_ports {sc_b_din[62]}]  \
  [get_ports {sc_b_din[61]}]  \
  [get_ports {sc_b_din[60]}]  \
  [get_ports {sc_b_din[59]}]  \
  [get_ports {sc_b_din[58]}]  \
  [get_ports {sc_b_din[57]}]  \
  [get_ports {sc_b_din[56]}]  \
  [get_ports {sc_b_din[55]}]  \
  [get_ports {sc_b_din[54]}]  \
  [get_ports {sc_b_din[53]}]  \
  [get_ports {sc_b_din[52]}]  \
  [get_ports {sc_b_din[51]}]  \
  [get_ports {sc_b_din[50]}]  \
  [get_ports {sc_b_din[49]}]  \
  [get_ports {sc_b_din[48]}]  \
  [get_ports {sc_b_din[47]}]  \
  [get_ports {sc_b_din[46]}]  \
  [get_ports {sc_b_din[45]}]  \
  [get_ports {sc_b_din[44]}]  \
  [get_ports {sc_b_din[43]}]  \
  [get_ports {sc_b_din[42]}]  \
  [get_ports {sc_b_din[41]}]  \
  [get_ports {sc_b_din[40]}]  \
  [get_ports {sc_b_din[39]}]  \
  [get_ports {sc_b_din[38]}]  \
  [get_ports {sc_b_din[37]}]  \
  [get_ports {sc_b_din[36]}]  \
  [get_ports {sc_b_din[35]}]  \
  [get_ports {sc_b_din[34]}]  \
  [get_ports {sc_b_din[33]}]  \
  [get_ports {sc_b_din[32]}]  \
  [get_ports {sc_b_din[31]}]  \
  [get_ports {sc_b_din[30]}]  \
  [get_ports {sc_b_din[29]}]  \
  [get_ports {sc_b_din[28]}]  \
  [get_ports {sc_b_din[27]}]  \
  [get_ports {sc_b_din[26]}]  \
  [get_ports {sc_b_din[25]}]  \
  [get_ports {sc_b_din[24]}]  \
  [get_ports {sc_b_din[23]}]  \
  [get_ports {sc_b_din[22]}]  \
  [get_ports {sc_b_din[21]}]  \
  [get_ports {sc_b_din[20]}]  \
  [get_ports {sc_b_din[19]}]  \
  [get_ports {sc_b_din[18]}]  \
  [get_ports {sc_b_din[17]}]  \
  [get_ports {sc_b_din[16]}]  \
  [get_ports {sc_b_din[15]}]  \
  [get_ports {sc_b_din[14]}]  \
  [get_ports {sc_b_din[13]}]  \
  [get_ports {sc_b_din[12]}]  \
  [get_ports {sc_b_din[11]}]  \
  [get_ports {sc_b_din[10]}]  \
  [get_ports {sc_b_din[9]}]  \
  [get_ports {sc_b_din[8]}]  \
  [get_ports {sc_b_din[7]}]  \
  [get_ports {sc_b_din[6]}]  \
  [get_ports {sc_b_din[5]}]  \
  [get_ports {sc_b_din[4]}]  \
  [get_ports {sc_b_din[3]}]  \
  [get_ports {sc_b_din[2]}]  \
  [get_ports {sc_b_din[1]}]  \
  [get_ports {sc_b_din[0]}] ] -to [list \
  [get_cells u_sram_a_u_sram]  \
  [get_cells u_sram_b_u_sram]  \
  [get_cells {u_slave_ab_cnt_a_reg[0]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[1]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[2]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[3]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[4]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[5]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[6]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[7]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[8]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[9]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[10]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[11]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[12]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[0]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[1]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[2]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[3]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[4]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[5]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[6]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[7]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[8]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[9]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[10]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[11]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[12]}]  \
  [get_cells {u_slave_ab_max_a_reg[6]}]  \
  [get_cells {u_slave_ab_max_a_reg[7]}]  \
  [get_cells {u_slave_ab_max_a_reg[8]}]  \
  [get_cells {u_slave_ab_max_a_reg[9]}]  \
  [get_cells {u_slave_ab_max_a_reg[10]}]  \
  [get_cells {u_slave_ab_max_a_reg[11]}]  \
  [get_cells {u_slave_ab_max_a_reg[12]}]  \
  [get_cells {u_slave_ab_max_b_reg[6]}]  \
  [get_cells {u_slave_ab_max_b_reg[7]}]  \
  [get_cells {u_slave_ab_max_b_reg[8]}]  \
  [get_cells {u_slave_ab_max_b_reg[9]}]  \
  [get_cells {u_slave_ab_max_b_reg[10]}]  \
  [get_cells {u_slave_ab_max_b_reg[11]}]  \
  [get_cells {u_slave_ab_max_b_reg[12]}]  \
  [get_cells u_slave_ab_we_a_en_reg]  \
  [get_cells u_slave_ab_we_b_en_reg]  \
  [get_cells {u_sram_a_bus_wbuf_reg[0]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[1]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[2]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[3]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[4]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[5]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[6]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[7]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[8]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[9]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[10]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[11]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[12]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[13]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[14]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[15]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[16]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[17]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[18]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[19]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[20]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[21]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[22]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[23]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[24]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[25]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[26]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[27]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[28]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[29]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[30]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[31]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[32]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[33]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[34]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[35]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[36]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[37]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[38]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[39]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[40]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[41]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[42]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[43]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[44]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[45]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[46]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[47]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[48]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[49]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[50]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[51]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[52]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[53]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[54]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[55]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[56]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[57]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[58]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[59]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[60]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[61]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[62]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[63]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[0]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[1]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[2]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[0]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[1]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[2]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[3]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[4]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[5]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[6]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[7]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[8]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[0]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[1]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[2]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[3]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[4]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[5]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[6]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[7]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[8]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[9]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[10]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[11]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[12]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[13]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[14]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[15]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[16]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[17]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[18]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[19]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[20]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[21]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[22]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[23]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[24]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[25]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[26]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[27]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[28]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[29]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[30]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[31]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[32]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[33]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[34]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[35]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[36]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[37]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[38]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[39]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[40]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[41]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[42]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[43]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[44]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[45]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[46]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[47]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[48]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[49]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[50]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[51]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[52]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[53]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[54]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[55]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[56]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[57]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[58]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[59]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[60]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[61]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[62]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[63]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[0]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[1]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[2]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[0]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[1]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[2]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[3]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[4]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[5]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[6]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[7]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[8]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[0]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[1]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[2]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[3]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[4]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[5]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[6]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[7]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[0]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[1]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[2]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[3]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[4]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[5]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[6]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[7]}]  \
  [get_cells u_slave_ab_chab_wr_s_reg]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[0]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[1]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[2]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[3]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[4]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[5]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[6]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[7]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[8]}]  \
  [get_cells u_sram_a_bus_we_d1_reg]  \
  [get_cells u_sram_a_bus_we_prev_reg]  \
  [get_cells {u_sram_a_flush_addr_reg[0]}]  \
  [get_cells {u_sram_a_flush_addr_reg[1]}]  \
  [get_cells {u_sram_a_flush_addr_reg[2]}]  \
  [get_cells {u_sram_a_flush_addr_reg[3]}]  \
  [get_cells {u_sram_a_flush_addr_reg[4]}]  \
  [get_cells {u_sram_a_flush_addr_reg[5]}]  \
  [get_cells {u_sram_a_flush_addr_reg[6]}]  \
  [get_cells {u_sram_a_flush_addr_reg[7]}]  \
  [get_cells {u_sram_a_flush_addr_reg[8]}]  \
  [get_cells u_sram_a_flush_d1_reg]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[0]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[1]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[2]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[3]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[4]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[5]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[6]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[7]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[8]}]  \
  [get_cells u_sram_b_bus_we_d1_reg]  \
  [get_cells u_sram_b_bus_we_prev_reg]  \
  [get_cells {u_sram_b_flush_addr_reg[0]}]  \
  [get_cells {u_sram_b_flush_addr_reg[1]}]  \
  [get_cells {u_sram_b_flush_addr_reg[2]}]  \
  [get_cells {u_sram_b_flush_addr_reg[3]}]  \
  [get_cells {u_sram_b_flush_addr_reg[4]}]  \
  [get_cells {u_sram_b_flush_addr_reg[5]}]  \
  [get_cells {u_sram_b_flush_addr_reg[6]}]  \
  [get_cells {u_sram_b_flush_addr_reg[7]}]  \
  [get_cells {u_sram_b_flush_addr_reg[8]}]  \
  [get_cells u_sram_b_flush_d1_reg] ]
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports clk]  \
  [get_ports rstn]  \
  [get_ports {mmio_dim_m[6]}]  \
  [get_ports {mmio_dim_m[5]}]  \
  [get_ports {mmio_dim_m[4]}]  \
  [get_ports {mmio_dim_m[3]}]  \
  [get_ports {mmio_dim_m[2]}]  \
  [get_ports {mmio_dim_m[1]}]  \
  [get_ports {mmio_dim_m[0]}]  \
  [get_ports {mmio_dim_n[6]}]  \
  [get_ports {mmio_dim_n[5]}]  \
  [get_ports {mmio_dim_n[4]}]  \
  [get_ports {mmio_dim_n[3]}]  \
  [get_ports {mmio_dim_n[2]}]  \
  [get_ports {mmio_dim_n[1]}]  \
  [get_ports {mmio_dim_n[0]}]  \
  [get_ports {mmio_dim_k[6]}]  \
  [get_ports {mmio_dim_k[5]}]  \
  [get_ports {mmio_dim_k[4]}]  \
  [get_ports {mmio_dim_k[3]}]  \
  [get_ports {mmio_dim_k[2]}]  \
  [get_ports {mmio_dim_k[1]}]  \
  [get_ports {mmio_dim_k[0]}]  \
  [get_ports {mmio_num_computation[6]}]  \
  [get_ports {mmio_num_computation[5]}]  \
  [get_ports {mmio_num_computation[4]}]  \
  [get_ports {mmio_num_computation[3]}]  \
  [get_ports {mmio_num_computation[2]}]  \
  [get_ports {mmio_num_computation[1]}]  \
  [get_ports {mmio_num_computation[0]}]  \
  [get_ports chip_chab_start]  \
  [get_ports {chip_chab_wdata_a[7]}]  \
  [get_ports {chip_chab_wdata_a[6]}]  \
  [get_ports {chip_chab_wdata_a[5]}]  \
  [get_ports {chip_chab_wdata_a[4]}]  \
  [get_ports {chip_chab_wdata_a[3]}]  \
  [get_ports {chip_chab_wdata_a[2]}]  \
  [get_ports {chip_chab_wdata_a[1]}]  \
  [get_ports {chip_chab_wdata_a[0]}]  \
  [get_ports {chip_chab_wdata_b[7]}]  \
  [get_ports {chip_chab_wdata_b[6]}]  \
  [get_ports {chip_chab_wdata_b[5]}]  \
  [get_ports {chip_chab_wdata_b[4]}]  \
  [get_ports {chip_chab_wdata_b[3]}]  \
  [get_ports {chip_chab_wdata_b[2]}]  \
  [get_ports {chip_chab_wdata_b[1]}]  \
  [get_ports {chip_chab_wdata_b[0]}]  \
  [get_ports chip_chab_wr]  \
  [get_ports tpu_a_re]  \
  [get_ports {tpu_a_addr[8]}]  \
  [get_ports {tpu_a_addr[7]}]  \
  [get_ports {tpu_a_addr[6]}]  \
  [get_ports {tpu_a_addr[5]}]  \
  [get_ports {tpu_a_addr[4]}]  \
  [get_ports {tpu_a_addr[3]}]  \
  [get_ports {tpu_a_addr[2]}]  \
  [get_ports {tpu_a_addr[1]}]  \
  [get_ports {tpu_a_addr[0]}]  \
  [get_ports tpu_b_re]  \
  [get_ports {tpu_b_addr[8]}]  \
  [get_ports {tpu_b_addr[7]}]  \
  [get_ports {tpu_b_addr[6]}]  \
  [get_ports {tpu_b_addr[5]}]  \
  [get_ports {tpu_b_addr[4]}]  \
  [get_ports {tpu_b_addr[3]}]  \
  [get_ports {tpu_b_addr[2]}]  \
  [get_ports {tpu_b_addr[1]}]  \
  [get_ports {tpu_b_addr[0]}]  \
  [get_ports sc_a_mem_ctrl]  \
  [get_ports sc_a_cen]  \
  [get_ports sc_a_wen]  \
  [get_ports {sc_a_addr[8]}]  \
  [get_ports {sc_a_addr[7]}]  \
  [get_ports {sc_a_addr[6]}]  \
  [get_ports {sc_a_addr[5]}]  \
  [get_ports {sc_a_addr[4]}]  \
  [get_ports {sc_a_addr[3]}]  \
  [get_ports {sc_a_addr[2]}]  \
  [get_ports {sc_a_addr[1]}]  \
  [get_ports {sc_a_addr[0]}]  \
  [get_ports {sc_a_din[63]}]  \
  [get_ports {sc_a_din[62]}]  \
  [get_ports {sc_a_din[61]}]  \
  [get_ports {sc_a_din[60]}]  \
  [get_ports {sc_a_din[59]}]  \
  [get_ports {sc_a_din[58]}]  \
  [get_ports {sc_a_din[57]}]  \
  [get_ports {sc_a_din[56]}]  \
  [get_ports {sc_a_din[55]}]  \
  [get_ports {sc_a_din[54]}]  \
  [get_ports {sc_a_din[53]}]  \
  [get_ports {sc_a_din[52]}]  \
  [get_ports {sc_a_din[51]}]  \
  [get_ports {sc_a_din[50]}]  \
  [get_ports {sc_a_din[49]}]  \
  [get_ports {sc_a_din[48]}]  \
  [get_ports {sc_a_din[47]}]  \
  [get_ports {sc_a_din[46]}]  \
  [get_ports {sc_a_din[45]}]  \
  [get_ports {sc_a_din[44]}]  \
  [get_ports {sc_a_din[43]}]  \
  [get_ports {sc_a_din[42]}]  \
  [get_ports {sc_a_din[41]}]  \
  [get_ports {sc_a_din[40]}]  \
  [get_ports {sc_a_din[39]}]  \
  [get_ports {sc_a_din[38]}]  \
  [get_ports {sc_a_din[37]}]  \
  [get_ports {sc_a_din[36]}]  \
  [get_ports {sc_a_din[35]}]  \
  [get_ports {sc_a_din[34]}]  \
  [get_ports {sc_a_din[33]}]  \
  [get_ports {sc_a_din[32]}]  \
  [get_ports {sc_a_din[31]}]  \
  [get_ports {sc_a_din[30]}]  \
  [get_ports {sc_a_din[29]}]  \
  [get_ports {sc_a_din[28]}]  \
  [get_ports {sc_a_din[27]}]  \
  [get_ports {sc_a_din[26]}]  \
  [get_ports {sc_a_din[25]}]  \
  [get_ports {sc_a_din[24]}]  \
  [get_ports {sc_a_din[23]}]  \
  [get_ports {sc_a_din[22]}]  \
  [get_ports {sc_a_din[21]}]  \
  [get_ports {sc_a_din[20]}]  \
  [get_ports {sc_a_din[19]}]  \
  [get_ports {sc_a_din[18]}]  \
  [get_ports {sc_a_din[17]}]  \
  [get_ports {sc_a_din[16]}]  \
  [get_ports {sc_a_din[15]}]  \
  [get_ports {sc_a_din[14]}]  \
  [get_ports {sc_a_din[13]}]  \
  [get_ports {sc_a_din[12]}]  \
  [get_ports {sc_a_din[11]}]  \
  [get_ports {sc_a_din[10]}]  \
  [get_ports {sc_a_din[9]}]  \
  [get_ports {sc_a_din[8]}]  \
  [get_ports {sc_a_din[7]}]  \
  [get_ports {sc_a_din[6]}]  \
  [get_ports {sc_a_din[5]}]  \
  [get_ports {sc_a_din[4]}]  \
  [get_ports {sc_a_din[3]}]  \
  [get_ports {sc_a_din[2]}]  \
  [get_ports {sc_a_din[1]}]  \
  [get_ports {sc_a_din[0]}]  \
  [get_ports sc_b_mem_ctrl]  \
  [get_ports sc_b_cen]  \
  [get_ports sc_b_wen]  \
  [get_ports {sc_b_addr[8]}]  \
  [get_ports {sc_b_addr[7]}]  \
  [get_ports {sc_b_addr[6]}]  \
  [get_ports {sc_b_addr[5]}]  \
  [get_ports {sc_b_addr[4]}]  \
  [get_ports {sc_b_addr[3]}]  \
  [get_ports {sc_b_addr[2]}]  \
  [get_ports {sc_b_addr[1]}]  \
  [get_ports {sc_b_addr[0]}]  \
  [get_ports {sc_b_din[63]}]  \
  [get_ports {sc_b_din[62]}]  \
  [get_ports {sc_b_din[61]}]  \
  [get_ports {sc_b_din[60]}]  \
  [get_ports {sc_b_din[59]}]  \
  [get_ports {sc_b_din[58]}]  \
  [get_ports {sc_b_din[57]}]  \
  [get_ports {sc_b_din[56]}]  \
  [get_ports {sc_b_din[55]}]  \
  [get_ports {sc_b_din[54]}]  \
  [get_ports {sc_b_din[53]}]  \
  [get_ports {sc_b_din[52]}]  \
  [get_ports {sc_b_din[51]}]  \
  [get_ports {sc_b_din[50]}]  \
  [get_ports {sc_b_din[49]}]  \
  [get_ports {sc_b_din[48]}]  \
  [get_ports {sc_b_din[47]}]  \
  [get_ports {sc_b_din[46]}]  \
  [get_ports {sc_b_din[45]}]  \
  [get_ports {sc_b_din[44]}]  \
  [get_ports {sc_b_din[43]}]  \
  [get_ports {sc_b_din[42]}]  \
  [get_ports {sc_b_din[41]}]  \
  [get_ports {sc_b_din[40]}]  \
  [get_ports {sc_b_din[39]}]  \
  [get_ports {sc_b_din[38]}]  \
  [get_ports {sc_b_din[37]}]  \
  [get_ports {sc_b_din[36]}]  \
  [get_ports {sc_b_din[35]}]  \
  [get_ports {sc_b_din[34]}]  \
  [get_ports {sc_b_din[33]}]  \
  [get_ports {sc_b_din[32]}]  \
  [get_ports {sc_b_din[31]}]  \
  [get_ports {sc_b_din[30]}]  \
  [get_ports {sc_b_din[29]}]  \
  [get_ports {sc_b_din[28]}]  \
  [get_ports {sc_b_din[27]}]  \
  [get_ports {sc_b_din[26]}]  \
  [get_ports {sc_b_din[25]}]  \
  [get_ports {sc_b_din[24]}]  \
  [get_ports {sc_b_din[23]}]  \
  [get_ports {sc_b_din[22]}]  \
  [get_ports {sc_b_din[21]}]  \
  [get_ports {sc_b_din[20]}]  \
  [get_ports {sc_b_din[19]}]  \
  [get_ports {sc_b_din[18]}]  \
  [get_ports {sc_b_din[17]}]  \
  [get_ports {sc_b_din[16]}]  \
  [get_ports {sc_b_din[15]}]  \
  [get_ports {sc_b_din[14]}]  \
  [get_ports {sc_b_din[13]}]  \
  [get_ports {sc_b_din[12]}]  \
  [get_ports {sc_b_din[11]}]  \
  [get_ports {sc_b_din[10]}]  \
  [get_ports {sc_b_din[9]}]  \
  [get_ports {sc_b_din[8]}]  \
  [get_ports {sc_b_din[7]}]  \
  [get_ports {sc_b_din[6]}]  \
  [get_ports {sc_b_din[5]}]  \
  [get_ports {sc_b_din[4]}]  \
  [get_ports {sc_b_din[3]}]  \
  [get_ports {sc_b_din[2]}]  \
  [get_ports {sc_b_din[1]}]  \
  [get_ports {sc_b_din[0]}] ] -to [list \
  [get_ports {tpu_a_dout[63]}]  \
  [get_ports {tpu_a_dout[62]}]  \
  [get_ports {tpu_a_dout[61]}]  \
  [get_ports {tpu_a_dout[60]}]  \
  [get_ports {tpu_a_dout[59]}]  \
  [get_ports {tpu_a_dout[58]}]  \
  [get_ports {tpu_a_dout[57]}]  \
  [get_ports {tpu_a_dout[56]}]  \
  [get_ports {tpu_a_dout[55]}]  \
  [get_ports {tpu_a_dout[54]}]  \
  [get_ports {tpu_a_dout[53]}]  \
  [get_ports {tpu_a_dout[52]}]  \
  [get_ports {tpu_a_dout[51]}]  \
  [get_ports {tpu_a_dout[50]}]  \
  [get_ports {tpu_a_dout[49]}]  \
  [get_ports {tpu_a_dout[48]}]  \
  [get_ports {tpu_a_dout[47]}]  \
  [get_ports {tpu_a_dout[46]}]  \
  [get_ports {tpu_a_dout[45]}]  \
  [get_ports {tpu_a_dout[44]}]  \
  [get_ports {tpu_a_dout[43]}]  \
  [get_ports {tpu_a_dout[42]}]  \
  [get_ports {tpu_a_dout[41]}]  \
  [get_ports {tpu_a_dout[40]}]  \
  [get_ports {tpu_a_dout[39]}]  \
  [get_ports {tpu_a_dout[38]}]  \
  [get_ports {tpu_a_dout[37]}]  \
  [get_ports {tpu_a_dout[36]}]  \
  [get_ports {tpu_a_dout[35]}]  \
  [get_ports {tpu_a_dout[34]}]  \
  [get_ports {tpu_a_dout[33]}]  \
  [get_ports {tpu_a_dout[32]}]  \
  [get_ports {tpu_a_dout[31]}]  \
  [get_ports {tpu_a_dout[30]}]  \
  [get_ports {tpu_a_dout[29]}]  \
  [get_ports {tpu_a_dout[28]}]  \
  [get_ports {tpu_a_dout[27]}]  \
  [get_ports {tpu_a_dout[26]}]  \
  [get_ports {tpu_a_dout[25]}]  \
  [get_ports {tpu_a_dout[24]}]  \
  [get_ports {tpu_a_dout[23]}]  \
  [get_ports {tpu_a_dout[22]}]  \
  [get_ports {tpu_a_dout[21]}]  \
  [get_ports {tpu_a_dout[20]}]  \
  [get_ports {tpu_a_dout[19]}]  \
  [get_ports {tpu_a_dout[18]}]  \
  [get_ports {tpu_a_dout[17]}]  \
  [get_ports {tpu_a_dout[16]}]  \
  [get_ports {tpu_a_dout[15]}]  \
  [get_ports {tpu_a_dout[14]}]  \
  [get_ports {tpu_a_dout[13]}]  \
  [get_ports {tpu_a_dout[12]}]  \
  [get_ports {tpu_a_dout[11]}]  \
  [get_ports {tpu_a_dout[10]}]  \
  [get_ports {tpu_a_dout[9]}]  \
  [get_ports {tpu_a_dout[8]}]  \
  [get_ports {tpu_a_dout[7]}]  \
  [get_ports {tpu_a_dout[6]}]  \
  [get_ports {tpu_a_dout[5]}]  \
  [get_ports {tpu_a_dout[4]}]  \
  [get_ports {tpu_a_dout[3]}]  \
  [get_ports {tpu_a_dout[2]}]  \
  [get_ports {tpu_a_dout[1]}]  \
  [get_ports {tpu_a_dout[0]}]  \
  [get_ports {tpu_b_dout[63]}]  \
  [get_ports {tpu_b_dout[62]}]  \
  [get_ports {tpu_b_dout[61]}]  \
  [get_ports {tpu_b_dout[60]}]  \
  [get_ports {tpu_b_dout[59]}]  \
  [get_ports {tpu_b_dout[58]}]  \
  [get_ports {tpu_b_dout[57]}]  \
  [get_ports {tpu_b_dout[56]}]  \
  [get_ports {tpu_b_dout[55]}]  \
  [get_ports {tpu_b_dout[54]}]  \
  [get_ports {tpu_b_dout[53]}]  \
  [get_ports {tpu_b_dout[52]}]  \
  [get_ports {tpu_b_dout[51]}]  \
  [get_ports {tpu_b_dout[50]}]  \
  [get_ports {tpu_b_dout[49]}]  \
  [get_ports {tpu_b_dout[48]}]  \
  [get_ports {tpu_b_dout[47]}]  \
  [get_ports {tpu_b_dout[46]}]  \
  [get_ports {tpu_b_dout[45]}]  \
  [get_ports {tpu_b_dout[44]}]  \
  [get_ports {tpu_b_dout[43]}]  \
  [get_ports {tpu_b_dout[42]}]  \
  [get_ports {tpu_b_dout[41]}]  \
  [get_ports {tpu_b_dout[40]}]  \
  [get_ports {tpu_b_dout[39]}]  \
  [get_ports {tpu_b_dout[38]}]  \
  [get_ports {tpu_b_dout[37]}]  \
  [get_ports {tpu_b_dout[36]}]  \
  [get_ports {tpu_b_dout[35]}]  \
  [get_ports {tpu_b_dout[34]}]  \
  [get_ports {tpu_b_dout[33]}]  \
  [get_ports {tpu_b_dout[32]}]  \
  [get_ports {tpu_b_dout[31]}]  \
  [get_ports {tpu_b_dout[30]}]  \
  [get_ports {tpu_b_dout[29]}]  \
  [get_ports {tpu_b_dout[28]}]  \
  [get_ports {tpu_b_dout[27]}]  \
  [get_ports {tpu_b_dout[26]}]  \
  [get_ports {tpu_b_dout[25]}]  \
  [get_ports {tpu_b_dout[24]}]  \
  [get_ports {tpu_b_dout[23]}]  \
  [get_ports {tpu_b_dout[22]}]  \
  [get_ports {tpu_b_dout[21]}]  \
  [get_ports {tpu_b_dout[20]}]  \
  [get_ports {tpu_b_dout[19]}]  \
  [get_ports {tpu_b_dout[18]}]  \
  [get_ports {tpu_b_dout[17]}]  \
  [get_ports {tpu_b_dout[16]}]  \
  [get_ports {tpu_b_dout[15]}]  \
  [get_ports {tpu_b_dout[14]}]  \
  [get_ports {tpu_b_dout[13]}]  \
  [get_ports {tpu_b_dout[12]}]  \
  [get_ports {tpu_b_dout[11]}]  \
  [get_ports {tpu_b_dout[10]}]  \
  [get_ports {tpu_b_dout[9]}]  \
  [get_ports {tpu_b_dout[8]}]  \
  [get_ports {tpu_b_dout[7]}]  \
  [get_ports {tpu_b_dout[6]}]  \
  [get_ports {tpu_b_dout[5]}]  \
  [get_ports {tpu_b_dout[4]}]  \
  [get_ports {tpu_b_dout[3]}]  \
  [get_ports {tpu_b_dout[2]}]  \
  [get_ports {tpu_b_dout[1]}]  \
  [get_ports {tpu_b_dout[0]}]  \
  [get_ports {sc_a_mem_dout[63]}]  \
  [get_ports {sc_a_mem_dout[62]}]  \
  [get_ports {sc_a_mem_dout[61]}]  \
  [get_ports {sc_a_mem_dout[60]}]  \
  [get_ports {sc_a_mem_dout[59]}]  \
  [get_ports {sc_a_mem_dout[58]}]  \
  [get_ports {sc_a_mem_dout[57]}]  \
  [get_ports {sc_a_mem_dout[56]}]  \
  [get_ports {sc_a_mem_dout[55]}]  \
  [get_ports {sc_a_mem_dout[54]}]  \
  [get_ports {sc_a_mem_dout[53]}]  \
  [get_ports {sc_a_mem_dout[52]}]  \
  [get_ports {sc_a_mem_dout[51]}]  \
  [get_ports {sc_a_mem_dout[50]}]  \
  [get_ports {sc_a_mem_dout[49]}]  \
  [get_ports {sc_a_mem_dout[48]}]  \
  [get_ports {sc_a_mem_dout[47]}]  \
  [get_ports {sc_a_mem_dout[46]}]  \
  [get_ports {sc_a_mem_dout[45]}]  \
  [get_ports {sc_a_mem_dout[44]}]  \
  [get_ports {sc_a_mem_dout[43]}]  \
  [get_ports {sc_a_mem_dout[42]}]  \
  [get_ports {sc_a_mem_dout[41]}]  \
  [get_ports {sc_a_mem_dout[40]}]  \
  [get_ports {sc_a_mem_dout[39]}]  \
  [get_ports {sc_a_mem_dout[38]}]  \
  [get_ports {sc_a_mem_dout[37]}]  \
  [get_ports {sc_a_mem_dout[36]}]  \
  [get_ports {sc_a_mem_dout[35]}]  \
  [get_ports {sc_a_mem_dout[34]}]  \
  [get_ports {sc_a_mem_dout[33]}]  \
  [get_ports {sc_a_mem_dout[32]}]  \
  [get_ports {sc_a_mem_dout[31]}]  \
  [get_ports {sc_a_mem_dout[30]}]  \
  [get_ports {sc_a_mem_dout[29]}]  \
  [get_ports {sc_a_mem_dout[28]}]  \
  [get_ports {sc_a_mem_dout[27]}]  \
  [get_ports {sc_a_mem_dout[26]}]  \
  [get_ports {sc_a_mem_dout[25]}]  \
  [get_ports {sc_a_mem_dout[24]}]  \
  [get_ports {sc_a_mem_dout[23]}]  \
  [get_ports {sc_a_mem_dout[22]}]  \
  [get_ports {sc_a_mem_dout[21]}]  \
  [get_ports {sc_a_mem_dout[20]}]  \
  [get_ports {sc_a_mem_dout[19]}]  \
  [get_ports {sc_a_mem_dout[18]}]  \
  [get_ports {sc_a_mem_dout[17]}]  \
  [get_ports {sc_a_mem_dout[16]}]  \
  [get_ports {sc_a_mem_dout[15]}]  \
  [get_ports {sc_a_mem_dout[14]}]  \
  [get_ports {sc_a_mem_dout[13]}]  \
  [get_ports {sc_a_mem_dout[12]}]  \
  [get_ports {sc_a_mem_dout[11]}]  \
  [get_ports {sc_a_mem_dout[10]}]  \
  [get_ports {sc_a_mem_dout[9]}]  \
  [get_ports {sc_a_mem_dout[8]}]  \
  [get_ports {sc_a_mem_dout[7]}]  \
  [get_ports {sc_a_mem_dout[6]}]  \
  [get_ports {sc_a_mem_dout[5]}]  \
  [get_ports {sc_a_mem_dout[4]}]  \
  [get_ports {sc_a_mem_dout[3]}]  \
  [get_ports {sc_a_mem_dout[2]}]  \
  [get_ports {sc_a_mem_dout[1]}]  \
  [get_ports {sc_a_mem_dout[0]}]  \
  [get_ports {sc_b_mem_dout[63]}]  \
  [get_ports {sc_b_mem_dout[62]}]  \
  [get_ports {sc_b_mem_dout[61]}]  \
  [get_ports {sc_b_mem_dout[60]}]  \
  [get_ports {sc_b_mem_dout[59]}]  \
  [get_ports {sc_b_mem_dout[58]}]  \
  [get_ports {sc_b_mem_dout[57]}]  \
  [get_ports {sc_b_mem_dout[56]}]  \
  [get_ports {sc_b_mem_dout[55]}]  \
  [get_ports {sc_b_mem_dout[54]}]  \
  [get_ports {sc_b_mem_dout[53]}]  \
  [get_ports {sc_b_mem_dout[52]}]  \
  [get_ports {sc_b_mem_dout[51]}]  \
  [get_ports {sc_b_mem_dout[50]}]  \
  [get_ports {sc_b_mem_dout[49]}]  \
  [get_ports {sc_b_mem_dout[48]}]  \
  [get_ports {sc_b_mem_dout[47]}]  \
  [get_ports {sc_b_mem_dout[46]}]  \
  [get_ports {sc_b_mem_dout[45]}]  \
  [get_ports {sc_b_mem_dout[44]}]  \
  [get_ports {sc_b_mem_dout[43]}]  \
  [get_ports {sc_b_mem_dout[42]}]  \
  [get_ports {sc_b_mem_dout[41]}]  \
  [get_ports {sc_b_mem_dout[40]}]  \
  [get_ports {sc_b_mem_dout[39]}]  \
  [get_ports {sc_b_mem_dout[38]}]  \
  [get_ports {sc_b_mem_dout[37]}]  \
  [get_ports {sc_b_mem_dout[36]}]  \
  [get_ports {sc_b_mem_dout[35]}]  \
  [get_ports {sc_b_mem_dout[34]}]  \
  [get_ports {sc_b_mem_dout[33]}]  \
  [get_ports {sc_b_mem_dout[32]}]  \
  [get_ports {sc_b_mem_dout[31]}]  \
  [get_ports {sc_b_mem_dout[30]}]  \
  [get_ports {sc_b_mem_dout[29]}]  \
  [get_ports {sc_b_mem_dout[28]}]  \
  [get_ports {sc_b_mem_dout[27]}]  \
  [get_ports {sc_b_mem_dout[26]}]  \
  [get_ports {sc_b_mem_dout[25]}]  \
  [get_ports {sc_b_mem_dout[24]}]  \
  [get_ports {sc_b_mem_dout[23]}]  \
  [get_ports {sc_b_mem_dout[22]}]  \
  [get_ports {sc_b_mem_dout[21]}]  \
  [get_ports {sc_b_mem_dout[20]}]  \
  [get_ports {sc_b_mem_dout[19]}]  \
  [get_ports {sc_b_mem_dout[18]}]  \
  [get_ports {sc_b_mem_dout[17]}]  \
  [get_ports {sc_b_mem_dout[16]}]  \
  [get_ports {sc_b_mem_dout[15]}]  \
  [get_ports {sc_b_mem_dout[14]}]  \
  [get_ports {sc_b_mem_dout[13]}]  \
  [get_ports {sc_b_mem_dout[12]}]  \
  [get_ports {sc_b_mem_dout[11]}]  \
  [get_ports {sc_b_mem_dout[10]}]  \
  [get_ports {sc_b_mem_dout[9]}]  \
  [get_ports {sc_b_mem_dout[8]}]  \
  [get_ports {sc_b_mem_dout[7]}]  \
  [get_ports {sc_b_mem_dout[6]}]  \
  [get_ports {sc_b_mem_dout[5]}]  \
  [get_ports {sc_b_mem_dout[4]}]  \
  [get_ports {sc_b_mem_dout[3]}]  \
  [get_ports {sc_b_mem_dout[2]}]  \
  [get_ports {sc_b_mem_dout[1]}]  \
  [get_ports {sc_b_mem_dout[0]}] ]
group_path -weight 1.000000 -name C2C -from [list \
  [get_cells u_sram_a_u_sram]  \
  [get_cells u_sram_b_u_sram]  \
  [get_cells {u_slave_ab_cnt_a_reg[0]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[1]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[2]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[3]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[4]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[5]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[6]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[7]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[8]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[9]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[10]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[11]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[12]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[0]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[1]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[2]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[3]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[4]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[5]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[6]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[7]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[8]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[9]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[10]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[11]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[12]}]  \
  [get_cells {u_slave_ab_max_a_reg[6]}]  \
  [get_cells {u_slave_ab_max_a_reg[7]}]  \
  [get_cells {u_slave_ab_max_a_reg[8]}]  \
  [get_cells {u_slave_ab_max_a_reg[9]}]  \
  [get_cells {u_slave_ab_max_a_reg[10]}]  \
  [get_cells {u_slave_ab_max_a_reg[11]}]  \
  [get_cells {u_slave_ab_max_a_reg[12]}]  \
  [get_cells {u_slave_ab_max_b_reg[6]}]  \
  [get_cells {u_slave_ab_max_b_reg[7]}]  \
  [get_cells {u_slave_ab_max_b_reg[8]}]  \
  [get_cells {u_slave_ab_max_b_reg[9]}]  \
  [get_cells {u_slave_ab_max_b_reg[10]}]  \
  [get_cells {u_slave_ab_max_b_reg[11]}]  \
  [get_cells {u_slave_ab_max_b_reg[12]}]  \
  [get_cells u_slave_ab_we_a_en_reg]  \
  [get_cells u_slave_ab_we_b_en_reg]  \
  [get_cells {u_sram_a_bus_wbuf_reg[0]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[1]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[2]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[3]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[4]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[5]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[6]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[7]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[8]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[9]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[10]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[11]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[12]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[13]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[14]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[15]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[16]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[17]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[18]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[19]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[20]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[21]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[22]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[23]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[24]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[25]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[26]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[27]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[28]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[29]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[30]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[31]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[32]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[33]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[34]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[35]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[36]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[37]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[38]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[39]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[40]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[41]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[42]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[43]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[44]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[45]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[46]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[47]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[48]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[49]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[50]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[51]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[52]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[53]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[54]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[55]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[56]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[57]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[58]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[59]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[60]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[61]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[62]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[63]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[0]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[1]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[2]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[0]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[1]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[2]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[3]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[4]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[5]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[6]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[7]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[8]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[0]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[1]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[2]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[3]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[4]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[5]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[6]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[7]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[8]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[9]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[10]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[11]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[12]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[13]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[14]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[15]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[16]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[17]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[18]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[19]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[20]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[21]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[22]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[23]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[24]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[25]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[26]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[27]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[28]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[29]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[30]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[31]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[32]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[33]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[34]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[35]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[36]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[37]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[38]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[39]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[40]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[41]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[42]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[43]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[44]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[45]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[46]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[47]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[48]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[49]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[50]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[51]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[52]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[53]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[54]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[55]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[56]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[57]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[58]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[59]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[60]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[61]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[62]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[63]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[0]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[1]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[2]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[0]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[1]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[2]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[3]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[4]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[5]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[6]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[7]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[8]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[0]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[1]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[2]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[3]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[4]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[5]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[6]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[7]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[0]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[1]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[2]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[3]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[4]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[5]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[6]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[7]}]  \
  [get_cells u_slave_ab_chab_wr_s_reg]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[0]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[1]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[2]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[3]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[4]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[5]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[6]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[7]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[8]}]  \
  [get_cells u_sram_a_bus_we_d1_reg]  \
  [get_cells u_sram_a_bus_we_prev_reg]  \
  [get_cells {u_sram_a_flush_addr_reg[0]}]  \
  [get_cells {u_sram_a_flush_addr_reg[1]}]  \
  [get_cells {u_sram_a_flush_addr_reg[2]}]  \
  [get_cells {u_sram_a_flush_addr_reg[3]}]  \
  [get_cells {u_sram_a_flush_addr_reg[4]}]  \
  [get_cells {u_sram_a_flush_addr_reg[5]}]  \
  [get_cells {u_sram_a_flush_addr_reg[6]}]  \
  [get_cells {u_sram_a_flush_addr_reg[7]}]  \
  [get_cells {u_sram_a_flush_addr_reg[8]}]  \
  [get_cells u_sram_a_flush_d1_reg]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[0]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[1]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[2]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[3]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[4]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[5]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[6]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[7]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[8]}]  \
  [get_cells u_sram_b_bus_we_d1_reg]  \
  [get_cells u_sram_b_bus_we_prev_reg]  \
  [get_cells {u_sram_b_flush_addr_reg[0]}]  \
  [get_cells {u_sram_b_flush_addr_reg[1]}]  \
  [get_cells {u_sram_b_flush_addr_reg[2]}]  \
  [get_cells {u_sram_b_flush_addr_reg[3]}]  \
  [get_cells {u_sram_b_flush_addr_reg[4]}]  \
  [get_cells {u_sram_b_flush_addr_reg[5]}]  \
  [get_cells {u_sram_b_flush_addr_reg[6]}]  \
  [get_cells {u_sram_b_flush_addr_reg[7]}]  \
  [get_cells {u_sram_b_flush_addr_reg[8]}]  \
  [get_cells u_sram_b_flush_d1_reg] ] -to [list \
  [get_cells u_sram_a_u_sram]  \
  [get_cells u_sram_b_u_sram]  \
  [get_cells {u_slave_ab_cnt_a_reg[0]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[1]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[2]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[3]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[4]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[5]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[6]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[7]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[8]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[9]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[10]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[11]}]  \
  [get_cells {u_slave_ab_cnt_a_reg[12]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[0]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[1]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[2]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[3]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[4]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[5]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[6]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[7]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[8]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[9]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[10]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[11]}]  \
  [get_cells {u_slave_ab_cnt_b_reg[12]}]  \
  [get_cells {u_slave_ab_max_a_reg[6]}]  \
  [get_cells {u_slave_ab_max_a_reg[7]}]  \
  [get_cells {u_slave_ab_max_a_reg[8]}]  \
  [get_cells {u_slave_ab_max_a_reg[9]}]  \
  [get_cells {u_slave_ab_max_a_reg[10]}]  \
  [get_cells {u_slave_ab_max_a_reg[11]}]  \
  [get_cells {u_slave_ab_max_a_reg[12]}]  \
  [get_cells {u_slave_ab_max_b_reg[6]}]  \
  [get_cells {u_slave_ab_max_b_reg[7]}]  \
  [get_cells {u_slave_ab_max_b_reg[8]}]  \
  [get_cells {u_slave_ab_max_b_reg[9]}]  \
  [get_cells {u_slave_ab_max_b_reg[10]}]  \
  [get_cells {u_slave_ab_max_b_reg[11]}]  \
  [get_cells {u_slave_ab_max_b_reg[12]}]  \
  [get_cells u_slave_ab_we_a_en_reg]  \
  [get_cells u_slave_ab_we_b_en_reg]  \
  [get_cells {u_sram_a_bus_wbuf_reg[0]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[1]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[2]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[3]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[4]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[5]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[6]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[7]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[8]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[9]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[10]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[11]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[12]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[13]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[14]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[15]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[16]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[17]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[18]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[19]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[20]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[21]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[22]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[23]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[24]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[25]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[26]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[27]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[28]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[29]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[30]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[31]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[32]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[33]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[34]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[35]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[36]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[37]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[38]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[39]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[40]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[41]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[42]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[43]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[44]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[45]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[46]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[47]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[48]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[49]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[50]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[51]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[52]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[53]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[54]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[55]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[56]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[57]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[58]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[59]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[60]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[61]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[62]}]  \
  [get_cells {u_sram_a_bus_wbuf_reg[63]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[0]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[1]}]  \
  [get_cells {u_sram_a_last_byte_sel_reg[2]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[0]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[1]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[2]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[3]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[4]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[5]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[6]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[7]}]  \
  [get_cells {u_sram_a_last_word_addr_reg[8]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[0]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[1]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[2]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[3]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[4]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[5]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[6]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[7]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[8]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[9]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[10]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[11]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[12]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[13]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[14]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[15]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[16]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[17]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[18]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[19]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[20]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[21]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[22]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[23]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[24]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[25]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[26]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[27]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[28]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[29]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[30]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[31]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[32]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[33]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[34]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[35]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[36]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[37]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[38]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[39]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[40]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[41]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[42]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[43]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[44]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[45]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[46]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[47]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[48]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[49]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[50]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[51]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[52]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[53]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[54]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[55]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[56]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[57]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[58]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[59]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[60]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[61]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[62]}]  \
  [get_cells {u_sram_b_bus_wbuf_reg[63]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[0]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[1]}]  \
  [get_cells {u_sram_b_last_byte_sel_reg[2]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[0]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[1]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[2]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[3]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[4]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[5]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[6]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[7]}]  \
  [get_cells {u_sram_b_last_word_addr_reg[8]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[0]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[1]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[2]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[3]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[4]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[5]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[6]}]  \
  [get_cells {u_slave_ab_chab_wdata_a_s_reg[7]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[0]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[1]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[2]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[3]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[4]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[5]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[6]}]  \
  [get_cells {u_slave_ab_chab_wdata_b_s_reg[7]}]  \
  [get_cells u_slave_ab_chab_wr_s_reg]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[0]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[1]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[2]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[3]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[4]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[5]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[6]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[7]}]  \
  [get_cells {u_sram_a_bus_waddr_d1_reg[8]}]  \
  [get_cells u_sram_a_bus_we_d1_reg]  \
  [get_cells u_sram_a_bus_we_prev_reg]  \
  [get_cells {u_sram_a_flush_addr_reg[0]}]  \
  [get_cells {u_sram_a_flush_addr_reg[1]}]  \
  [get_cells {u_sram_a_flush_addr_reg[2]}]  \
  [get_cells {u_sram_a_flush_addr_reg[3]}]  \
  [get_cells {u_sram_a_flush_addr_reg[4]}]  \
  [get_cells {u_sram_a_flush_addr_reg[5]}]  \
  [get_cells {u_sram_a_flush_addr_reg[6]}]  \
  [get_cells {u_sram_a_flush_addr_reg[7]}]  \
  [get_cells {u_sram_a_flush_addr_reg[8]}]  \
  [get_cells u_sram_a_flush_d1_reg]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[0]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[1]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[2]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[3]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[4]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[5]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[6]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[7]}]  \
  [get_cells {u_sram_b_bus_waddr_d1_reg[8]}]  \
  [get_cells u_sram_b_bus_we_d1_reg]  \
  [get_cells u_sram_b_bus_we_prev_reg]  \
  [get_cells {u_sram_b_flush_addr_reg[0]}]  \
  [get_cells {u_sram_b_flush_addr_reg[1]}]  \
  [get_cells {u_sram_b_flush_addr_reg[2]}]  \
  [get_cells {u_sram_b_flush_addr_reg[3]}]  \
  [get_cells {u_sram_b_flush_addr_reg[4]}]  \
  [get_cells {u_sram_b_flush_addr_reg[5]}]  \
  [get_cells {u_sram_b_flush_addr_reg[6]}]  \
  [get_cells {u_sram_b_flush_addr_reg[7]}]  \
  [get_cells {u_sram_b_flush_addr_reg[8]}]  \
  [get_cells u_sram_b_flush_d1_reg] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_m[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_m[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_m[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_m[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_m[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_m[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_m[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_n[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_n[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_n[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_n[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_n[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_n[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_n[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_k[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_k[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_k[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_k[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_k[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_k[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_dim_k[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_num_computation[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_num_computation[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_num_computation[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_num_computation[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_num_computation[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_num_computation[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {mmio_num_computation[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports chip_chab_start]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_a[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_a[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_a[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_a[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_a[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_a[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_a[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_a[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_b[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_b[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_b[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_b[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_b[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_b[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_b[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {chip_chab_wdata_b[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports chip_chab_wr]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports tpu_a_re]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_a_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports tpu_b_re]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {tpu_b_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_a_mem_ctrl]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_a_cen]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_a_wen]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_a_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_b_mem_ctrl]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_b_cen]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports sc_b_wen]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -max 0.25 [get_ports {sc_b_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports rstn]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_m[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_m[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_m[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_m[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_m[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_m[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_m[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_n[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_n[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_n[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_n[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_n[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_n[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_n[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_k[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_k[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_k[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_k[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_k[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_k[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_dim_k[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_num_computation[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_num_computation[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_num_computation[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_num_computation[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_num_computation[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_num_computation[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {mmio_num_computation[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports chip_chab_start]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_a[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_a[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_a[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_a[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_a[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_a[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_a[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_a[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_b[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_b[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_b[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_b[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_b[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_b[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_b[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {chip_chab_wdata_b[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports chip_chab_wr]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports tpu_a_re]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports tpu_b_re]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_a_mem_ctrl]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_a_cen]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_a_wen]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_din[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_b_mem_ctrl]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_b_cen]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports sc_b_wen]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_addr[0]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[63]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[62]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[61]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[60]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[59]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[58]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[57]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[56]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[55]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[54]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[53]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[52]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[51]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[50]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[49]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[48]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[47]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[46]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[45]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[44]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[43]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[42]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[41]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[40]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[39]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[38]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[37]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[36]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[35]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[34]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[33]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[32]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[31]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[30]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[29]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[28]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[27]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[26]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[25]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[24]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[23]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[22]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[21]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[20]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[19]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[18]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[17]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[16]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[15]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[14]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[13]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[12]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[11]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[10]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[9]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[8]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[7]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[6]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[5]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[4]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[3]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[2]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[1]}]
set_input_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_din[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_a_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {tpu_b_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_a_mem_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -max 6.25 [get_ports {sc_b_mem_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_a_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {tpu_b_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_a_mem_dout[0]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[63]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[62]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[61]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[60]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[59]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[58]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[57]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[56]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[55]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[54]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[53]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[52]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[51]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[50]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[49]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[48]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[47]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[46]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[45]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[44]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[43]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[42]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[41]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[40]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[39]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[38]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[37]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[36]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[35]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[34]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[33]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[32]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[31]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[30]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[29]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[28]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[27]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[26]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[25]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[24]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[23]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[22]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[21]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[20]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[19]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[18]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[17]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[16]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[15]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[14]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[13]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[12]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[11]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[10]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[9]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[8]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[7]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[6]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[5]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[4]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[3]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[2]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[1]}]
set_output_delay -clock [get_clocks Clk] -add_delay -min 0.0 [get_ports {sc_b_mem_dout[0]}]
set_wire_load_mode "segmented"
set_clock_uncertainty -setup 0.15 [get_clocks Clk]
set_clock_uncertainty -hold 0.15 [get_clocks Clk]
