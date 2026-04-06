# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# project_setup.tcl

# Tested on tsmc65gplus 1p9m6x1z1u
# Tested on Cadence Genus, Innovus, Tempus, Voltus versions 20.1
# All paths are relative to the syn/work (for Genus) or pnr/work (for Innovus) directory
# Requires the following environment variables: $PDK_PATH, $PDK_DIGITAL, $CDSHOME

# This set of scripts has been tested with the following tools:
# IC 6.1.8-64b.500.22
# GENUS 21.16-s062_1
# INNOVUS v21.16-s078_1
# QUANTUS 21.2.2-p045
# TEMPUS v21.16-s080_1
# VOLTUS v21.16-s080_1


# namespace for Genus operations.  Syntehsis.
namespace eval gn {}	
# namespace for innovus operations.  Place&Route.  Some variables from gn namespace may be used in innovus flow if shared.
namespace eval iv {}	

#####################################################################
# Path Information (do not change this)
#####################################################################
set gn::RTLDir		../../input/RTL/
set gn::SDCDir		../../input/SDC/
set gn::OutDir		../output
set gn::reportDir	../report
set iv::OutDir		../output
set iv::reportDir	../report
#####################################################################
# Tool Variables
#####################################################################
set gn::SYN_EFFORT	medium
set gn::MAP_EFFORT	high
set gn::INCR_EFFORT	high
# IF any Genus messages annoy you, add it here
set gn::SUPPRESS_MSG	{LBR-30 LBR-31 VLOGPT-35}


#####################################################################
# Project Information, Synthesis
#####################################################################
# Replace this with the name of your topcell
set TOPCELL	  sram_wrapper_c
set vars(std_height)      1.8
# List of HDL files
set gn::VERILOG_LIST	[list "sram_wrapper_c.sv"]	
set gn::SDC_LIST	[list "sram_wrapper_c.sdc"]
# Tech node, in nm
set iv::node		65

#####################################################################
# Project Information, Floorplanning
#####################################################################
# Use Tempus engine?  More accurate for long wires
set iv::TEMPUS_ENGINE	0
# Incremental optimization?
set iv::INCR_OPT	0
# Power and ground net names as they should be implemented in your design
set iv::PWR_name	DVDD
set iv::GND_name	DVSS
# Power and ground pin names as they are in the digital std cell lib
set iv::PWR_libname	VDD
set iv::GND_libname	VSS
#### ring parameters ####
# metal layer
set vars(ring,top_layer)        7  
set vars(ring,bottom_layer)     7  
set vars(ring,left_layer)       6  
set vars(ring,right_layer)      6  
# width
set vars(ring,top_width)        1.8
set vars(ring,bottom_width)     1.8
set vars(ring,left_width)       1.8
set vars(ring,right_width)      1.8
# spacing
set vars(ring,top_space)        0.8
set vars(ring,bottom_space)     0.8
set vars(ring,left_space)       0.8
set vars(ring,right_space)      0.8
# offset
set vars(ring,top_offset)       0.8
set vars(ring,bottom_offset)    0.8
set vars(ring,left_offset)      0.8
set vars(ring,right_offset)     0.8
#### stripes parameters ####
# stripes direction
set vars(stripe,dir)     vertical  
# stripes spacing between VDD and GND
set vars(stripe,space)          0.8
# stripes metal layer
set vars(stripe,metal)          6
# stripes width
set vars(stripe,width)         1.8
# Stripes set distance
# set vars(stripe,setdist)	360
#set vars(stripe,setdist)	[expr { ($vars(fp,width)/2)-$vars(stripe,width)-0.5*$vars(stripe,space)-$vars(fp,io_core_space) }]
# This prevents an additional stripe at the right most edge
# set vars(stripe,setdist)	[expr { (($vars(fp,width))-$vars(stripe,width)-0.5*$vars(stripe,space)-0.5*$vars(fp,io_core_space))/3 }]
set vars(stripe,setdist)	30 ;#fix distance across design
#### horizontal stripes parameters (M7) ####
# metal layer for horizontal stripes
set vars(hstripe,metal)         7
# spacing between VDD and GND horizontal stripes
set vars(hstripe,space)         1
# width of horizontal stripes
set vars(hstripe,width)         1.3
# set-to-set distance for horizontal stripes
set vars(hstripe,setdist)      [expr {16*$vars(std_height)}]

