export VCS_HOME := /afs/ece.cmu.edu/support/synopsys/synopsys.release/T-Foundation/vcs/T-2022.06

# Target executable
TARGET = simv

# Source files
SRC = ../spi_slave.sv \
      ../../mmio_registers.sv \
      ../../top.sv \
      spi_master.sv \
      tb.sv 

# SRC += $(wildcard *.sv)
SRC := $(sort $(SRC)) # Removes duplicates

# Set the number of threads to use for parallel compilation (2 * cores)
CORES = $(shell getconf _NPROCESSORS_ONLN)
THREADS = $(shell echo $$((2 * $(CORES))))

# VCS flags
VCSFLAGS = -full64 -sverilog -debug_all +lint=all +warn=all -j$(THREADS) +v2k

COMMON_FLAGS +=

# Simulator
SIM = vcs

# Altera FPGA library files (for simulation)
INC_V =
INC_V_FLAGS = $(addprefix -v , $(INC_V))

INC_SV =
INC_SV_FLAGS = $(addprefix -v , $(INC_SV))

# Copy common flags
VCSFLAGS += $(COMMON_FLAGS)

default: full

full: $(SRC)
	$(SIM) $(VCSFLAGS) $(INC_V_FLAGS) $(INC_SV_FLAGS) -o $(TARGET) $(SRC)

# run target
run: full
	./$(TARGET)

# waveform
wave: full
	./$(TARGET) -gui &

clean:
	-rm -rf csrc
	-rm -rf DVEfiles
	-rm -f $(TARGET)
	-rm -rf $(TARGET).daidir
	-rm -rf ucli.key
	-rm -rf *.vpd *.vcd *.fsdb
	-rm -rf *.log *.key

.PHONY: default full clean run wave