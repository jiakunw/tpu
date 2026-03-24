# ============================================================
# script.tcl - Cadence JasperGold FPV Script
# Module: sram_wrapper
# ============================================================

# Clear previous session
clear -all

# ============================================================
# Analyze Design Files
# ============================================================
# Add FORMAL define to enable SVA
analyze -sv09 +define+FORMAL sram_wrapper.sv

# Include sram00 model if available
# analyze -v /path/to/sram00.v

# ============================================================
# Elaborate Design
# ============================================================
# Blackbox sram00 (treat as abstract)
elaborate -top sram_wrapper -bbox_m sram00

# ============================================================
# Clock and Reset Setup
# ============================================================
clock clk
reset ~rstn

# ============================================================
# FPV Engine Settings
# ============================================================
set_engine_mode {Hp Ht Bm}
set_prove_time_limit 300s
set_max_trace_length 50

# ============================================================
# Assumptions Sanity Check
# ============================================================
check_assumptions -show -dead_end

# ============================================================
# Prove All Assertions
# ============================================================
prove -all

# ============================================================
# Check Coverage Points
# ============================================================
cover -all

# ============================================================
# Report Results
# ============================================================
report -property -results > results.txt
report -summary

# ============================================================
# Interactive Debug (optional)
# ============================================================
# If assertion fails, visualize counterexample:
# visualize -property <property_name> -new_window

puts ""
puts "============================================"
puts "  JasperGold FPV Complete"
puts "============================================"
puts ""