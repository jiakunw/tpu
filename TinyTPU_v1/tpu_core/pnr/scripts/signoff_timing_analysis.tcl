# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: signoff_timing_analysis.tcl

###########################################################################
# Signoff timing analysis using Innovus (make sure to run the separate
# Tempus signoff timing afterwards)
###########################################################################

###############################################################################
# Extract and time analysis
###############################################################################

proc extract_and_time_design {prefix} {

 

    set_db extract_rc_use_qrc_oa_interface true
    set_db extract_rc_coupled true
    eval_legacy { setDelayCalMode -engine default }
    set_db extract_rc_effort_level signoff
    set_db extract_rc_lef_tech_file_map "../../input/qrc.map"
    set_db timing_analysis_type ocv
    set_db timing_analysis_cppr both
    set_db delaycal_enable_si true

    extract_rc

    write_parasitics -rc_corner RC_BEST  -spef_file $iv::OutDir/export_RC_BEST.spef
    write_parasitics -rc_corner RC_WORST -spef_file $iv::OutDir/export_RC_WORST.spef
    write_parasitics -rc_corner RC_TYP   -spef_file $iv::OutDir/export_RC_TYP.spef

    #signoff timing analysis

    time_design    \
        -sign_off                               \
        -report_only                            \
        -report_prefix $prefix                  \
        -path_report                            \
        -drv_report                             \
        -slack_report                           \
        -num_paths 500                          \
        -report_dir $iv::reportDir           \
        -timing_debug_report

    time_design    \
        -sign_off                               \
        -hold                                   \
        -report_only                            \
        -report_prefix $prefix                  \
        -path_report                            \
        -slack_report                           \
        -num_paths 500                          \
        -report_dir $iv::reportDir            \
        -timing_debug_report

}

# ##############################################################################
# Signoff timing with QRC map file
# ##############################################################################

proc signoff_qrc {prefix} {



    if {[file exists "../../input/qrc.map"] == 0} {
        puts "ERROR signoff_qrc. qrc.map doesn't exist. Cannot continue."
        return ""
    }

    ### Runs signoff timing analysis using extraction (Quantus QRC) and Tempus in batch mode, and generates timing reports and ECO DB for each view. The command prints out a timing summary table per view and all the views combined.
    ### NOTE this file is calling the qrc.map file specified by setExtractRCMode

    #  signoff extraction
    set_db extract_rc_use_qrc_oa_interface true		
    set_db extract_rc_engine post_route
    set_db extract_rc_effort_level signoff		
    set_db extract_rc_coupled true
    set_db extract_rc_lef_tech_file_map "../../input/qrc.map"

    extract_rc

    write_parasitics -rc_corner RC_BEST  -spef_file $iv::OutDir/export_signoff_RC_BEST.spef
    write_parasitics -rc_corner RC_WORST -spef_file $iv::OutDir/export_signoff_RC_WORST.spef
    write_parasitics -rc_corner RC_TYP   -spef_file $iv::OutDir/export_signoff_RC_TYP.spef

    # signoff timing analysis using TEMPUS (engine AAE)
    eval_legacy { setInputTransitionDelay 100.0ps }
    eval_legacy { setDefaultLoadForAllNet 0.1pf }

    ## Delay Mode
    eval_legacy { setDelayCalMode -engine aae } ;# Default : true
    set_db delaycal_enable_si true ;# Default : false
    set_db delaycal_equivalent_waveform_model propagation; # Default : none

    ## SI settings
    set_db si_delay_separate_on_data true ;# Default : false
    set_db si_delay_delta_annotation_mode lumpedOnNet ;# Default : arc
    set_db si_delay_delta_threshold 1e-12 ;# Default : -1
    eval_legacy { setSIMode -use_si_slew_for_delay true } ;# Default : false
    set_db si_enable_glitch_propagation true ;# Default : false
    set_db opt_post_route_report_si_transitions true  ;# Default : false
    set_db timing_enable_si_cppr true  ;# Default : true
    set_db timing_cppr_transition_sense same_transition_expanded ;# Default : normal

    ## STA globals
    set_db timing_case_analysis_for_icg_propagation always  ;# Default : false
    set_db timing_analysis_cppr both  ;# equivalent to legacy timing_remove_clock_reconvergence_pessimism Default : none
    set_db timing_report_unconstrained_paths true  ;# Default : false

    ## Only for signoff STA (will impact runtime for optimisation)
    set_db si_delay_enable_double_clocking_check true  ;# Default : false
    set_db si_glitch_enable_report true  ;# Default : false
    set_db si_delay_enable_report true   ;# Default : false
    set_db timing_cppr_threshold_ps 0    ;# Default : 20

    set_db delaycal_enable_si true
    eval_legacy { setDelayCalMode -siAware true -engine aae -mode signoff }

    time_design    \
        -sign_off                                \
        -expanded_views                          \
        -report_prefix $prefix                   \
        -path_report                             \
        -drv_report                              \
        -slack_report                            \
        -num_paths 500                           \
        -report_dir $iv::reportDir             \
        -timing_debug_report -report_only

    time_design    \
        -sign_off                                \
        -hold                                    \
        -expanded_views                          \
        -report_prefix $prefix                   \
        -path_report                             \
        -slack_report                            \
        -num_paths 500                           \
        -report_dir $iv::reportDir             \
        -timing_debug_report -report_only

}
