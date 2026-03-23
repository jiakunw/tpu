#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sun Mar 22 13:33:36 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.16-s078_1 (64bit) 12/07/2022 12:07 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.16-s078_1 NR221206-1807/21_16-UB (database version 18.20.600) {superthreading v2.17}
#@(#)CDS: AAE 21.16-s035 (64bit) 12/07/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.16-s024_1 () Dec  5 2022 05:41:45 ( )
#@(#)CDS: SYNTECH 21.16-s009_1 () Nov  9 2022 03:47:50 ( )
#@(#)CDS: CPE v21.16-s066
#@(#)CDS: IQuantus/TQuantus 21.1.1-s939 (64bit) Wed Nov 9 09:34:24 PST 2022 (Linux 3.10.0-693.el7.x86_64)

#@ source ../scripts/run_all.tcl
#@ Begin verbose source (pre): source ../scripts/run_all.tcl
#@ source ../../input/project_setup.tcl
#@ Begin verbose source ../../input/project_setup.tcl (pre)
namespace eval gn {}	
namespace eval iv {}	
set gn::RTLDir		../../input/RTL/
set gn::SDCDir		../../input/SDC/
set gn::OutDir		../output
set gn::reportDir	../report
set iv::OutDir		../output
set iv::reportDir	../report
set gn::SYN_EFFORT	medium
set gn::MAP_EFFORT	high
set gn::INCR_EFFORT	high
set gn::SUPPRESS_MSG	{LBR-30 LBR-31 VLOGPT-35}
set TOPCELL	  input_idx_controller	
set gn::VERILOG_LIST	[glob ${gn::RTLDir}*.v]	
set gn::SDC_LIST	[glob ${gn::SDCDir}*.sdc]
set iv::node		65
set iv::TEMPUS_ENGINE	1
set iv::INCR_OPT	1
set iv::PWR_name	DVDD
set iv::GND_name	DVSS
set iv::PWR_libname	VDD
set iv::GND_libname	VSS
set vars(fp,width)         100
set vars(fp,height)         100
set vars(fp,io_core_space)   27.5  
set vars(ring,top_layer)        9  
set vars(ring,bottom_layer)     9  
set vars(ring,left_layer)       8  
set vars(ring,right_layer)      8  
set vars(ring,top_width)        9.06  
set vars(ring,bottom_width)     9.06  
set vars(ring,left_width)       9.06  
set vars(ring,right_width)      9.06  
set vars(ring,top_space)        4.44  
set vars(ring,bottom_space)     4.44  
set vars(ring,left_space)       4.44  
set vars(ring,right_space)      4.44  
set vars(ring,top_offset)       4.44  
set vars(ring,bottom_offset)    4.44  
set vars(ring,left_offset)      4.44  
set vars(ring,right_offset)     4.44  
set vars(stripe,dir)     vertical  
set vars(stripe,space)          4.44  
set vars(stripe,metal)          8  
set vars(stripe,width)         9.06 
set vars(stripe,setdist)	[expr { (($vars(fp,width))-$vars(stripe,width)-0.5*$vars(stripe,space)-0.5*$vars(fp,io_core_space))/2 }]
set vars(cell,decaps) "DCAP64 DCAP32 DCAP16 DCAP8 DCAP4"
set vars(cell,welltap) ""
set vars(cell,welltap,gap) ""
set vars(cell,tieHiLo) "TIEH TIEL"
set vars(cell,filler) "DCAP64 DCAP32 DCAP16 DCAP8 DCAP4 FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
set vars(cell,filler_nosch) "FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
set vars(cell,antenna) "ANTENNA"
set iv::TMRDIST		25
set iv::data_bottom_routing_layer	1
set iv::data_top_routing_layer		9
set vars(cell,clk_bufs) {CKBD1 CKBD12 CKBD16 CKBD2 CKBD20 CKBD24 CKBD3 CKBD4 CKBD6 CKBD8}
set vars(cell,clk_invs) {CKND1 CKND12 CKND16 CKND2 CKND20 CKND24 CKND3 CKND4 CKND6 CKND8}
set iv::clk_bottom_routing_layer	2
set iv::clk_top_routing_layer		7
set iv::clk_maxfanout			20
set iv::clk_maxcap			10pf
set iv::setup_target_slack		0.15
set iv::hold_target_slack		0.15
set PDK_PATH		"/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/Base_PDK/PDK_CRN65GP_v1.0c_official_IC61_20101010"
set PDK_DIGITAL		"/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/digital"
set gn::NLDMLIB		[list "$PDK_DIGITAL/Front_End/timing_power_noise/NLDM/tcbn65gplus_200a/tcbn65gpluswc.lib"]
set iv::OALIB		[list "tcbn65gplus_oalib" ]
set iv::OATECH		"tcbn65gplus_oalib"
set iv::OAPHYS		"tcbn65gplus"
set iv::OAPHYSTECH		"tsmcN65"
set iv::VERILOG_SUBCKT  "$PDK_DIGITAL/Front_End/verilog/tcbn65gplus_200a/tcbn65gplus_pwr.v"
set iv::SPICE_SUBCKT    "$PDK_DIGITAL/Back_End/spice/tcbn65gplus_200a/tcbn65gplus_200a.spi"
#@ End verbose source ../../input/project_setup.tcl
#@ source ../scripts/1_import.tcl
#@ Begin verbose source ../scripts/1_import.tcl (pre)
catch { exec rm cds.lib }
file copy  ../../input/project.lib ./cds.lib
set_db design_process_node $iv::node
set_multi_cpu_usage -no_cpu_auto_adjustment true -local_cpu 8 -keep_license true
set_db timing_report_fields {hpin cell delay required arrival edge user_derate transition load}
set_db timing_allow_input_delay_on_clock_source false
set_db write_def_hierarchy_delimiter {/}
set_db init_oa_ref_libs $iv::OALIB
set_db init_oa_tech_lib $iv::OATECH
set_db init_oa_design_view {floorplan}
set_db init_netlist_files ../../syn/output/$TOPCELL.syn.v
set_db init_power_nets $iv::PWR_name
set_db init_ground_nets $iv::GND_name
set_db init_mmmc_files ../../input/mmmc.tcl
set_db delaycal_input_transition_delay {0.1ps}
set_db init_oa_layout_views {layout}
set_db init_oa_abstract_views {abstract}
read_mmmc ../../input/mmmc.tcl
#@ Begin verbose source ../../input/mmmc.tcl (pre)
create_rc_corner -name RC_BEST -qrc_tech  "$PDK_PATH/Assura/lvs_rcx/tn65cmsp007v1_1_3a/RC_QRC_crn65lp_1p9m_6x1z1u_alrdl_5corners_13a/RC_QRC_crn65lp_1p09m+alrdl_6x1z1u_rcbest/qrcTechFile"
create_rc_corner -name RC_TYP -qrc_tech   "$PDK_PATH/Assura/lvs_rcx/tn65cmsp007v1_1_3a/RC_QRC_crn65lp_1p9m_6x1z1u_alrdl_5corners_13a/RC_QRC_crn65lp_1p09m+alrdl_6x1z1u_typical/qrcTechFile"
create_rc_corner -name RC_WORST -qrc_tech "$PDK_PATH/Assura/lvs_rcx/tn65cmsp007v1_1_3a/RC_QRC_crn65lp_1p9m_6x1z1u_alrdl_5corners_13a/RC_QRC_crn65lp_1p09m+alrdl_6x1z1u_rcworst/qrcTechFile"
create_library_set -name libs_typ -timing [list  \
    "$PDK_DIGITAL/Front_End/timing_power_noise/NLDM/tcbn65gplus_200a/tcbn65gplustc.lib"  \
    ] -si [list  \
    "$PDK_DIGITAL/Back_End/celtic/tcbn65gplus_200a/tcbn65gplustc.cdb"  \
]
create_library_set -name libs_min -timing [list  \
    "$PDK_DIGITAL/Front_End/timing_power_noise/NLDM/tcbn65gplus_200a/tcbn65gplusbc.lib"  \
    ] -si [list  \
    "$PDK_DIGITAL/Back_End/celtic/tcbn65gplus_200a/tcbn65gplusbc.cdb"  \
]
create_library_set -name libs_min_lt -timing [list  \
    "$PDK_DIGITAL/Front_End/timing_power_noise/NLDM/tcbn65gplus_200a/tcbn65gpluslt.lib"  \
    ] -si [list  \
    "$PDK_DIGITAL/Back_End/celtic/tcbn65gplus_200a/tcbn65gpluslt.cdb"  \
]
create_library_set -name libs_max -timing [list  \
    "$PDK_DIGITAL/Front_End/timing_power_noise/NLDM/tcbn65gplus_200a/tcbn65gpluswc.lib"  \
    ] -si [list  \
    "$PDK_DIGITAL/Back_End/celtic/tcbn65gplus_200a/tcbn65gpluswc.cdb"  \
]
create_opcond -name oc_typ    -process 1 -voltage 1.0 -temperature  25
create_opcond -name oc_min    -process 1 -voltage 1.1 -temperature  0
create_opcond -name oc_min_lt -process 1 -voltage 1.1 -temperature -40
create_opcond -name oc_max    -process 1 -voltage 0.9 -temperature 125
create_timing_condition -name tc_typ     -library_sets libs_typ     -opcond oc_typ
create_timing_condition -name tc_min     -library_sets libs_min     -opcond oc_min
create_timing_condition -name tc_min_lt  -library_sets libs_min_lt  -opcond oc_min_lt
create_timing_condition -name tc_max     -library_sets libs_max     -opcond oc_max
create_constraint_mode  -name mode_normal -sdc_files ../../syn/output/$TOPCELL.syn.sdc
create_delay_corner -name dc_typ    -timing_condition tc_typ     -rc_corner {RC_TYP}
create_delay_corner -name dc_min    -timing_condition tc_min     -rc_corner {RC_BEST}
create_delay_corner -name dc_min_lt -timing_condition tc_min_lt  -rc_corner {RC_BEST}
create_delay_corner -name dc_max    -timing_condition tc_max     -rc_corner {RC_WORST}
create_analysis_view -name av_normal_typ     -constraint_mode {mode_normal}  -delay_corner {dc_typ}
create_analysis_view -name av_normal_min     -constraint_mode {mode_normal}  -delay_corner {dc_min}
create_analysis_view -name av_normal_min_lt  -constraint_mode {mode_normal}  -delay_corner {dc_min_lt}
create_analysis_view -name av_normal_max     -constraint_mode {mode_normal}  -delay_corner {dc_max}
set_analysis_view \
	-setup {  av_normal_max   av_normal_typ     av_normal_min   av_normal_min_lt }  \
	-hold  {  av_normal_min   av_normal_min_lt  av_normal_typ   av_normal_max}
