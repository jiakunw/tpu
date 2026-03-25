# ============================================================
# script.tcl - Cadence JasperGold FPV Script
# Module: sram_wrapper
# 
# Run from: /user/stud/fall25/dy2538/ee6350/DIGITAL/Sram_wrapper
# Command:  jg -fpv script.tcl
# ============================================================

# Clear previous session
clear -all

# ============================================================
# Analyze Design Files
# ============================================================
# sram_wrapper with FORMAL define
analyze -sv09 {+define+FORMAL} sram_wrapper.sv

# ============================================================
# Elaborate Design
# ============================================================
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

puts ""
puts "============================================"
puts "  JasperGold FPV Complete"
puts "  Results saved to results.txt"
puts "============================================"
puts ""
