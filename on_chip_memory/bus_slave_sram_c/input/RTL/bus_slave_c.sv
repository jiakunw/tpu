///////////////////////////////////////////////////////////////////////////////
// bus_slave_c.sv
//
// TPU Bus Slave - C Channel (sequential read from SRAM_C)
//
// Negedge sampling: master drives CHC_START/CHC_RD at posedge BUS_CLK.
// Slave samples at negedge -> 50ns setup margin before next posedge.
//
// Read timing:
//   posedge P   : master drives CHC_RD=1
//   negedge P   : chc_rd_s=1 sampled, cnt_c stays at current address
//   posedge P+1 : sram_wrapper_c sees bus_re=1, SRAM reads, Q valid +0.01ns
//   negedge P+1 : cnt_c incremented
//   posedge P+2 : C_CAPTURE; CHC_RDATA = sram_c_dout (Q still valid)
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module bus_slave_c #(
    parameter SRAM_AW = 12,
    parameter DW      = 8
)(
    input  logic              clk,
    input  logic              rstn,

    // CPU Interface
    input  logic              chc_start,
    input  logic              chc_rd,
    output logic [DW-1:0]     chc_rdata,

    // SRAM_C Interface (read only)
    output logic               sram_c_re,
    output logic [SRAM_AW-1:0] sram_c_addr,
    input  logic [DW-1:0]      sram_c_dout     // combinational from SRAM Q
);

    logic              chc_rd_s;
    logic [SRAM_AW:0]  cnt_c;

    always_ff @(negedge clk) begin
        if (!rstn) begin
            chc_rd_s <= 1'b0;
            cnt_c    <= '0;
        end else begin
            chc_rd_s <= chc_rd;
            if (chc_start)
                cnt_c <= '0;
            else if (chc_rd_s)
                cnt_c <= cnt_c + 1'b1;
        end
    end

    assign sram_c_re   = chc_rd_s;
    assign sram_c_addr = cnt_c[SRAM_AW-1:0];

    // chc_rdata directly from sram_c_dout (combinational from SRAM Q).
    // At C_CAPTURE (posedge P+2), Q is valid from posedge P+1 + 0.01ns.
    assign chc_rdata = sram_c_dout;

endmodule


