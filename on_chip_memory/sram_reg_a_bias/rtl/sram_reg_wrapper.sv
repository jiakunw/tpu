///////////////////////////////////////////////////////////////////////////////
// sram_reg_wrapper.sv
//
// Dual-port wrapper for regf00 (Bias) + sram00 (Matrix A)
//
// Port A: bus_slave write interface (8-bit byte)
// Port B: tpu_core read interface (64-bit Matrix A + 32-bit Bias)
//
// Address map (13-bit byte address, 5120 bytes total):
//   0x0000 ~ 0x03FF  ->  regf00  (256 words x 4 bytes) = Bias
//   0x0400 ~ 0x13FF  ->  sram00  (512 words x 8 bytes) = Matrix A
//
// Key assumption: bus_slave write and tpu_core read are time-multiplexed,
//                 they will not access simultaneously.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module sram_reg_wrapper #(
    parameter AW = 13,
    parameter DW = 8
)(
    input  logic            clk,
    input  logic            rstn,

    //=========================================================================
    // Port A: bus_slave write interface (8-bit byte)
    //=========================================================================
    input  logic            bus_we,
    input  logic            bus_re,
    input  logic [AW-1:0]   bus_addr,
    input  logic [DW-1:0]   bus_din,
    output logic [DW-1:0]   bus_dout,
    output logic            bus_dout_valid,

    //=========================================================================
    // Port B: tpu_core read interface (64-bit Matrix A + 32-bit Bias)
    //=========================================================================
    input  logic            tpu_a_re,           // Matrix A read enable
    input  logic [8:0]      tpu_a_raddr,        // Matrix A word address
    output logic [63:0]     tpu_a_rdata,        // Matrix A data (64-bit)
    
    input  logic            tpu_bias_re,        // Bias read enable  
    input  logic [7:0]      tpu_bias_raddr,     // Bias word address
    output logic [31:0]     tpu_bias_rdata      // Bias data (32-bit)
);

    // =========================================================================
    // Address decode for bus_slave
    // =========================================================================
    localparam [AW-1:0] SRAM_BASE = 13'h0400;

    logic            in_regf;       // Address in regf00 region
    logic            in_sram;       // Address in sram00 region
    logic [AW-1:0]   sram_offset;   // Offset from SRAM_BASE

    assign in_regf     = (bus_addr < SRAM_BASE);
    assign in_sram     = ~in_regf;
    assign sram_offset = bus_addr - SRAM_BASE;

    // =========================================================================
    // regf00 (256 x 32-bit) - Bias Storage
    // =========================================================================
    logic [31:0] regf_wbuf;         // Write buffer for byte accumulation
    logic        regf_we_d1;        // Delayed write enable
    logic [7:0]  regf_waddr_d1;     // Delayed word address

    // Accumulate bytes into 32-bit buffer (bus_slave write)
    // Bytes are placed according to addr[1:0]: 0->LSB, 3->MSB
    always_ff @(posedge clk) begin
        if (bus_we && in_regf)
            regf_wbuf[bus_addr[1:0]*8 +: 8] <= bus_din;
    end

    // Fire write one cycle after 4th byte arrives (addr[1:0]==11)
    // At that posedge, regf_wbuf already has all 4 bytes
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            regf_we_d1    <= 1'b0;
            regf_waddr_d1 <= '0;
        end else begin
            regf_we_d1    <= bus_we && in_regf && (bus_addr[1:0] == 2'b11);
            regf_waddr_d1 <= bus_addr[9:2];
        end
    end

    // regf00 control signals - arbitrate between bus_slave write and tpu_core read
    logic        regf_cen, regf_wen;
    logic [7:0]  regf_a;
    logic [31:0] regf_d;
    logic [31:0] regf_q;

    // Priority: bus_slave write > tpu_core read > bus_slave read
    always_comb begin
        if (regf_we_d1) begin
            // bus_slave write (highest priority during data loading)
            regf_cen = 1'b0;
            regf_wen = 1'b0;  // WEN=0 means write
            regf_a   = regf_waddr_d1;
            regf_d   = regf_wbuf;
        end else if (tpu_bias_re) begin
            // tpu_core read bias (during computation)
            regf_cen = 1'b0;
            regf_wen = 1'b1;  // WEN=1 means read
            regf_a   = tpu_bias_raddr;
            regf_d   = '0;
        end else if (bus_re && in_regf) begin
            // bus_slave read (for debug/verification)
            regf_cen = 1'b0;
            regf_wen = 1'b1;
            regf_a   = bus_addr[9:2];
            regf_d   = '0;
        end else begin
            // Idle - disable chip
            regf_cen = 1'b1;
            regf_wen = 1'b1;
            regf_a   = '0;
            regf_d   = '0;
        end
    end

    // regf00 instance (256 x 32-bit register file)
    regf00 u_regf00 (
        .CLK  (clk),
        .CEN  (regf_cen),
        .WEN  (regf_wen),
        .A    (regf_a),
        .D    (regf_d),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (regf_q)
    );

    assign tpu_bias_rdata = regf_q;

    // =========================================================================
    // sram00 (512 x 64-bit) - Matrix A Storage
    // =========================================================================
    logic [63:0] sram_wbuf;         // Write buffer for byte accumulation
    logic        sram_we_d1;        // Delayed write enable
    logic [8:0]  sram_waddr_d1;     // Delayed word address

    // Accumulate bytes into 64-bit buffer (bus_slave write)
    // Bytes are placed according to offset[2:0]: 0->LSB, 7->MSB
    always_ff @(posedge clk) begin
        if (bus_we && in_sram)
            sram_wbuf[sram_offset[2:0]*8 +: 8] <= bus_din;
    end

    // Fire write one cycle after 8th byte arrives (offset[2:0]==111)
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sram_we_d1    <= 1'b0;
            sram_waddr_d1 <= '0;
        end else begin
            sram_we_d1    <= bus_we && in_sram && (sram_offset[2:0] == 3'b111);
            sram_waddr_d1 <= sram_offset[11:3];
        end
    end

    // sram00 control signals - arbitrate between bus_slave write and tpu_core read
    logic        sram_cen, sram_wen;
    logic [8:0]  sram_a;
    logic [63:0] sram_d;
    logic [63:0] sram_q;

    // Priority: bus_slave write > tpu_core read > bus_slave read
    always_comb begin
        if (sram_we_d1) begin
            // bus_slave write (highest priority during data loading)
            sram_cen = 1'b0;
            sram_wen = 1'b0;
            sram_a   = sram_waddr_d1;
            sram_d   = sram_wbuf;
        end else if (tpu_a_re) begin
            // tpu_core read Matrix A (during computation)
            sram_cen = 1'b0;
            sram_wen = 1'b1;
            sram_a   = tpu_a_raddr;
            sram_d   = '0;
        end else if (bus_re && in_sram) begin
            // bus_slave read (for debug/verification)
            sram_cen = 1'b0;
            sram_wen = 1'b1;
            sram_a   = sram_offset[11:3];
            sram_d   = '0;
        end else begin
            // Idle - disable chip
            sram_cen = 1'b1;
            sram_wen = 1'b1;
            sram_a   = '0;
            sram_d   = '0;
        end
    end

    // sram00 instance (512 x 64-bit SRAM)
    sram00 u_sram00 (
        .CLK  (clk),
        .CEN  (sram_cen),
        .WEN  (sram_wen),
        .A    (sram_a),
        .D    (sram_d),
        .EMA  (3'b010),
        .RETN (1'b1),
        .Q    (sram_q)
    );

    // Matrix A output to tpu_core (1-cycle read latency)
    logic tpu_a_re_d1;
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn)
            tpu_a_re_d1 <= 1'b0;
        else
            tpu_a_re_d1 <= tpu_a_re;
    end
    assign tpu_a_rdata = sram_q;

    // =========================================================================
    // bus_slave Read Mux (8-bit byte output)
    // =========================================================================
    logic [1:0] regf_byte_sel_r;    // Registered byte select for regf00
    logic [2:0] sram_byte_sel_r;    // Registered byte select for sram00
    logic       bus_re_regf_d1;     // Delayed regf00 read enable
    logic       bus_re_sram_d1;     // Delayed sram00 read enable

    // Register read controls (1-cycle latency for synchronous read)
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bus_re_regf_d1   <= 1'b0;
            bus_re_sram_d1   <= 1'b0;
            regf_byte_sel_r  <= '0;
            sram_byte_sel_r  <= '0;
        end else begin
            bus_re_regf_d1   <= bus_re & in_regf;
            bus_re_sram_d1   <= bus_re & in_sram;
            regf_byte_sel_r  <= bus_addr[1:0];
            sram_byte_sel_r  <= sram_offset[2:0];
        end
    end

    // Output valid when read was issued previous cycle
    assign bus_dout_valid = bus_re_regf_d1 | bus_re_sram_d1;

    // Byte mux: select appropriate byte from 32-bit or 64-bit word
    always_comb begin
        if      (bus_re_regf_d1) bus_dout = regf_q[regf_byte_sel_r*8 +: 8];
        else if (bus_re_sram_d1) bus_dout = sram_q[sram_byte_sel_r*8 +: 8];
        else                     bus_dout = '0;
    end

endmodule