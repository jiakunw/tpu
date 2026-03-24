///////////////////////////////////////////////////////////////////////////////
// sram_wrapper.sv
//
// Dual-port wrapper for sram00 (512 x 64-bit)
//
// Used for:
//   - Matrix B: bus_slave write (8-bit), tpu_core read (64-bit)
//   - Matrix C: tpu_core write (64-bit), bus_slave read (8-bit)
//
// Key assumption: bus_slave and tpu_core are time-multiplexed,
//                 they will not access simultaneously.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module sram_wrapper #(
    parameter AW = 9,       // Word address width (512 words)
    parameter DW = 8        // bus_slave data width (byte)
)(
    input  wire          clk,
    input  wire          rstn,

    //=========================================================================
    // Port A: bus_slave interface (8-bit byte)
    //=========================================================================
    input  wire          bus_we,            // Write enable
    input  wire          bus_re,            // Read enable
    input  wire [AW+2:0] bus_addr,          // Byte address (12-bit for 512 words x 8 bytes)
    input  wire [DW-1:0] bus_din,           // Write data (8-bit)
    output wire [DW-1:0] bus_dout,          // Read data (8-bit)
    output reg           bus_dout_valid,    // Read data valid

    //=========================================================================
    // Port B: tpu_core interface (64-bit word)
    //=========================================================================
    input  wire          tpu_we,            // Write enable
    input  wire          tpu_re,            // Read enable
    input  wire [AW-1:0] tpu_addr,          // Word address (9-bit)
    input  wire [63:0]   tpu_din,           // Write data (64-bit)
    output wire [63:0]   tpu_dout           // Read data (64-bit)
);

    // =========================================================================
    // bus_slave write accumulator (8 bytes -> 64-bit word)
    // =========================================================================
    reg [63:0]   bus_wbuf;          // Write buffer for byte accumulation
    reg          bus_we_d1;         // Delayed write enable
    reg [AW-1:0] bus_waddr_d1;      // Delayed word address

    // Extract byte select and word address from bus byte address
    wire [2:0]    bus_byte_sel  = bus_addr[2:0];        // Which byte in word
    wire [AW-1:0] bus_word_addr = bus_addr[AW+2:3];     // Word address

    // Accumulate bytes into 64-bit buffer
    // Bytes are placed according to bus_byte_sel: 0->LSB, 7->MSB
    always @(posedge clk) begin
        if (bus_we)
            bus_wbuf[bus_byte_sel*8 +: 8] <= bus_din;
    end

    // Fire write one cycle after 8th byte arrives (byte_sel==111)
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bus_we_d1    <= 1'b0;
            bus_waddr_d1 <= '0;
        end else begin
            bus_we_d1    <= bus_we && (bus_byte_sel == 3'b111);
            bus_waddr_d1 <= bus_word_addr;
        end
    end

    // =========================================================================
    // SRAM control signal arbitration
    // Priority: tpu_core write > bus_slave write > tpu_core read > bus_slave read
    // =========================================================================
    wire        sram_cen;           // Chip enable (active low)
    wire        sram_wen;           // Write enable (active low)
    wire [8:0]  sram_addr;          // Address
    wire [63:0] sram_din;           // Write data
    wire [63:0] sram_q;             // Read data

    reg         sram_cen_r;
    reg         sram_wen_r;
    reg [8:0]   sram_addr_r;
    reg [63:0]  sram_din_r;

    always @(*) begin
        if (tpu_we) begin
            // tpu_core write - highest priority during compute phase
            // This is for writing Matrix C results
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b0;     // WEN=0 means write
            sram_addr_r = tpu_addr;
            sram_din_r  = tpu_din;
        end else if (bus_we_d1) begin
            // bus_slave write - accumulated 64-bit word
            // This is for loading Matrix B
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b0;
            sram_addr_r = bus_waddr_d1;
            sram_din_r  = bus_wbuf;
        end else if (tpu_re) begin
            // tpu_core read - for reading Matrix B during compute
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b1;     // WEN=1 means read
            sram_addr_r = tpu_addr;
            sram_din_r  = '0;
        end else if (bus_re) begin
            // bus_slave read - for reading Matrix C results
            sram_cen_r  = 1'b0;
            sram_wen_r  = 1'b1;
            sram_addr_r = bus_word_addr;
            sram_din_r  = '0;
        end else begin
            // Idle - disable chip to save power
            sram_cen_r  = 1'b1;
            sram_wen_r  = 1'b1;
            sram_addr_r = '0;
            sram_din_r  = '0;
        end
    end

    assign sram_cen  = sram_cen_r;
    assign sram_wen  = sram_wen_r;
    assign sram_addr = sram_addr_r;
    assign sram_din  = sram_din_r;

    // =========================================================================
    // SRAM Instance (512 x 64-bit)
    // =========================================================================
    sram00 u_sram (
        .CLK  (clk),
        .CEN  (sram_cen),
        .WEN  (sram_wen),
        .A    (sram_addr),
        .D    (sram_din),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_q)
    );

    // =========================================================================
    // tpu_core output (64-bit, 1-cycle read latency)
    // =========================================================================
    assign tpu_dout = sram_q;

    // =========================================================================
    // bus_slave output (8-bit, 1-cycle read latency)
    // =========================================================================
    reg [2:0] bus_byte_sel_d1;      // Registered byte select

    // Register read controls for 1-cycle latency
    // bus_dout_valid is 1 cycle after bus_re, matching SRAM read latency
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bus_byte_sel_d1 <= '0;
            bus_dout_valid  <= 1'b0;
        end else begin
            bus_byte_sel_d1 <= bus_byte_sel;
            bus_dout_valid  <= bus_re;  // 1-cycle delay matches SRAM
        end
    end

    // Select appropriate byte from 64-bit word
    assign bus_dout = sram_q[bus_byte_sel_d1*8 +: 8];

endmodule