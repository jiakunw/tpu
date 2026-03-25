#!/bin/python3
# make_pinmap.py
# Pin placement for rf_top

f = open("./pins.io", "w")

f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# Top - dim outputs (18 pins)
f.write("\t(top\n")
f.write("\t\t(pin name=\"dim_m[0]\"\t\toffset=5.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 6):
    f.write(f"\t\t(pin name=\"dim_m[{i}]\"\t\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(6):
    f.write(f"\t\t(pin name=\"dim_n[{i}]\"\t\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(6):
    f.write(f"\t\t(pin name=\"dim_k[{i}]\"\t\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Bottom - clk, rst_n
f.write("\t(bottom\n")
f.write("\t\t(pin name=\"clk\"\t\toffset=10.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rst_n\"\t\tskip=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Left - SPI pins
f.write("\t(left\n")
f.write("\t\t(pin name=\"spi_sck\"\t\toffset=5.0000 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"spi_cs_n\"\t\tskip=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"spi_mosi\"\t\tskip=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"spi_miso\"\t\tskip=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# Right - TPU control
f.write("\t(right\n")
f.write("\t\t(pin name=\"tpu_start\"\t\toffset=5.0000 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_idle\"\t\tskip=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_working\"\t\tskip=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_done\"\t\tskip=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

f.write(")\n")
f.close()

print("Generated pins.io")
