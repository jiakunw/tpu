#!/bin/python3
f = open("./pins.io.auto", "w")

f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# -----------------------------
# Top: 输出索引
# -----------------------------
f.write("\t(top\n")

f.write("\t\t(pin name=\"c_row_idx[0]\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 9):
    f.write("\t\t(pin name=\"c_row_idx[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(9):
    f.write("\t\t(pin name=\"c_col_idx[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Bottom: 输入参数
# -----------------------------
f.write("\t(bottom\n")

f.write("\t\t(pin name=\"row_idx[0]\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 3):
    f.write("\t\t(pin name=\"row_idx[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(7):
    f.write("\t\t(pin name=\"num_computation[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(7):
    f.write("\t\t(pin name=\"m[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(7):
    f.write("\t\t(pin name=\"k[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Left: 时钟和控制输入
# -----------------------------
f.write("\t(left\n")

f.write("\t\t(pin name=\"clk\"\t\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rstn\"\t\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"alu_init\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"in_valid\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Right: 控制输出
# -----------------------------
f.write("\t(right\n")

f.write("\t\t(pin name=\"done_flag\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

f.write(")\n")
f.close()