#!/bin/tcsh

# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Genus: clean_innovus.tcsh

rm -fvr *.rpt*
rm -fvr *.cmd*
rm -fvr *.log*
rm -fvr ../report/*
rm -fvr ../output/*
rm -fvr ../dfII/*
rm -fv ctsSpec_ccopt.tcl
rm -fv origScaleFactor.tcl
rm -fv RC_factors.tcl
rm -fv cds.lib
rm -fvr checkDesign
rm -fvr *.txt
rm -fvr *.lef
rm -fvr timingReports
rm -fvr *.route
rm -fvr .cadence
rm -fvr mp*
rm -fv ihdlParamFile
rm -fv rc_model.bin
rm -fv *.tcl
rm -fv fixlayout_runtime.il
rm -fvr .tech_scripts
rm -fvr .*
rm -fvr */	# This deletes subfolders, such as a previously exported OA design.
