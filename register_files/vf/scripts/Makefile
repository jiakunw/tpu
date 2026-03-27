RTL_DIR = ../../input/RTL
TB_DIR = ../../input/TB

vcs:
	vcs -sverilog -full64 -timescale=1ns/1ps -debug_all $(TB_DIR)/tb.sv $(TB_DIR)/axi_spi_master.sv $(RTL_DIR)/rf_top.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/spi_slave.sv -o simv
	./simv | tee sim.log

vsim:
	vlib work
	vlog +acc -sv $(RTL_DIR)/spi_slave.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/rf_top.sv
	vlog +acc -sv $(TB_DIR)/axi_spi_master.sv $(TB_DIR)/tb.sv
	vsim -c -do "run -all; quit" work.tb | tee sim.log

vsim_gui:
	vlib work
	vlog +acc -sv $(RTL_DIR)/spi_slave.sv $(RTL_DIR)/mmio_registers.sv $(RTL_DIR)/rf_top.sv
	vlog +acc -sv $(TB_DIR)/axi_spi_master.sv $(TB_DIR)/tb.sv
	vsim -do "add wave -r /*; run -all" work.tb

clean:
	rm -rf simv simv.daidir csrc work transcript *.log *.wlf *.vcd

.PHONY: vcs vsim vsim_gui clean
