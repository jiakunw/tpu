###############################################################################
# Makefile — Full-chip integration testbench (tb_top.sv)
# Simulator: VCS
###############################################################################

# ─── Directories ─────────────────────────────────────────────────────────────
TB_DIR       := .
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
SRAM_DIR   := /user/stud/fall25/dy2538/ee6350/DIGITAL/SRAM00_gen
SRAM_MODEL := $(SRAM_DIR)/sram00.v

# ─── Source files ─────────────────────────────────────────────────────────────

# tpu_core sub-modules (leaves first, tpu_core last; skip *_backup.v)
TPU_MODS := \
    $(TPU_RTL)/activation/ReLU_clamp.v                             \
    $(TPU_RTL)/addr_converter/addr_converter.v                     \
    $(TPU_RTL)/input_buffer/input_buffer.v                         \
    $(TPU_RTL)/input_idx_controller/in_ac_mode_controller.v        \
    $(TPU_RTL)/input_idx_controller/input_idx_controller.v         \
    $(TPU_RTL)/input_offset_substract/input_offset_substract.v     \
    $(TPU_RTL)/output_buffer/output_buffer.v                       \
    $(TPU_RTL)/output_idx_controller/out_ac_mode_controller.v      \
    $(TPU_RTL)/output_idx_controller/output_idx_controller.v       \
    $(TPU_RTL)/output_offset_adder/output_offset_adder.v           \
    $(TPU_RTL)/scale_multiplier/scale_multiplier_32x16.v           \
    $(TPU_RTL)/scale_multiplier/scale_multiplier.v                 \
    $(TPU_RTL)/bias_adder/bias_adder.v                             \
    $(TPU_RTL)/systolic/systolic_array_8x8.v                       \
    $(TPU_RTL)/tpu_core/systolic_array_wrapper.v                   \
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
TB_SRCS  := $(TB_DIR)/tb.sv

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
    +notimingcheck \
    +no_tchk_msg \
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

# ─── ModelSim targets ────────────────────────────────────────────────────────
VSIM     := vsim
VLOG     := vlog
MSIM_DIR := msim_work

VLOG_FLAGS := \
    -sv                \
    -timescale 1ns/1ps \
    +notimingchecks    \
    +acc

VSIM_FLAGS := \
    -t 1ps             \
    +notimingchecks    \
    +no_tchk_msg       \
    -l msim_sim.log

## ModelSim compile only
msim_compile:
	@echo "=== ModelSim Compiling ==="
	@mkdir -p $(MSIM_DIR)
	$(VLOG) $(VLOG_FLAGS) -work $(MSIM_DIR) $(ALL_SRCS) | tee msim_compile.log
	@echo "=== ModelSim Compile done ==="

## ModelSim run only (batch, no GUI)
msim_run:
	@echo "=== ModelSim Running ==="
	$(VSIM) $(VSIM_FLAGS) -work $(MSIM_DIR) -c tb \
	    -do "run -all; quit" | tee -a msim_sim.log
	@echo "=== ModelSim Simulation done ==="

## ModelSim compile + run (batch)
msim: msim_compile msim_run

## ModelSim with GUI waveform
msim_wave:
	$(VSIM) $(VSIM_FLAGS) -work $(MSIM_DIR) tb \
	    -do "add wave -r /*; run -all"

## Clean ModelSim artifacts
msim_clean:
	rm -rf $(MSIM_DIR) msim_compile.log msim_sim.log transcript *.wlf
