# project_setup_ab.tcl
# Combined SRAM A+B wrapper (sram_wrapper_ab)
# Same width as single sram_wrapper (~155um), ~2x height (~360 rows)

namespace eval gn {}
namespace eval iv {}

#####################################################################
# Path Information
#####################################################################
set gn::RTLDir          ../../input/RTL/
set gn::SDCDir          ../../input/SDC/
set gn::OutDir          ../output
set gn::reportDir       ../report
set iv::OutDir          ../output
set iv::reportDir       ../report

#####################################################################
# Tool Variables
#####################################################################
set gn::SYN_EFFORT      medium
set gn::MAP_EFFORT      high
set gn::INCR_EFFORT     high
set gn::SUPPRESS_MSG    {LBR-30 LBR-31 VLOGPT-35}

#####################################################################
# Project Information, Synthesis
#####################################################################
set TOPCELL             bus_slave_sram_ab
set vars(std_height)    1.8

set gn::VERILOG_LIST    [list "bus_slave_ab.sv" "sram_wrapper_ab.sv" "bus_slave_sram_ab.sv"]
set gn::SDC_LIST        [glob ${gn::SDCDir}*.sdc]
set iv::node            65

#####################################################################
# Project Information, Floorplanning
# Same width as single sram_wrapper (155um), ~2x height (360 rows)
#####################################################################
set iv::TEMPUS_ENGINE   0
set iv::INCR_OPT        0
set iv::PWR_name        DVDD
set iv::GND_name        DVSS
set iv::PWR_libname     VDD
set iv::GND_libname     VSS

#### ring parameters (same as single wrapper) ####
set vars(ring,top_layer)        7
set vars(ring,bottom_layer)     7
set vars(ring,left_layer)       6
set vars(ring,right_layer)      6
set vars(ring,top_width)        1.8
set vars(ring,bottom_width)     1.8
set vars(ring,left_width)       1.8
set vars(ring,right_width)      1.8
set vars(ring,top_space)        0.8
set vars(ring,bottom_space)     0.8
set vars(ring,left_space)       0.8
set vars(ring,right_space)      0.8
set vars(ring,top_offset)       0.8
set vars(ring,bottom_offset)    0.8
set vars(ring,left_offset)      0.8
set vars(ring,right_offset)     0.8

#### stripes ####
set vars(stripe,dir)            vertical
set vars(stripe,space)          0.8
set vars(stripe,metal)          6
set vars(stripe,width)          1.8
set vars(stripe,setdist)        60

#### horizontal stripes ####
set vars(hstripe,metal)         5
set vars(hstripe,space)         1
set vars(hstripe,width)         1.3
set vars(hstripe,setdist)       [expr {32*$vars(std_height)}]

#### die dimensions ####
# Same width as single wrapper; ~2x height (360 rows vs 180 rows)
set vars(fp,width)              176.6
set vars(fp,height)             [expr {360 * $vars(std_height)}]
set vars(fp,io_core_space)      [expr { ($vars(ring,left_width)*2)+$vars(ring,left_offset)*2 + 0.4}]

### Special cells
set vars(cell,decaps)   "DCAP64 DCAP32 DCAP16 DCAP8 DCAP4"
set vars(cell,welltap)  ""
set vars(cell,welltap,gap) ""
set vars(cell,tieHiLo)  "TIEH TIEL"
set vars(cell,filler)   "DCAP64 DCAP32 DCAP16 DCAP8 DCAP4 FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
set vars(cell,filler_nosch) "FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
set vars(cell,antenna)  "ANTENNA"

set iv::TMRDIST         25
set iv::data_bottom_routing_layer   1
set iv::data_top_routing_layer      6

#####################################################################
# Clock Tree Synthesis
#####################################################################
set vars(cell,clk_bufs) {CKBD1 CKBD12 CKBD16 CKBD2 CKBD20 CKBD24 CKBD3 CKBD4 CKBD6 CKBD8}
set vars(cell,clk_invs) {CKND1 CKND12 CKND16 CKND2 CKND20 CKND24 CKND3 CKND4 CKND6 CKND8}
set iv::clk_bottom_routing_layer    2
set iv::clk_top_routing_layer       7
set iv::clk_maxfanout               20
set iv::clk_maxcap                  10pf
set iv::setup_target_slack          1
set iv::hold_target_slack           0.5

