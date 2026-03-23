# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: 6_checks.tcl


###############################################################################
# PARASITICS EXTRACTION AND TIMING ANALYSIS
###############################################################################
source ../scripts/signoff_timing_analysis.tcl
#delete_floating_nets
#delete_dangling_ports
#delete_empty_hinsts
# Make sure all views are activated
set_analysis_view \
		-setup {  av_normal_max   av_normal_typ     av_normal_min   av_normal_min_lt }  \
		-hold  {  av_normal_min   av_normal_min_lt  av_normal_typ   av_normal_max}

# Cannot do QRC extraction because we do not have qrc map file and corner qrc rulefiles
signoff_qrc "Signoff_Final"

# ##############################################################################
# RC SCALE FACTORS EXTRACTION
# ##############################################################################
### Generates the resistance and capacitance scale factors for optimal RC correlation
report_rc_factors   \
    -pre_route true                          \
    -post_route medium                       \
    -reference signoff                       \
    -out_file $iv::OutDir/RC_factors.tcl

# ##############################################################################
# Verify geometry
# ##############################################################################

delete_drc_markers
check_drc -out_file $iv::reportDir/checks.verifyGeometry.rpt
check_connectivity -type all -out_file $iv::reportDir/checks.connectivity.rpt
check_process_antenna -out_file $iv::reportDir/checks.antenna.rpt
check_legacy_design -all -out_dir $iv::reportDir/export
write_netlist $iv::reportDir/export.v
