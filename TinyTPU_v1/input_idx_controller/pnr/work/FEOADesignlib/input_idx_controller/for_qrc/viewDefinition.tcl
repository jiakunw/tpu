if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name libs_typ\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tcbn65gplustc.lib]\
   -si\
    [list ${::IMEX::libVar}/mmmc/tcbn65gplustc.cdb]
create_library_set -name libs_min_lt\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tcbn65gpluslt.lib]\
   -si\
    [list ${::IMEX::libVar}/mmmc/tcbn65gpluslt.cdb]
create_library_set -name libs_min\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tcbn65gplusbc.lib]\
   -si\
    [list ${::IMEX::libVar}/mmmc/tcbn65gplusbc.cdb]
create_library_set -name libs_max\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tcbn65gpluswc.lib]\
   -si\
    [list ${::IMEX::libVar}/mmmc/tcbn65gpluswc.cdb]
create_opcond -name oc_typ -process 1 -voltage 1 -temperature 25
create_opcond -name oc_min_lt -process 1 -voltage 1.1 -temperature -40
create_opcond -name oc_min -process 1 -voltage 1.1 -temperature 0
create_opcond -name oc_max -process 1 -voltage 0.9 -temperature 125
create_timing_condition -name tc_min_lt\
   -library_sets [list libs_min_lt]\
   -opcond oc_min_lt
create_timing_condition -name tc_typ\
   -library_sets [list libs_typ]\
   -opcond oc_typ
create_timing_condition -name tc_min\
   -library_sets [list libs_min]\
   -opcond oc_min
create_timing_condition -name tc_max\
   -library_sets [list libs_max]\
   -opcond oc_max
create_rc_corner -name RC_BEST\
   -pre_route_res 1\
   -post_route_res {1 1 1}\
   -pre_route_cap 1\
   -post_route_cap {1 1 1}\
   -post_route_cross_cap {1 1 1}\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -qrc_tech ${::IMEX::libVar}/mmmc/RC_BEST/qrcTechFile
create_rc_corner -name RC_TYP\
   -pre_route_res 1\
   -post_route_res {1 1 1}\
   -pre_route_cap 1\
   -post_route_cap {1 1 1}\
   -post_route_cross_cap {1 1 1}\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -qrc_tech ${::IMEX::libVar}/mmmc/RC_TYP/qrcTechFile
create_rc_corner -name RC_WORST\
   -pre_route_res 1\
   -post_route_res {1 1 1}\
   -pre_route_cap 1\
   -post_route_cap {1 1 1}\
   -post_route_cross_cap {1 1 1}\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -qrc_tech ${::IMEX::libVar}/mmmc/RC_WORST/qrcTechFile
create_delay_corner -name dc_min\
   -timing_condition {tc_min}\
   -rc_corner RC_BEST
create_delay_corner -name dc_min_lt\
   -timing_condition {tc_min_lt}\
   -rc_corner RC_BEST
create_delay_corner -name dc_max\
   -timing_condition {tc_max}\
   -rc_corner RC_WORST
create_delay_corner -name dc_typ\
   -timing_condition {tc_typ}\
   -rc_corner RC_TYP
create_constraint_mode -name mode_normal\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/mode_normal/mode_normal.sdc]
create_analysis_view -name av_normal_typ -constraint_mode mode_normal -delay_corner dc_typ -latency_file ${::IMEX::dataVar}/mmmc/views/av_normal_typ/latency.sdc
create_analysis_view -name av_normal_min -constraint_mode mode_normal -delay_corner dc_min -latency_file ${::IMEX::dataVar}/mmmc/views/av_normal_min/latency.sdc
create_analysis_view -name av_normal_min_lt -constraint_mode mode_normal -delay_corner dc_min_lt -latency_file ${::IMEX::dataVar}/mmmc/views/av_normal_min_lt/latency.sdc
create_analysis_view -name av_normal_max -constraint_mode mode_normal -delay_corner dc_max -latency_file ${::IMEX::dataVar}/mmmc/views/av_normal_max/latency.sdc
set_analysis_view -setup [list av_normal_max av_normal_typ av_normal_min av_normal_min_lt] -hold [list av_normal_min av_normal_min_lt av_normal_typ av_normal_max]
catch {set_interactive_constraint_mode [list mode_normal] } 
