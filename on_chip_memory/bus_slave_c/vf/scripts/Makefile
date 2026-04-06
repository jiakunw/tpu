RTL_DIR          = ../../input/RTL
SRAM_DIR         = /user/stud/fall25/dy2538/ee6350/DIGITAL/SRAM00_gen
SRAM_WRAPPER_DIR = ../../../H_Sram_wrapper
TB_DIR           = ../../input/TB
PNR_DIR          = ../../pnr/output
PNR_SR_DIR       = $(SRAM_WRAPPER_DIR)/pnr/output
SYN_DIR          = ../../syn/output
SYN_SR_DIR       = $(SRAM_WRAPPER_DIR)/syn/output
LIB_DIR          = ../lib

##################################################
# RTL Simulation - VCS
##################################################
vcs:
	vcs +notimingchecks -sverilog -full64 -timescale=1ns/1ps -debug_all \
		$(SRAM_DIR)/sram00.v \
		$(SRAM_WRAPPER_DIR)/input/RTL/sram_wrapper_c.sv \
		$(TB_DIR)/bus_master.sv \
		$(RTL_DIR)/bus_slave_c.sv \
		$(TB_DIR)/tb.sv \
		-o simv
	./simv | tee sim.log

##################################################
# RTL Simulation - ModelSim (batch)
##################################################
vsim:
	vlib work
	vlog +acc $(SRAM_DIR)/sram00.v
	vlog +acc -sv $(SRAM_WRAPPER_DIR)/input/RTL/sram_wrapper.sv
	vlog +acc -sv $(RTL_DIR)/bus_slave_ab.sv
	vlog +acc -sv $(TB_DIR)/bus_master.sv $(TB_DIR)/tb.sv
	vsim -c -do "run -all; quit" work.tb | tee sim.log

##################################################
# RTL Simulation - ModelSim (GUI)
##################################################
vsim_gui:
	vlib work
	vlog +acc $(SRAM_DIR)/sram00.v
	vlog +acc -sv $(SRAM_WRAPPER_DIR)/input/RTL/sram_wrapper.sv
	vlog +acc -sv $(RTL_DIR)/bus_slave_ab.sv
	vlog +acc -sv $(TB_DIR)/bus_master.sv $(TB_DIR)/tb.sv
	vsim -do "add wave -r /*; run -all" work.tb

##################################################
# Post-Synthesis Simulation - VCS
##################################################
post_syn_vcs:
	vcs +notimingchecks -sverilog -full64 -timescale=1ns/1ps \
	    -sdf max:tb/u_slave_c:$(SYN_DIR)/bus_slave_c.syn.sdf \
	    -sdf max:tb/u_sram_c:$(SYN_SR_DIR)/sram_wrapper_c.syn.sdf \
	    $(LIB_DIR)/tcbn65gplus.v \
	    $(SRAM_DIR)/sram00.v \
	    $(SYN_SR_DIR)/sram_wrapper_c.syn.v \
	    $(SYN_DIR)/bus_slave_c.syn.v \
	    $(TB_DIR)/bus_master.sv \
	    $(TB_DIR)/tb.sv \
	    -o simv_syn
	./simv_syn | tee post_syn.log

##################################################
# Post-PnR Simulation - VCS (all three corners)
##################################################
post_pnr_vcs:
	# MIN corner (FF, 1.1V, -40C)
	vcs -sverilog -full64 -timescale=1ns/1ps \
	    +neg_tchk +sdfverbose \
	    -sdf min:tb/u_slave_c:$(PNR_DIR)/bus_slave_c.funct.sdf \
	    -sdf min:tb/u_sram_c:$(PNR_SR_DIR)/sram_wrapper_c.funct.sdf \
	    $(LIB_DIR)/tcbn65gplus.v \
	    $(SRAM_DIR)/sram00.v \
	    $(PNR_DIR)/bus_slave_c.funct.v \
	    $(PNR_SR_DIR)/sram_wrapper_c.funct.v \
	    $(TB_DIR)/bus_master.sv \
	    $(TB_DIR)/tb.sv \
	    -o simv_min
	./simv_min +sdfverbose 2>&1 | tee post_pnr_min.log
	# TYP corner (TT, 1.0V, 25C)
	vcs -sverilog -full64 -timescale=1ns/1ps \
	    +neg_tchk +sdfverbose \
	    -sdf typ:tb/u_slave_c:$(PNR_DIR)/bus_slave_c.funct.sdf \
	    -sdf typ:tb/u_sram_c:$(PNR_SR_DIR)/sram_wrapper_c.funct.sdf \
	    $(LIB_DIR)/tcbn65gplus.v \
	    $(SRAM_DIR)/sram00.v \
	    $(PNR_DIR)/bus_slave_c.funct.v \
	    $(PNR_SR_DIR)/sram_wrapper_c.funct.v \
	    $(TB_DIR)/bus_master.sv \
	    $(TB_DIR)/tb.sv \
	    -o simv_typ
	./simv_typ +sdfverbose 2>&1 | tee post_pnr_typ.log
	# MAX corner (SS, 0.9V, 125C)
	vcs -sverilog -full64 -timescale=1ns/1ps \
	    +notimingchecks +neg_tchk +sdfverbose \
	    -sdf max:tb/u_slave_c:$(PNR_DIR)/bus_slave_c.funct.sdf \
	    -sdf max:tb/u_sram_c:$(PNR_SR_DIR)/sram_wrapper_c.funct.sdf \
	    $(LIB_DIR)/tcbn65gplus.v \
	    $(SRAM_DIR)/sram00.v \
	    $(PNR_DIR)/bus_slave_c.funct.v \
	    $(PNR_SR_DIR)/sram_wrapper_c.funct.v \
	    $(TB_DIR)/bus_master.sv \
	    $(TB_DIR)/tb.sv \
	    -o simv_max
	./simv_max +sdfverbose 2>&1 | tee post_pnr_max.log
	@echo "=========================================="
	@echo "Post-PnR VCS simulation complete!"
	@echo "  post_pnr_min.log - FF (1.1V, -40C)"
	@echo "  post_pnr_typ.log - TT (1.0V, 25C)"
	@echo "  post_pnr_max.log - SS (0.9V, 125C)"
	@echo "=========================================="

##################################################
# Post-PnR Simulation - ModelSim (all three corners)
##################################################
post_pnr_modelsim:
	vlib work
	vmap work work
	vlog +acc -incr $(LIB_DIR)/tcbn65gplus.v
	vlog +acc -incr $(PNR_DIR)/*.funct.v
	@for f in $(TB_DIR)/*.v; do vlog +acc -incr $$f; done
	# MIN corner
	vsim -voptargs=+acc -t ps -lib work \
		-sdfmin /TB/spsram=$(PNR_DIR)/sram_wrapper.funct.sdf \
		-sdfnoerror \
		-suppress 3438,3262,12091,3448,8756,8470,3444 \
		-wlf min_corner.wlf \
		-c -do "add wave *; run -all; quit" TB | tee post_pnr_min.log

##################################################
# View ModelSim Waveforms
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
	rm -rf csrc work transcript
	rm -rf *.log *.wlf *.vcd

.PHONY: vcs vsim vsim_gui post_syn_vcs post_pnr_vcs post_pnr_modelsim view_min view_typ view_max clean
