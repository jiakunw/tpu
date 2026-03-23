#!/bin/python3
f = open("./pins.io.auto", "w")
f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# -----------------------------
# Top: 输出信号
# -----------------------------
f.write("\t(top\n")

# sram_wdata_c[0..255]
f.write("\t\t(pin name=\"sram_wdata_c[0]\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 256):
    f.write("\t\t(pin name=\"sram_wdata_c[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

# out_ready
f.write("\t\t(pin name=\"out_ready\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

# row_idx[2:0]
for i in range(3):
    f.write("\t\t(pin name=\"row_idx[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Bottom: SRAM 输入数据
# -----------------------------
f.write("\t(bottom\n")

# sram_rdata_a0[31:0]
f.write("\t\t(pin name=\"sram_rdata_a0[0]\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 32):
    f.write("\t\t(pin name=\"sram_rdata_a0[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

# sram_rdata_a1[31:0]
for i in range(32):
    f.write("\t\t(pin name=\"sram_rdata_a1[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

# sram_rdata_b0[31:0]
for i in range(32):
    f.write("\t\t(pin name=\"sram_rdata_b0[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

# sram_rdata_b1[31:0]
for i in range(32):
    f.write("\t\t(pin name=\"sram_rdata_b1[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Left: 时钟和控制信号
# -----------------------------
f.write("\t(left\n")
f.write("\t\t(pin name=\"clk\"\t\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rstn\"\t\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"alu_start\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"all_input_are_fed\"\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"keep_pe_value\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

# zero_point_a[7:0]
for i in range(8):
    f.write("\t\t(pin name=\"zero_point_a[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

# zero_point_b[7:0]
for i in range(8):
    f.write("\t\t(pin name=\"zero_point_b[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Right: tile_num
# -----------------------------
f.write("\t(right\n")
f.write("\t\t(pin name=\"tile_num[0]\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 6):
    f.write("\t\t(pin name=\"tile_num[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

f.write(")\n")
f.close()