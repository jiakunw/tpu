##################################################
# Modelsim do file to run simuilation
##################################################
vlib work
vmap work work
# Include Source File and Testbench
vlog +acc -incr ./../../input/RTL/slow_control_256.v
vlog +acc -incr ./../../input/TB/ftdi_MPSSE_SPI_emu.v
vlog +acc -incr +define+SIM_BEHAV ./../../input/TB/slow_control_256_tb.v 
# Run Simulator, specify top module
vsim +acc -t ps -lib work Top
do wave.tcl
run -all
