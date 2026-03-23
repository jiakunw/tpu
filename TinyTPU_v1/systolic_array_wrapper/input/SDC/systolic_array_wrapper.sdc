set sdc_version 1.6

current_design systolic_array_wrapper

set clkperiod 20

# SPECIFY CLOCK NAMES HERE
# set <clock name in Genus> [get_ports <name of your clock pin>]
set clks [get_ports clk]

# SPECIFY YOUR CLOCK NAME AND PERIOD HERE
# create_clock <clock name in Genus> -name "<name of your clock pin>" -period <clock period in nS> 
set num 0
foreach c $clks {
    create_clock $c -name "clk"	-period $clkperiod
    incr 0
}

# SPECIFY CAP LOADING ON OUTPUT PINS (pF)	
set_load -pin_load 0.5 [get_ports *]

# SPECIFY CLOCK UNCERTAINTY IN nS
set_clock_transition  0.15  [all_clocks]
set_clock_uncertainty 0.15  [all_clocks] 

# Inputs arrive at the rising edge of Clk
set data_inputs [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay  -clock "clk" -max 0.25 $data_inputs
set_input_delay  -clock "clk" -min 0.2 $data_inputs
# Outputs to be strobed in at the rising edge of Clk
set_output_delay -clock "clk" -max [expr $clkperiod/4] [all_outputs]
set_output_delay -clock "clk" -min 0.0 [all_outputs]