#@ End verbose source ../../input/mmmc.tcl
read_physical -oa_ref_libs $iv::OALIB -oa_tech_lib $iv::OATECH
read_netlist ../../syn/output/$TOPCELL.syn.v
init_design
gui_fit
gui_set_draw_view fplan
#@ source ../../input/user_timing_derating.tcl
#@ Begin verbose source ../../input/user_timing_derating.tcl (pre)
set_timing_derate -delay_corner dc_min -late 1.2
set_timing_derate -delay_corner dc_min_lt -late 1.2
set_timing_derate -delay_corner dc_max -early 0.8
report_timing_derate
#@ End verbose source ../../input/user_timing_derating.tcl
connect_global_net $iv::PWR_name -type pg_pin -pin_base_name $iv::PWR_libname -inst *
connect_global_net $iv::GND_name -type pg_pin -pin_base_name $iv::GND_libname -inst *
connect_global_net $iv::PWR_name -type tiehi
connect_global_net $iv::GND_name -type tielo
#@ End verbose source ../scripts/1_import.tcl
#@ source ../scripts/2_floorplan.tcl
#@ Begin verbose source ../scripts/2_floorplan.tcl (pre)
create_floorplan \
	-site "core" \
    	-die_size [list $vars(fp,width) $vars(fp,height) $vars(fp,io_core_space) $vars(fp,io_core_space) $vars(fp,io_core_space) $vars(fp,io_core_space)]
