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
# Project Information, Synthesis
#####################################################################
# Replace this with the name of your topcell
set TOPCELL		bus_slave_ab	
# List of HDL files
set gn::VERILOG_LIST	[list "bus_slave_ab.sv"]	
set gn::SDC_LIST	[list "bus_slave_ab.sdc"]
# Tech node, in nm
set iv::node		65

#####################################################################
# Project Information, Floorplanning
#####################################################################
# Use Tempus engine?  More accurate for long wires
set iv::TEMPUS_ENGINE	1
# Incremental optimization?
set iv::INCR_OPT	1
# Power and ground net names as they should be implemented in your design
set iv::PWR_name	DVDD
set iv::GND_name	DVSS
# Power and ground pin names as they are in the digital std cell lib
set iv::PWR_libname	VDD
set iv::GND_libname	VSS
#### die dimensions ####
set vars(fp,width)           103.0
set vars(fp,height)          103.0
set vars(fp,io_core_space)   27.5  
#### ring parameters ####
# metal layer
set vars(ring,top_layer)        9  
set vars(ring,bottom_layer)     9  
set vars(ring,left_layer)       8  
set vars(ring,right_layer)      8  
# width
set vars(ring,top_width)        9.06  
set vars(ring,bottom_width)     9.06  
set vars(ring,left_width)       9.06  
set vars(ring,right_width)      9.06  
# spacing
set vars(ring,top_space)        4.44  
set vars(ring,bottom_space)     4.44  
set vars(ring,left_space)       4.44  
set vars(ring,right_space)      4.44  
# offset
set vars(ring,top_offset)       4.44  
set vars(ring,bottom_offset)    4.44  
set vars(ring,left_offset)      4.44  
set vars(ring,right_offset)     4.44  
#### stripes parameters ####
# stripes direction
set vars(stripe,dir)     vertical  
# stripes spacing between VDD and GND
set vars(stripe,space)          4.44  
# stripes metal layer
set vars(stripe,metal)          8  
# stripes width
set vars(stripe,width)         9.06  
# Stripes set distance
#set vars(stripe,setdist)	360
#set vars(stripe,setdist)	[expr { ($vars(fp,width)/2)-$vars(stripe,width)-0.5*$vars(stripe,space)-$vars(fp,io_core_space) }]
# This prevents an additional stripe at the right most edge
set vars(stripe,setdist)	[expr { ($vars(fp,width)/2)-$vars(stripe,width)-0.5*$vars(stripe,space)-0.5*$vars(fp,io_core_space) }]
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
set iv::data_top_routing_layer		7
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
set iv::setup_target_slack		1.0
set iv::hold_target_slack		1.0


#####################################################################
# PDK Information, Synthesis Only
#####################################################################
# Where possible, provide worst case corners.  Synthesis should always be done on the worst corner.
# See mmmc.tcl for library setup for innovus
# See user_timing_derating.tcl for user customization
# Grab from environment variable
set env(PDK_PATH)               "/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/Base_PDK/PDK_CRN65GP_v1.0c_official_IC61_20101010"
set env(PDK_DIGITAL)            "/courses/ee6350/pdk2023/T-N65-CM-SP-018-K3_MOM/digital"

set PDK_PATH		$env(PDK_PATH)	
set PDK_DIGITAL		$env(PDK_DIGITAL)	
# List of NLDM libraries of all std cell libraries to be used
set gn::NLDMLIB		[list "$PDK_DIGITAL/Front_End/timing_power_noise/NLDM/tcbn65gplus_200a/tcbn65gpluswc.lib"]


#####################################################################
# PDK Information, Plkace&Route OpenAccess format
# IMPORTANT: The OpenAccess library associated here must match with the technology specifics in project.lib and mmmc.tcl
#####################################################################
# OA library containing abstracts and vias
set iv::OALIB		[list "tcbn65gplus_oalib" ]
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
