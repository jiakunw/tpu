`timescale 1ns/1ps
`define SD #1

module sram_wrapper #(
    parameter SRAM_DATA_WIDTH = 64,
    parameter SRAM_ADDR_WIDTH = 9
)(
    input   clk,

    input   wr_en,
    input   rd_en,

    input   [SRAM_ADDR_WIDTH-1:0] waddr,
    input   [SRAM_ADDR_WIDTH-1:0] raddr,

    input   [SRAM_DATA_WIDTH-1:0] wdata,
    output  [SRAM_DATA_WIDTH-1:0] rdata
);

    wire sram_cs;
    reg  [SRAM_ADDR_WIDTH-1:0] sram_addr;

    wire sram_cen_delayed;
    wire sram_wen_delayed;
    wire [SRAM_ADDR_WIDTH-1:0] sram_addr_delayed;
    wire [SRAM_DATA_WIDTH-1:0] sram_din_delayed;
    wire [SRAM_DATA_WIDTH-1:0] sram_dout;

    assign sram_cs = wr_en | rd_en;

    assign `SD sram_cen_delayed  = ~sram_cs;
    assign `SD sram_wen_delayed  = ~wr_en;
    assign `SD sram_addr_delayed = sram_addr;
    assign `SD sram_din_delayed  = wdata;

    assign rdata = sram_dout;

    always @(*) begin
        if (wr_en) begin
            sram_addr = waddr;
        end
        else if (rd_en) begin
            sram_addr = raddr;
        end
        else begin
            sram_addr = {SRAM_ADDR_WIDTH{1'b0}};
        end
    end

    sram00 sram00_inst (
        .CLK  (clk),
        .CEN  (sram_cen_delayed),
        .WEN  (sram_wen_delayed),
        .A    (sram_addr_delayed),
        .D    (sram_din_delayed),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_dout)
    );

endmodule
