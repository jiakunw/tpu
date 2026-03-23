##################################################
#  Modelsim do file to run simulation
#  MS 7/2015
##################################################
onerror {quit -f}

vlib work 
vmap work work

# include standard cell verilog model
vlog +acc -incr ../../lib/tcbn65gplus.v

# Include Netlist and Testbench
vlog +acc -incr ../../../../tpu_core/syn/output/tpu_core.syn.v
vlog +acc -incr ../../../dc/sram_wrapper/sram_wrapper.nl.v
vlog +acc -incr ../../../rtl/sram_wrapper/sram00.v

vlog +acc -incr testbench.v 

# Run Simulator 

vsim -voptargs=+acc -t ps -lib work \
-sdfmax testbench/DUT=../../../../tpu_core/syn/output/tpu_core.syn.sdf \
-sdftyp testbench/A_SRAM=../../../dc/sram_wrapper/sram_wrapper.syn.sdf \
-sdftyp testbench/B_SRAM=../../../dc/sram_wrapper/sram_wrapper.syn.sdf \
-sdftyp testbench/C_SRAM=../../../dc/sram_wrapper/sram_wrapper.syn.sdf \
testbench
onfinish final   

do waveformat.do   
run -all
view wave
wave zoom full 