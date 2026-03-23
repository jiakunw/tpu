##################################################
#  Modelsim do file to run simulation
#  MS 7/2015
##################################################
onerror {quit -f}

vlib work 
vmap work work

# Include Netlist and Testbench
vlog +acc -suppress 12110 -incr ../../rtl/input_buffer/input_buffer.v 
vlog +acc -suppress 12110 -incr ../../rtl/systolic/systolic_array_8x8.v 
vlog +acc -suppress 12110 -incr ../../rtl/output_buffer/output_buffer.v 
vlog +acc -suppress 12110 -incr ../../rtl/tpu_core/tpu_core.v 
vlog +acc -suppress 12110 -incr ../../rtl/tpu_core/systolic_array_wrapper.v 
vlog +acc -suppress 12110 -incr ../../rtl/input_idx_controller/in_ac_mode_controller.v
vlog +acc -suppress 12110 -incr ../../rtl/input_idx_controller/input_idx_controller.v
vlog +acc -suppress 12110 -incr ../../rtl/output_idx_controller/out_ac_mode_controller.v
vlog +acc -suppress 12110 -incr ../../rtl/output_idx_controller/output_idx_controller.v
vlog +acc -suppress 12110 -incr ../../rtl/input_offset_substract/input_offset_substract.v
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
vsim +acc -suppress 12110 -t ps -lib work testbench 
do waveformat.do   
run -all
view wave
wave zoom full 