gui_fit
if {$vars(cell,tieHiLo) != ""} {
set_db add_tieoffs_max_distance 20 ;
set_db add_tieoffs_cells $vars(cell,tieHiLo)
}
read_io_file ../../input/pins.io
set box [split [join [get_db current_design .core_bbox.]]]
set x1 [lindex $box 0]
set y1 [lindex $box 1]
set x2 [lindex $box 2]
set y2 [lindex $box 3]
set_db add_rings_avoid_short 0
set_db add_rings_extend_over_row 0
set_db add_rings_ignore_rows 0
set_db add_rings_orthogonal_only true
set_db add_rings_target default
set_db add_rings_skip_shared_inner_ring none
set_db add_rings_skip_via_on_pin {standardcell}
set_db add_rings_skip_via_on_wire_shape {noshape}
set_db add_rings_stacked_via_bottom_layer M1
set_db add_rings_stacked_via_top_layer AP
set_db add_rings_via_using_exact_crossover_size 1
add_rings -nets "$iv::PWR_name $iv::GND_name" \
    -type core_rings -follow core \
    -layer "top $vars(ring,top_layer) bottom $vars(ring,bottom_layer) left $vars(ring,left_layer) right $vars(ring,right_layer)" \
    -width "top $vars(ring,top_width) bottom $vars(ring,bottom_width) left $vars(ring,left_width) right $vars(ring,right_width)" \
    -spacing "top $vars(ring,top_space) bottom  $vars(ring,bottom_space) left $vars(ring,left_space) right $vars(ring,right_space)" \
    -offset "top $vars(ring,top_offset) bottom $vars(ring,bottom_offset) left $vars(ring,left_offset) right $vars(ring,right_offset)" \
    -center 0 -extend_corner {} -threshold 0 \
    -jog_distance 0 -snap_wire_center_to_grid None
add_stripes \
    -direction $vars(stripe,dir) -spacing $vars(stripe,space) -layer $vars(stripe,metal) -width $vars(stripe,width) \
    -nets "$iv::PWR_name $iv::GND_name" \
    -create_pins 1 \
    -start_from left \
    -start_offset $vars(stripe,setdist) \
    -set_to_set_distance $vars(stripe,setdist)
