import os
import random
import sys

def write_uint8_hex_row_by_row(filename, X_3d, num_comp, R, C):
    with open(filename, "a") as f:  
        for comp in range(num_comp):
            for i in range(R):
                for j in range(C):
                    v = X_3d[i][j][comp] & 0xFF   # 强制 UINT8
                    f.write(f"{v:02X}\n")

def write_int32_hex_row_by_row(filename, X_3d, num_comp, R, C):
    with open(filename, "a") as f:   # append 模式
        for comp in range(num_comp):
            for i in range(R):
                for j in range(C):
                    v = X_3d[i][j][comp] & 0xFFFFFFFF 
                    f.write(f"{v:08X}\n")

def write_int33_hex_row_by_row(filename, X_3d, num_comp, R, C):
    with open(filename, "a") as f:   # append 模式
        for comp in range(num_comp):
            for i in range(R):
                for j in range(C):
                    f.write(int_to_twos_complement(X_3d[i][j][comp], 33) + "\n")

def write_uint8_hex_row_by_row(filename, X_3d, num_comp, R, C):
    with open(filename, "a") as f:   # append 模式
        for comp in range(num_comp):
            for i in range(R):
                for j in range(C):
                    v = X_3d[i][j][comp] & 0xFF   # 保证 8bit
                    f.write(f"{v:02X}\n")         # 2位hex（uint8）

def hw_round(x):
    if x >= 0:
        return int(x + 0.5)
    else:
        return int(x - 0.5)

def generate_random_binary(width):
    value = random.randint(0, 2**width - 1)
    return format(value, f'0{width}b')

def convert_16bit_binary_to_q016(binary):
    value = int(binary, 2)
    return value / 65536.0

def int_to_twos_complement(value, width):
    return format(value & ((1 << width) - 1), f'0{width}b')

def relu_clamp(x):
    if x < 0:
        return 0
    elif x > 255:
        return 255
    else:
        return x

import os

def gen_testbench_from_template(template_path, out_folder, m, n, k, num_comp,
                                out_name="testbench.v"):
    # 读模板
    with open(template_path, "r") as f:
        tb = f.read()

    # 替换 marker
    tb = tb.replace("@M_DIM", str(m))
    tb = tb.replace("@N_DIM", str(n))
    tb = tb.replace("@K_DIM", str(k))
    tb = tb.replace("@NUM_COMPUTATION", str(num_comp))

    # 写到目标目录
    current_dir = os.path.dirname(os.path.abspath(__file__))
    out_path = os.path.join(current_dir, out_name)
    with open(out_path, "w") as f:
        f.write(tb)

    return out_path


def main():

    m = 8
    n = 1024
    k = 8
    num_comp = 1

    # if (m*n*num_comp > 4096) or (n*k*num_comp > 4096) or (m*k*num_comp > 4096):
    #     print("Matrix size exceeds limit (4096). Program terminated.")
    #     sys.exit()

    # create folder for test case
    folder_name = f"{m}_{n}_{k}_{num_comp}"
    folder_path = f"./{folder_name}"

    os.makedirs(folder_path, exist_ok=True)

    A_path = os.path.join(folder_path, "A.txt")
    B_path = os.path.join(folder_path, "B.txt")
    C_path = os.path.join(folder_path, "C.txt")
    Clamped_path = os.path.join(folder_path, "C_clamped.txt")
    Bias_path = os.path.join(folder_path, "bias.txt")
    Out_bias_path = os.path.join(folder_path, "out_bias.txt")
    Out_scale_path = os.path.join(folder_path, "out_scale.txt")

    open(A_path, "w").close()
    open(B_path, "w").close()
    open(C_path, "w").close()
    open(Clamped_path, "w").close()
    open(Bias_path, "w").close()
    open(Out_bias_path, "w").close()
    open(Out_scale_path, "w").close()

    # generate testbench from template
    template_path = "./testbench_template.v"
    tb_out_path = gen_testbench_from_template(
        template_path=template_path,
        out_folder=folder_path,
        m=m, n=n, k=k,
        num_comp=num_comp,
        out_name="testbench.v"
    )

    # create random uint8 data for A and B
    A_u8 = [[[0 for _ in range(num_comp)] for _ in range(n)] for _ in range(m)]
    B_u8 = [[[0 for _ in range(num_comp)] for _ in range(k)] for _ in range(n)]

    for comp in range(num_comp):
        for i in range(m):
            for j in range(n):
                A_u8[i][j][comp] = random.randint(0, 255)

        for i in range(n):
            for j in range(k):
                B_u8[i][j][comp] = random.randint(0, 255)

    # save A and B to files in hex format, row by row, component by component
    write_uint8_hex_row_by_row(A_path, A_u8, num_comp, m, n)
    write_uint8_hex_row_by_row(B_path, B_u8, num_comp, n, k)

    # generate randome scale factor
    scale_factor_binary = generate_random_binary(16)
    scale_factor = convert_16bit_binary_to_q016(scale_factor_binary)
    shift = random.randint(0, 31)
    with open(Out_scale_path, "w") as f:
        f.write(scale_factor_binary + "\n")
        f.write(format(shift, "05b") + "\n")

    # create A and B with bias
    bias1 = random.randint(0, 255)
    bias2 = random.randint(0, 255)
    bias3 = random.randint(0, 255)
    with open(Bias_path, "a") as f:
        f.write(f"{bias1 & 0xFF:02X}\n")
        f.write(f"{bias2 & 0xFF:02X}\n")
        f.write(f"{bias3 & 0xFF:02X}\n")

    # create random int32 output bias
    out_bias = [random.randint(-(2**30), 2**30 - 1) for _ in range(m)]

    with open(Out_bias_path, "w") as f:
        for x in out_bias:
            f.write(f"{x & 0xFFFFFFFF:08X}\n")

    # create A and B with bias removed
    A = [[[A_u8[i][j][comp] - bias1 for comp in range(num_comp)]
            for j in range(n)]
            for i in range(m)]

    B = [[[B_u8[i][j][comp] - bias2 for comp in range(num_comp)]
            for j in range(k)]
            for i in range(n)]

    # compute C = A * B
    C = [[[0 for _ in range(num_comp)]
        for _ in range(k)]
        for _ in range(m)]

    C_clamped = [[[0 for _ in range(num_comp)]
        for _ in range(k)]
        for _ in range(m)]

    for comp in range(num_comp):
        for i in range(m):
            for j in range(k):
                acc = 0
                for t in range(n):
                    acc += A[i][t][comp] * B[t][j][comp]
                C[i][j][comp] = acc + out_bias[i]
                C[i][j][comp] = C[i][j][comp] * scale_factor / (2**shift)
                C[i][j][comp] = hw_round(C[i][j][comp])
                C[i][j][comp] = C[i][j][comp] + bias3
                C_clamped[i][j][comp] = relu_clamp(C[i][j][comp])

    write_int33_hex_row_by_row(C_path, C, num_comp, m, k)
    write_uint8_hex_row_by_row(Clamped_path, C_clamped, num_comp, m, k)

if __name__ == "__main__":
    main()
