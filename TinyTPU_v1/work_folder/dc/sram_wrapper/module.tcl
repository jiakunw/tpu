#########################################
# TCL script for Design Compiler        #
# MS 2015                               #
#########################################

##################################################
# Read design and library
##################################################

## Set top_level name
#set top_level dut
#
## Read system verilog files
#analyze -format verilog "../../rtl/dut/dut.v"
#
#elaborate ${top_level}
#
## List the names of the designs
#list_designs
#
## Check error
#if { [check_error -v] == 1 } { exit 1 }
#
## Set current design
#current_design $top_level
#
## Link the design
#link
#
## Generate structural verilog netlist
#write -hierarchy -format verilog -output "${top_level}.nl.v"
#
## Finish synthesis
#quit


#########################################
# READ Design and Library               #
#########################################

# Set top level module name
set top_level  sram_wrapper

#source -verbose "../common_scripts/common.tcl"
# Read libraries
set search_path [list "." "/courses/ee6350/pdk2025/tcbn65gplus/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn65gplus_200a" "/tools/synopsys/syn/U-2022.12-SP7/libraries/syn" "../../sram00_gen/"]
set synthetic_library [list "dw_foundation.sldb"]
set link_library [list "*" "tcbn65gplustc_ccs.db" "dw_foundation.sldb" "sram00_nldm_tt_1p00v_1p00v_25c_syn.db"]
set target_library [list "tcbn65gplustc_ccs.db"]

# Read verilog files and elaborate
analyze -format verilog "../../rtl/$top_level/$top_level.v"
# analyze -format verilog "../../dc/down_counter/down_counter.nl.v"
# analyze -format verilog "../../dc/sram_controller/sram_controller.nl.v"
# analyze -format verilog "../../dc/sram_wrapper/sram_wrapper.nl.v"

elaborate $top_level

# List the names of the designs
list_designs

# Check error
if { [check_error -v] == 1 } { exit 1 }

# Link the design
link
check_design

# Set current design
current_design $top_level
check_design

#########################################
# Design Constraints                    #
#########################################

set_max_capacitance 0.005 [all_inputs]
set_max_fanout 4 [all_inputs]
set_max_fanout 4 $top_level

set_fix_multiple_port_nets -all -buffer_constants

check_design

# Timing constraints
source -verbose "./timing.tcl"

#########################################
# Don't touch synthesized submodules    #
#########################################

# set_dont_touch down_counter_inst
# set_dont_touch sram_controller_inst
# set_dont_touch sram_wrapper_inst

#########################################
# Compile                               #
#########################################

current_design $top_level
link

compile

#########################################
# Write outputs                         #
#########################################
source -verbose "../../common_scripts/namingrules.tcl"
#write -hierarchy -format verilog -output "${top_level}.nl.v"
write -format verilog -output "${top_level}.nl.v"
write_sdf -context verilog "${top_level}.temp.sdf"
write_sdf "${top_level}.syn.sdf"
write_sdc "${top_level}.syn.sdc" -version 2.1

# Generate report file
set maxpaths 20
set rpt_file "${top_level}.dc.rpt"
check_design > $rpt_file
report_area  >> ${rpt_file}
report_power -verbose -hier -analysis_effort medium >> ${rpt_file}
report_design >> ${rpt_file}
report_cell >> ${rpt_file}
report_port -verbose >> ${rpt_file}
report_compile_options >> ${rpt_file}
report_constraint -all_violators -verbose >> ${rpt_file}
report_timing -path full -delay max -max_paths $maxpaths -nworst 100 >> ${rpt_file}

report_timing -delay max -nworst 1 -max_paths 10000 -path end -nosplit -unique -sort_by slack > ${top_level}.syn.critical_regs
report_timing -delay max -nworst 1 -max_paths 10000 -path full -nosplit -unique -sort_by slack > ${top_level}.syn.critical_regs.full
report_timing -delay max -nworst 1 -max_paths 10000 -path end -nosplit -unique -sort_by slack -to [all_outputs] > ${top_level}.syn.critical_regs.output
report_timing -delay max -nworst 1 -max_paths 10000 -path end -nosplit -unique -sort_by slack -to [all_registers -data_pins] > ${top_level}.syn.critical_regs.regs
report_timing -delay min -nworst 1 -max_paths 10000 -path short -nosplit -unique -sort_by slack > ${top_level}.syn.fast_path

quit