#####################################################################
# PDK Information
#####################################################################
set env(SRAM_DIR) "../../../SRAM00_gen"
set env(PDK_PATH)     "/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/Base_PDK/PDK_CRN65GP_v1.0c_official_IC61_20101010"
set env(PDK_DIGITAL)  "/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/digital"

set SRAM_DIR        $env(SRAM_DIR)
set PDK_PATH        $env(PDK_PATH)
set PDK_DIGITAL     $env(PDK_DIGITAL)

set gn::NLDMLIB [list \
    "$PDK_DIGITAL/Front_End/timing_power_noise/NLDM/tcbn65gplus_200a/tcbn65gpluswc.lib" \
    "$SRAM_DIR/sram00_nldm_ss_0p90v_0p90v_125c_syn.lib" ]

#####################################################################
# PDK Information, Place & Route
#####################################################################
set iv::OALIB           [list "tcbn65gplus_oalib" "sram00_oalib"]
set iv::OALIB_COSTUM    [list "sram00_oalib"]
set iv::OATECH          "tcbn65gplus_oalib"
set iv::OAPHYS          "tcbn65gplus"
set iv::OAPHYSTECH      "tsmcN65"
set iv::VERILOG_SUBCKT  "$PDK_DIGITAL/Front_End/verilog/tcbn65gplus_200a/tcbn65gplus_pwr.v"
set iv::SPICE_SUBCKT    "$PDK_DIGITAL/Back_End/spice/tcbn65gplus_200a/tcbn65gplus_200a.spi"

#####################################################################
# SRAM Hard Macro Paths (two sram00 instances: u_sram_a and u_sram_b)
#####################################################################
set iv::SRAM_LEF        "$SRAM_DIR/sram00.vclef"
set iv::SRAM_GDS        "$SRAM_DIR/sram00.gds2"
set iv::SRAM_CDL        "$SRAM_DIR/sram00.cdl"

set iv::SRAM_LIB_TYP    "$SRAM_DIR/sram00_nldm_tt_1p00v_1p00v_25c_syn.lib"
set iv::SRAM_LIB_MIN    "$SRAM_DIR/sram00_nldm_ff_1p10v_1p10v_0c_syn.lib"
set iv::SRAM_LIB_MIN_LT "$SRAM_DIR/sram00_nldm_ff_1p10v_1p10v_m40c_syn.lib"
set iv::SRAM_LIB_MAX    "$SRAM_DIR/sram00_nldm_ss_0p90v_0p90v_125c_syn.lib"

set iv::BLACKBOX_LIST {sram00}
set iv::MACRO_V_LIST [list "$SRAM_DIR/sram00.v"]

###############################################################################
# HARD MACRO PLACEMENT
# sram00 actual dims R0: W=312.26um, H=128.765um
#
# Two sram00 instances stacked vertically:
#   u_sram_a: bottom (SRAM A), R90 orientation
#   u_sram_b: top    (SRAM B), R90 orientation, offset by ~H+margin
#
# With R90: placed width becomes 128.765um, placed height becomes 312.26um
# Both fit within fp,width=155um
###############################################################################
set vars(fp,io_core_space) [expr { ($vars(ring,left_width)*2)+$vars(ring,left_offset)*2 + 0.4}]

# SRAM A — bottom half
set vars(sram_a,inst_name)  "u_sram_a"
set vars(sram_a,x)          $vars(fp,io_core_space)
set vars(sram_a,y)          $vars(fp,io_core_space)
set vars(sram_a,orient)     "R90"

# SRAM B — top half (offset by sram_a placed height + small margin)
set vars(sram_b,inst_name)  "u_sram_b"
set vars(sram_b,x)          $vars(fp,io_core_space)
set vars(sram_b,y)          [expr {$vars(fp,io_core_space) + 312.26 + 5.0}]
set vars(sram_b,orient)     "R90"
