RTL_DIR = ../../input/RTL
SRAM_DIR = /user/stud/fall25/dy2538/ee6350/DIGITAL/SRAM00_gen
SRAM_WRAPPER_DIR = ../../../sram_wrapper
TB_DIR  = ../../input/TB
PNR_DIR = ../../pnr/output
LIB_DIR = ../lib

##################################################
# RTL Simulation - VCS
##################################################
vcs:
	vcs -sverilog -full64 -timescale=1ns/1ps -debug_all \
		$(SRAM_DIR)/sram00.v \
		$(SRAM_WRAPPER_DIR)/input/RTL/sram_wrapper.sv \
		$(TB_DIR)/bus_master.sv \
		$(RTL_DIR)/bus_slave_ab.sv \
		$(TB_DIR)/tb.sv
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
# Post-PnR Simulation - VCS (all three corners)
##################################################
post_pnr_vcs:
	# MIN corner (FF, 1.1V, -40C - fastest)
	vcs -full64 -timescale=1ns/1ps \
		+neg_tchk +sdfverbose \
		-sdf min:/TB/spsram:$(PNR_DIR)/sram_wrapper.funct.sdf \
		$(LIB_DIR)/tcbn65gplus.v \
		$(PNR_DIR)/*.funct.v \
		$(TB_DIR)/*.v \
		-o simv_min
	./simv_min +sdfverbose 2>&1 | tee post_pnr_min.log

	# TYP corner (TT, 1.0V, 25C - typical)
	vcs -full64 -timescale=1ns/1ps \
		+neg_tchk +sdfverbose \
		-sdf typ:/TB/spsram:$(PNR_DIR)/sram_wrapper.funct.sdf \
		$(LIB_DIR)/tcbn65gplus.v \
		$(PNR_DIR)/*.funct.v \
		$(TB_DIR)/*.v \
		-o simv_typ
	./simv_typ +sdfverbose 2>&1 | tee post_pnr_typ.log

	# MAX corner (SS, 0.9V, 125C - slowest)
	vcs -full64 -timescale=1ns/1ps \
		+neg_tchk +sdfverbose \
		-sdf max:/TB/spsram:$(PNR_DIR)/sram_wrapper.funct.sdf \
		$(LIB_DIR)/tcbn65gplus.v \
		$(PNR_DIR)/*.funct.v \
		$(TB_DIR)/*.v \
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

	# MIN corner (FF, 1.1V, -40C - fastest)
	vsim -voptargs=+acc -t ps -lib work \
		-sdfmin /TB/spsram=$(PNR_DIR)/sram_wrapper.funct.sdf \
		-sdfnoerror \
		-suppress 3438,3262,12091,3448,8756,8470,3444 \
		-wlf min_corner.wlf \
		-c -do "add wave *; run -all; quit" TB | tee post_pnr_min.log

	# TYP corner (TT, 1.0V, 25C - typical)
	vsim -voptargs=+acc -t ps -lib work \
		-sdftyp /TB/spsram=$(PNR_DIR)/sram_wrapper.funct.sdf \
		-sdfnoerror \
		-suppress 3438,3262,12091,3448,8756,8470,3444 \
		-wlf typ_corner.wlf \
		-c -do "add wave *; run -all; quit" TB | tee post_pnr_typ.log

	# MAX corner (SS, 0.9V, 125C - slowest)
	vsim -voptargs=+acc -t ps -lib work \
		-sdfmax /TB/spsram=$(PNR_DIR)/sram_wrapper.funct.sdf \
		-sdfnoerror \
		-suppress 3438,3262,12091,3448,8756,8470,3444 \
		-wlf max_corner.wlf \
		-c -do "add wave *; run -all; quit" TB | tee post_pnr_max.log

	@echo "=========================================="
	@echo "Post-PnR ModelSim simulation complete!"
	@echo "  min_corner.wlf - FF (1.1V, -40C)"
	@echo "  typ_corner.wlf - TT (1.0V, 25C)"
	@echo "  max_corner.wlf - SS (0.9V, 125C)"
	@echo "=========================================="

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
	rm -rf simv simv_min simv_typ simv_max
	rm -rf simv.daidir simv_min.daidir simv_typ.daidir simv_max.daidir
	rm -rf csrc work transcript
	rm -rf *.log *.wlf *.vcd

.PHONY: vcs vsim vsim_gui post_pnr_vcs post_pnr_modelsim view_min view_typ view_max clean
