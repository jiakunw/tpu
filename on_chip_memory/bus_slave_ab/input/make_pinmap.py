#!/bin/python3
# make_pinmap.py
# Pin placement for bus_slave_ab
# Top   = BUS_CLK, BUS_RST_N
# Left  = bus interface inputs (CHAB_*)
# Right = sram interface outputs (sram_a_*, sram_b_*, debug_cnt_ab)

f = open("./pins.io", "w")
f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# ============================================================
# TOP: clock and reset
# ============================================================
f.write("\t(top\n")
f.write("\t\t(pin name=\"BUS_CLK\"\t\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"BUS_RST_N\"\t\tskip=3.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ============================================================
# LEFT: bus interface inputs
#   CHAB_START, CHAB_WR, CHAB_WDATA_A[7:0], CHAB_WDATA_B[7:0]
# ============================================================
left_pins = (
    ["CHAB_START", "CHAB_WR"]
    + [f"CHAB_WDATA_A[{i}]" for i in range(8)]
    + [f"CHAB_WDATA_B[{i}]" for i in range(8)]
)

f.write("\t(left\n")
for idx, pin in enumerate(left_pins):
    if idx == 0:
        f.write(f"\t\t(pin name=\"{pin}\"\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
    else:
        f.write(f"\t\t(pin name=\"{pin}\"\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ============================================================
# RIGHT: sram interface outputs
#   sram_a_we, sram_a_addr[11:0], sram_a_din[7:0]
#   sram_b_we, sram_b_addr[11:0], sram_b_din[7:0]
#   debug_cnt_ab[11:0]
# ============================================================
right_pins = (
    ["sram_a_we"]
    + [f"sram_a_addr[{i}]" for i in range(12)]
    + [f"sram_a_din[{i}]" for i in range(8)]
    + ["sram_b_we"]
    + [f"sram_b_addr[{i}]" for i in range(12)]
    + [f"sram_b_din[{i}]" for i in range(8)]
    + [f"debug_cnt_ab[{i}]" for i in range(12)]
)

f.write("\t(right\n")
for idx, pin in enumerate(right_pins):
    if idx == 0:
        f.write(f"\t\t(pin name=\"{pin}\"\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
    else:
        f.write(f"\t\t(pin name=\"{pin}\"\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ============================================================
# BOTTOM: empty
# ============================================================
f.write("\t(bottom\n")
f.write("\t)\n")

f.write(")\n")
f.close()
print(f"Generated pins.io  (top=2, left={len(left_pins)}, right={len(right_pins)}, bottom=0)")
