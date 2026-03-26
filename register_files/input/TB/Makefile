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

# Source Files
TB = tb.sv

RTL = axi_spi_master.sv \
      rf_top.sv \
      tpu_spi_slave.sv \
      tpu_mmio_regfile.sv

# Output
SIMV = simv
LOGFILE = sim.log

#===============================================================================
# Targets
#===============================================================================

# Default: compile and run
all: compile run

# Compile only
compile: $(SIMV)

$(SIMV): $(TB) $(RTL)
	$(VCS) $(VCSFLAGS) $(TB) $(RTL) -o $(SIMV)

# Run simulation
run: $(SIMV)
	./$(SIMV) | tee $(LOGFILE)

# Run with waveform dump
wave: $(SIMV)
	./$(SIMV) +dump_vcd | tee $(LOGFILE)

# Open waveform (DVE)
dve: $(SIMV)
	./$(SIMV) -gui &

# Open waveform (Verdi) - if available
verdi:
	verdi -ssf novas.fsdb &

# Clean
clean:
	rm -rf $(SIMV) simv.daidir csrc *.log *.vcd *.fsdb
	rm -rf DVEfiles inter.vpd ucli.key vc_hdrs.h
	rm -rf novas.* verdiLog *.conf *.rc

# Clean all
distclean: clean
	rm -rf *.vpd *.vcd *.fsdb

#===============================================================================
# Help
#===============================================================================
help:
	@echo "============================================"
	@echo "  SPI Master-Slave Testbench Makefile"
	@echo "============================================"
	@echo ""
	@echo "  make          - Compile and run"
	@echo "  make compile  - Compile only"
	@echo "  make run      - Run simulation"
	@echo "  make wave     - Run with VCD dump"
	@echo "  make dve      - Run with DVE GUI"
	@echo "  make clean    - Clean build files"
	@echo ""

.PHONY: all compile run wave dve verdi clean distclean help