finish_floorplan -auto_halo
route_special -connect {core_pin}  \
    -allow_layer_change 0  \
    -allow_jogging 1 \
    -floating_stripe_target ring
delete_drc_markers
check_drc -out_file $iv::reportDir/fp.verifyGeometry.rpt
#@ End verbose source ../scripts/2_floorplan.tcl
#@ source ../scripts/3_place.tcl
#@ Begin verbose source ../scripts/3_place.tcl (pre)
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
if {$vars(cell,welltap) != ""} {...}
set_db route_early_global_effort_level low
set_db route_early_global_top_routing_layer $iv::data_top_routing_layer
set_db route_early_global_bottom_routing_layer $iv::data_bottom_routing_layer
reset_db -category place
set_db place_global_cong_effort high
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
report_always_on_buffer
check_legacy_design -all
set_db opt_buffer_assign_nets true
place_opt_design -expanded_views
set_db add_tieoffs_max_distance 20
add_tieoffs -lib_cell $vars(cell,tieHiLo)
delete_routes -type signal
delete_drc_markers
check_drc -out_file $iv::reportDir/place.verifyGeometry.rpt
time_design -pre_cts -report_prefix preCTS -report_dir $iv::reportDir/place.time_design.rpt -timing_debug_report
set_power_output_dir $iv::reportDir
report_power -out_file $iv::reportDir/place.power.rpt
report_power -insts * -out_file $iv::reportDir/place.power_insts.rpt
#@ End verbose source ../scripts/3_place.tcl
#@ source ../scripts/4_cts.tcl
#@ Begin verbose source ../scripts/4_cts.tcl (pre)
set_db timing_analysis_type ocv
set_db timing_analysis_cppr both
set_db timing_analysis_check_type setup
set clk_tree_top_layer $iv::clk_top_routing_layer
set clk_tree_bottom_layer $iv::clk_bottom_routing_layer
set route_clock_nets true
set ccopt_effort high
set_db cts_move_logic true
set_db cts_consider_power_intent true
set leakage_power_effort none
set dynamic_power_effort none
set_db cts_check_route_follows_guide true
set_db cts_rename_clock_tree_nets true
set_db cts_buffer_cells $vars(cell,clk_bufs)
set_db cts_inverter_cells $vars(cell,clk_invs)
set_db cts_use_inverters true
create_clock_tree_spec        \
    -views { av_normal_typ }  \
    -keep_all_sdc_clocks      \
    -out_file ctsSpec_ccopt.tcl
