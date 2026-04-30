# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Genus: 3_export.tcl

write_hdl > $gn::OutDir/$TOPCELL.syn.v
write_sdc -view default_mode > $gn::OutDir/$TOPCELL.syn.sdc
# This is usually only for post-synthesis simulation.
# Note, we've synthesized using worst-case corners to obtain maximum spec delays. 
# Therefore, SDF back-annotation must be done with MTM_SPEC set to MAXIMUM.
write_sdf > $gn::OutDir/$TOPCELL.syn.sdf
