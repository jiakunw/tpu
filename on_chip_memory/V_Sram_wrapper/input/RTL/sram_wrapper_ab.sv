///////////////////////////////////////////////////////////////////////////////
// sram_wrapper_ab.sv
//
// Dual-port wrapper for sram00 (512 x 64-bit)
// Used for Matrix A and Matrix B: bus writes (8-bit), TPU reads (64-bit).
//
// Two fixes over original:
//   1. bus_wbuf cleared at start of each new 64-bit word (byte_sel==0)
//      so partial words never contain stale bytes from previous transaction.
//   2. Flush logic: when bus_we falls on a non-8-aligned boundary,
//      the partial word is written to SRAM one cycle later.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define SD #1

module sram_wrapper_ab #(
    parameter AW = 9,
    parameter DW = 8
)(
    input  wire          clk,
    input  wire          rstn,

    // Port A: bus_slave (write only)
    input  wire          bus_we,
    input  wire [AW+2:0] bus_addr,
    input  wire [DW-1:0] bus_din,

    // Port B: tpu_core (read only)
    input  wire          tpu_re,
    input  wire [AW-1:0] tpu_addr,
    output wire [63:0]   tpu_dout
);

    wire [2:0]    bus_byte_sel  = bus_addr[2:0];
    wire [AW-1:0] bus_word_addr = bus_addr[AW+2:3];

    // =========================================================================
    // Byte accumulator
    // Clear entire word when byte_sel==0 (new word starts) to avoid
    // stale bytes from previous transaction contaminating partial words.
    // =========================================================================
    reg [63:0]   bus_wbuf;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn)
            bus_wbuf <= 64'b0;
        else if (bus_we) begin
            if (bus_byte_sel == 3'b0)
                bus_wbuf <= {56'b0, bus_din};  // clear + write byte 0
            else
                bus_wbuf[bus_byte_sel*8 +: 8] <= bus_din;
        end
    end

    // =========================================================================
    // Normal write trigger: 8th byte (byte_sel==7) completes a full word
    // =========================================================================
    reg          bus_we_d1;
    reg [AW-1:0] bus_waddr_d1;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn) begin
            bus_we_d1    <= 1'b0;
            bus_waddr_d1 <= {AW{1'b0}};
        end else begin
            bus_we_d1    <= bus_we && (bus_byte_sel == 3'b111);
            bus_waddr_d1 <= bus_word_addr;  // always track last word addr
        end
    end

    // =========================================================================
    // Flush logic: detect falling edge of bus_we on non-8-aligned boundary
    // and trigger a SRAM write one cycle later to commit the partial word.
    // =========================================================================
    reg          bus_we_prev;
    reg [2:0]    last_byte_sel;
    reg [AW-1:0] last_word_addr;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn) begin
            bus_we_prev   <= 1'b0;
            last_byte_sel <= 3'b0;
            last_word_addr<= {AW{1'b0}};
        end else begin
            bus_we_prev <= bus_we;
            if (bus_we) begin
                last_byte_sel  <= bus_byte_sel;
                last_word_addr <= bus_word_addr;
            end
        end
    end

    // Flush fires one cycle after bus_we falls, if last byte wasn't byte 7
    wire need_flush = bus_we_prev && !bus_we && (last_byte_sel != 3'b111);
    reg  flush_d1;
    reg  [AW-1:0] flush_addr;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn) begin
            flush_d1   <= 1'b0;
            flush_addr <= {AW{1'b0}};
        end else begin
            flush_d1   <= need_flush;
            flush_addr <= last_word_addr;
        end
    end

    // =========================================================================
    // SRAM control: normal write, flush write, or TPU read
    // Priority: bus_we_d1 = flush_d1 > tpu_re (write before read)
    // =========================================================================
    wire do_write = bus_we_d1 || flush_d1;
    wire [AW-1:0] write_addr = bus_we_d1 ? bus_waddr_d1 : flush_addr;

    wire        sram_cen  = (do_write || tpu_re) ? 1'b0 : 1'b1;
    wire        sram_wen  = do_write ? 1'b0 : 1'b1;
    wire [8:0]  sram_addr = do_write ? write_addr : tpu_addr;
    wire [63:0] sram_din  = bus_wbuf;

    wire        sram_cen_delayed;
    wire        sram_wen_delayed;
    wire [8:0]  sram_addr_delayed;
    wire [63:0] sram_din_delayed;

    assign `SD sram_cen_delayed  = sram_cen;
    assign `SD sram_wen_delayed  = sram_wen;
    assign `SD sram_addr_delayed = sram_addr;
    assign `SD sram_din_delayed  = sram_din;

    wire [63:0] sram_q;

    sram00 u_sram (
        .CLK  (clk),
        .CEN  (sram_cen_delayed),
        .WEN  (sram_wen_delayed),
        .A    (sram_addr_delayed),
        .D    (sram_din_delayed),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_q)
    );

    assign tpu_dout = sram_q;

endmodule
