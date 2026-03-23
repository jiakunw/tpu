# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: 1_import.tcl

#### Copying cds.lib in the working directory
catch { exec rm cds.lib }
file copy  ../../input/project.lib ./cds.lib

################################################################################
# GLOBAL SETTINGS
################################################################################
set_db design_process_node $iv::node
set_multi_cpu_usage -no_cpu_auto_adjustment true -local_cpu 8 -keep_license true
set_db timing_report_fields {hpin cell delay required arrival edge user_derate transition load}

#### Set this global to allow set_input_delay assertion to have an effect on clock source paths beginning at the clock root
set_db timing_allow_input_delay_on_clock_source false
set_db write_def_hierarchy_delimiter {/}
#set_db init_lef_files $gn::LEFLIB
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
#set_db init_oa_default_rule "LEFDefaultRouteSpec_DFM"

read_mmmc ../../input/mmmc.tcl

################################################################################
# INIT DESIGN
################################################################################
#### Initializes a design using the Tcl globals.
#read_physical -lefs $gn::LEFLIB
#read_physical -oa_ref_libs $iv::OALIB 
read_physical -oa_ref_libs $iv::OALIB -oa_tech_lib $iv::OATECH

read_netlist ../../syn/output/$TOPCELL.syn.v

init_design
#### Fits the entire design in the viewable window. You can use this command at any stage of the design flow to view the design in entirety
gui_fit

### Sets the view to floorplan view. This view displays the hierarchical module and block guides, connection flightlines, and floorplan objects, including block placement, and power and ground nets.
gui_set_draw_view fplan

source ../../input/user_timing_derating.tcl

################################################################################
# POWER GROUND CONNECT
################################################################################
connect_global_net $iv::PWR_name -type pg_pin -pin_base_name $iv::PWR_libname -inst *
connect_global_net $iv::GND_name -type pg_pin -pin_base_name $iv::GND_libname -inst *
#connect_global_net $vars(A_PWR,net_name) -type pg_pin -pin_base_name $vars(A_PWR,pin_name) -inst *
#connect_global_net $vars(A_GND,net_name) -type pg_pin -pin_base_name $vars(A_GND,pin_name) -inst *
connect_global_net $iv::PWR_name -type tiehi
connect_global_net $iv::GND_name -type tielo

