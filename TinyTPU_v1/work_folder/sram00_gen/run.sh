#!/bin/bash
# ============================================================
# ARM SRAM Compiler – Parameterized Script
# TSMC 65nm CLN65GPLUS | sram_sp_hdc_svt_rvt_hvt
# ============================================================

# ── Tool Path ───────────────────────────────────────────────
COMPILER_BASE="/tools/misc/EE6321/arm/tsmc/cln65gplus/sram_sp_hdc_svt_rvt_hvt/r0p0-00eac0"
COMPILER="${COMPILER_BASE}/bin/sram_sp_hdc_svt_rvt_hvt"

# ── Output Directory ─────────────────────────────────────────
# Toplevel="SRAM00"
# OUTPUT_DIR="${Toplevel}_gen"  # ← 改这里指定输出位置
OUTPUT_DIR="./"

# ── Instance / Memory Configuration ─────────────────────────
INSTNAME="sram00"
WORDS=512
BITS=64
FREQUENCY=100
MUX=4
DRIVE=6

# ── Write Mask ──────────────────────────────────────────────
WRITE_MASK="off"
WRITE_THRU="off"
WP_SIZE=8

# ── Physical / Process Options ───────────────────────────────
TOP_LAYER="m5-m9"
REDUNDANCY="off"
BMUX="off"
SER="none"
BACK_BIASING="off"
POWER_GATING="off"
ATF="off"
DIODES="on"

# ── Power/Ground Pin Renaming ────────────────────────────────
PWR_GND_RENAME="VDDPE:VDD,VDDCE:VDD,VSSE:VSS"

# ── Bus Delimiter & Naming ───────────────────────────────────
LEFT_BUS_DELIM="["
RIGHT_BUS_DELIM="]"
PREFIX=""
NAME_CASE="upper"
CHECK_INSTNAME="on"

# ── Comment ─────────────────────────────────────────────────
COMMENT="First Attempt"

# ── Output Formats to Generate ──────────────────────────────
VIEWS=(verilog synopsys lvs vclef-fp gds2)

# ============================================================
# 创建并切换到输出目录
# ============================================================
mkdir -p "${OUTPUT_DIR}"
cd "${OUTPUT_DIR}" || { echo "[ERROR] Cannot cd to ${OUTPUT_DIR}"; exit 1; }

echo "[INFO] Output directory: $(pwd)"

# ============================================================
# Build shared argument string
# ============================================================
ARGS=(
    -instname        "${INSTNAME}"
    -words           "${WORDS}"
    -bits            "${BITS}"
    -frequency       "${FREQUENCY}"
    -mux             "${MUX}"
    -drive           "${DRIVE}"
    -write_mask      "${WRITE_MASK}"
    -write_thru      "${WRITE_THRU}"
    -wp_size         "${WP_SIZE}"
    -top_layer       "${TOP_LAYER}"
    -redundancy      "${REDUNDANCY}"
    -bmux            "${BMUX}"
    -ser             "${SER}"
    -back_biasing    "${BACK_BIASING}"
    -power_gating    "${POWER_GATING}"
    -atf             "${ATF}"
    -cust_comment    "${COMMENT}"
    -left_bus_delim  "${LEFT_BUS_DELIM}"
    -right_bus_delim "${RIGHT_BUS_DELIM}"
    -prefix          "${PREFIX}"
    -name_case       "${NAME_CASE}"
    -check_instname  "${CHECK_INSTNAME}"
    -diodes          "${DIODES}"
    -pwr_gnd_rename  "${PWR_GND_RENAME}"
)

# ============================================================
# Run compiler for each view
# ============================================================
echo "============================================"
echo " SRAM Compiler: ${INSTNAME}"
echo " Config: ${WORDS}x${BITS}b  @${FREQUENCY}MHz  MUX${MUX}"
echo "============================================"

for VIEW in "${VIEWS[@]}"; do
    echo ""
    echo "[INFO] Generating view: ${VIEW} ..."
    "${COMPILER}" "${VIEW}" "${ARGS[@]}"
    if [ $? -eq 0 ]; then
        echo "[DONE] ${VIEW} completed successfully."
    else
        echo "[ERROR] ${VIEW} failed! Aborting."
        exit 1
    fi
done

echo ""
echo "============================================"
echo " All views generated to: ${OUTPUT_DIR}"
echo "============================================"