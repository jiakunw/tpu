##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# include standard cell verilog model
vlog +acc -incr /courses/ee6350/pdk2025/tcbn65gplus/TSMCHOME/digital/Front_End/verilog/tcbn65gplus_140b/tcbn65gplus.v

# include the testbench file
vlog +acc -incr testbench.v

# include verilog modules
vlog +acc -incr ../../dc/sram_wrapper/sram_wrapper.nl.v
vlog +acc -incr ../../rtl/sram_wrapper/sram00.v
# run simulation with sdf annotations and check waveforms 

vsim -voptargs=+acc -t ps -lib work \
-sdftyp testbench/u_dut=../../dc/sram_wrapper/sram_wrapper.syn.sdf \
-wlf output.wlf \
testbench
onfinish final    

add wave *
# do waveformat.do   
run -all
view wave
wave zoom full 
# run -all
