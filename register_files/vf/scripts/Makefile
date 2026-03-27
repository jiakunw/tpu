#===============================================================================
# Makefile for SPI Master-Slave Testbench
#===============================================================================

RTL_DIR = ../../input/RTL
TB_DIR  = ../../input/TB

#===============================================================================
# VCS
#===============================================================================
vcs:
    vcs -sverilog -full64 -assert svaext -debug_access+all -kdb \
        +lint=all -timescale=1ns/1ps -j4 \
        $(TB_DIR)/axi_spi_master.sv $(TB_DIR)/tb.sv \
        $(RTL_DIR)/rf_top.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/spi_slave.sv \
        -o simv
    ./simv | tee sim.log

#===============================================================================
# ModelSim
#===============================================================================
vsim:
    vlib work
    vlog +acc -sv $(RTL_DIR)/spi_slave.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/rf_top.sv
    vlog +acc -sv axi_spi_master.sv tb.sv
    vsim -c -do "run -all; quit" work.tb | tee sim.log

vsim_gui:
    vlib work
    vlog +acc -sv $(RTL_DIR)/spi_slave.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/rf_top.sv
    vlog +acc -sv axi_spi_master.sv tb.sv
    vsim -do "add wave -r /*; run -all" work.tb

#===============================================================================
# Clean
#===============================================================================
clean:
    rm -rf simv simv.daidir csrc work transcript *.log *.wlf *.vcd

.PHONY: vcs vsim vsim_gui clean
