#!/bin/python3
# make_pinmap.py -- sram_wrapper_c
# Top  : clk, rstn
# Left : tpu interface (tpu_we, tpu_addr[8:0], tpu_din[63:0])  -- write only
# Right: bus interface (bus_re, bus_addr[11:0], bus_dout[7:0]) -- read only

AW_WORD = 9    # tpu_addr
AW_BYTE = 12   # bus_addr (AW+2:0)
DW_TPU  = 64   # tpu_din
DW_BUS  = 8    # bus_dout

f = open("./pins.io", "w")
f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# Top: clk, rstn
f.write("\t(top\n")
f.write("\t\t(pin name=\"clk\"\t\toffset=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rstn\"\t\tskip=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Left: tpu interface (write only)
f.write("\t(left\n")
f.write("\t\t(pin name=\"tpu_we\"\t\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_WORD):
    f.write(f"\t\t(pin name=\"tpu_addr[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_TPU):
    f.write(f"\t\t(pin name=\"tpu_din[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Right: bus interface (read only)
f.write("\t(right\n")
f.write("\t\t(pin name=\"bus_re\"\t\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_BYTE):
    f.write(f"\t\t(pin name=\"bus_addr[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_BUS):
    f.write(f"\t\t(pin name=\"bus_dout[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Bottom: empty
f.write("\t(bottom\n")
f.write("\t)\n")

f.write(")\n")
f.close()

left_count  = 1 + AW_WORD + DW_TPU
right_count = 1 + AW_BYTE + DW_BUS
print(f"Generated pins.io (top=2, left={left_count}, right={right_count}, bottom=0)")
