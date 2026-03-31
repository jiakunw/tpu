##################################################
# Modelsim do file to run simuilation
##################################################
vlib work
vmap work work
# Include Source File and Testbench
vlog +acc -incr ./../lib/tcbn65gplus.v
vlog +acc -incr ./../../pnr/output/slow_control_256.funct.v
vlog +acc -incr ./../../input/TB/ftdi_MPSSE_SPI_emu.v
vlog +acc -incr +define+SIM_POSTPNR +define+SDF_CORNER="MINIMUM" ./../../input/TB/slow_control_256_tb.v
# Run Simulator, specify top module
vsim +acc -t ps -lib work Top
do wave.tcl
run -all


vlog +acc -incr +define+SIM_POSTPNR +define+SDF_CORNER="TYPICAL" ./../../input/TB/slow_control_256_tb.v
# Run Simulator, specify top module
vsim +acc -t ps -lib work Top
do wave.tcl
run -all


vlog +acc -incr +define+SIM_POSTPNR +define+SDF_CORNER="MAXIMUM" ./../../input/TB/slow_control_256_tb.v
# Run Simulator, specify top module
vsim +acc -t ps -lib work Top
do wave.tcl
run -all
