##################################################
# Modelsim do file to run simuilation
##################################################
vlib work
vmap work work
# Include Source File and Testbench
vlog +acc -incr ./../lib/tcbn65gplus.v
vlog +acc -incr ./../../pnr/output/*.funct.v
# vlog +acc -incr ./../../input/TB/*.v
foreach f [glob  ./../../input/TB/*.v] {
    vlog +acc -incr $f
}
vsim -voptargs=+acc -t ps -lib work \
    -sdfmin /TB/spsram=./../../pnr/output/sram_wrapper.funct.sdf \
    -sdfnoerror \
    -suppress 3438,3262,12091,3448,8756,8470,3444 \
    -wlf min_corner.wlf \
    TB

onfinish final
add wave *
run -all
quit -sim

##################################################
# TYPICAL Corner (TT, 1.0V, 25°C)
##################################################
vsim -voptargs=+acc -t ps -lib work \
    -sdftyp /TB/spsram=./../../pnr/output/sram_wrapper.funct.sdf \
    -sdfnoerror \
    -suppress 3438,3262,12091,3448,8756,8470,3444 \
    -wlf typ_corner.wlf \
    TB

onfinish final
add wave *
run -all
quit -sim

##################################################
# MAXIMUM Corner (SS, 0.9V, 125°C)
##################################################
vsim -voptargs=+acc -t ps -lib work \
    -sdfmax /TB/spsram=./../../pnr/output/sram_wrapper.funct.sdf \
    -sdfnoerror \
    -suppress 3438,3262,12091,3448,8756,8470,3444 \
    -wlf max_corner.wlf \
    TB

onfinish final
add wave *
run -all
view wave
wave zoom full
puts "=========================================="
puts "Simulation complete! Waveforms saved:"
puts "  min_corner.wlf - FF (1.1V, -40C, fastest)"
puts "  typ_corner.wlf - TT (1.0V, 25C, typical)"
puts "  max_corner.wlf - SS (0.9V, 125C, slowest)"
puts ""
puts "To view: vsim -view <filename>.wlf"
puts "=========================================="
vsim -view min_corner.wlf
vsim -view typ_corner.wlf
vsim -view max_corner.wlf
view wave
wave zoom full