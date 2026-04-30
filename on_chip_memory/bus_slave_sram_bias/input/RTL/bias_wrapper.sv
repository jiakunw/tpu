///////////////////////////////////////////////////////////////////////////////
// bias_wrapper.sv
//
// Wrapper for sram01 (512 x 32-bit) used for bias storage.
//
// Bus writes 8-bit bytes; wrapper accumulates 4 bytes into one 32-bit word.
// byte_sel is [1:0] (2-bit): 0=bits[7:0], 1=bits[15:8], 2=bits[23:16], 3=bits[31:24]
//
// TPU reads 32-bit words directly.
//
// Scan-chain test override (sc_mem_ctrl=1 selects sc_ inputs).
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define SD #1

module bias_wrapper #(
    parameter AW = 9,   // 512 words
    parameter DW = 8
)(
    input  wire          clk,
    input  wire          rstn,

    // Port A: bus_slave (write only, 8-bit)
    input  wire          bus_we,
    input  wire [AW+1:0] bus_addr,   // [1:0]=byte_sel, [AW+1:2]=word_addr
    input  wire [DW-1:0] bus_din,

    // Port B: tpu_core (read only, 32-bit)
    input  wire          tpu_re,
    input  wire [AW-1:0] tpu_addr,
    output wire [31:0]   tpu_dout,

    // Scan-chain / test override (sc_mem_ctrl=1 selects sc_ inputs)
    input  wire          sc_mem_ctrl,
    input  wire          sc_cen,
    input  wire          sc_wen,
    input  wire [AW-1:0] sc_addr,
    input  wire [31:0]   sc_din,
    output wire [31:0]   sc_mem_dout
);

    wire [1:0]    bus_byte_sel  = bus_addr[1:0];
    wire [AW-1:0] bus_word_addr = bus_addr[AW+1:2];

    // =========================================================================
    // 4-byte accumulator (32-bit word)
    // Clear on byte_sel==0 (start of new word)
    // =========================================================================
    reg [31:0] bus_wbuf;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn)
            bus_wbuf <= 32'b0;
        else if (bus_we) begin
            if (bus_byte_sel == 2'b00)
                bus_wbuf <= {24'b0, bus_din};   // clear + write byte 0
            else
                bus_wbuf[bus_byte_sel*8 +: 8] <= bus_din;
        end
    end

    // =========================================================================
    // Write trigger: 4th byte (byte_sel==3) completes a full word
    // =========================================================================
    reg          bus_we_d1;
    reg [AW-1:0] bus_waddr_d1;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn) begin
            bus_we_d1    <= 1'b0;
            bus_waddr_d1 <= {AW{1'b0}};
        end else begin
            bus_we_d1    <= bus_we && (bus_byte_sel == 2'b11);
            bus_waddr_d1 <= bus_word_addr;
        end
    end

    // =========================================================================
    // Flush logic: partial word on falling edge of bus_we
    // =========================================================================
    reg          bus_we_prev;
    reg [1:0]    last_byte_sel;
    reg [AW-1:0] last_word_addr;

    // synopsys sync_set_reset "rstn"
    always @(posedge clk) begin
        if (!rstn) begin
            bus_we_prev    <= 1'b0;
            last_byte_sel  <= 2'b0;
            last_word_addr <= {AW{1'b0}};
        end else begin
            bus_we_prev <= bus_we;
            if (bus_we) begin
                last_byte_sel  <= bus_byte_sel;
                last_word_addr <= bus_word_addr;
            end
        end
    end

    wire need_flush = bus_we_prev && !bus_we && (last_byte_sel != 2'b11);
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
    // Priority: bus_we_d1 = flush_d1 > tpu_re
    // =========================================================================
    wire do_write = bus_we_d1 || flush_d1;
    wire [AW-1:0] write_addr = bus_we_d1 ? bus_waddr_d1 : flush_addr;

    wire          sram_cen  = (do_write || tpu_re) ? 1'b0 : 1'b1;
    wire          sram_wen  = do_write ? 1'b0 : 1'b1;
    wire [AW-1:0] sram_addr = do_write ? write_addr : tpu_addr;
    wire [31:0]   sram_din  = bus_wbuf;

    // System-path delayed signals
    wire          sys_cen;
    wire          sys_wen;
    wire [AW-1:0] sys_addr;
    wire [31:0]   sys_din;

    assign `SD sys_cen  = sram_cen;
    assign `SD sys_wen  = sram_wen;
    assign `SD sys_addr = sram_addr;
    assign `SD sys_din  = sram_din;

    // Scan-chain path delayed signals
    wire          sc_cen_delayed;
    wire          sc_wen_delayed;
    wire [AW-1:0] sc_addr_delayed;
    wire [31:0]   sc_din_delayed;

    assign `SD sc_cen_delayed  = sc_cen;
    assign `SD sc_wen_delayed  = sc_wen;
    assign `SD sc_addr_delayed = sc_addr;
    assign `SD sc_din_delayed  = sc_din;

    // =========================================================================
    // sc_mem_ctrl mux: 1 = scan-chain, 0 = system
    // =========================================================================
    wire          mux_cen  = sc_mem_ctrl ? sc_cen_delayed  : sys_cen;
    wire          mux_wen  = sc_mem_ctrl ? sc_wen_delayed  : sys_wen;
    wire [AW-1:0] mux_addr = sc_mem_ctrl ? sc_addr_delayed : sys_addr;
    wire [31:0]   mux_din  = sc_mem_ctrl ? sc_din_delayed  : sys_din;

    wire [31:0] sram_q;

    sram01 u_sram (
        .CLK  (clk),
        .CEN  (mux_cen),
        .WEN  (mux_wen),
        .A    (mux_addr),
        .D    (mux_din),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_q)
    );

    assign tpu_dout    = sram_q;
    assign sc_mem_dout = sram_q;

endmodule
