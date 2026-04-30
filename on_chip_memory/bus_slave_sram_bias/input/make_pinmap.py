#!/bin/python3
# make_pinmap_bias.py -- bias_wrapper (sram01 512x32-bit)
# Top   : clk, rstn
# Left  : bus interface (write only): bus_we, bus_addr[10:0], bus_din[7:0]
# Right : tpu interface (read only):  tpu_re, tpu_addr[8:0], tpu_dout[31:0]
# Bottom: empty

AW      = 9       # word address width
AW_BYTE = AW + 1  # bus_addr = [AW+1:0] = 10 bits
DW_BUS  = 8
DW_TPU  = 32      # sram01 is 32-bit wide

f = open("./pins.io", "w")
f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# Top: clk, rstn
f.write("\t(top\n")
f.write("\t\t(pin name=\"clk\"\t\toffset=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rstn\"\t\tskip=5.0    layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Left: bus interface (write only)
f.write("\t(left\n")
f.write("\t\t(pin name=\"bus_we\"\t\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW_BYTE):
    f.write(f"\t\t(pin name=\"bus_addr[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_BUS):
    f.write(f"\t\t(pin name=\"bus_din[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Right: tpu interface (read only)
f.write("\t(right\n")
f.write("\t\t(pin name=\"tpu_re\"\t\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(AW):
    f.write(f"\t\t(pin name=\"tpu_addr[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(DW_TPU):
    f.write(f"\t\t(pin name=\"tpu_dout[{i}]\"\tskip=3.6 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Bottom: empty
f.write("\t(bottom\n")
f.write("\t)\n")

f.write(")\n")
f.close()

left_count  = 1 + AW_BYTE + DW_BUS
right_count = 1 + AW + DW_TPU
print(f"Generated pins.io  (top=2, left={left_count}, right={right_count}, bottom=0)")