#@ source ctsSpec_ccopt.tcl
#@ Begin verbose source ctsSpec_ccopt.tcl (pre)
if { [get_db clock_trees] != {} } {...}
namespace eval ::ccopt {}
namespace eval ::ccopt::ilm {}
set ::ccopt::ilm::ccoptSpecRestoreData {}
if { [catch {ccopt_check_and_flatten_ilms_no_restore}] } {...}
set ::ccopt::ilm::ccoptSpecRestoreData $::ccopt::ilm::ccoptRestoreILMState
set_db port:clk .cts_is_sdc_clock_root true
create_clock_tree -name clk -source clk -no_skew_group
set_db clock_tree:clk .cts_target_max_transition_time_sdc_early -index delay_corner:dc_max 0.150
set_db clock_tree:clk .cts_target_max_transition_time_sdc_late -index delay_corner:dc_max 0.150
set_db clock_tree:clk .cts_target_max_transition_time_sdc_early -index delay_corner:dc_typ 0.150
set_db clock_tree:clk .cts_target_max_transition_time_sdc_late -index delay_corner:dc_typ 0.150
set_db clock_tree:clk .cts_target_max_transition_time_sdc_early -index delay_corner:dc_min 0.150
set_db clock_tree:clk .cts_target_max_transition_time_sdc_late -index delay_corner:dc_min 0.150
set_db clock_tree:clk .cts_target_max_transition_time_sdc_early -index delay_corner:dc_min_lt 0.150
set_db clock_tree:clk .cts_target_max_transition_time_sdc_late -index delay_corner:dc_min_lt 0.150
set_db port:clk .cts_clock_period 20
set_db cts_timing_connectivity_info {}
create_skew_group -name clk/mode_normal -sources clk -auto_sinks
set_db skew_group:clk/mode_normal .cts_skew_group_include_source_latency true
set_db skew_group:clk/mode_normal .cts_skew_group_created_from_clock clk
set_db skew_group:clk/mode_normal .cts_skew_group_created_from_constraint_mode mode_normal
set_db skew_group:clk/mode_normal .cts_skew_group_created_from_delay_corners {dc_max dc_typ dc_min dc_min_lt}
check_clock_tree_convergence
if { [get_db ccopt_auto_design_state_for_ilms] == 0 } {...}
#@ End verbose source ctsSpec_ccopt.tcl
set_db cts_max_fanout $iv::clk_maxfanout
set_db cts_target_max_capacitance $iv::clk_maxcap
ccopt_design -check_cts_config
ccopt_design
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
set_db opt_useful_skew false
set_db opt_useful_skew_ccopt extreme
set_db opt_leakage_to_dynamic_ratio 1.0
opt_design -post_cts
opt_design -post_cts -hold
opt_clock_skew -post_cts
time_design -post_cts -report_prefix postCTS -report_dir $iv::reportDir -timing_debug_report  -num_paths 10000
time_design -post_cts -hold -report_prefix postCTS -report_dir $iv::reportDir -timing_debug_report -num_paths 10000
report_summary -no_html -out_dir $iv::reportDir/SummaryReport
#@ End verbose source ../scripts/4_cts.tcl
#@ source ../scripts/5_route.tcl
#@ Begin verbose source ../scripts/5_route.tcl (pre)
set_interactive_constraint_modes [ all_constraint_modes -active ]
set_db design_bottom_routing_layer $iv::data_bottom_routing_layer
set_db design_top_routing_layer $iv::data_top_routing_layer
set_db route_design_detail_post_route_wire_widen_rule NA
set_db route_design_with_timing_driven false
set_db route_design_with_si_driven false
set_db route_design_detail_on_grid_only None
set_db route_design_strict_honor_route_rule true
set_db route_design_detail_use_multi_cut_via_effort high
set_db route_design_concurrent_minimize_via_count_effort high
set_db route_design_detail_fix_antenna true
set_db route_design_detail_search_and_repair true
set_db route_design_detail_end_iteration 20
set_db route_design_detail_fix_antenna true
set_db route_design_antenna_diode_insertion true
set_db route_design_diode_insertion_for_clock_nets true
set_db route_design_antenna_cell_name vars(cell,antenna)
set_route_attributes -skip_routing true -nets $iv::PWR_name
set_route_attributes -skip_routing true -nets $iv::GND_name
route_design -global_detail
set_db timing_analysis_type ocv
set_db timing_analysis_cppr both
time_design -post_route -path_report -drv_report -report_prefix pre_hold_fix -report_dir $iv::reportDir -timing_debug_report
time_design -hold -post_route -path_report -report_prefix pre_hold_fix -report_dir $iv::reportDir -timing_debug_report
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
set_db opt_post_route_allow_overlap false
opt_design -post_route -setup
opt_design -post_route -hold
set_db opt_area_recovery false
set_db opt_remove_redundant_insts true
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
if {$iv::INCR_OPT} {
opt_design -post_route -incremental
time_design  -post_route  -report_prefix route_opt_3_incr  -report_dir $iv::reportDir/timingReports  -timing_debug_report  -num_paths 1000
time_design -hold  -post_route  -report_prefix route_opt_3_incr  -report_dir $iv::reportDir/timingReports  -timing_debug_report  -num_paths 1000
}
set_db si_glitch_enable_report 1
set_db si_delay_enable_report 1
report_timing
report_noise -out_file $iv::reportDir/route.noise.txt
if {$iv::TEMPUS_ENGINE} {
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
opt_design -post_route -drv
opt_design -post_route
opt_design -post_route -hold
}
set_db route_design_detail_fix_antenna true
set_db route_design_antenna_diode_insertion true
set_db route_design_detail_post_route_swap_via multiCut
set_db route_design_detail_use_multi_cut_via_effort high
set_db route_design_reserve_space_for_multi_cut false
set_db route_design_with_via_in_pin false
route_design -via_opt
delete_drc_markers
check_drc -out_file $iv::reportDir/route.verifyGeometry.rpt -limit 100000
delete_routes_with_violations
route_eco
delete_drc_markers
check_drc -out_file $iv::reportDir/route.verifyGeometry_eco.rpt -limit 100000
set_db power_handle_glitch true
report_power -out_dir $iv::reportDir
report_power -out_file $iv::reportDir/postRoute.power.rpt
report_power -insts * -out_file $iv::reportDir/postRoute.power_instances.rpt
report_route -multi_cut
report_route -summary
add_fillers -base_cells $vars(cell,filler) -prefix FILLER
route_eco -target
delete_drc_markers
check_drc -out_file $iv::reportDir/route.verifyGeometry_route_Opt.rpt
#@ source ../scripts/addMetalFill.tcl
#@ Begin verbose source ../scripts/addMetalFill.tcl (pre)
delete_metal_fill -shapes { FILLWIRE FILLWIREOPC } -modes all
set box [split [join [eval_legacy {dbGet top.fPlan.corebox}]]]
set ne [lindex $box 0]
set nw [lindex $box 1]
set se [lindex $box 2]
set sw [lindex $box 3]
set_metal_fill -layer 8 -min_width 2 -min_length 2 -active_spacing 3 -gap_spacing 2.5
set_metal_fill -layer 9 -min_width 3 -min_length 3 -active_spacing 3 -gap_spacing 2.5
set_metal_fill -layer 10 -min_width 3 -min_length 3 -active_spacing 3 -gap_spacing 2.5
add_metal_fill -area $ne $nw $se $sw -on_cell -layers { 1 2 3 4 5 6 7 8 9 10 } -stagger on -square_shape -timing_aware on > $iv::reportDir/route.addMetalFill.rpt
set_db current_design .nets.special_wires.shape corewire
#@ End verbose source ../scripts/addMetalFill.tcl
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
delete_place_halo -all_blocks
delete_route_blockages -type all
delete_route_halos -all_blocks
delete_drc_markers
check_drc -out_file $iv::reportDir/route.verifyGeometry_route_postMetalFill.rpt
#@ End verbose source ../scripts/5_route.tcl
#@ source ../scripts/6_checks.tcl
#@ Begin verbose source ../scripts/6_checks.tcl (pre)
#@ source ../scripts/signoff_timing_analysis.tcl
#@ Begin verbose source ../scripts/signoff_timing_analysis.tcl (pre)
proc extract_and_time_design {prefix} {

 

    set_db extract_rc_use_qrc_oa_interface true
    set_db extract_rc_coupled true
    eval_legacy { setDelayCalMode -engine default }
    set_db extract_rc_effort_level signoff
    set_db extract_rc_lef_tech_file_map "../../input/qrc.map"
    set_db timing_analysis_type ocv
    set_db timing_analysis_cppr both
    set_db delaycal_enable_si true

    extract_rc

    write_parasitics -rc_corner RC_BEST  -spef_file $iv::OutDir/export_RC_BEST.spef
    write_parasitics -rc_corner RC_WORST -spef_file $iv::OutDir/export_RC_WORST.spef
    write_parasitics -rc_corner RC_TYP   -spef_file $iv::OutDir/export_RC_TYP.spef

    #signoff timing analysis

    time_design    \
        -sign_off                               \
        -report_only                            \
        -report_prefix $prefix                  \
        -path_report                            \
        -drv_report                             \
        -slack_report                           \
        -num_paths 500                          \
        -report_dir $iv::reportDir           \
        -timing_debug_report

    time_design    \
        -sign_off                               \
        -hold                                   \
        -report_only                            \
        -report_prefix $prefix                  \
        -path_report                            \
        -slack_report                           \
        -num_paths 500                          \
        -report_dir $iv::reportDir            \
        -timing_debug_report

}
proc signoff_qrc {prefix} {



    if {[file exists "../../input/qrc.map"] == 0} {
        puts "ERROR signoff_qrc. qrc.map doesn't exist. Cannot continue."
        return ""
    }

    ### Runs signoff timing analysis using extraction (Quantus QRC) and Tempus in batch mode, and generates timing reports and ECO DB for each view. The command prints out a timing summary table per view and all the views combined.
    ### NOTE this file is calling the qrc.map file specified by setExtractRCMode

    #  signoff extraction
    set_db extract_rc_use_qrc_oa_interface true		
    set_db extract_rc_engine post_route
    set_db extract_rc_effort_level signoff		
    set_db extract_rc_coupled true
    set_db extract_rc_lef_tech_file_map "../../input/qrc.map"

    extract_rc

    write_parasitics -rc_corner RC_BEST  -spef_file $iv::OutDir/export_signoff_RC_BEST.spef
    write_parasitics -rc_corner RC_WORST -spef_file $iv::OutDir/export_signoff_RC_WORST.spef
    write_parasitics -rc_corner RC_TYP   -spef_file $iv::OutDir/export_signoff_RC_TYP.spef

    # signoff timing analysis using TEMPUS (engine AAE)
    eval_legacy { setInputTransitionDelay 100.0ps }
    eval_legacy { setDefaultLoadForAllNet 0.1pf }

    ## Delay Mode
    eval_legacy { setDelayCalMode -engine aae } ;# Default : true
    set_db delaycal_enable_si true ;# Default : false
    set_db delaycal_equivalent_waveform_model propagation; # Default : none

    ## SI settings
    set_db si_delay_separate_on_data true ;# Default : false
    set_db si_delay_delta_annotation_mode lumpedOnNet ;# Default : arc
    set_db si_delay_delta_threshold 1e-12 ;# Default : -1
    eval_legacy { setSIMode -use_si_slew_for_delay true } ;# Default : false
    set_db si_enable_glitch_propagation true ;# Default : false
    set_db opt_post_route_report_si_transitions true  ;# Default : false
    set_db timing_enable_si_cppr true  ;# Default : true
    set_db timing_cppr_transition_sense same_transition_expanded ;# Default : normal

    ## STA globals
    set_db timing_case_analysis_for_icg_propagation always  ;# Default : false
    set_db timing_analysis_cppr both  ;# equivalent to legacy timing_remove_clock_reconvergence_pessimism Default : none
    set_db timing_report_unconstrained_paths true  ;# Default : false

    ## Only for signoff STA (will impact runtime for optimisation)
    set_db si_delay_enable_double_clocking_check true  ;# Default : false
    set_db si_glitch_enable_report true  ;# Default : false
    set_db si_delay_enable_report true   ;# Default : false
    set_db timing_cppr_threshold_ps 0    ;# Default : 20

    set_db delaycal_enable_si true
    eval_legacy { setDelayCalMode -siAware true -engine aae -mode signoff }

    time_design    \
        -sign_off                                \
        -expanded_views                          \
        -report_prefix $prefix                   \
        -path_report                             \
        -drv_report                              \
        -slack_report                            \
        -num_paths 500                           \
        -report_dir $iv::reportDir             \
        -timing_debug_report -report_only

    time_design    \
        -sign_off                                \
        -hold                                    \
        -expanded_views                          \
        -report_prefix $prefix                   \
        -path_report                             \
        -slack_report                            \
        -num_paths 500                           \
        -report_dir $iv::reportDir             \
        -timing_debug_report -report_only

}
#@ End verbose source ../scripts/signoff_timing_analysis.tcl
set_analysis_view \
		-setup {  av_normal_max   av_normal_typ     av_normal_min   av_normal_min_lt }  \
		-hold  {  av_normal_min   av_normal_min_lt  av_normal_typ   av_normal_max}
