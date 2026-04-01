#!/bin/python3
# make_pinmap.py  -- sram_wrapper (dual-port: bus_slave 8-bit + tpu_core 64-bit)
# Top    : clk, rstn
# Left   : bus-related  (bus_we, bus_re, bus_addr, bus_din, bus_dout, bus_dout_valid)
# Right  : tpu-related  (tpu_we, tpu_re, tpu_addr, tpu_din, tpu_dout)
# Bottom : empty

AW_WORD = 9     # tpu_addr width  (AW-1:0)
AW_BYTE = 12    # bus_addr width  (AW+2:0)
DW_BUS  = 8     # bus_din/dout width
DW_TPU  = 64    # tpu_din/dout width

f = open("./pins.io", "w")
f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# ============================================================
# Top: clk, rstn
# ============================================================
f.write("\t(top\n")
f.write("\t\t(pin name=\"clk\"\t\toffset=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rstn\"\t\tskip=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ============================================================
# Left: bus-related
#   bus_we, bus_re, bus_addr[11:0], bus_din[7:0], bus_dout[7:0], bus_dout_valid
# ============================================================
f.write("\t(left\n")
f.write("\t\t(pin name=\"bus_we\"\t\toffset=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"bus_re\"\t\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_BYTE):
    f.write(f"\t\t(pin name=\"bus_addr[{i}]\"\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_BUS):
    f.write(f"\t\t(pin name=\"bus_din[{i}]\"\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_BUS):
    f.write(f"\t\t(pin name=\"bus_dout[{i}]\"\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"bus_dout_valid\"\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ============================================================
# Right: tpu-related
#   tpu_we, tpu_re, tpu_addr[8:0], tpu_din[63:0], tpu_dout[63:0]
# ============================================================
f.write("\t(right\n")
f.write("\t\t(pin name=\"tpu_we\"\t\toffset=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_re\"\t\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_WORD):
    f.write(f"\t\t(pin name=\"tpu_addr[{i}]\"\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_TPU):
    f.write(f"\t\t(pin name=\"tpu_din[{i}]\"\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_TPU):
    f.write(f"\t\t(pin name=\"tpu_dout[{i}]\"\tskip=3.6 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ============================================================
# Bottom: empty
# ============================================================
f.write("\t(bottom\n")
f.write("\t)\n")

f.write(")\n")
f.close()

left_count  = 2 + AW_BYTE + DW_BUS + DW_BUS + 1
right_count = 2 + AW_WORD + DW_TPU + DW_TPU
print(f"Generated pins.io  (top=2, left={left_count}, right={right_count}, bottom=0)")
