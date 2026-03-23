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
vlog +acc -suppress 12110 -incr ../../../rtl/tpu_core/tpu_core.v 

vlog +acc -incr ../../../../systolic_array_wrapper/pnr/output/systolic_array_wrapper.funct.v
vlog +acc -incr ../../../../input_idx_controller/pnr/output/input_idx_controller.funct.v
vlog +acc -incr ../../../../output_idx_controller/pnr/output/output_idx_controller.funct.v

vlog +acc -suppress 12110 -incr ../../../rtl/bias_adder/bias_adder.v
vlog +acc -suppress 12110 -incr ../../../rtl/scale_multiplier/scale_multiplier_32x16.v
vlog +acc -suppress 12110 -incr ../../../rtl/scale_multiplier/scale_multiplier.v
vlog +acc -suppress 12110 -incr ../../../rtl/output_offset_adder/output_offset_adder.v
vlog +acc -suppress 12110 -incr ../../../rtl/sram_wrapper/sram_wrapper.v
vlog +acc -suppress 12110 -incr ../../../rtl/sram_wrapper/sram00.v
vlog +acc -suppress 12110 -incr ../../../rtl/addr_converter/addr_converter.v
vlog +acc -suppress 12110 -incr ../../../rtl/activation/ReLU_clamp.v


#TYPICAL
#MINIMUM
#MAXIMUM

vlog +acc -incr +define+SIM_POSTPNR +define+SDF_CORNER="TYPICAL" testbench.v 
vsim +acc -t ps -lib work testbench
onfinish final  
do waveformat.do   
run -all
view wave
wave zoom full 