#!/bin/python3
# make_pinmap.py -- bus_slave_c
# Top  : BUS_CLK, BUS_RST_N
# Left : bus interface (CHC_START, CHC_RD, sram_c_dout[7:0])
# Right: sram + output (sram_c_re, sram_c_addr[11:0], CHC_RDATA[7:0], debug_cnt_c[11:0])

f = open("./pins.io", "w")
f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# Top: clock and reset
f.write("\t(top\n")
f.write("\t\t(pin name=\"BUS_CLK\"\t\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"BUS_RST_N\"\t\tskip=3.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Left: bus inputs + sram_c_dout (input from sram_wrapper_c)
left_pins = (
    ["CHC_START", "CHC_RD"]
    + [f"sram_c_dout[{i}]" for i in range(8)]
)
f.write("\t(left\n")
for idx, pin in enumerate(left_pins):
    offset = "offset=5.0" if idx == 0 else "skip=1.0"
    f.write(f"\t\t(pin name=\"{pin}\"\t{offset} layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Right: sram control outputs + CHC_RDATA + debug
right_pins = (
    ["sram_c_re"]
    + [f"sram_c_addr[{i}]" for i in range(12)]
    + [f"CHC_RDATA[{i}]" for i in range(8)]
    + [f"debug_cnt_c[{i}]" for i in range(12)]
)
f.write("\t(right\n")
for idx, pin in enumerate(right_pins):
    offset = "offset=5.0" if idx == 0 else "skip=1.0"
    f.write(f"\t\t(pin name=\"{pin}\"\t{offset} layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Bottom: empty
f.write("\t(bottom\n")
f.write("\t)\n")

f.write(")\n")
f.close()
print(f"Generated pins.io (top=2, left={len(left_pins)}, right={len(right_pins)}, bottom=0)")
