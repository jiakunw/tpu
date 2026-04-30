///////////////////////////////////////////////////////////////////////////////
// bus_slave_bias.sv
//
// TPU Bus Slave - Bias Channel
//
// Forwards CHAB_WDATA_BIAS bytes from the master into bus_slave_sram_bias
// (sram01, 512 x 32-bit). Bias is one INT32 per row of M -> M*4 bytes per
// matmul block.
//
// Counter:
//   max_bias = num_computation * M * 4    (where M = dim_m << 3)
//   cnt_bias counts every chab_wr pulse while we_bias_en is high.
//   When cnt_bias reaches max_bias, we_bias_en is cleared and further
//   chab_wr pulses (still counting up A and B) no longer write bias.
//
// Negedge sampling: master drives signals at posedge BUS_CLK, slave samples
// at negedge -> 50ns setup margin before the next posedge.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module bus_slave_bias #(
    parameter SRAM_AW = 11,   // bias_wrapper byte addr = AW(9) + 2 byte_sel bits
    parameter DW      = 8
)(
    input  logic              clk,
    input  logic              rstn,

    // Dimensions from on-chip register file (valid before CHAB_START)
    // dim_m is M / 8 (e.g. M=16 -> dim_m=2)
    input  logic [6:0]        dim_m,
    input  logic [6:0]        num_computation,

    // Bus Interface (driven by master at posedge BUS_CLK)
    input  logic              chab_start,
    input  logic [DW-1:0]     chab_wdata_bias,
    input  logic              chab_wr,

    // SRAM_BIAS Interface (-> bus_slave_sram_bias / bias_wrapper)
    output logic               sram_bias_we,
    output logic [SRAM_AW-1:0] sram_bias_addr,
    output logic [DW-1:0]      sram_bias_din
);

    localparam CNT_W = SRAM_AW + 1;

    // =========================================================================
    // Negedge-sampled bus signals
    // =========================================================================
    logic              chab_wr_s;
    logic [DW-1:0]     chab_wdata_bias_s;

    // Total bytes to write (registered at START to latch stable dims)
    logic [SRAM_AW:0]  max_bias;

    // Byte counter and write-enable gate
    logic [SRAM_AW:0]  cnt_bias;
    logic              we_bias_en;

    // synopsys sync_set_reset "rstn"
    always_ff @(negedge clk) begin
        if (!rstn) begin
            chab_wr_s         <= 1'b0;
            chab_wdata_bias_s <= '0;
            cnt_bias          <= '0;
            max_bias          <= '0;
            we_bias_en        <= 1'b0;
        end else begin
            // Sample bus inputs
            chab_wr_s         <= chab_wr;
            chab_wdata_bias_s <= chab_wdata_bias;

            if (chab_start) begin
                // Latch dimensions and reset counter
                cnt_bias   <= '0;
                // num_computation * M * 4  =  num_computation * (dim_m << 3) << 2
                max_bias   <= CNT_W'(num_computation) * (CNT_W'(dim_m << 3) << 2);
                we_bias_en <= 1'b1;
            end else if (chab_wr_s) begin
                if (we_bias_en) begin
                    if (cnt_bias + 1 >= max_bias) begin
                        cnt_bias   <= cnt_bias + 1'b1;
                        we_bias_en <= 1'b0;
                    end else begin
                        cnt_bias <= cnt_bias + 1'b1;
                    end
                end
            end
        end
    end

    // =========================================================================
    // Drive SRAM interface
    // =========================================================================
    assign sram_bias_we   = chab_wr_s & we_bias_en;
    assign sram_bias_addr = cnt_bias;     // top bit truncated, gated by we_bias_en
    assign sram_bias_din  = chab_wdata_bias_s;

endmodule
