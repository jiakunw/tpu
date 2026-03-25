# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Innovus: 7_export.tcl

source ../scripts/makePins.tcl

###############################################################################
# VDD/GND PINS and PIN LABELS CREATION
###############################################################################
create_pg_pin -name $iv::PWR_name -net $iv::PWR_name
create_pg_pin -name $iv::GND_name -net $iv::GND_name

## This procedure creates PG pins and labels for sub-blocks and wirebonded designs
make_pins_core

###############################################################################
# FUNCTIONAL analysis: EXPORTING POST LAYOUT NETLIST & PARASITICS (.sdf file)
###############################################################################
write_netlist $iv::OutDir/$TOPCELL.funct.v
write_netlist $iv::OutDir/$TOPCELL.functpg.v -include_pg_ports 
write_sdf  \
        -edges check_edge               \
        -min_view      av_normal_min_lt \
        -max_view      av_normal_max    \
        -typical_view  av_normal_typ    \
        $iv::OutDir/$TOPCELL.funct.sdf  \
        -recompute_delaycal

###############################################################################
#  LVS and PHYSICAL DESIGN NETLIST EXPORT
###############################################################################
# Include cells that have electrical connections only.
write_netlist \
    $iv::OutDir/$TOPCELL.lvs.v                                \
    -exclude_leaf_cells                                \
    -include_pg_ports                                  \
    -include_phys_cells $vars(cell,decaps)		\
    -exclude_insts_of_cells $vars(cell,filler_nosch)

# Convert to SPICE netlist using Calibre
catch {exec v2lvs -v $iv::OutDir/$TOPCELL.lvs.v -o $iv::OutDir/$TOPCELL.lvs.spi -l $iv::VERILOG_SUBCKT -s $iv::SPICE_SUBCKT -s0 DVSS -s1 DVDD -w 2 -a<>}

# Open, lvs.v and add DVDD and DVSS inout ports to the top cell

write_netlist \
    $iv::OutDir/$TOPCELL.phys.v   \
    -phys                         \
    -omit_floating_ports          \
    -include_pg_ports             \
    -exclude_leaf_cells

###############################################################################
# CREATING VIRTUOSO SCHEMATIC VIEW
###############################################################################
### Cleanup markers
delete_drc_markers
delete_place_halo -all_blocks
#delete_place_blockages -all
delete_route_blockages -type all
delete_route_halos -all_blocks

### Creates Virtuoso project library
catch {exec rm -fvr $TOPCELL }
# Attach to OA tech
#catch {create_oa_lib $TOPCELL -oa_reference_tech_libs $iv::OALIB }
catch {create_oa_lib $TOPCELL -oa_reference_tech_libs $iv::OAPHYS }

### Edit ihdlParamFile accordingly (editing ihdlParamFile in pnr/work)
### this files will be later on sourced to generate the schematic view
set f [open ./../scripts/ihdlParamFile_stock]
set lines [split [read $f] "\n"]
close $f
lset lines 0 "dest_sch_lib := $TOPCELL "
lset lines 1 "ref_lib_list := basic, US_8ths, $iv::OAPHYS"
lset lines 2 "schematic_view_name := schematic"
lset lines 3 "symbol_view_name := symbol"
lset lines 4 "log_file_name := verilogIn.log"
lset lines 5 "map_file_name := verilogIn.map.table"
lset lines 6 "power_net := \\$iv::PWR_name!"
lset lines 7 "ground_net := \\$iv::GND_name!"
lset lines 8 "import_if_exists := 1"
lset lines 9 "max_net_name_length := 100000"
set f [open ihdlParamFile w]
puts -nonewline $f [join $lines "\n"]
close $f
unset lines

### Generating schematic
puts "Making final virtuoso schematic view. (check verilogIn.log for details)"
catch {exec rm -rvf $TOPCELL/$TOPCELL/symbol}
catch {exec rm -rvf $TOPCELL/$TOPCELL/schematic}
catch {exec rm -rvf $TOPCELL/$TOPCELL/functional}
catch {exec ihdl +DUMB_SCH -PARAM ./ihdlParamFile $iv::OutDir/$TOPCELL.lvs.v}
puts "Schematic, symbol and functional views were generated."


###############################################################################
# CREATING ABSTRACT VIEW
###############################################################################
puts "Making final virtuoso abstract view... "
catch {exec rm -rvf $TOPCELL/$TOPCELL/abstract}

write_oa  \
    $TOPCELL $TOPCELL abstract \
    -auto_remaster                           \
    -oa_leaf_views [list "abstract"]


###############################################################################
# CREATING LAYOUT VIEW
###############################################################################
puts "Making final virtuoso layout view... "
catch {exec rm -rvf $TOPCELL/$TOPCELL/layout}

write_oa  \
    $TOPCELL $TOPCELL layout \
    -auto_remaster                           \
    -oa_ref_libs [list "$iv::OAPHYS" "$iv::OAPHYSTECH"]	\
    -oa_leaf_views [list "layout"]


### Alternative legacy approach
# write_db -oa_lib_cell_view " $oaLibName [get_db designs .name] dfm"
# catch {exec virtuoso -nograph -log makeLayout.log -replay ../scripts/makeLayout.il}
puts "Layout generated."

###############################################################################
# LAYOUT POST-PROCESSING
###############################################################################
# Generate the runtime fix layout script for virtuoso to replay
set lines [list]
lset lines 0 "load(\"../scripts/virtuoso_postprocess.il\")"
lset lines 1 "drawDMEXCL(\"${TOPCELL}\" \"${TOPCELL}\" \"layout\")"
lset lines 2 "changeLabelPurposeToPin(\"${TOPCELL}\" \"${TOPCELL}\" \"layout\")"
lset lines 3 "exit"
set f [open fixlayout_runtime.il w]
puts -nonewline $f [join $lines "\n"]
close $f
unset lines
# Execute virtuoso
catch {exec virtuoso -nograph -log fixlayout_runtime.log -replay fixlayout_runtime.il}









