set sdc_version 1.6

current_design bus_slave_ab

set clkperiod 25.0

# SPECIFY CLOCK NAMES HERE
# set <clock name in Genus> [get_ports <name of your clock pin>]
set clks [get_ports BUS_CLK]

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

# Inputs arrive at the rising edge of Clk
set data_inputs [remove_from_collection [all_inputs] [get_ports BUS_CLK]]
set_input_delay  -clock "Clk" -max 0.25 $data_inputs
set_input_delay  -clock "Clk" -min 0.2 $data_inputs
# Outputs to be strobed in at the rising edge of Clk
set_output_delay -clock Clk -max [expr $clkperiod/4] [all_outputs]
set_output_delay -clock Clk -min 0.0        [all_outputs]
