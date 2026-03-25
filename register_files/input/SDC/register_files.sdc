set sdc_version 1.6

current_design rf_top

set clkperiod 25.0

# SPECIFY CLOCK NAMES HERE
# set <clock name in Genus> [get_ports <name of your clock pin>]
set clks [get_ports clk]

# SPECIFY YOUR CLOCK NAME AND PERIOD HERE
# create_clock <clock name in Genus> -name "<name of your clock pin>" -period <clock period in nS> 
set num 0
foreach c $clks {
    create_clock $c -name "Clk"	-period $clkperiod
    incr 0
}

# SPECIFY CAP LOADING ON OUTPUT PINS (pF)	
set_load -pin_load 0.5 [get_ports *]

# SPECIFY CLOCK UNCERTAINTY IN nS
set_clock_transition  0.2  [all_clocks]
set_clock_uncertainty 0.2  [all_clocks]

# Inputs arrive at the falling edge of clk
set_input_delay -clock "Clk" -clock_fall 0 [get_ports DO]
set_input_delay -clock "Clk" -clock_fall 0 [get_ports CS_activelow]

# Outputs to be strobed in at the rising edge of SCLK
set_output_delay -clock "Clk" -max -clock_fall [expr $clkperiod/4] [get_ports DI]
set_output_delay -clock "Clk" -max -clock_fall [expr $clkperiod/4] [get_ports slow_control*]