#### die dimensions ####
set vars(fp,width)         [expr {180 * $vars(std_height)}]
set vars(fp,height)        [expr {85 * $vars(std_height)}]
set vars(fp,io_core_space)   [expr { ($vars(ring,left_width)*2)+$vars(ring,left_offset)*2 + 0.4}]
### Special cells
set vars(cell,decaps) "DCAP64 DCAP32 DCAP16 DCAP8 DCAP4"
set vars(cell,welltap) ""
set vars(cell,welltap,gap) ""
set vars(cell,tieHiLo) "TIEH TIEL"
#set vars(cell,filler) "FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
set vars(cell,filler) "DCAP64 DCAP32 DCAP16 DCAP8 DCAP4 FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
# do not export these cells into the schematic
set vars(cell,filler_nosch) "FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
set vars(cell,antenna) "ANTENNA"
# Special treatment for triple-majority voters, microns of separation between same TMR group.  Registers must be named with TMR1*, TMR2, and TMR3*
set iv::TMRDIST		25
# Routing variables
set iv::data_bottom_routing_layer	1
set iv::data_top_routing_layer		6
#####################################################################
# Project Information, Clock Tree Synthesis
#####################################################################
set vars(cell,clk_bufs) {CKBD1 CKBD12 CKBD16 CKBD2 CKBD20 CKBD24 CKBD3 CKBD4 CKBD6 CKBD8}
set vars(cell,clk_invs) {CKND1 CKND12 CKND16 CKND2 CKND20 CKND24 CKND3 CKND4 CKND6 CKND8}
set iv::clk_bottom_routing_layer	2
set iv::clk_top_routing_layer		7
set iv::clk_maxfanout			20
set iv::clk_maxcap			10pf
# Target setup and hold slack, in nS
############# SRAM CONSTRAINT
set iv::setup_target_slack		1   
set iv::hold_target_slack		0.5
#############

#####################################################################
# PDK Information, Synthesis Only
#####################################################################
# Where possible, provide worst case corners.  Synthesis should always be done on the worst corner.
# See mmmc.tcl for library setup for innovus
# See user_timing_derating.tcl for user customization
# Grab from environment variable
# set PDK_PATH		$env(PDK_PATH)	
# set PDK_DIGITAL		$env(PDK_DIGITAL)	
set env(SRAM_DIR) "../../../SRAM00_gen"
set env(PDK_PATH)		"/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/Base_PDK/PDK_CRN65GP_v1.0c_official_IC61_20101010"
set env(PDK_DIGITAL)		"/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/digital"

set SRAM_DIR       $env(SRAM_DIR)
set PDK_PATH		$env(PDK_PATH)	
set PDK_DIGITAL	 $env(PDK_DIGITAL)	

# List of NLDM libraries of all std cell libraries to be used
set gn::NLDMLIB [list "$PDK_DIGITAL/Front_End/timing_power_noise/NLDM/tcbn65gplus_200a/tcbn65gpluswc.lib" \
                            "$SRAM_DIR/sram00_nldm_ss_0p90v_0p90v_125c_syn.lib" ] 


#####################################################################
# PDK Information, Plkace&Route OpenAccess format
# IMPORTANT: The OpenAccess library associated here must match with the technology specifics in project.lib and mmmc.tcl
#####################################################################
# OA library containing abstracts and vias
set iv::OALIB   [list "tcbn65gplus_oalib" "sram00_oalib"]
set iv::OALIB_COSTUM   [list  "sram00_oalib"] 
# OA library containing tech data
set iv::OATECH		"tcbn65gplus_oalib"
# OA library containing physical cells (schematic, layout, symbol)
set iv::OAPHYS		"tcbn65gplus"
# OA tech library for OAPHYS
set iv::OAPHYSTECH		"tsmcN65"
# Verilog subcircuit definitions (with power)
set iv::VERILOG_SUBCKT  "$PDK_DIGITAL/Front_End/verilog/tcbn65gplus_200a/tcbn65gplus_pwr.v"
# SPICE subcircuit definitions (with power)
set iv::SPICE_SUBCKT    "$PDK_DIGITAL/Back_End/spice/tcbn65gplus_200a/tcbn65gplus_200a.spi"

#####################################################################
# SRAM Hard Macro Paths
#####################################################################


set iv::SRAM_LEF        "$SRAM_DIR/sram00.vclef"
set iv::SRAM_GDS        "$SRAM_DIR/sram00.gds2"
set iv::SRAM_CDL        "$SRAM_DIR/sram00.cdl"

# SRAM timing libs
set iv::SRAM_LIB_TYP    "$SRAM_DIR/sram00_nldm_tt_1p00v_1p00v_25c_syn.lib"
set iv::SRAM_LIB_MIN    "$SRAM_DIR/sram00_nldm_ff_1p10v_1p10v_0c_syn.lib"
set iv::SRAM_LIB_MIN_LT "$SRAM_DIR/sram00_nldm_ff_1p10v_1p10v_m40c_syn.lib"
set iv::SRAM_LIB_MAX    "$SRAM_DIR/sram00_nldm_ss_0p90v_0p90v_125c_syn.lib"

# Hard macro black box list
set iv::BLACKBOX_LIST {sram00}
# set iv::

# Hard macro behavioral models for synthesis
set iv::MACRO_V_LIST [list "$SRAM_DIR/sram00.v" ]

###############################################################################
# HARD MACRO: SRAM
# 实际尺寸 R0: W=312.26um, H=128.765um
# R0 放置: 占用 X=312.26um, Y=128.765um
###############################################################################
set vars(sram,inst_name)   "u_sram"
set vars(sram,x)           $vars(fp,io_core_space)
set vars(sram,y)           $vars(fp,io_core_space)
set vars(sram,orient)      "R180"