signoff_qrc "Signoff_Final"
report_rc_factors   \
    -pre_route true                          \
    -post_route medium                       \
    -reference signoff                       \
    -out_file $iv::OutDir/RC_factors.tcl
delete_drc_markers
check_drc -out_file $iv::reportDir/checks.verifyGeometry.rpt
check_connectivity -type all -out_file $iv::reportDir/checks.connectivity.rpt
check_process_antenna -out_file $iv::reportDir/checks.antenna.rpt
check_legacy_design -all -out_dir $iv::reportDir/export
write_netlist $iv::reportDir/export.v
#@ End verbose source ../scripts/6_checks.tcl
#@ source ../scripts/7_export.tcl
#@ Begin verbose source ../scripts/7_export.tcl (pre)
#@ source ../scripts/makePins.tcl
#@ Begin verbose source ../scripts/makePins.tcl (pre)
proc make_pins_core { }  {
    global vars
    foreach pgnet [get_db pg_nets] {
        set pg_stripe [lindex  [get_db $pgnet .special_wires -if { .shape == stripe || .shape == ring || .shape == corewire} ] {0} ]
        if { $pg_stripe != "" } {
            set pg_x [get_db $pg_stripe .polygon.bbox.ll.x ]
            set pg_y [get_db $pg_stripe .polygon.bbox.ll.y ]
            set pg_L [get_db $pg_stripe .layer.name ]
            puts "Creating OA label for PG net:  [get_db $pgnet .name]"
            create_pg_pin \
                -name [get_db $pgnet .name] \
                -net [get_db $pgnet .name]  \
                -geometry $pg_L $pg_x $pg_y [expr $pg_x+1.0] [expr $pg_y+1.0]
            create_text \
                -point $pg_x $pg_y \
                -label [get_db $pgnet .name]\
                -orient R0 \
                -layer $pg_L \
                -oa_purpose drawing \
		        -height 0.1
        }
    }
    foreach p [get_db ports] {
        set edge [get_db $p .pin_edge]
        if {$edge == 0} { set orient R0 }
        if {$edge == 1} { set orient R90 }
        if {$edge == 2} { set orient R180 }
        if {$edge == 3} { set orient R270 }
        puts "Creating OA label for signal net: [string map { [ < ] > } [join [get_db $p .name]]]"
        create_text \
            -point [get_db $p .location.x ] [get_db $p .location.y ] \
            -label [string map { [ < ] > } [join [get_db $p .name]]] \
            -orient $orient \
            -layer [get_db $p .layer.name] \
            -oa_purpose drawing \
	        -height 0.1
    }
}
proc make_pins_bumps { }  {
    global vars
    foreach pgnet [concat $vars(VDD,pin) $vars(GND,pin) ] {
        create_pg_pin -name $pgnet -net $pgnet
    }

    foreach bump [get_db bumps] {
        puts [concat "-> Creating label and pin for IO bump \[" [get_db $bump .name] "\] net \[" [get_db $bump .net.name] "\]"]

        if { ! ([get_db $bump .net.name] in [concat $vars(VDD,pin) $vars(GND,pin) ] ) } {
            edit_pin \
                -fixed_pin 1 -layer AP  \
                -assign  [list [get_db $bump .center.x] [get_db $bump .center.y] ] \
                -snap mgrid -pin_depth 0.1 -pin_width  0.1 \
                -side inside -fix_overlap false -honor_constraint false     \
                -pin  [get_db $bump .net.name]
        }

        create_text \
            -point [get_db $bump .center.x] [get_db $bump .center.y] \
            -label [string map { [ < ] > } [join [get_db $bump .net.name] ]] \
            -orient R0 -layer AP -height 10 \
            -oa_purpose drawing \
	        -height 0.1
    }
}
#@ End verbose source ../scripts/makePins.tcl
create_pg_pin -name $iv::PWR_name -net $iv::PWR_name
create_pg_pin -name $iv::GND_name -net $iv::GND_name
make_pins_core
write_netlist $iv::OutDir/$TOPCELL.funct.v
write_netlist $iv::OutDir/$TOPCELL.functpg.v -include_pg_ports 
write_sdf  \
        -edges check_edge               \
        -min_view      av_normal_min_lt \
        -max_view      av_normal_max    \
        -typical_view  av_normal_typ    \
        $iv::OutDir/$TOPCELL.funct.sdf  \
        -recompute_delaycal
