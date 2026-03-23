# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: 3_place.tcl


###############################################################################
#  Special treatment for TMR
###############################################################################
# RX May 3, 2019
# Force TMR registers to be TMR_DIST lateral distance away from each other.
# To use this, TMR instances names in the source verilog code must begin with "TMR1", "TMR2", and "TMR3" for Innovus to correctly locate and group them.
select_obj [get_db insts TMR1*]
set n 0
foreach {ptr1} [get_db selected .name] {
	
	set ptr2 [regsub "TMR1" $ptr1 "TMR2"] 
	set ptr3 [regsub "TMR1" $ptr1 "TMR3"] 
	
	# Not all TMR* instance names are actually TMR registers.  Sometimes they are auto-synthesized one-time instances inserted by Genus.
	catch {create_inst_space_group tmrSpaceGrp${n} -inst [list $ptr1 $ptr2 $ptr3] -spacing_x $iv::TMRDIST -spacing_y $iv::TMRDIST}
	
	incr n
}
report_inst_space_group > $iv::reportDir/place.instSpaceGroup.rpt

unset n

###############################################################################
#  PLACEMENT configuration
###############################################################################

if {$vars(cell,welltap) != ""} {
    add_well_taps \
      -cell $vars(cell,welltap) \
      -cell_interval $vars(cell,welltap,gap) \
      -in_row_offset 7 \
      -start_row 1 \
      -prefix WELLTAP \
      -checker_board
}

### Early Global Route (earlyGlobalRoute) is a quick global routing for estimating routing-related congestion and parasitic (resistance and capacitance) values.
##The Early Global Route results are also used for pin assignment when you commit partitions in hierarchical designs
#route_early_global

set_db route_early_global_effort_level low
set_db route_early_global_top_routing_layer $iv::data_top_routing_layer
set_db route_early_global_bottom_routing_layer $iv::data_bottom_routing_layer

reset_db -category place

set_db place_global_cong_effort high
## -timingDriven 1 missing
## -modulePlan 1 missing
set_db place_global_clock_gate_aware 1
set_db place_global_clock_power_driven 0
set_db place_global_ignore_scan true
set_db place_global_reorder_scan 1
set_db place_global_ignore_spare 1
set_db place_global_place_io_pins 1
set_db place_global_module_aware_spare 0
set_db place_detail_preserve_routing 0
set_db place_detail_remove_affected_routing 0
set_db place_detail_check_route 0
set_db place_detail_swap_eeq_cells 0

gui_set_draw_view place

### Reports the available always-on buffers and inverters per domain.
report_always_on_buffer
### Checks for missing or inconsistent library and design data at any stage of the design and writes the results to a text and HTML report.
check_legacy_design -all

set_db opt_buffer_assign_nets true

###############################################################################
#  PLACEMENT
###############################################################################
### Executes pre-CTS flow with both placement and pre-CTS optimization.
place_opt_design -expanded_views

###############################################################################
# ADDING TIEHI and TIELO
###############################################################################
set_db add_tieoffs_max_distance 20
add_tieoffs -lib_cell $vars(cell,tieHiLo)

###############################################################################
# POWER ANALYSIS and DRC CHECK
###############################################################################
delete_routes -type signal
delete_drc_markers
check_drc -out_file $iv::reportDir/place.verifyGeometry.rpt

time_design -pre_cts -report_prefix preCTS -report_dir $iv::reportDir/place.time_design.rpt -timing_debug_report

set_power_output_dir $iv::reportDir
report_power -out_file $iv::reportDir/place.power.rpt
report_power -insts * -out_file $iv::reportDir/place.power_insts.rpt




