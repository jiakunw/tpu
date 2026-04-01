# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: run_all.tcl


# Setup project
source ../../input/project_setup.tcl



# Execute flow (TOFIX)、
# set_db timing_report_compress_format none
source ../scripts/1_import.tcl
source ../scripts/2_floorplan.tcl
source ../scripts/3_place.tcl
source ../scripts/4_cts.tcl
source ../scripts/5_route.tcl
source ../scripts/6_checks.tcl
source ../scripts/7_export.tcl

gui_show
