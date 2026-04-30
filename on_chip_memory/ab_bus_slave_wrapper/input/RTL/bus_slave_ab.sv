///////////////////////////////////////////////////////////////////////////////
// bus_slave_ab.sv
//
// TPU Bus Slave - AB Channel
//
// Writes Matrix A (M×N bytes) and Matrix B (N×K bytes) simultaneously.
// Two independent counters with independent write enables:
//   cnt_a counts to M*N, after which sram_a_we is deasserted
//   cnt_b counts to N*K, after which sram_b_we is deasserted
//
// Dimensions (M, N, K) are provided from on-chip register file and must
// be valid before CHAB_START is asserted.
//
// Negedge sampling: master drives signals at posedge BUS_CLK.
// Slave samples at negedge -> 50ns setup margin before next posedge.
//
// Software must transpose Matrix A before sending (row-major, transposed).
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module bus_slave_ab #(
    parameter SRAM_AW = 12,
    parameter DW      = 8
)(
    input  logic              clk,
    input  logic              rstn,

    // Dimensions from on-chip register file (valid before CHAB_START)
    // Each value is the actual dimension divided by 8 (e.g. M=16 -> DIM_M=2)
    input  logic [6:0]        dim_m,           // rows of A / 8
    input  logic [6:0]        dim_n,           // cols of A / 8 = rows of B / 8
    input  logic [6:0]        dim_k,           // cols of B / 8
    input  logic [6:0]        num_computation, // number of matrix multiply blocks

    // Bus Interface (driven by master at posedge BUS_CLK)
    input  logic              chab_start,
    input  logic [DW-1:0]     chab_wdata_a,
    input  logic [DW-1:0]     chab_wdata_b,
    input  logic              chab_wr,

    // SRAM_A Interface (M×N bytes)
    output logic               sram_a_we,
    output logic [SRAM_AW-1:0] sram_a_addr,
    output logic [DW-1:0]      sram_a_din,

    // SRAM_B Interface (N×K bytes)
    output logic               sram_b_we,
    output logic [SRAM_AW-1:0] sram_b_addr,
    output logic [DW-1:0]      sram_b_din
);

    localparam CNT_W = SRAM_AW + 1;

    // =========================================================================
    // Negedge-sampled bus signals
    // =========================================================================
    logic              chab_wr_s;
    logic [DW-1:0]     chab_wdata_a_s;
    logic [DW-1:0]     chab_wdata_b_s;

    // Byte counts: M*N and N*K (registered at START to latch stable dims)
    logic [SRAM_AW:0] max_a;   // M * N
    logic [SRAM_AW:0] max_b;   // N * K

    // Independent counters
    logic [SRAM_AW:0] cnt_a;
    logic [SRAM_AW:0] cnt_b;

    // Write enable flags (cleared when counter reaches max)
    logic we_a_en;
    logic we_b_en;

    // synopsys sync_set_reset "rstn"
    always_ff @(negedge clk) begin
        if (!rstn) begin
            chab_wr_s      <= 1'b0;
            chab_wdata_a_s <= '0;
            chab_wdata_b_s <= '0;
            cnt_a          <= '0;
            cnt_b          <= '0;
            max_a          <= '0;
            max_b          <= '0;
            we_a_en        <= 1'b0;
            we_b_en        <= 1'b0;
        end else begin
            // Sample bus inputs
            chab_wr_s      <= chab_wr;
            chab_wdata_a_s <= chab_wdata_a;
            chab_wdata_b_s <= chab_wdata_b;

            if (chab_start) begin
                // Latch dimensions and reset counters
                cnt_a   <= '0;
                cnt_b   <= '0;
                max_a   <= CNT_W'(num_computation) * (CNT_W'(dim_m << 3) * CNT_W'(dim_n << 3));
                max_b   <= CNT_W'(num_computation) * (CNT_W'(dim_n << 3) * CNT_W'(dim_k << 3));
                we_a_en <= 1'b1;
                we_b_en <= 1'b1;
            end else if (chab_wr_s) begin
                // Advance counter A if still writing
                if (we_a_en) begin
                    if (cnt_a + 1 >= max_a) begin
                        cnt_a   <= cnt_a + 1'b1;
                        we_a_en <= 1'b0;
                    end else begin
                        cnt_a <= cnt_a + 1'b1;
                    end
                end
                // Advance counter B if still writing
                if (we_b_en) begin
                    if (cnt_b + 1 >= max_b) begin
                        cnt_b   <= cnt_b + 1'b1;
                        we_b_en <= 1'b0;
                    end else begin
                        cnt_b <= cnt_b + 1'b1;
                    end
                end
            end
        end
    end

    // =========================================================================
    // Drive SRAM interfaces
    // sram_*_we uses the previous chab_wr_s (delayed increment pattern)
    // we_*_en gates the write enable
    // =========================================================================
    assign sram_a_we   = chab_wr_s & we_a_en;
    assign sram_a_addr = cnt_a;
    assign sram_a_din  = chab_wdata_a_s;

    assign sram_b_we   = chab_wr_s & we_b_en;
    assign sram_b_addr = cnt_b;
    assign sram_b_din  = chab_wdata_b_s;

endmodule
