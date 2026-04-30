
## This procedure creates PG pins and labels for sub-blocks and wirebonded designs
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


### This procedure creates bumps 
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
