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
    	-die_size [list $vars(fp,width) $vars(fp,height) $vars(fp,io_core_space) $vars(fp,io_core_space) $vars(fp,io_core_space)/2 $vars(fp,io_core_space)]\
    -flip s
gui_fit

set_db [get_db insts $vars(sram,inst_name)] .dont_touch true
set_db [get_db insts $vars(sram,inst_name)] .place_status fixed


if {$vars(cell,tieHiLo) != ""} {
    set_db add_tieoffs_max_distance 20 ;
    set_db add_tieoffs_cells $vars(cell,tieHiLo)
}

###############################################################################
# HARD MACRO PLACEMENT
###############################################################################
# Place SRAM at fixed location in core area
# Adjust coordinates based on actual SRAM dimensions from LEF
place_inst $vars(sram,inst_name) \
    $vars(sram,x) $vars(sram,y) $vars(sram,orient) -fixed

# Confirm actual bbox after rotation
set sram_bbox [get_db [get_db insts $vars(sram,inst_name)] .bbox]
puts "INFO: SRAM placed at $sram_bbox"
puts "INFO: SRAM OBS (M1-M4+VIA1-3) loaded from LEF, no manual blockage needed"


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


set overlap [expr {$vars(ring,right_offset) + $vars(ring,right_width)}]  ;# overlap
update_floorplan \
    -core_to_right  [expr {$vars(fp,io_core_space) - $overlap}] \


# Vertical stripes (M6)
add_stripes \
    -direction $vars(stripe,dir) \
    -spacing   $vars(stripe,space) \
    -layer     M$vars(stripe,metal) \
    -width     $vars(stripe,width) \
    -nets      "$iv::GND_name $iv::PWR_name" \
    -create_pins 1 \
    -start_from left \
    -start_offset [expr {$vars(stripe,setdist) / 2.0}] \
    -set_to_set_distance $vars(stripe,setdist)

# Horizontal stripes (M7): forms the grid with vertical stripes
add_stripes \
    -direction horizontal \
    -spacing   $vars(hstripe,space) \
    -layer     M$vars(hstripe,metal) \
    -width     $vars(hstripe,width) \
    -nets      "$iv::GND_name $iv::PWR_name" \
    -create_pins 1 \
    -start_from bottom \
    -start_offset [expr {$vars(hstripe,setdist) / 4.0 -0.9}] \
    -set_to_set_distance $vars(hstripe,setdist)

create_place_halo \
    -insts  $vars(sram,inst_name)\
    -halo_deltas {0 0 3 0}

# finish_floorplan -add_halo 5 -halo_inst $vars(sram,inst_name)

### sroute: Routes power structures.
# route_special -connect {core_pin pad_ring}  \
#     -allow_layer_change 0  \
#     -allow_jogging 1 \
#     -floating_stripe_target ring

# # Connect SRAM power pins to ring
# route_special -connect {block_pin} \
#     -block_pin_target {ring stripe} \
#     -nets "$iv::PWR_name $iv::GND_name"

route_special \
    -connect {core_pin block_pin} \
    -block_pin_target {ring stripe}\
    -nets "$iv::PWR_name $iv::GND_name" \
    -block_pin all \
    -allow_layer_change 0 \
    -allow_jogging 0 \

###############################################################################
# DRC CHECK
# #############################################################################
delete_drc_markers
check_drc -out_file $iv::reportDir/fp.verifyGeometry.rpt




