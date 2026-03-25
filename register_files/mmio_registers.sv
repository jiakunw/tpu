//////////////////////////////////////////////////////////////////////////////
// TPU MMIO Register File
// 
// Address Map (4-bit address = original address >> 2):
//   0x0 (0x00) = Control Register (R/W)
//   0x1 (0x04) = Status Register  (R only, updated by TPU)
//   0x2 (0x08) = Dimension M      (R/W)
//   0x3 (0x0C) = Dimension N      (R/W)
//   0x4 (0x10) = Dimension K      (R/W)
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
    output logic        reg_addr_valid,  // Address exists (for read or write)
    output logic        reg_writable,    // Address is writable
    
    // TPU control interface
    output logic        tpu_start,       // Pulse when start bit written
    input  logic        tpu_idle,        // TPU is idle
    input  logic        tpu_working,     // TPU is working
    input  logic        tpu_done,        // TPU computation done (pulse)
    
    // Dimension outputs to TPU
    output logic [5:0]  dim_m,
    output logic [5:0]  dim_n,
    output logic [5:0]  dim_k
);

    //=========================================================================
    // Address definitions (original address >> 2)
    //=========================================================================
    localparam ADDR_CONTROL = 4'h0;  // 0x00 >> 2 = 0
    localparam ADDR_STATUS  = 4'h1;  // 0x04 >> 2 = 1
    localparam ADDR_DIM_M   = 4'h2;  // 0x08 >> 2 = 2
    localparam ADDR_DIM_N   = 4'h3;  // 0x0C >> 2 = 3
    localparam ADDR_DIM_K   = 4'h4;  // 0x10 >> 2 = 4

    //=========================================================================
    // Register storage
    //=========================================================================
    logic [7:0] control_reg;
    logic [7:0] status_reg;
    logic [7:0] dim_m_reg;
    logic [7:0] dim_n_reg;
    logic [7:0] dim_k_reg;
    logic       done_latched;

    //=========================================================================
    // Address validity - does this address exist?
    //=========================================================================
    always_comb begin
        case (reg_addr)
            ADDR_CONTROL,
            ADDR_STATUS,
            ADDR_DIM_M,
            ADDR_DIM_N,
            ADDR_DIM_K:  reg_addr_valid = 1'b1;
            default:     reg_addr_valid = 1'b0;
        endcase
    end

    //=========================================================================
    // Writable check - is this address writable?
    // Status register is READ-ONLY
    //=========================================================================
    always_comb begin
        case (reg_addr)
            ADDR_CONTROL,
            ADDR_DIM_M,
            ADDR_DIM_N,
            ADDR_DIM_K:  reg_writable = 1'b1;
            ADDR_STATUS: reg_writable = 1'b0;  // Read-only!
            default:     reg_writable = 1'b0;
        endcase
    end

    //=========================================================================
    // Read data mux
    //=========================================================================
    always_comb begin
        case (reg_addr)
            ADDR_CONTROL: reg_rdata = control_reg;
            ADDR_STATUS:  reg_rdata = status_reg;
            ADDR_DIM_M:   reg_rdata = dim_m_reg;
            ADDR_DIM_N:   reg_rdata = dim_n_reg;
            ADDR_DIM_K:   reg_rdata = dim_k_reg;
            default:      reg_rdata = 8'h00;
        endcase
    end

    //=========================================================================
    // Control Register (0x00)
    // [0]: start - write 1 to start TPU, auto-clears next cycle
    // [7:1]: reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            control_reg <= 8'h00;
        end else if (reg_wr && reg_addr == ADDR_CONTROL) begin
            control_reg <= reg_wdata;
        end else if (control_reg[0]) begin
            // Auto-clear start bit after one cycle
            control_reg[0] <= 1'b0;
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
        status_reg = 8'h00;
        status_reg[0] = tpu_idle;
        status_reg[1] = tpu_working;
        status_reg[2] = done_latched;
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_latched <= 1'b0;
        end else if (tpu_done) begin
            // Latch done signal from TPU
            done_latched <= 1'b1;
        end else if (reg_rd && reg_addr == ADDR_STATUS) begin
            // Clear on read
            done_latched <= 1'b0;
        end
    end

    //=========================================================================
    // Dimension Register M (0x08)
    // [5:0]: dimension m for m x n * n x k matmul
    // [7:6]: reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dim_m_reg <= 8'h00;
        end else if (reg_wr && reg_addr == ADDR_DIM_M) begin
            dim_m_reg <= reg_wdata;
        end
    end
    
    assign dim_m = dim_m_reg[5:0];

    //=========================================================================
    // Dimension Register N (0x0C)
    // [5:0]: dimension n for m x n * n x k matmul
    // [7:6]: reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dim_n_reg <= 8'h00;
        end else if (reg_wr && reg_addr == ADDR_DIM_N) begin
            dim_n_reg <= reg_wdata;
        end
    end
    
    assign dim_n = dim_n_reg[5:0];

    //=========================================================================
    // Dimension Register K (0x10)
    // [5:0]: dimension k for m x n * n x k matmul
    // [7:6]: reserved
    //=========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dim_k_reg <= 8'h00;
        end else if (reg_wr && reg_addr == ADDR_DIM_K) begin
            dim_k_reg <= reg_wdata;
        end
    end
    
    assign dim_k = dim_k_reg[5:0];

endmodule