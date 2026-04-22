//////////////////////////////////////////////////////////////////////////////
// TPU MMIO Register File
// 
// Address Map (4-bit address = original address >> 2):
//   0x0 (0x00) = Control Register   (R/W)
//   0x1 (0x04) = Status Register    (R only, updated by TPU)
//   0x2 (0x08) = Dimension M        (R/W)
//   0x3 (0x0C) = Dimension N        (R/W)
//   0x4 (0x10) = Dimension K        (R/W)
//   0x5 (0x14) = Zero Point A       (R/W) [7:0]
//   0x6 (0x18) = Zero Point B       (R/W) [7:0]
//   0x7 (0x1C) = Zero Point C       (R/W) [7:0]
//   0x8 (0x20) = Scale Factor LO    (R/W) [7:0]  scale_factor[7:0]
//   0x9 (0x24) = Scale Factor HI    (R/W) [7:0]  scale_factor[15:8]
//   0xA (0x28) = Scale Shift        (R/W) [4:0]
//
//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tpu_mmio_regfile (
    input  logic        clk,
    input  logic        rst_n,
    
    // SPI Slave interface
    input  logic [3:0]  reg_addr,
    input  logic        reg_rd,
    input  logic        reg_wr,
    input  logic [7:0]  reg_wdata,
    output logic [7:0]  reg_rdata,
    output logic        reg_addr_valid,
    output logic        reg_writable,
    
    // TPU control interface
    output logic        tpu_start,
    input  logic        tpu_idle,
    input  logic        tpu_working,
    input  logic        tpu_done,
    
    // Dimension outputs to TPU
    output logic [5:0]  dim_m,
    output logic [5:0]  dim_n,
    output logic [5:0]  dim_k,

    // Zero point outputs
    output logic [7:0]  zero_point_a,
    output logic [7:0]  zero_point_b,
    output logic [7:0]  zero_point_c,

    // Scale outputs
    output logic [15:0] scale_factor,
    output logic [4:0]  scale_shift,

    // TPU core reset (pulse when done is read, to restart tpu_core)
    output logic        tpu_core_rst
);

    //=========================================================================
    // Address definitions
    //=========================================================================
    localparam ADDR_CONTROL    = 4'h0;
    localparam ADDR_STATUS     = 4'h1;
    localparam ADDR_DIM_M      = 4'h2;
    localparam ADDR_DIM_N      = 4'h3;
    localparam ADDR_DIM_K      = 4'h4;
    localparam ADDR_ZP_A       = 4'h5;
    localparam ADDR_ZP_B       = 4'h6;
    localparam ADDR_ZP_C       = 4'h7;
    localparam ADDR_SCALE_LO   = 4'h8;
    localparam ADDR_SCALE_HI   = 4'h9;
    localparam ADDR_SCALE_SHIFT = 4'hA;

    //=========================================================================
    // Register storage
    //=========================================================================
    logic [7:0] control_reg;
    logic [7:0] status_reg;
    logic [7:0] dim_m_reg;
    logic [7:0] dim_n_reg;
    logic [7:0] dim_k_reg;
    logic [7:0] zp_a_reg;
    logic [7:0] zp_b_reg;
    logic [7:0] zp_c_reg;
    logic [7:0] scale_lo_reg;
    logic [7:0] scale_hi_reg;
    logic [7:0] scale_shift_reg;
    logic       done_latched;

    //=========================================================================
    // Address validity
    //=========================================================================
    always_comb begin
        case (reg_addr)
            ADDR_CONTROL,
            ADDR_STATUS,
            ADDR_DIM_M,
            ADDR_DIM_N,
            ADDR_DIM_K,
            ADDR_ZP_A,
            ADDR_ZP_B,
            ADDR_ZP_C,
            ADDR_SCALE_LO,
            ADDR_SCALE_HI,
            ADDR_SCALE_SHIFT: reg_addr_valid = 1'b1;
            default:          reg_addr_valid = 1'b0;
        endcase
    end

    //=========================================================================
    // Writable check (STATUS is read-only)
    //=========================================================================
    always_comb begin
        case (reg_addr)
            ADDR_CONTROL,
            ADDR_DIM_M,
            ADDR_DIM_N,
            ADDR_DIM_K,
            ADDR_ZP_A,
            ADDR_ZP_B,
            ADDR_ZP_C,
            ADDR_SCALE_LO,
            ADDR_SCALE_HI,
            ADDR_SCALE_SHIFT: reg_writable = 1'b1;
            ADDR_STATUS:      reg_writable = 1'b0;
            default:          reg_writable = 1'b0;
        endcase
    end

    //=========================================================================
    // Read data mux
    //=========================================================================
    always_comb begin
        case (reg_addr)
            ADDR_CONTROL:     reg_rdata = control_reg;
            ADDR_STATUS:      reg_rdata = status_reg;
            ADDR_DIM_M:       reg_rdata = dim_m_reg;
            ADDR_DIM_N:       reg_rdata = dim_n_reg;
            ADDR_DIM_K:       reg_rdata = dim_k_reg;
            ADDR_ZP_A:        reg_rdata = zp_a_reg;
            ADDR_ZP_B:        reg_rdata = zp_b_reg;
            ADDR_ZP_C:        reg_rdata = zp_c_reg;
            ADDR_SCALE_LO:    reg_rdata = scale_lo_reg;
            ADDR_SCALE_HI:    reg_rdata = scale_hi_reg;
            ADDR_SCALE_SHIFT: reg_rdata = scale_shift_reg;
            default:          reg_rdata = 8'h00;
        endcase
    end

    //=========================================================================
    // Control Register (0x00)
    // [0]: start - write 1 to start TPU
    //             stays HIGH until tpu_done is asserted, then clears
    // [7:1]: reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            control_reg <= 8'h00;
        end else if (tpu_done) begin
            control_reg[0] <= 1'b0;   // clear start on done (highest priority)
        end else if (reg_wr && reg_addr == ADDR_CONTROL) begin
            control_reg <= reg_wdata;
        end
    end
    assign tpu_start = control_reg[0];

    //=========================================================================
    // Status Register (0x04) - READ ONLY
    // [0]: idle    - TPU is idle
    // [1]: working - TPU is working
    // [2]: done    - TPU is done (clear on read)
    // [7:3]: reserved
    //=========================================================================
    always_comb begin
        status_reg    = 8'h00;
        status_reg[0] = tpu_idle;
        status_reg[1] = tpu_working;
        status_reg[2] = done_latched;
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_latched  <= 1'b0;
            tpu_core_rst  <= 1'b0;
        end else if (tpu_done) begin
            done_latched  <= 1'b1;
            tpu_core_rst  <= 1'b0;
        end else if (reg_rd && reg_addr == ADDR_STATUS && done_latched) begin
            done_latched  <= 1'b0;
            tpu_core_rst  <= 1'b1;   // 1-cycle reset pulse to tpu_core
        end else begin
            tpu_core_rst  <= 1'b0;
        end
    end

    //=========================================================================
    // Dimension Register M (0x08)
    // [5:0]: dimension m, [7:6]: reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) dim_m_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_DIM_M) dim_m_reg <= reg_wdata;
    end
    assign dim_m = dim_m_reg[5:0];

    //=========================================================================
    // Dimension Register N (0x0C)
    // [5:0]: dimension n, [7:6]: reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) dim_n_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_DIM_N) dim_n_reg <= reg_wdata;
    end
    assign dim_n = dim_n_reg[5:0];

    //=========================================================================
    // Dimension Register K (0x10)
    // [5:0]: dimension k, [7:6]: reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) dim_k_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_DIM_K) dim_k_reg <= reg_wdata;
    end
    assign dim_k = dim_k_reg[5:0];

    //=========================================================================
    // Zero Point A (0x14) - [7:0]
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) zp_a_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_ZP_A) zp_a_reg <= reg_wdata;
    end
    assign zero_point_a = zp_a_reg;

    //=========================================================================
    // Zero Point B (0x18) - [7:0]
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) zp_b_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_ZP_B) zp_b_reg <= reg_wdata;
    end
    assign zero_point_b = zp_b_reg;

    //=========================================================================
    // Zero Point C (0x1C) - [7:0]
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) zp_c_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_ZP_C) zp_c_reg <= reg_wdata;
    end
    assign zero_point_c = zp_c_reg;

    //=========================================================================
    // Scale Factor LO (0x20) - scale_factor[7:0]
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) scale_lo_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_SCALE_LO) scale_lo_reg <= reg_wdata;
    end

    //=========================================================================
    // Scale Factor HI (0x24) - scale_factor[15:8]
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) scale_hi_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_SCALE_HI) scale_hi_reg <= reg_wdata;
    end

    assign scale_factor = {scale_hi_reg, scale_lo_reg};

    //=========================================================================
    // Scale Shift (0x28) - [4:0], [7:5] reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) scale_shift_reg <= 8'h00;
        else if (reg_wr && reg_addr == ADDR_SCALE_SHIFT) scale_shift_reg <= reg_wdata;
    end
    assign scale_shift = scale_shift_reg[4:0];

endmodule
