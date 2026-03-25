# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: addMetalFill.tcl

############################################################################
delete_metal_fill -shapes { FILLWIRE FILLWIREOPC } -modes all

#set box [split [join [dbGet top.fPlan.corebox]]]
set box [split [join [eval_legacy {dbGet top.fPlan.corebox}]]]
set ne [lindex $box 0]
set nw [lindex $box 1]
set se [lindex $box 2]
set sw [lindex $box 3]

#setMetalFill -layer 6 -minDensity 27.00
#setMetalFill -layer 7 -minDensity 23.00

set_metal_fill -layer 8 -min_width 2 -min_length 2 -active_spacing 3 -gap_spacing 2.5
set_metal_fill -layer 9 -min_width 3 -min_length 3 -active_spacing 3 -gap_spacing 2.5
set_metal_fill -layer 10 -min_width 3 -min_length 3 -active_spacing 3 -gap_spacing 2.5

#addMetalFill -layer { 1 2 3 4 5 6 7 } -area $ne $nw $se $sw -onCells
add_metal_fill -area $ne $nw $se $sw -on_cell -layers { 1 2 3 4 5 6 7 8 9 10 } -stagger on -square_shape -timing_aware on > $iv::reportDir/route.addMetalFill.rpt

# Specific to TSMC 65 1p9m 6x1z1u using tcbn65gplus_oa_* libraries:
# add_metal_fill creates a "special wire" type with shape="fillwire".  
# Shape attributed needs to be set to "corewire" for it to show up as a drawing layer in the tsmc65digital OA tech.
#select_obj [get_db current_design .nets.special_wires]
set_db current_design .nets.special_wires.shape corewire
