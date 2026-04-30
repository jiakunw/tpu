# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: 4_cts.tcl

###############################################################################
# CTS SETTINGS
###############################################################################
### Ensure that sufficient analysis view are active.
### Clock specification generation is fully multi-mode and it is important that views using both functional and scan modes are active.
### Sets global analysis modes for timing analysis.
### onChipVariation --- Calculates the delay for one path based on maximum operating condition while calculating the delay for another path based on minimum operating condition for setup or hold checks
set_db timing_analysis_type ocv
### Removes pessimism from clock paths that have a portion of the clock network in common between the clock source and clock destination paths
## Enables removal of clock reconvergence pessimism for both setup and hold modes when both is specified
set_db timing_analysis_cppr both
###Reports violations for hold and setup checks
set_db timing_analysis_check_type setup
#set_db timing_analysis_useful_skew true
### Decide top and bottom routing layers for CTS
set clk_tree_top_layer $iv::clk_top_routing_layer
set clk_tree_bottom_layer $iv::clk_bottom_routing_layer
### Route all clock nets during CTS
set route_clock_nets true
set ccopt_effort high
### If this property is set, the CTS algorithm will move logic that appears in the clock tree. "Logic" does not include clock gates, buffers, and inverters in a clock tree, which are always moved unless they are locked, or clock generators that are above the root of the clock tree
set_db cts_move_logic true
### Clock tree definition will, by default, not continue through certain types of cell arc (for instance, the clock to Q arc in a DFF). This property allows you to override the default behavior by specifying the output library pin to which the clock tree should propagate, when it arrives at an instance of the given input library pin.
#set_ccopt_property library_trace_through_to -lib_pin <name>
set_db cts_consider_power_intent true
set leakage_power_effort none
set dynamic_power_effort none
### Specifies whether CCOpt will balance this clock tree. If set to true, CCOpt will not balance or optimize this clock tree. The default is false.
#set_db cts_opt_ignore false
#### Specifies whether to run diagnostic checks to ensure that clock nets routed by NanoRoute follow route guides. The diagnostic checks compare lengths of estimated routes to the final detailed wiring.
set_db cts_check_route_follows_guide true
### Tells CCOpt to rename all clock tree nets for easy identification later in the flow.
set_db cts_rename_clock_tree_nets true
### This property specifies the current waveform calculation methods when considering EM constraints.No or incorrect method means NOT considering EM constraints.
#set_ccopt_property consider_em_constraints avg
### Configure library cells for CTS to use. CTS will use matching falily cells which are NOT dont_use
### NOTE: for buffers, inverters and clock gating use LOW threshold (LVT) cells. In this way the resulting insertion delay will be lower leading to less On Chip Variation.
set_db cts_buffer_cells $vars(cell,clk_bufs)
set_db cts_inverter_cells $vars(cell,clk_invs)
#set_ccopt_property clock_gating_cells $vars(cell,clk_gating)
### Include this setting to use inverters in preference to buffers.
### For many, but not all, low geometry processes inverters result in lower insertion delay and power than buffers.
set_db cts_use_inverters true

### Creates a clock tree network with associated skew groups and other clock tree synthesis (CTS) configuration settings based on a multi-mode timing configuration.
create_clock_tree_spec        \
    -views { av_normal_typ }  \
    -keep_all_sdc_clocks      \
    -out_file ctsSpec_ccopt.tcl

source ctsSpec_ccopt.tcl

set_db cts_max_fanout $iv::clk_maxfanout
set_db cts_target_max_capacitance $iv::clk_maxcap

 ### This command can be used to perform setup, library and design validation checks WITHOUT running CTS
ccopt_design -check_cts_config

###############################################################################
# CLOCK TREE GENERATION
###############################################################################

ccopt_design

###############################################################################
# POST CTS TIMING OPTIMIZATION
###############################################################################

#setOptMode
# -effort high  TO FIND
# -yieldEffort none TO FIND
set_db opt_area_recovery false
set_db opt_remove_redundant_insts true
set_db opt_add_insts true
set_db opt_detail_drv_failure_reason true
set_db opt_delete_insts true
set_db opt_down_size_insts true
set_db opt_fix_hold_allow_overlap auto
set_db opt_post_route_fix_glitch true
set_db opt_post_route_fix_si_transitions true
set_db opt_fix_hold_allow_setup_tns_degradation true
set_db opt_fix_hold_allow_resize  true
set_db opt_fix_hold_on_excluded_clock_nets false
set_db opt_move_insts true
set_db opt_fix_hold_verbose true
set_db opt_setup_target_slack $iv::setup_target_slack
set_db opt_hold_target_slack $iv::hold_target_slack
set_db opt_max_density 0.90
set_db opt_drv_margin 0

#clk skew optimization settings MODIFIED skewed
set_db opt_useful_skew false
set_db opt_useful_skew_ccopt extreme
set_db opt_leakage_to_dynamic_ratio 1.0

### SETUP optimization
opt_design -post_cts

### HOLD optimization
opt_design -post_cts -hold

### Modifies the clock arrival time on sequential elements in order to improve the data path timing between two sequential elements
opt_clock_skew -post_cts

###############################################################################
# CTS REPORTS
###############################################################################
### Report on timing
# setup
time_design -post_cts -report_prefix postCTS -report_dir $iv::reportDir -timing_debug_report  -num_paths 10000

time_design -post_cts -hold -report_prefix postCTS -report_dir $iv::reportDir -timing_debug_report -num_paths 10000

### Report on clock trees to check area and other statistics
#report_ccopt_clock_trees -file $iv::reportDir/ClockTreeReports/clock_trees.rpt

### Report on skew groups to check insertion delay and skew
#report_ccopt_skew_groups -file $iv::reportDir/ClockTreeReports/skew_groups.rpt

### Reports statistics for the entire design
report_summary -no_html -out_dir $iv::reportDir/SummaryReport







