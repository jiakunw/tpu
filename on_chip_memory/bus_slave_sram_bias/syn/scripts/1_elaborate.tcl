# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Genus: 1_elaborate.tcl


#####################################################################
# Preset global variables and attributes
#####################################################################
set_db max_cpus_per_server 8
set_db super_thread_servers "localhost"
set_db map_fancy_names 1
set_db information_level 9
set_db hdl_max_loop_limit 1024
set_db hdl_unconnected_value none
set_db hdl_reg_naming_style %s_reg%s
set_db iopt_force_constant_removal true
set_db use_scan_seqs_for_non_dft false
suppress_messages $gn::SUPPRESS_MSG
set_db shrink_factor 1.0


#####################################################################
# RTL and libraries setup
#####################################################################
# Search paths
set_db init_lib_search_path $PDK_PATH
set_db init_hdl_search_path $gn::RTLDir
# LEF and captable (deprecated)
#set_db lef_library $gn::LEFLIB
#set_db cap_table_file $gn::CAPTABLE
#set_db interconnect_mode ple
# Liberty library
set_db library $gn::NLDMLIB
# Power root attributes
set_db lp_insert_clock_gating false
set_db lp_clock_gating_prefix lpg
set_db hdl_track_filename_row_col true
set_db leakage_power_effort low

#####################################################################
# Load RTL
#####################################################################

# Treat hard macros as black boxes




# Load RTL
set_db hdl_language v2001
read_hdl $gn::VERILOG_LIST
# elaborate $TOPCELL

# # 确认 sram00 被当作黑盒（可选）
# set_db [get_db modules sram00] .is_black_box true
# # Load all hard macro behavioral models
# foreach v $iv::MACRO_V_LIST {
#     read_hdl $v
# }

#####################################################################
# Elaborate
#####################################################################
elaborate $TOPCELL

#####################################################################
# Constraint setup
#####################################################################
# We are synthesizing only in one mode (default mode) which is the worst case corner as specified by the timing libraries
create_mode -default -name default_mode -design $TOPCELL

# read sdc constraint
foreach gn::SDC_FILE $gn::SDC_LIST {
    read_sdc [file join $gn::SDCDir $gn::SDC_FILE] -mode default_mode
}

report_timing -lint

#####################################################################
# Define cost groups (clock-clock, clock-output, input-clock, input-output)
#####################################################################
define_cost_group -name I2C
define_cost_group -name C2O
define_cost_group -name I2O
define_cost_group -name C2C
path_group -from [all des seqs] -to [all_outputs] -group C2O -name C2O -mode default_mode
path_group -from [all_inputs] -to [all des seqs] -group I2C -name I2C -mode default_mode
path_group -from [all_inputs] -to [all_outputs] -group I2O -name I2O -mode default_mode
path_group -from [all des seqs] -to [all des seqs] -group C2C -name C2C -mode default_mode

#####################################################################
# Initial reports
#####################################################################
# All time values are in pS!
# print out the exceptions
set gn::XCEP [vfind /designs* -exception *]
puts "\nGN INFO: Total numbers of exceptions: [llength $gn::XCEP]\n"
catch {open $gn::reportDir/initial.all_exception.rpt "w"} gn::FXCEP
puts $gn::FXCEP "Total numbers of exceptions: [llength $gn::XCEP]\n"
foreach gn::X $gn::XCEP {
  puts $gn::FXCEP $gn::X
}
close $gn::FXCEP

# report initial design
report_design > $gn::reportDir/initial.design.rpt

# report initial gates
report_gates > $gn::reportDir/initial.gate.rpt

# report initial area
report_area > $gn::reportDir/initial.area.rpt

# report initial timing
report_timing > $gn::reportDir/initial.timing.rpt

# report initial timing groups
report_timing -endpoints > $gn::reportDir/initial.timing_ep.rpt
report_timing -max_slack 0.1 > $gn::reportDir/initial.timing_marginalviol.rpt
report_timing -from [all_inputs] > $gn::reportDir/initial.timing_in.rpt
report_timing -from [all_inputs] -unconstrained > $gn::reportDir/initial.timing_in_uc.rpt
report_timing -to   [all_outputs] > $gn::reportDir/initial.timing_out.rpt
report_timing -to   [all_outputs] -unconstrained > $gn::reportDir/initial.timing_out_uc.rpt
report_timing_summary > $gn::reportDir/initial.timingsummary.rpt
# Across clock domains
set gn::CNT 1
foreach gn::CLK [vfind /designs* -clock *] {
  exec echo "####################" > $gn::reportDir/initial.timing.clk$gn::CNT
  exec echo "# from clock: $gn::CLK" >> $gn::reportDir/initial.timing.clk$gn::CNT
  exec echo "# to clock: $gn::CLK" >> $gn::reportDir/initial.timing.clk$gn::CNT
  exec echo "####################" >> $gn::reportDir/initial.timing.clk$gn::CNT
  report_timing -from $gn::CLK -to $gn::CLK >> $gn::reportDir/initial.timing_clk$gn::CNT.rpt
  incr gn::CNT
}

# report initial summary
puts "\nGN INFO: Reporting Initial QoR below...\n"
redirect -tee $gn::reportDir/initial.qor.rpt {report_qor}
puts "\nEC INFO: Reporting Initial Summary below...\n"
redirect -tee $gn::reportDir/initial.summary.rpt {report summary}

report_timing -lint