write_netlist \
    $iv::OutDir/$TOPCELL.lvs.v                                \
    -exclude_leaf_cells                                \
    -include_pg_ports                                  \
    -include_phys_cells $vars(cell,decaps)		\
    -exclude_insts_of_cells $vars(cell,filler_nosch)
catch {exec v2lvs -v $iv::OutDir/$TOPCELL.lvs.v -o $iv::OutDir/$TOPCELL.lvs.spi -l $iv::VERILOG_SUBCKT -s $iv::SPICE_SUBCKT -s0 DVSS -s1 DVDD -w 2 -a<>}
write_netlist \
    $iv::OutDir/$TOPCELL.phys.v   \
    -phys                         \
    -omit_floating_ports          \
    -include_pg_ports             \
    -exclude_leaf_cells
delete_drc_markers
delete_place_halo -all_blocks
delete_route_blockages -type all
delete_route_halos -all_blocks
catch {exec rm -fvr $TOPCELL }
catch {create_oa_lib $TOPCELL -oa_reference_tech_libs $iv::OAPHYS }
set f [open ./../scripts/ihdlParamFile_stock]
set lines [split [read $f] "\n"]
close $f
lset lines 0 "dest_sch_lib := $TOPCELL "
lset lines 1 "ref_lib_list := basic, US_8ths, $iv::OAPHYS"
lset lines 2 "schematic_view_name := schematic"
lset lines 3 "symbol_view_name := symbol"
lset lines 4 "log_file_name := verilogIn.log"
lset lines 5 "map_file_name := verilogIn.map.table"
lset lines 6 "power_net := \\$iv::PWR_name!"
lset lines 7 "ground_net := \\$iv::GND_name!"
lset lines 8 "import_if_exists := 1"
lset lines 9 "max_net_name_length := 100000"
set f [open ihdlParamFile w]
puts -nonewline $f [join $lines "\n"]
close $f
unset lines
puts "Making final virtuoso schematic view. (check verilogIn.log for details)"
catch {exec rm -rvf $TOPCELL/$TOPCELL/symbol}
catch {exec rm -rvf $TOPCELL/$TOPCELL/schematic}
catch {exec rm -rvf $TOPCELL/$TOPCELL/functional}
catch {exec ihdl +DUMB_SCH -PARAM ./ihdlParamFile $iv::OutDir/$TOPCELL.lvs.v}
puts "Schematic, symbol and functional views were generated."
puts "Making final virtuoso abstract view... "
catch {exec rm -rvf $TOPCELL/$TOPCELL/abstract}
write_oa  \
    $TOPCELL $TOPCELL abstract \
    -auto_remaster                           \
    -oa_leaf_views [list "abstract"]
puts "Making final virtuoso layout view... "
catch {exec rm -rvf $TOPCELL/$TOPCELL/layout}
write_oa  \
    $TOPCELL $TOPCELL layout \
    -auto_remaster                           \
    -oa_ref_libs [list "$iv::OAPHYS" "$iv::OAPHYSTECH"]	\
    -oa_leaf_views [list "layout"]
puts "Layout generated."
set lines [list]
lset lines 0 "load(\"../scripts/virtuoso_postprocess.il\")"
lset lines 1 "drawDMEXCL(\"${TOPCELL}\" \"${TOPCELL}\" \"layout\")"
lset lines 2 "changeLabelPurposeToPin(\"${TOPCELL}\" \"${TOPCELL}\" \"layout\")"
lset lines 3 "exit"
set f [open fixlayout_runtime.il w]
puts -nonewline $f [join $lines "\n"]
close $f
unset lines
catch {exec virtuoso -nograph -log fixlayout_runtime.log -replay fixlayout_runtime.il}
#@ End verbose source ../scripts/7_export.tcl
gui_show
#@ End verbose source: ../scripts/run_all.tcl
exit
