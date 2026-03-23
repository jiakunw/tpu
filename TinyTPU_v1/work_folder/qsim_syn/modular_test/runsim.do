##################################################
#  Modelsim do file to run simulation
#  MS 7/2015
##################################################
onerror {quit -f}

vlib work 
vmap work work

# include standard cell verilog model
vlog +acc -incr ../lib/tcbn65gplus.v

# Include Netlist and Testbench

vlog +acc -incr ../../../systolic_array_wrapper/syn/output/systolic_array_wrapper.syn.v
vlog +acc -incr ../../../input_idx_controller/syn/output/input_idx_controller.syn.v
vlog +acc -incr ../../../output_idx_controller/syn/output/output_idx_controller.syn.v

vlog +acc -suppress 12110 -incr ../../rtl/bias_adder/bias_adder.v
vlog +acc -suppress 12110 -incr ../../rtl/scale_multiplier/scale_multiplier_32x16.v
vlog +acc -suppress 12110 -incr ../../rtl/scale_multiplier/scale_multiplier.v
vlog +acc -suppress 12110 -incr ../../rtl/output_offset_adder/output_offset_adder.v
vlog +acc -suppress 12110 -incr ../../rtl/sram_wrapper/sram_wrapper.v
vlog +acc -suppress 12110 -incr ../../rtl/sram_wrapper/sram00.v
vlog +acc -suppress 12110 -incr ../../rtl/addr_converter/addr_converter.v
vlog +acc -suppress 12110 -incr ../../rtl/activation/ReLU_clamp.v
vlog +acc -suppress 12110 -incr testbench.v 

# Run Simulator 
vsim +acc -suppress 12110 -t ps -lib work \
-sdfmax testbench/systolic_array_wrapper_inst=../../../systolic_array_wrapper/syn/output/systolic_array_wrapper.syn.sdf \
-sdfmax testbench/input_idx_controller_inst=../../../input_idx_controller/syn/output/input_idx_controller.syn.sdf \
-sdfmax testbench/output_idx_controller_inst=../../../output_idx_controller/syn/output/output_idx_controller.syn.sdf \
testbench 
onfinish final  

do waveformat.do   
run -all
view wave
wave zoom full 