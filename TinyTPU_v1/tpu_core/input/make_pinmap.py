#!/bin/python3
f = open("./pins.io.auto", "w")

f.write("(globals\n")
f.write("\tversion = 3\n")
f.write("\tio_order = default\n")
f.write(")\n")
f.write("(iopin\n")

# -----------------------------
# Top: 主要输出数据
# -----------------------------
f.write("\t(top\n")

f.write("\t\t(pin name=\"outcome_full_TEST[0]\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 264):
    f.write("\t\t(pin name=\"outcome_full_TEST[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(64):
    f.write("\t\t(pin name=\"outcome_quantized[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Bottom: SRAM输入数据
# -----------------------------
f.write("\t(bottom\n")

f.write("\t\t(pin name=\"sram_rdata_a[0]\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
for i in range(1, 64):
    f.write("\t\t(pin name=\"sram_rdata_a[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(64):
    f.write("\t\t(pin name=\"sram_rdata_b[" + str(i) + "]\"\t\tskip=0.70 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Left: 时钟、启动、矩阵参数
# -----------------------------
f.write("\t(left\n")

f.write("\t\t(pin name=\"clk\"\t\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"rstn\"\t\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"tpu_start\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"keep_pe_value\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(7):
    f.write("\t\t(pin name=\"m[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(7):
    f.write("\t\t(pin name=\"n[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(7):
    f.write("\t\t(pin name=\"k[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(7):
    f.write("\t\t(pin name=\"num_computation[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

# -----------------------------
# Right: 量化参数、地址、控制输出
# -----------------------------
f.write("\t(right\n")

for i in range(8):
    if i == 0:
        f.write("\t\t(pin name=\"zero_point_a[0]\"\t\toffset=26.0000 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
    else:
        f.write("\t\t(pin name=\"zero_point_a[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(8):
    f.write("\t\t(pin name=\"zero_point_b[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(8):
    f.write("\t\t(pin name=\"zero_point_c[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(32):
    f.write("\t\t(pin name=\"bias[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(16):
    f.write("\t\t(pin name=\"scale_factor[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(5):
    f.write("\t\t(pin name=\"scale_shift[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(9):
    f.write("\t\t(pin name=\"a_raddr[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(9):
    f.write("\t\t(pin name=\"b_raddr[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(9):
    f.write("\t\t(pin name=\"c_waddr[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(9):
    f.write("\t\t(pin name=\"c_row_idx_TEST[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(9):
    f.write("\t\t(pin name=\"c_col_idx_TEST[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

for i in range(9):
    f.write("\t\t(pin name=\"bias_addr[" + str(i) + "]\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t\t(pin name=\"a_b_sram_rd_en\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"bias_sram_rd_en\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"c_sram_w_en\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")
f.write("\t\t(pin name=\"done_flag\"\t\tskip=10.0 layer=4 width=0.1000 depth=0.5200 place_status=fixed)\n")

f.write("\t)\n")

f.write(")\n")
f.close()