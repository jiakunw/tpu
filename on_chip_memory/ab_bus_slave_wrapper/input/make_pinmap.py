#!/bin/python3
# make_pinmap_ab.py -- sram_wrapper_ab (A+B combined: bus write, TPU read)
#
# Layout: same width as single sram_wrapper, ~2x height
#   Top    : clk, rstn + SRAM_A bus/tpu interface
#   Bottom : SRAM_B bus/tpu interface
#   Left   : bus_a interface (we, addr, din)
#   Right  : tpu_a interface (re, addr, dout)
#   (B signals mirrored on same sides, placed toward bottom half)

AW_BYTE = 12   # bus_addr width
AW_WORD = 9    # tpu_addr width
DW_BUS  = 8    # bus_din width
DW_TPU  = 64   # tpu_dout width

f = open("./pins.io", "w")
f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# ── TOP: clk, rstn, then SRAM_A bus signals ──────────────────────────────────
f.write("\t(top\n")
f.write("\t\t(pin name=\"clk\"\t\t\toffset=10.0  layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rstn\"\t\t\tskip=5.0     layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
# SRAM_A bus interface on top
f.write("\t\t(pin name=\"bus_a_we\"\t\tskip=10.0    layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_BYTE):
    f.write(f"\t\t(pin name=\"bus_a_addr[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_BUS):
    f.write(f"\t\t(pin name=\"bus_a_din[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
# SRAM_A tpu interface on top (right side of top edge)
f.write("\t\t(pin name=\"tpu_a_re\"\t\tskip=10.0    layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_WORD):
    f.write(f"\t\t(pin name=\"tpu_a_addr[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_TPU):
    f.write(f"\t\t(pin name=\"tpu_a_dout[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ── BOTTOM: SRAM_B bus + tpu interface ───────────────────────────────────────
f.write("\t(bottom\n")
f.write("\t\t(pin name=\"bus_b_we\"\t\toffset=10.0  layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_BYTE):
    f.write(f"\t\t(pin name=\"bus_b_addr[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_BUS):
    f.write(f"\t\t(pin name=\"bus_b_din[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_b_re\"\t\tskip=10.0    layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_WORD):
    f.write(f"\t\t(pin name=\"tpu_b_addr[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_TPU):
    f.write(f"\t\t(pin name=\"tpu_b_dout[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Left and right empty (all signals on top/bottom)
f.write("\t(left\n")
f.write("\t)\n")
f.write("\t(right\n")
f.write("\t)\n")

f.write(")\n")
f.close()

top_count    = 2 + 1 + AW_BYTE + DW_BUS + 1 + AW_WORD + DW_TPU
bottom_count = 1 + AW_BYTE + DW_BUS + 1 + AW_WORD + DW_TPU
print(f"Generated pins.io  (top={top_count}, bottom={bottom_count}, left=0, right=0)")
