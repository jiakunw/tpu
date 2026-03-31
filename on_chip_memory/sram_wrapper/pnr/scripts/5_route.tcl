# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: 5_route.tcl


###############################################################################
# ROUTING SETTINGS
###############################################################################
set_interactive_constraint_modes [ all_constraint_modes -active ]
### Controls certain aspects of how the NanoRoute router routes the design.
set_db design_bottom_routing_layer $iv::data_bottom_routing_layer
set_db design_top_routing_layer $iv::data_top_routing_layer
set_db route_design_detail_post_route_wire_widen_rule NA
set_db route_design_with_timing_driven false
set_db route_design_with_si_driven false
set_db route_design_detail_on_grid_only None
set_db route_design_strict_honor_route_rule true
#the tool will only do post-route via optimization and all normal routing will be SKIPPED
set_db route_design_detail_use_multi_cut_via_effort high
set_db route_design_concurrent_minimize_via_count_effort high
set_db route_design_detail_fix_antenna true
### The router runs search-and-repair routing during detailed routing. During search and repair, it locates shorts and spacing violations and reroutes the affected areas to eliminate as many of the violations as possible.
### Runs a search-and-repair step after the initial detailed routing.
set_db route_design_detail_search_and_repair true
### search and repair number of iterations
set_db route_design_detail_end_iteration 20
### Antenna fixing settings
set_db route_design_detail_fix_antenna true
set_db route_design_antenna_diode_insertion true
### Inserts diodes to repair process antenna violations on clock nets that are in the regular net section of the DEF file.
set_db route_design_diode_insertion_for_clock_nets true
set_db route_design_antenna_cell_name vars(cell,antenna)

set_route_attributes -skip_routing true -nets $iv::PWR_name
set_route_attributes -skip_routing true -nets $iv::GND_name

###############################################################################
# GLOBAL & DETAILED ROUTING
###############################################################################
### Runs routing or postroute via or wire optimization using the NanoRoute router.
### -globalDetail : Runs timing-driven and SI-driven global and detailed routing.
### When specified, it unfixes the clock nets and then routes all nets, including clocks that still need to be routed.
### It does not ECO route the clock nets prior to other signals so clock nets are not given priority as they are with routeDesign.

route_design -global_detail

### This command checks for routing congestion
#congRepair

###############################################################################
# TIMING ANALYSIS
###############################################################################
set_db timing_analysis_type ocv
set_db timing_analysis_cppr both
time_design -post_route -path_report -drv_report -report_prefix pre_hold_fix -report_dir $iv::reportDir -timing_debug_report
time_design -hold -post_route -path_report -report_prefix pre_hold_fix -report_dir $iv::reportDir -timing_debug_report

###############################################################################
# OPTIMIZATION I
###############################################################################
set_db opt_post_route_allow_overlap false
set_db opt_area_recovery true
set_db opt_remove_redundant_insts true
set_db opt_move_insts true
set_db opt_delete_insts true
set_db opt_setup_target_slack $iv::setup_target_slack
set_db opt_hold_target_slack $iv::hold_target_slack
set_db opt_fix_hold_allow_setup_tns_degradation true
set_db opt_fix_hold_allow_resize true
set_db opt_max_density 0.90
set_db opt_drv_margin 0
set_db opt_useful_skew false
set_db opt_leakage_to_dynamic_ratio 1.0
# RX: Avoid overlapping cells!
set_db opt_post_route_allow_overlap false

### SETUP optimization
opt_design -post_route -setup

### HOLD optimization
opt_design -post_route -hold

###############################################################################
# ROUTING OPTIMIZATION II
###############################################################################
set_db opt_area_recovery false
set_db opt_remove_redundant_insts true
#set_db opt_move_insts false 
# RX: Avoid overlapping cells!
set_db opt_move_insts true
set_db opt_delete_insts true
set_db opt_setup_target_slack $iv::setup_target_slack
set_db opt_hold_target_slack $iv::hold_target_slack
set_db opt_fix_hold_allow_setup_tns_degradation true
set_db opt_fix_hold_allow_resize true
set_db opt_max_density 0.90
set_db opt_drv_margin 0
set_db opt_useful_skew true
set_db opt_leakage_to_dynamic_ratio 1.0
set_db opt_fix_hold_verbose true

opt_design -post_route -setup

opt_design -post_route -hold

opt_design -post_route -drv

###############################################################################
# ROUTING OPTIMIZATION III
###############################################################################
if {$iv::INCR_OPT} {
	opt_design -post_route -incremental

	time_design \
	    -post_route \
	    -report_prefix route_opt_3_incr \
	    -report_dir $iv::reportDir/timingReports \
	    -timing_debug_report \
	    -num_paths 1000

	time_design -hold \
	    -post_route \
	    -report_prefix route_opt_3_incr \
	    -report_dir $iv::reportDir/timingReports \
	    -timing_debug_report \
	    -num_paths 1000
}

