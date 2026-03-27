#===============================================================================
# Makefile for SPI Master-Slave Testbench
# Supports: VCS and ModelSim
#===============================================================================

#===============================================================================
# Tool Selection (default: vcs)
# Usage: make SIM=vsim
#===============================================================================
SIM ?= vcs

#===============================================================================
# Directories
#===============================================================================
RTL_DIR = ../RTL

#===============================================================================
# Source Files
#===============================================================================
TB = tb.sv \
     axi_spi_master.sv

RTL = $(RTL_DIR)/rf_top.sv \
      $(RTL_DIR)/mmio_registers.sv \
      $(RTL_DIR)/spi_slave.sv

ALL_SRC = $(TB) $(RTL)

#===============================================================================
# VCS Settings
#===============================================================================
VCS = vcs
VCSFLAGS = -sverilog -full64 \
           -assert svaext \
           -debug_access+all \
           -kdb \
           +lint=all \
           -timescale=1ns/1ps \
           -j4

SIMV = simv

#===============================================================================
# ModelSim Settings!
#===============================================================================
VLIB = vlib
VLOG = vlog
VSIM = vsim

WORK_DIR = work
VLOGFLAGS = -sv -timescale=1ns/1ps +acc
VSIMFLAGS = -c -do "run -all; quit"
VSIMFLAGS_GUI = -do "add wave -r /*; run -all"

TOP = tb

#===============================================================================
# Output
#===============================================================================
LOGFILE = sim.log

#===============================================================================
# Default Target
#===============================================================================
ifeq ($(SIM),vsim)
all: vsim_compile vsim_run
else
all: vcs_compile vcs_run
endif

#===============================================================================
# VCS Targets
#===============================================================================
vcs_compile: $(SIMV)

$(SIMV): $(ALL_SRC)
	$(VCS) $(VCSFLAGS) $(ALL_SRC) -o $(SIMV)

vcs_run: $(SIMV)
	./$(SIMV) | tee $(LOGFILE)

vcs_wave: $(SIMV)
	./$(SIMV) | tee $(LOGFILE)
	@echo "VCD file: wave.vcd"

#===============================================================================
# ModelSim Targets
#===============================================================================
vsim_compile: $(WORK_DIR)
	$(VLOG) $(VLOGFLAGS) -work $(WORK_DIR) $(ALL_SRC)

$(WORK_DIR):
	$(VLIB) $(WORK_DIR)

vsim_run: vsim_compile
	$(VSIM) $(VSIMFLAGS) -work $(WORK_DIR) $(TOP) | tee $(LOGFILE)

vsim_gui: vsim_compile
	$(VSIM) $(VSIMFLAGS_GUI) -work $(WORK_DIR) $(TOP) &

vsim_wave: vsim_compile
	$(VSIM) -do "add wave -r /*; run -all; quit" -work $(WORK_DIR) $(TOP)

#===============================================================================
# Clean
#===============================================================================
clean:
	rm -rf $(SIMV) simv.daidir csrc *.log *.vcd *.fsdb *.wlf
	rm -rf DVEfiles inter.vpd ucli.key vc_hdrs.h
	rm -rf novas.* verdiLog *.conf *.rc
	rm -rf $(WORK_DIR) transcript vsim.wlf modelsim.ini

#===============================================================================
# Help
#===============================================================================
help:
	@echo "============================================"
	@echo "  SPI TB Makefile - VCS & ModelSim"
	@echo "============================================"
	@echo ""
	@echo "  VCS (default):"
	@echo "    make                - Compile & run with VCS"
	@echo "    make vcs_compile    - Compile only"
	@echo "    make vcs_run        - Run simulation"
	@echo "    make vcs_wave       - Run with VCD dump"
	@echo ""
	@echo "  ModelSim:"
	@echo "    make SIM=vsim       - Compile & run with ModelSim"
	@echo "    make vsim_compile   - Compile only"
	@echo "    make vsim_run       - Run (command line)"
	@echo "    make vsim_gui       - Run with GUI"
	@echo "    make vsim_wave      - Run with waveform"
	@echo ""
	@echo "    make clean          - Clean all"
	@echo ""

.PHONY: all vcs_compile vcs_run vcs_wave vsim_compile vsim_run vsim_gui vsim_wave clean help