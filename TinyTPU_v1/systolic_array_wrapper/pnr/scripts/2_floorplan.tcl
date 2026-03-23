# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: 2_floorplan.tcl

###############################################################################
# Creating Floorplan
###############################################################################

# The name "CoreSite" or "core" may change depending on the OA tech.  To see the name, generate an abstract view of a std cell.
create_floorplan \
	-site "core" \
    	-die_size [list $vars(fp,width) $vars(fp,height) $vars(fp,io_core_space) $vars(fp,io_core_space) $vars(fp,io_core_space) $vars(fp,io_core_space)]

gui_fit

if {$vars(cell,tieHiLo) != ""} {
    set_db add_tieoffs_max_distance 20 ;
    set_db add_tieoffs_cells $vars(cell,tieHiLo)
}

###############################################################################
# READ IO FILE
###############################################################################
read_io_file ../../input/pins.io
set box [split [join [get_db current_design .core_bbox.]]]
set x1 [lindex $box 0]
set y1 [lindex $box 1]
set x2 [lindex $box 2]
set y2 [lindex $box 3]

###############################################################################
# POWER ROUTING and CONNECTION
###############################################################################
#### Create options for the ring
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

# Create the ring, Top and Bottom in M5, Left and Right in M4
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

### sroute: Routes power structures.
route_special -connect {core_pin}  \
    -allow_layer_change 0  \
    -allow_jogging 1 \
    -floating_stripe_target ring

###############################################################################
# DRC CHECK
# #############################################################################
delete_drc_markers
check_drc -out_file $iv::reportDir/fp.verifyGeometry.rpt




