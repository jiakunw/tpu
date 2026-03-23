MODULE_NAME=sram_wrapper

# Synthesize
dc_shell -f module.tcl | tee log

#### Python script processing
source "/courses/ee6350/pdk2025/miniconda3/bin/activate"

# Add power and ground pins
echo "--> Producing $MODULE_NAME.nl.PG.v"
python add_pg.py $MODULE_NAME

# Comment out set_ideal_network
echo "--> Commenting out set_ideal_network in $MODULE_NAME.syn.mod.sdc"
python proc_sdc.py $MODULE_NAME
