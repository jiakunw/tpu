//////////////////////////////////////////////////////////////////////////////
// TPU MMIO Register File
// 
// Address Map (4-bit address = original address >> 2):
//   0x0 (0x00) = Control Register   (R/W)
//   0x1 (0x04) = Status Register    (R only, updated by TPU)
//   0x2 (0x08) = Dimension M        (R/W)
//   0x3 (0x0C) = Dimension N        (R/W)
//   0x4 (0x10) = Dimension K        (R/W)
//   0x5 (0x14) = Num Computation    (R/W) [6:0]
//   0x6 (0x18) = Zero Point A       (R/W) [7:0]
//   0x7 (0x1C) = Zero Point B       (R/W) [7:0]
//   0x8 (0x20) = Zero Point C       (R/W) [7:0]
//   0x9 (0x24) = Scale Factor LO    (R/W) [7:0]  tpu_scale_factor[7:0]
//   0xA (0x28) = Scale Factor HI    (R/W) [7:0]  tpu_scale_factor[15:8]
//   0xB (0x2C) = Scale Shift        (R/W) [4:0]
//   0xC (0x30) = Keep PE Value      (R/W) [1:0]
//   0xD (0x34) = Full Precision     (R/W) [0]
//
//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module mmio_register_file (
    input  logic        clk,
    input  logic        rstn,
    
    // SPI Slave interface
    input  logic [3:0]  reg_addr,
    input  logic        reg_rd,
    input  logic        reg_wr,
    input  logic [7:0]  reg_wdata,
    output logic [7:0]  reg_rdata,
    output logic        reg_addr_valid,
    output logic        reg_writable,

    // Scan chain interface (sc_mmio_ctrl=1: use sc values, 0: use system values)
    input  logic        sc_mmio_ctrl,
    input  logic [3:0]  sc_mmio_reg_addr,
    input  logic        sc_mmio_reg_rd,
    input  logic        sc_mmio_reg_wr,
    input  logic [7:0]  sc_mmio_reg_wdata,
    output logic [7:0]  sc_mmio_reg_rdata,
    output logic        sc_mmio_reg_addr_valid,
    output logic        sc_mmio_reg_writable,
    
    // TPU control interface
    output logic        fsm_start,
    output logic [1:0]  fsm_keep_pe_value,
    output logic        fsm_tpu_full_percision,
    input  logic        fsm_idle,
    input  logic        fsm_working,
    input  logic        fsm_done,
    
    // Dimension outputs to TPU
    output logic [6:0]  tpu_dim_m,
    output logic [6:0]  tpu_dim_n,
    output logic [6:0]  tpu_dim_k,
    output logic [6:0]  tpu_num_computation,

    // Zero point outputs
    output logic [7:0]  tpu_zero_point_a,
    output logic [7:0]  tpu_zero_point_b,
    output logic [7:0]  tpu_zero_point_c,

    // Scale outputs
    output logic [15:0] tpu_scale_factor,
    output logic [4:0]  tpu_scale_shift
);

    //=========================================================================
    // Scan chain mux signals
    //=========================================================================
    logic [3:0] reg_addr_mux;
    logic       reg_rd_mux;
    logic       reg_wr_mux;
    logic [7:0] reg_wdata_mux;

    always_comb begin
        if (sc_mmio_ctrl) begin
            reg_addr_mux  = sc_mmio_reg_addr;
            reg_rd_mux    = sc_mmio_reg_rd;
            reg_wr_mux    = sc_mmio_reg_wr;
            reg_wdata_mux = sc_mmio_reg_wdata;
        end else begin
            reg_addr_mux  = reg_addr;
            reg_rd_mux    = reg_rd;
            reg_wr_mux    = reg_wr;
            reg_wdata_mux = reg_wdata;
        end
    end

    assign sc_mmio_reg_rdata      = reg_rdata;
    assign sc_mmio_reg_addr_valid = reg_addr_valid;
    assign sc_mmio_reg_writable   = reg_writable;

    //=========================================================================
    // Address definitions
    //=========================================================================
    localparam ADDR_CONTROL         = 4'h0;
    localparam ADDR_STATUS          = 4'h1;
    localparam ADDR_DIM_M           = 4'h2;
    localparam ADDR_DIM_N           = 4'h3;
    localparam ADDR_DIM_K           = 4'h4;
    localparam ADDR_NUM_COMPUTATION = 4'h5;
    localparam ADDR_ZP_A            = 4'h6;
    localparam ADDR_ZP_B            = 4'h7;
    localparam ADDR_ZP_C            = 4'h8;
    localparam ADDR_SCALE_LO        = 4'h9;
    localparam ADDR_SCALE_HI        = 4'hA;
    localparam ADDR_SCALE_SHIFT     = 4'hB;
    localparam ADDR_KEEP_PE_VALUE   = 4'hC;
    localparam ADDR_FULL_PERCISION  = 4'hD;

    //=========================================================================
    // Register storage
    //=========================================================================
    logic [7:0] control_reg;
    logic [7:0] status_reg;
    logic [7:0] tpu_dim_m_reg;
    logic [7:0] tpu_dim_n_reg;
    logic [7:0] tpu_dim_k_reg;
    logic [7:0] num_computation_reg;
    logic [7:0] zp_a_reg;
    logic [7:0] zp_b_reg;
    logic [7:0] zp_c_reg;
    logic [7:0] scale_lo_reg;
    logic [7:0] scale_hi_reg;
    logic [7:0] tpu_scale_shift_reg;
    logic [7:0] keep_pe_value_reg;
    logic [7:0] full_percision_reg;
    logic       done_latched;

    //=========================================================================
    // Address validity
    //=========================================================================
    always_comb begin
        case (reg_addr_mux)
            ADDR_CONTROL,
            ADDR_STATUS,
            ADDR_DIM_M,
            ADDR_DIM_N,
            ADDR_DIM_K,
            ADDR_NUM_COMPUTATION,
            ADDR_ZP_A,
            ADDR_ZP_B,
            ADDR_ZP_C,
            ADDR_SCALE_LO,
            ADDR_SCALE_HI,
            ADDR_SCALE_SHIFT,
            ADDR_KEEP_PE_VALUE,
            ADDR_FULL_PERCISION: reg_addr_valid = 1'b1;
            default:             reg_addr_valid = 1'b0;
        endcase
    end

    //=========================================================================
    // Writable check (STATUS is read-only)
    //=========================================================================
    always_comb begin
        case (reg_addr_mux)
            ADDR_CONTROL,
            ADDR_DIM_M,
            ADDR_DIM_N,
            ADDR_DIM_K,
            ADDR_NUM_COMPUTATION,
            ADDR_ZP_A,
            ADDR_ZP_B,
            ADDR_ZP_C,
            ADDR_SCALE_LO,
            ADDR_SCALE_HI,
            ADDR_SCALE_SHIFT,
            ADDR_KEEP_PE_VALUE,
            ADDR_FULL_PERCISION: reg_writable = 1'b1;
            ADDR_STATUS:         reg_writable = 1'b0;
            default:             reg_writable = 1'b0;
        endcase
    end

    //=========================================================================
    // Read data mux
    //=========================================================================
    always_comb begin
        case (reg_addr_mux)
            ADDR_CONTROL:     reg_rdata = control_reg;
            ADDR_STATUS:      reg_rdata = status_reg;
            ADDR_DIM_M:       reg_rdata = tpu_dim_m_reg;
            ADDR_DIM_N:       reg_rdata = tpu_dim_n_reg;
            ADDR_DIM_K:              reg_rdata = tpu_dim_k_reg;
            ADDR_NUM_COMPUTATION:    reg_rdata = num_computation_reg;
            ADDR_ZP_A:               reg_rdata = zp_a_reg;
            ADDR_ZP_B:        reg_rdata = zp_b_reg;
            ADDR_ZP_C:        reg_rdata = zp_c_reg;
            ADDR_SCALE_LO:    reg_rdata = scale_lo_reg;
            ADDR_SCALE_HI:    reg_rdata = scale_hi_reg;
            ADDR_SCALE_SHIFT:    reg_rdata = tpu_scale_shift_reg;
            ADDR_KEEP_PE_VALUE:  reg_rdata = keep_pe_value_reg;
            ADDR_FULL_PERCISION: reg_rdata = full_percision_reg;
            default:             reg_rdata = 8'h00;
        endcase
    end

    //=========================================================================
    // Control Register (0x00)
    // [0]: start - write 1 to start TPU
    //             stays HIGH until fsm_done is asserted, then clears
    // [7:1]: reserved
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) begin
            control_reg <= 8'h00;
        end else if (fsm_done) begin
            control_reg[0] <= 1'b0;   // clear start on done (highest priority)
        end else if (reg_wr_mux && reg_addr_mux == ADDR_CONTROL) begin
            control_reg <= reg_wdata_mux;
        end
    end
    assign fsm_start = control_reg[0];

    //=========================================================================
    // Status Register (0x04) - READ ONLY
    // [0]: idle    - TPU is idle
    // [1]: working - TPU is working
    // [2]: done    - TPU is done (clear on read)
    // [7:3]: reserved
    //=========================================================================
    always_comb begin
        status_reg    = 8'h00;
        status_reg[0] = fsm_idle;
        status_reg[1] = fsm_working;
        status_reg[2] = done_latched;
    end
    
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) begin
            done_latched  <= 1'b0;
        end else if (fsm_done) begin
            done_latched  <= 1'b1;
        end else if (reg_rd_mux && reg_addr_mux == ADDR_STATUS && done_latched) begin
            done_latched  <= 1'b0;
        end
    end

    //=========================================================================
    // Dimension Register M (0x08)
    // [5:0]: dimension m, [7:6]: reserved
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) tpu_dim_m_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_DIM_M) tpu_dim_m_reg <= reg_wdata_mux;
    end
    assign tpu_dim_m = tpu_dim_m_reg[6:0];

    //=========================================================================
    // Dimension Register N (0x0C)
    // [5:0]: dimension n, [7:6]: reserved
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) tpu_dim_n_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_DIM_N) tpu_dim_n_reg <= reg_wdata_mux;
    end
    assign tpu_dim_n = tpu_dim_n_reg[6:0];

    //=========================================================================
    // Dimension Register K (0x10)
    // [5:0]: dimension k, [7:6]: reserved
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) tpu_dim_k_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_DIM_K) tpu_dim_k_reg <= reg_wdata_mux;
    end
    assign tpu_dim_k = tpu_dim_k_reg[6:0];

    //=========================================================================
    // Num Computation (0x14) - [6:0], [7] reserved
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) num_computation_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_NUM_COMPUTATION) num_computation_reg <= reg_wdata_mux;
    end
    assign tpu_num_computation = num_computation_reg[6:0];

    //=========================================================================
    // Zero Point A (0x14) - [7:0]
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) zp_a_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_ZP_A) zp_a_reg <= reg_wdata_mux;
    end
    assign tpu_zero_point_a = zp_a_reg;

    //=========================================================================
    // Zero Point B (0x18) - [7:0]
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) zp_b_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_ZP_B) zp_b_reg <= reg_wdata_mux;
    end
    assign tpu_zero_point_b = zp_b_reg;

    //=========================================================================
    // Zero Point C (0x1C) - [7:0]
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) zp_c_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_ZP_C) zp_c_reg <= reg_wdata_mux;
    end
    assign tpu_zero_point_c = zp_c_reg;

    //=========================================================================
    // Scale Factor LO (0x20) - tpu_scale_factor[7:0]
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) scale_lo_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_SCALE_LO) scale_lo_reg <= reg_wdata_mux;
    end

    //=========================================================================
    // Scale Factor HI (0x24) - tpu_scale_factor[15:8]
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) scale_hi_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_SCALE_HI) scale_hi_reg <= reg_wdata_mux;
    end

    assign tpu_scale_factor = {scale_hi_reg, scale_lo_reg};

    //=========================================================================
    // Scale Shift (0x28) - [4:0], [7:5] reserved
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) tpu_scale_shift_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_SCALE_SHIFT) tpu_scale_shift_reg <= reg_wdata_mux;
    end
    assign tpu_scale_shift = tpu_scale_shift_reg[4:0];

    //=========================================================================
    // Keep PE Value (0x2C) - [1:0], [7:2] reserved
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) keep_pe_value_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_KEEP_PE_VALUE) keep_pe_value_reg <= reg_wdata_mux;
    end
    assign fsm_keep_pe_value = keep_pe_value_reg[1:0];

    //=========================================================================
    // Full Precision (0x30) - [0], [7:1] reserved
    //=========================================================================
    // synopsys sync_set_reset "rstn"
    always_ff @(posedge clk) begin
        if (!rstn) full_percision_reg <= 8'h00;
        else if (reg_wr_mux && reg_addr_mux == ADDR_FULL_PERCISION) full_percision_reg <= reg_wdata_mux;
    end
    assign fsm_tpu_full_percision = full_percision_reg[0];

endmodule
