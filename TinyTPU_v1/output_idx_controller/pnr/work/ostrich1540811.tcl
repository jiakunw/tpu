set refSpefFileName     .signoff_RC_WORST.spef.gz
set cmpSpefFileName     .preroute_RC_WORST_clkNets.spef.gz
set reportFileName      ostrichCmp_RC_WORST_preroute_clock.rpt
set reportXCap          0
set tcapFilter          ""
set resFilter           ""
set xcapFilter          ""


if {[catch {
 read_spef -setname ref -filename $refSpefFileName
 read_spef -setname cmp -filename $cmpSpefFileName

 eval build_plot -plotname plot1 -golden ref -target cmp -datatype tcap $tcapFilter
 eval build_plot -plotname plot1 -golden ref -target cmp -datatype res $resFilter
 if {$reportXCap} {
   eval build_plot -plotname plot1 -golden ref -target cmp -datatype xcap $xcapFilter
 }

 set rec_cap_scale_factor [get_scale_factor -plotname plot1 -datatype tcap -recommended]
 set rec_res_scale_factor [get_scale_factor -plotname plot1 -datatype res -recommended]
 if {$reportXCap} {
   set rec_xcap_scale_factor [get_scale_factor -plotname plot1 -datatype xcap -recommended]
 }

 set reportFile [open $reportFileName "w"]
 if {$reportFile < 0} {
   putError $::uiEmsHandleId 16515 $reportFileName
   exit
 }

 puts $reportFile "#Refrence Spef File Name                                 $refSpefFileName"
 puts $reportFile "#Compare Spef File Name                                  $cmpSpefFileName"
 puts $reportFile "#Suggested Resistance Scale Factor                       $rec_res_scale_factor"
 puts $reportFile "#Suggested Capacitance Scale Factor                      $rec_cap_scale_factor"
 if {$reportXCap} {
    puts $reportFile "#Suggested Cross Coupling Cap. Scale Factor              $rec_xcap_scale_factor"
 }

 set stats_cap [get_plot_statistics -plotname plot1 -datatype tcap -tcl_list]
 set stats_res [get_plot_statistics -plotname plot1 -datatype res -tcl_list]

 puts $reportFile "\nCap stats\n========="
 foreach i $stats_cap {puts $reportFile "$i"}
 puts $reportFile "\nRes stats\n========="
 foreach i $stats_res {puts $reportFile "$i"}

 if {$reportXCap} {
   set stats_xcap [get_plot_statistics -plotname plot1 -datatype xcap -tcl_list]
   puts $reportFile "\nCoupling Cap stats\n========="
   foreach i $stats_xcap {puts $reportFile "$i"}
 }

 close $reportFile
 exit
} errMsg ] } {
  putError $::uiEmsHandleId 16516 $errMsg
  exit
}

  
