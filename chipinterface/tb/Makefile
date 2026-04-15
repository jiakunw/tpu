###############################################################################
# Makefile — Full-chip integration testbench (tb_top.sv)
# Simulator: VCS
###############################################################################

# ─── Directories ─────────────────────────────────────────────────────────────
TB_DIR       := /Users/mac/Development/tpu/chipinterface/tb
TOP_DIR      := ../rtl
REG_RTL      := ../../register_files/input/RTL
REG_TB       := ../../register_files/input/TB
BSAB_RTL     := ../../on_chip_memory/bus_slave_ab/input/RTL
SRAM_AB_RTL  := ../../on_chip_memory/V_Sram_wrapper/input/RTL
BSC_RTL      := ../../on_chip_memory/bus_slave_c/input/RTL
SRAM_C_RTL   := ../../on_chip_memory/H_Sram_wrapper/input/RTL
BM_TB        := ../../on_chip_memory/bus_slave_c/input/TB
TPU_RTL      := ../../tpu_core/rtl

# ─── SRAM behavioral model ───────────────────────────────────────────────────
# Confirm the exact filename inside SRAM00_gen/.
# Common names: sram00.v / SRAM00.v / sram00_behav.v
# Override: make sim SRAM_MODEL=/other/path/sram00.v
SRAM_DIR   := /user/stud/fall25/dy2538/ee6350/DIGITAL/SRAM00_gen
SRAM_MODEL := $(SRAM_DIR)/sram00.v

# ─── Source files ─────────────────────────────────────────────────────────────

# tpu_core sub-modules (leaves first, tpu_core last; skip dut/)
TPU_MODS := \
    $(TPU_RTL)/activation/activation.v                        \
    $(TPU_RTL)/addr_converter/addr_converter.v                \
    $(TPU_RTL)/input_buffer/input_buffer.v                    \
    $(TPU_RTL)/input_idx_controller/input_idx_controller.v    \
    $(TPU_RTL)/input_offset_substract/input_offset_substract.v \
    $(TPU_RTL)/output_buffer/output_buffer.v                  \
    $(TPU_RTL)/output_idx_controller/output_idx_controller.v  \
    $(TPU_RTL)/output_offset_adder/output_offset_adder.v      \
    $(TPU_RTL)/scale_multiplier/scale_multiplier.v            \
    $(TPU_RTL)/bias_adder/bias_adder.v                        \
    $(TPU_RTL)/systolic/systolic.v                            \
    $(TPU_RTL)/tpu_core/tpu_core.v

# register file & SPI
REG_SRCS := \
    $(REG_RTL)/mmio_registers.sv  \
    $(REG_RTL)/spi_slave.sv       \
    $(REG_TB)/axi_spi_master.sv

# bus slaves / wrappers / master
BUS_SRCS := \
    $(BSAB_RTL)/bus_slave_ab.sv     \
    $(SRAM_AB_RTL)/sram_wrapper.sv  \
    $(BSC_RTL)/bus_slave_c.sv       \
    $(SRAM_C_RTL)/sram_wrapper_c.sv \
    $(BM_TB)/bus_master.sv

# chip top
TOP_SRCS := $(TOP_DIR)/chipinterface.sv

# testbench
TB_SRCS  := tb.sv

# All sources in compile order
ALL_SRCS := \
    $(SRAM_MODEL) \
    $(TPU_MODS)   \
    $(REG_SRCS)   \
    $(BUS_SRCS)   \
    $(TOP_SRCS)   \
    $(TB_SRCS)

# ─── VCS options ─────────────────────────────────────────────────────────────
VCS      := vcs
SIMV     := simv
WORK_DIR := work

VCS_FLAGS := \
    -full64            \
    -sverilog          \
    -timescale=1ns/1ps \
    -debug_all         \
    +v2k               \
    -notice            \
    +lint=TFIPC        \
    -l compile.log

SIMV_FLAGS := \
    -l sim.log

# ─── Targets ─────────────────────────────────────────────────────────────────

.PHONY: all compile run sim wave clean help

all: sim

## Compile only
compile:
	@echo "=== Compiling ==="
	@mkdir -p $(WORK_DIR)
	$(VCS) $(VCS_FLAGS) $(ALL_SRCS) -o $(WORK_DIR)/$(SIMV)
	@echo "=== Compile done ==="

## Run only (assumes compile already done)
run:
	@echo "=== Running ==="
	$(WORK_DIR)/$(SIMV) $(SIMV_FLAGS)
	@echo "=== Simulation done ==="

## Compile + run
sim: compile run

## Open DVE waveform viewer
wave:
	dve -vpd $(WORK_DIR)/vcdplus.vpd &

## Clean build artifacts
clean:
	rm -rf $(WORK_DIR) *.log csrc ucli.key vc_hdrs.h DVEfiles \
	       AN.DB inter.vpd vcdplus.vpd novas.rc novas.conf \
	       simv simv.daidir

help:
	@echo "Targets:"
	@echo "  make sim     — compile + run (default)"
	@echo "  make compile — compile only"
	@echo "  make run     — run only"
	@echo "  make wave    — open DVE waveform viewer"
	@echo "  make clean   — remove all build artifacts"
	@echo ""
	@echo "  SRAM_MODEL default: $(SRAM_DIR)/sram00.v"
	@echo "  Override:  make sim SRAM_MODEL=/other/path/sram00.v"