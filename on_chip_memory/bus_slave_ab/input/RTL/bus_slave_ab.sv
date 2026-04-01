///////////////////////////////////////////////////////////////////////////////
// bus_slave_ab.sv
//
// TPU Bus Slave - AB Channel (simultaneous write to SRAM_A and SRAM_B)
//
// Negedge sampling design:
//   Master drives CHAB_WR/WDATA/START at posedge BUS_CLK.
//   Slave samples all bus inputs at negedge BUS_CLK -> 50ns setup time
//   before next posedge, satisfying sram_wrapper's posedge FF requirements.
//
// Counter (cnt_ab) uses DELAYED increment:
//   Increments based on the PREVIOUS negedge's sampled chab_wr_s, not the
//   current one. This guarantees that at the posedge where sram_wrapper
//   accumulates the byte, cnt_ab still holds the correct (pre-increment)
//   byte address. The counter advances at the negedge AFTER the write.
//
// Timing for byte K (zero-indexed):
//   posedge P   : master drives CHAB_WR=1, WDATA=byte_K
//   negedge P   : chab_wr_s=1, wdata_s=byte_K, cnt_ab += prev_wr (0 if first)
//   posedge P+1 : sram_wrapper sees bus_we=1, bus_addr=cnt_ab=K, accumulates byte_K
//   negedge P+1 : chab_wr_s=0, cnt_ab += chab_wr_s=1 -> cnt_ab = K+1
//   posedge P+2 : sram_wrapper sees bus_we=0, no accumulation
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module bus_slave_ab #(
    parameter SRAM_AW = 12,   // byte address width: 4096 bytes (512 words x 8B)
    parameter DW      = 8
)(
    input  logic              BUS_CLK,
    input  logic              BUS_RST_N,

    // Bus Interface (driven by master at posedge BUS_CLK)
    input  logic              CHAB_START,
    input  logic [DW-1:0]     CHAB_WDATA_A,
    input  logic [DW-1:0]     CHAB_WDATA_B,
    input  logic              CHAB_WR,

    // SRAM_A Interface (write only)
    output logic               sram_a_we,
    output logic [SRAM_AW-1:0] sram_a_addr,
    output logic [DW-1:0]      sram_a_din,

    // SRAM_B Interface (write only)
    output logic               sram_b_we,
    output logic [SRAM_AW-1:0] sram_b_addr,
    output logic [DW-1:0]      sram_b_din,

    output logic [SRAM_AW-1:0] debug_cnt_ab
);

    logic              chab_wr_s;
    logic [DW-1:0]     chab_wdata_a_s;
    logic [DW-1:0]     chab_wdata_b_s;
    logic [SRAM_AW-1:0] cnt_ab;

    always_ff @(negedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            chab_wr_s      <= 1'b0;
            chab_wdata_a_s <= '0;
            chab_wdata_b_s <= '0;
            cnt_ab         <= '0;
        end else begin
            chab_wr_s      <= CHAB_WR;
            chab_wdata_a_s <= CHAB_WDATA_A;
            chab_wdata_b_s <= CHAB_WDATA_B;
            if (CHAB_START)
                cnt_ab <= '0;
            else if (chab_wr_s)
                cnt_ab <= cnt_ab + 1'b1;
        end
    end

    assign sram_a_we   = chab_wr_s;
    assign sram_a_addr = cnt_ab;
    assign sram_a_din  = chab_wdata_a_s;

    assign sram_b_we   = chab_wr_s;
    assign sram_b_addr = cnt_ab;
    assign sram_b_din  = chab_wdata_b_s;

    assign debug_cnt_ab = cnt_ab;

endmodule
