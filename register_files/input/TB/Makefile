#===============================================================================
# Makefile for SPI Master-Slave Testbench
#===============================================================================

# Tool
VCS = vcs

# VCS Flags
VCSFLAGS = -sverilog -full64 \
           -assert svaext \
           -debug_access+all \
           +lint=all \
           -timescale=1ns/1ps \
           -j4

# Directories
RTL_DIR = ../RTL

# Source Files
TB = tb.sv \
     axi_spi_master.sv

RTL = $(RTL_DIR)/rf_top.sv \
      $(RTL_DIR)/mmio_registers.sv \
      $(RTL_DIR)/spi_slave.sv

# Output
SIMV = simv
LOGFILE = sim.log

#===============================================================================
# Targets
#===============================================================================

all: compile run

compile: $(SIMV)

$(SIMV): $(TB) $(RTL)
	$(VCS) $(VCSFLAGS) $(TB) $(RTL) -o $(SIMV)

run: $(SIMV)
	./$(SIMV) | tee $(LOGFILE)

wave: $(SIMV)
	./$(SIMV) | tee $(LOGFILE)

dve: $(SIMV)
	./$(SIMV) -gui &

clean:
	rm -rf $(SIMV) simv.daidir csrc *.log *.vcd *.fsdb
	rm -rf DVEfiles inter.vpd ucli.key vc_hdrs.h

.PHONY: all compile run wave dve clean