###############################################################################
#  NOISE REPORT
###############################################################################
set_db si_glitch_enable_report 1
set_db si_delay_enable_report 1

report_timing
report_noise -out_file $iv::reportDir/route.noise.txt

# ##############################################################################
# ROUTING OPTIMIZATION THROUGH TEMPUS ENGINE
# ##############################################################################
# Slow but gives more accurate results for designs with long wires
# RX: added two setOptMode to prevent cells from overlapping
if {$iv::TEMPUS_ENGINE} { ;
    eval_legacy {
        setOptMode -postRouteAllowOverlap false
        setDelayCalMode -engine aae
        setDelayCalMode -siaware true
        setDelayCalMode -equivalent_waveform_model_propagation true
        setDelayCalMode -equivalent_waveform_model_type ecsm
        setSIMode -separate_delta_delay_on_data true
        setSIMode -delta_delay_annotation_mode lumpedOnNet
        setSIMode -delta_delay_threshold 1e-12
        setSIMode -use_si_slew_for_delay true
        setSIMode -enable_glitch_propagation true
        setSIMode -report_si_slew_max_transition true
        set_global timing_enable_si_cppr true
        set_global timing_cppr_transition_sense same_transition_expanded
        set_global timing_case_analysis_for_icg_propagation always
        set_global timing_remove_clock_reconvergence_pessimism true
        set_global timing_report_unconstrained_paths true
        setSIMode -enable_double_clocking_check true
        setSIMode -enable_glitch_report true
        setSIMode -enable_delay_report true
        set_global timing_cppr_threshold_ps 0
        setDelayCalMode -siAware true -engine aae -mode opt_signoff
	setOptMode -moveInst true
	setOptMode -postRouteAllowOverlap false
    }

    ### DRV optimization
    opt_design -post_route -drv
    ### SETUP optimization
    opt_design -post_route
    ### HOLD optimization
    opt_design -post_route -hold
}

###############################################################################
#  VIA OPTIMIZATION
###############################################################################
set_db route_design_detail_fix_antenna true
set_db route_design_antenna_diode_insertion true
### Swaps single-cut vias for multiple-cut vias or reverses swapping on critical nets in a fully routed design, so that multiple-cut vias are swapped for single-cut vias on those nets.
set_db route_design_detail_post_route_swap_via multiCut
set_db route_design_detail_use_multi_cut_via_effort high
set_db route_design_reserve_space_for_multi_cut false
set_db route_design_with_via_in_pin false
route_design -via_opt

###############################################################################
# DRC FIX
###############################################################################
### This command is part of an ECO flow process and is based on the NanoRoute router
delete_drc_markers
check_drc -out_file $iv::reportDir/route.verifyGeometry.rpt -limit 100000
delete_routes_with_violations
route_eco
delete_drc_markers
check_drc -out_file $iv::reportDir/route.verifyGeometry_eco.rpt -limit 100000

# ##############################################################################
# POST ROUTING POWER & MULTI VIA REPORT
# ##############################################################################
set_db power_handle_glitch true
report_power -out_dir $iv::reportDir
report_power -out_file $iv::reportDir/postRoute.power.rpt
report_power -insts * -out_file $iv::reportDir/postRoute.power_instances.rpt
report_route -multi_cut
report_route -summary

###############################################################################
# ADDING FILLER CELLS WITH DECAP and FILLERS (removed during optimization)
###############################################################################
add_fillers -base_cells $vars(cell,filler) -prefix FILLER

# Or explicitly specify amount of decap:
#add_decaps -total_cap 14000 -cells DCAP64 DCAP32 DCAP16 DCAP8 
#add_fillers -base_cells $vars(cell,filler) -prefix FILLER

# addFiller command is running on a postRoute database. It is recommended to be followed by ecoRoute -target command to make the DRC clean.
route_eco -target

###############################################################################
# ROUTING DRC CHECK
###############################################################################
delete_drc_markers
check_drc -out_file $iv::reportDir/route.verifyGeometry_route_Opt.rpt

###############################################################################
# Dummy metal filling
###############################################################################
source ../scripts/addMetalFill.tcl

###############################################################################
# TIMING REPORT
###############################################################################

time_design \
	-post_route \
	-report_prefix route_final \
	-report_dir $iv::reportDir/timingReports \
	-timing_debug_report \
	-num_paths 1000

time_design \
	-hold \
	-post_route \
	-report_prefix route_final \
	-report_dir $iv::reportDir/timingReports \
	-timing_debug_report \
	-num_paths 1000

check_timing -verbose


###############################################################################
# DRC CHECK III
###############################################################################
delete_place_halo -all_blocks
### delete_place_blockages -all
delete_route_blockages -type all
delete_route_halos -all_blocks

delete_drc_markers
check_drc -out_file $iv::reportDir/route.verifyGeometry_route_postMetalFill.rpt








