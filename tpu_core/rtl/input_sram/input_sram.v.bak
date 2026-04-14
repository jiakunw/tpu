`timescale 1ns/1ps
`define SD #1

module input_sram #(
    parameter SRAM_DATA_WIDTH = 64,
    parameter SRAM_ADDR_WIDTH = 9
)(
    input   clk,

    // SRAM A
    input   wr_en_a,
    input   rd_en_a,
    input   [SRAM_ADDR_WIDTH-1:0] waddr_a,
    input   [SRAM_ADDR_WIDTH-1:0] raddr_a,
    input   [SRAM_DATA_WIDTH-1:0] wdata_a,
    output  [SRAM_DATA_WIDTH-1:0] rdata_a,

    // SRAM B
    input   wr_en_b,
    input   rd_en_b,
    input   [SRAM_ADDR_WIDTH-1:0] waddr_b,
    input   [SRAM_ADDR_WIDTH-1:0] raddr_b,
    input   [SRAM_DATA_WIDTH-1:0] wdata_b,
    output  [SRAM_DATA_WIDTH-1:0] rdata_b
);

    // -------------------------------------------------------------------------
    // SRAM A
    // -------------------------------------------------------------------------
    wire sram_cs_a;
    reg  [SRAM_ADDR_WIDTH-1:0] sram_addr_a;

    wire sram_cen_delayed_a;
    wire sram_wen_delayed_a;
    wire [SRAM_ADDR_WIDTH-1:0] sram_addr_delayed_a;
    wire [SRAM_DATA_WIDTH-1:0] sram_din_delayed_a;
    wire [SRAM_DATA_WIDTH-1:0] sram_dout_a;

    assign sram_cs_a = wr_en_a | rd_en_a;

    assign `SD sram_cen_delayed_a  = ~sram_cs_a;
    assign `SD sram_wen_delayed_a  = ~wr_en_a;
    assign `SD sram_addr_delayed_a = sram_addr_a;
    assign `SD sram_din_delayed_a  = wdata_a;

    assign rdata_a = sram_dout_a;

    always @(*) begin
        if (wr_en_a)
            sram_addr_a = waddr_a;
        else if (rd_en_a)
            sram_addr_a = raddr_a;
        else
            sram_addr_a = {SRAM_ADDR_WIDTH{1'b0}};
    end

    sram00 sram_a (
        .CLK  (clk),
        .CEN  (sram_cen_delayed_a),
        .WEN  (sram_wen_delayed_a),
        .A    (sram_addr_delayed_a),
        .D    (sram_din_delayed_a),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_dout_a)
    );

    // -------------------------------------------------------------------------
    // SRAM B
    // -------------------------------------------------------------------------
    wire sram_cs_b;
    reg  [SRAM_ADDR_WIDTH-1:0] sram_addr_b;

    wire sram_cen_delayed_b;
    wire sram_wen_delayed_b;
    wire [SRAM_ADDR_WIDTH-1:0] sram_addr_delayed_b;
    wire [SRAM_DATA_WIDTH-1:0] sram_din_delayed_b;
    wire [SRAM_DATA_WIDTH-1:0] sram_dout_b;

    assign sram_cs_b = wr_en_b | rd_en_b;

    assign `SD sram_cen_delayed_b  = ~sram_cs_b;
    assign `SD sram_wen_delayed_b  = ~wr_en_b;
    assign `SD sram_addr_delayed_b = sram_addr_b;
    assign `SD sram_din_delayed_b  = wdata_b;

    assign rdata_b = sram_dout_b;

    always @(*) begin
        if (wr_en_b)
            sram_addr_b = waddr_b;
        else if (rd_en_b)
            sram_addr_b = raddr_b;
        else
            sram_addr_b = {SRAM_ADDR_WIDTH{1'b0}};
    end

    sram00 sram_b (
        .CLK  (clk),
        .CEN  (sram_cen_delayed_b),
        .WEN  (sram_wen_delayed_b),
        .A    (sram_addr_delayed_b),
        .D    (sram_din_delayed_b),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_dout_b)
    );

endmodule