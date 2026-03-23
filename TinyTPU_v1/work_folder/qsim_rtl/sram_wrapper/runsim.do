##################################################
#  Modelsim do file to run simulation
##################################################

vlib work
vmap work work
onerror {quit -f}

# vlog +acc -incr tb_sram_wrapper.v
vlog +acc -incr ./testbench.v 
foreach f [glob ../../rtl/sram_wrapper/*.v] {
    vlog +acc -incr $f
}

# Run Simulator + 波形
vsim +acc -suppress 12110 -t ps -lib work testbench -wlf output.wlf
onfinish final    
# 添加所有信号波形
add wave *

# 如有自定义波形格式取消注释
# do waveformat.do

run -all
view wave
wave zoom full 