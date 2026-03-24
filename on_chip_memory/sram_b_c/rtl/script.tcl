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
analyze -sv09 +define+FORMAL \
        /user/stud/fall25/dy2538/ee6350/DIGITAL/Sram_wrapper/sram_wrapper.sv

# sram00 ARM IP
analyze -v +define+ARM_UD_MODEL \
           +define+ARM_UD_DP \
           +define+ARM_UD_CP \
           +define+ARM_UD_SEQ \
           /user/stud/fall25/dy2538/EE6321/ref/memory_compiler/sram00/sram00.v

# ============================================================
# Elaborate Design
# ============================================================
elaborate -top sram_wrapper

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