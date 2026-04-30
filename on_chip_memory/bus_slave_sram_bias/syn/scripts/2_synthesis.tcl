# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Genus: 2_synthesis.tcl

################################################
# Logic optimization
################################################
set_db syn_generic_effort $gn::SYN_EFFORT
syn_generic
report datapath > $gn::reportDir/syn_preopt.datapath_generic.rpt

################################################
# Synthesizing to gates
################################################
set_db syn_map_effort $gn::MAP_EFFORT
syn_map
report datapath > $gn::reportDir/syn_preopt.datapath_mapped.rpt

################################################
# Further optimization
################################################
set_db syn_opt_effort $gn::INCR_EFFORT
syn_opt

################################################
# Post-synth reports
################################################
foreach cg [vfind / -cost_group -null_ok *] {
  report_timing -group [list $cg] > $gn::reportDir/syn_postopt.timing_[basename $cg]_post_incr.rpt
}

# report syn-to-generic design
report_design > $gn::reportDir/syn_postopt.design.rpt

# report syn-to-generic gates
report_gates -power > $gn::reportDir/syn_postopt.gates.rpt

# report syn-to-generic area
report_area > $gn::reportDir/syn_postopt.area.rpt

# report syn-to-generic timing
report_timing -nworst 5 > $gn::reportDir/syn_postopt.timing.rpt

# report syn-to-generic timing groups
report_timing -endpoints > $gn::reportDir/syn_postopt.timing_ep.rpt
report_timing -max_slack 0.1 > $gn::reportDir/syn_postopt.timing_marginalviol.rpt
report_timing -from [all_inputs] > $gn::reportDir/syn_postopt.timing_in.rpt
report_timing -to   [all_outputs] > $gn::reportDir/syn_postopt.timing_out.rpt
report_timing_summary > $gn::reportDir/syn_postopt.timingsummary.rpt
# Across clock domains
set gn::CNT 1
foreach gn::CLK [vfind /designs* -clock *] {
  exec echo "####################" > $gn::reportDir/syn_postopt.timing.clk$gn::CNT
  exec echo "# from clock: $gn::CLK" >> $gn::reportDir/syn_postopt.timing.clk$gn::CNT
  exec echo "# to clock: $gn::CLK" >> $gn::reportDir/syn_postopt.timing.clk$gn::CNT
  exec echo "####################" >> $gn::reportDir/syn_postopt.timing.clk$gn::CNT
  report_timing -from $gn::CLK -to $gn::CLK >> $gn::reportDir/syn_postopt.timing_clk$gn::CNT.rpt
  incr gn::CNT
}

### Create reports
report_clock_gating > $gn::reportDir/syn_postopt.clockgating.rpt
report_power > $gn::reportDir/syn_postopt.power.rpt
report_area > $gn::reportDir/syn_postopt.area.rpt
report_qor > $gn::reportDir/syn_postopt.qor.rpt



