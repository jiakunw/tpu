###############################################################################
# register_files.sdc - high-speed dual-clock SPI version
###############################################################################

set sdc_version 1.6

current_design spi_slave_mmio_register_file

#==============================================================================
# Clock definitions
#
# Synthesis target: 40 MHz for both clocks (period = 25 ns).
# Silicon will run at:
#   - chip_clk : 10 MHz  (4x margin over 25 ns)
#   - SPI_SCK  : 10 MHz  (4x margin over 25 ns)
# Over-constraining at synthesis ensures setup timing closure with plenty
# of safety margin against PVT variation, IR drop, and OCV.
#==============================================================================
set clkperiod 25.0
set sckperiod 25.0

# Main chip clock
create_clock -name "Clk" -period $clkperiod [get_ports clk]

# SPI clock (asynchronous, from external master)
create_clock -name "SPI_SCK" -period $sckperiod [get_ports spi_sck]

#==============================================================================
# Asynchronous clock groups
#==============================================================================
set_clock_groups -asynchronous \
    -group {Clk} \
    -group {SPI_SCK}

#==============================================================================
# Clock uncertainty / transition
#==============================================================================
set_clock_transition  0.2  [all_clocks]
set_clock_uncertainty 0.2  [all_clocks]

#==============================================================================
# Output load
#==============================================================================
set_load -pin_load 0.5 [get_ports *]

#==============================================================================
# Asynchronous reset
#==============================================================================
set_false_path -from [get_ports arstn]

#==============================================================================
# Chip-clock-domain inputs / outputs
#==============================================================================
set chip_clk_inputs [remove_from_collection \
    [all_inputs] \
    [get_ports {clk arstn spi_sck spi_cs_n spi_mosi}]]

set_input_delay  -clock "Clk" -max 1.0 $chip_clk_inputs
set_input_delay  -clock "Clk" -min 0.0 $chip_clk_inputs

set chip_clk_outputs [remove_from_collection \
    [all_outputs] \
    [get_ports {spi_miso}]]

set_output_delay -clock "Clk" -max [expr $clkperiod/4] $chip_clk_outputs
set_output_delay -clock "Clk" -min 0.0                  $chip_clk_outputs

#==============================================================================
# SPI inputs (sck domain)
#
# Tightened for 25 ns SCK period: 4 ns input delay leaves 21 ns budget for
# internal sck-domain logic (RX shifter has ~1 LUT depth, very loose).
# At silicon 100 ns SCK, this provides ample margin.
#==============================================================================
set_input_delay -clock "SPI_SCK" -max 4.0 [get_ports spi_cs_n]
set_input_delay -clock "SPI_SCK" -min 0.0 [get_ports spi_cs_n]
set_input_delay -clock "SPI_SCK" -max 4.0 [get_ports spi_mosi]
set_input_delay -clock "SPI_SCK" -min 0.0 [get_ports spi_mosi]

#==============================================================================
# SPI output (sck domain)
#
# Tightened for 25 ns SCK period: 4 ns output delay budget. Slave updates
# MISO on SCK falling edge; master samples on rising edge half-period later.
#==============================================================================
set_output_delay -clock "SPI_SCK" -clock_fall -max 4.0 [get_ports spi_miso]
set_output_delay -clock "SPI_SCK" -clock_fall -min 0.0 [get_ports spi_miso]
