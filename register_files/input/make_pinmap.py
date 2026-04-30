#!/bin/python3
# make_pinmap_rf_top.py -- rf_top (updated)
#
# Top   : dim_m[7:0], dim_n[7:0], dim_k[7:0], num_computation[7:0]  (32 pins)
# Bottom: clk, rst_n, scale_factor[15:0], scale_shift[4:0]           (19 pins)
# Left  : SPI (4 pins) + zero_point_a/b/c[7:0]                       (28 pins)
# Right : tpu_start, tpu_idle, tpu_working, tpu_done, tpu_core_rst   ( 5 pins)

f = open("./pins.io", "w")
f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# ── TOP: dim_m/n/k [7:0], num_computation[7:0] ───────────────────────────────
f.write("\t(top\n")
f.write("\t\t(pin name=\"dim_m[0]\"\t\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 8):
    f.write(f"\t\t(pin name=\"dim_m[{i}]\"\t\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(8):
    f.write(f"\t\t(pin name=\"dim_n[{i}]\"\t\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(8):
    f.write(f"\t\t(pin name=\"dim_k[{i}]\"\t\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(8):
    f.write(f"\t\t(pin name=\"num_computation[{i}]\"\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ── BOTTOM: clk, rst_n, scale_factor[15:0], scale_shift[4:0] ─────────────────
f.write("\t(bottom\n")
f.write("\t\t(pin name=\"clk\"\t\t\toffset=5.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rst_n\"\t\tskip=2.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(16):
    f.write(f"\t\t(pin name=\"scale_factor[{i}]\"\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(5):
    f.write(f"\t\t(pin name=\"scale_shift[{i}]\"\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ── LEFT: SPI + zero_point_a/b/c ─────────────────────────────────────────────
f.write("\t(left\n")
f.write("\t\t(pin name=\"spi_sck\"\t\toffset=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"spi_cs_n\"\t\tskip=2.0  layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"spi_mosi\"\t\tskip=2.0  layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"spi_miso\"\t\tskip=2.0  layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(8):
    f.write(f"\t\t(pin name=\"zero_point_a[{i}]\"\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(8):
    f.write(f"\t\t(pin name=\"zero_point_b[{i}]\"\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(8):
    f.write(f"\t\t(pin name=\"zero_point_c[{i}]\"\tskip=1.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

# ── RIGHT: TPU control ────────────────────────────────────────────────────────
f.write("\t(right\n")
f.write("\t\t(pin name=\"tpu_start\"\t\toffset=5.0 layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_idle\"\t\tskip=5.0  layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_working\"\t\tskip=5.0  layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_done\"\t\tskip=5.0  layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_core_rst\"\tskip=5.0  layer=5 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t)\n")

f.write(")\n")
f.close()

top_count    = 32
bottom_count = 2 + 16 + 5
left_count   = 4 + 8 + 8 + 8
right_count  = 5
print(f"Generated pins.io  (top={top_count}, bottom={bottom_count}, left={left_count}, right={right_count})")
