RTL_DIR   = ../../input/RTL
TB_DIR    = ../../input/TB
PNR_DIR   = ../../pnr/output
LIB_DIR   = ../lib
INST      = rf_top
INST_NAME = /tb/u_slave

##################################################
# RTL Simulation - VCS
##################################################
vcs:
	vcs -sverilog -full64 -timescale=1ns/1ps -debug_all \
		$(TB_DIR)/tb.sv $(TB_DIR)/axi_spi_master.sv \
		$(RTL_DIR)/rf_top.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/spi_slave.sv \
		-o simv
	./simv | tee sim.log

##################################################
# RTL Simulation - ModelSim (batch)
##################################################
vsim:
	vlib work
	vlog +acc -sv $(RTL_DIR)/spi_slave.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/rf_top.sv
	vlog +acc -sv $(TB_DIR)/axi_spi_master.sv $(TB_DIR)/tb.sv
	vsim -c -do "run -all; quit" work.tb | tee sim.log

##################################################
# RTL Simulation - ModelSim (GUI)
##################################################
vsim_gui:
	vlib work
	vlog +acc -sv $(RTL_DIR)/spi_slave.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/rf_top.sv
	vlog +acc -sv $(TB_DIR)/axi_spi_master.sv $(TB_DIR)/tb.sv
	vsim -do "add wave -r /*; run -all" work.tb

##################################################
# Post-PnR Simulation - VCS (all three corners)
##################################################
post_pnr_vcs:
	# MIN corner (FF, 1.1V, -40C - fastest)
	vcs -full64 -sverilog -timescale=1ns/1ps \
		+neg_tchk +sdfverbose \
		-sdf min:$(INST_NAME):$(PNR_DIR)/$(INST).funct.sdf \
		$(LIB_DIR)/tcbn65gplus.v \
		$(PNR_DIR)/*.funct.v \
		$(TB_DIR)/*.sv \
		-o simv_min
	./simv_min +sdfverbose 2>&1 | tee post_pnr_min.log

	# TYP corner (TT, 1.0V, 25C - typical)
	vcs -full64 -sverilog -timescale=1ns/1ps \
		+neg_tchk +sdfverbose \
		-sdf typ:$(INST_NAME):$(PNR_DIR)/$(INST).funct.sdf \
		$(LIB_DIR)/tcbn65gplus.v \
		$(PNR_DIR)/*.funct.v \
		$(TB_DIR)/*.sv \
		-o simv_typ
	./simv_typ +sdfverbose 2>&1 | tee post_pnr_typ.log

	# MAX corner (SS, 0.9V, 125C - slowest)
	vcs -full64 -sverilog -timescale=1ns/1ps \
		+neg_tchk +sdfverbose \
		-sdf max:$(INST_NAME):$(PNR_DIR)/$(INST).funct.sdf \
		$(LIB_DIR)/tcbn65gplus.v \
		$(PNR_DIR)/*.funct.v \
		$(TB_DIR)/*.sv \
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
	@for f in $(TB_DIR)/*.sv; do vlog +acc -incr $$f; done

	# MIN corner (FF, 1.1V, -40C - fastest)
	vsim -voptargs=+acc -t ps -lib work \
		-sdfmin $(INST_NAME)=$(PNR_DIR)/$(INST).funct.sdf \
		-sdfnoerror \
		-suppress 3438,3262,12091,3448,8756,8470,3444 \
		-wlf min_corner.wlf \
		-c -do "add wave *; run -all; quit" TB | tee post_pnr_min.log

	# TYP corner (TT, 1.0V, 25C - typical)
	vsim -voptargs=+acc -t ps -lib work \
		-sdftyp $(INST_NAME)=$(PNR_DIR)/$(INST).funct.sdf \
		-sdfnoerror \
		-suppress 3438,3262,12091,3448,8756,8470,3444 \
		-wlf typ_corner.wlf \
		-c -do "add wave *; run -all; quit" TB | tee post_pnr_typ.log

	# MAX corner (SS, 0.9V, 125C - slowest)
	vsim -voptargs=+acc -t ps -lib work \
		-sdfmax $(INST_NAME)=$(PNR_DIR)/$(INST).funct.sdf \
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
