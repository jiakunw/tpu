RTL_DIR      = ../../input/RTL
TB_DIR       = ../../input/TB
PNR_DIR      = ../../pnr/output
SYN_DIR      = ../../syn/output
LIB_DIR      = ../lib

# RTL source files (compile order: leaves first)
RTL_SRCS = \
    $(RTL_DIR)/reset_synchronizer.sv          \
    $(RTL_DIR)/mmio_registers.sv              \
    $(RTL_DIR)/spi_slave.sv                   \
    $(RTL_DIR)/spi_slave_mmio_register_file.sv 

##################################################
# RTL Simulation - VCS
##################################################
vcs:
	vcs +notimingchecks -sverilog -full64 -timescale=1ns/1ps -debug_all \
	    $(TB_DIR)/axi_spi_master.sv           \
	    $(RTL_SRCS)                           \
	    $(TB_DIR)/tb.sv                       \
	    -o simv
	./simv | tee sim.log

##################################################
# RTL Simulation - ModelSim (batch)
##################################################
vsim:
	vlib work
	vlog +acc -sv $(RTL_SRCS)
	vlog +acc -sv $(TB_DIR)/tb.sv
	vsim -c -do "run -all; quit" work.tb | tee sim.log

##################################################
# RTL Simulation - ModelSim (GUI)
##################################################
vsim_gui:
	vlib work
	vlog +acc -sv $(RTL_SRCS)
	vlog +acc -sv $(TB_DIR)/tb.sv
	vsim -do "add wave -r /*; run -all" work.tb

##################################################
# Post-Synthesis Simulation - VCS
##################################################
post_syn_vcs:
	vcs -sverilog +notimingchecks -full64 -timescale=1ns/1ps \
	    -sdf max:tb/u_dut:$(SYN_DIR)/spi_slave_mmio_register_file.syn.sdf \
	    $(TB_DIR)/axi_spi_master.sv \
	    $(LIB_DIR)/tcbn65gplus.v \
	    $(SYN_DIR)/spi_slave_mmio_register_file.syn.v \
	    $(TB_DIR)/tb.sv \
	    -o simv_syn
	./simv_syn | tee post_syn.log

##################################################
# Post-PnR Simulation - VCS (three corners)
##################################################
post_pnr_vcs:
	# MIN corner
	vcs -sverilog -full64 -timescale=1ns/1ps \
	    +neg_tchk +sdfverbose \
	    -sdf min:tb/u_dut:$(PNR_DIR)/spi_slave_mmio_register_file.funct.sdf \
	    $(TB_DIR)/axi_spi_master.sv \
	    $(LIB_DIR)/tcbn65gplus.v \
	    $(PNR_DIR)/spi_slave_mmio_register_file.funct.v \
	    $(TB_DIR)/tb.sv \
	    -o simv_min
	./simv_min +sdfverbose 2>&1 | tee post_pnr_min.log
	# TYP corner
	vcs -sverilog -full64 -timescale=1ns/1ps \
	    +neg_tchk +sdfverbose \
	    -sdf typ:tb/u_dut:$(PNR_DIR)/spi_slave_mmio_register_file.funct.sdf \
	    $(LIB_DIR)/tcbn65gplus.v \
	    $(PNR_DIR)/spi_slave_mmio_register_file.funct.v \
	    $(TB_DIR)/tb.sv \
	    -o simv_typ
	./simv_typ +sdfverbose 2>&1 | tee post_pnr_typ.log
	# MAX corner
	vcs -sverilog -full64 -timescale=1ns/1ps \
	    +notimingchecks +neg_tchk +sdfverbose \
	    -sdf max:tb/u_dut:$(PNR_DIR)/spi_slave_mmio_register_file.funct.sdf \
	    $(LIB_DIR)/tcbn65gplus.v \
	    $(PNR_DIR)/spi_slave_mmio_register_file.funct.v \
	    $(TB_DIR)/tb.sv \
	    -o simv_max
	./simv_max +sdfverbose 2>&1 | tee post_pnr_max.log
	@echo "Post-PnR done: min/typ/max"

##################################################
# View Waveforms
##################################################
view_min:
	vsim -view min_corner.wlf -do "view wave; wave zoom full"
view_typ:
	vsim -view typ_corner.wlf -do "view wave; wave zoom full"
view_max:
	vsim -view max_corner.wlf -do "view wave; wave zoom full"

##################################################
# Clean
##################################################
clean:
	rm -rf simv simv_min simv_typ simv_max simv_syn
	rm -rf simv.daidir simv_min.daidir simv_typ.daidir simv_max.daidir simv_syn.daidir
	rm -rf csrc work transcript *.log *.wlf *.vcd

.PHONY: vcs vsim vsim_gui post_syn_vcs post_pnr_vcs view_min view_typ view_max clean
