//////////////////////////////////////////////////////////////////////////////
// TPU SPI Slave - Shift Register Version
// 
// SPI Mode 0: CPOL=0, CPHA=0
//   - Sample MOSI on SCK rising edge
//   - Shift out MISO on SCK falling edge
//
// KEY CHANGE: Use actual shift registers for both TX and RX
// This avoids all the complex tx_bit_idx timing issues.
//
//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tpu_spi_slave (
    input  logic        clk,
    input  logic        rst_n,
    
    // SPI interface
    input  logic        spi_sck,
    input  logic        spi_cs_n,
    input  logic        spi_mosi,
    output logic        spi_miso,
    
    // Register interface
    output logic [3:0]  reg_addr,
    output logic        reg_rd,
    output logic        reg_wr,
    output logic [7:0]  reg_wdata,
    input  logic [7:0]  reg_rdata,
    input  logic        reg_addr_valid,
    input  logic        reg_writable
);

    //=========================================================================
    // Constants
    //=========================================================================
    localparam CMD_READ  = 4'b0001;
    localparam CMD_WRITE = 4'b0010;
    localparam RESP_ACK  = 8'hFF;
    localparam RESP_NAK  = 8'hF0;

    //=========================================================================
    // Input synchronizers
    //=========================================================================
    logic [2:0] sck_sync;
    logic [2:0] cs_sync;
    logic [1:0] mosi_sync;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sck_sync  <= 3'b000;
            cs_sync   <= 3'b111;
            mosi_sync <= 2'b00;
        end else begin
            sck_sync  <= {sck_sync[1:0], spi_sck};
            cs_sync   <= {cs_sync[1:0], spi_cs_n};
            mosi_sync <= {mosi_sync[0], spi_mosi};
        end
    end
    
    wire sck_rise  = (sck_sync[2:1] == 2'b01);
    wire sck_fall  = (sck_sync[2:1] == 2'b10);
    wire cs_active = ~cs_sync[2];
    wire mosi_bit  = mosi_sync[1];

    //=========================================================================
    // Bit counter (0-7)
    //=========================================================================
    logic [2:0] bit_cnt;
    logic       byte_done;      // Pulses when 8 bits received
    logic       byte_done_d1;   // Delayed by 1 cycle
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'd0;
        end else if (!cs_active) begin
            bit_cnt <= 3'd0;
        end else if (sck_rise) begin
            bit_cnt <= bit_cnt + 3'd1;  // Wraps 7->0
        end
    end
    
    // byte_done pulses when we've just received the 8th bit
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_done    <= 1'b0;
            byte_done_d1 <= 1'b0;
        end else begin
            byte_done    <= cs_active && sck_rise && (bit_cnt == 3'd7);
            byte_done_d1 <= byte_done;
        end
    end

    //=========================================================================
    // RX Shift Register
    //=========================================================================
    logic [7:0] rx_shift;
    logic [7:0] rx_byte;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_shift <= 8'h00;
        end else if (!cs_active) begin
            rx_shift <= 8'h00;
        end else if (sck_rise) begin
            rx_shift <= {rx_shift[6:0], mosi_bit};
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_byte <= 8'h00;
        end else if (byte_done) begin
            rx_byte <= rx_shift;
        end
    end

    //=========================================================================
    // Byte counter (0=CMD, 1=RESP, 2=DATA, 3=ACK)
    //=========================================================================
    logic [1:0] byte_num;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_num <= 2'd0;
        end else if (!cs_active) begin
            byte_num <= 2'd0;
        end else if (byte_done) begin
            byte_num <= byte_num + 2'd1;
        end
    end

    //=========================================================================
    // Command decode
    //=========================================================================
    logic [3:0] cmd_addr_r;
    logic       cmd_is_read;
    logic       cmd_is_write;
    logic       cmd_valid;
    logic       cmd_writable;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cmd_addr_r   <= 4'h0;
            cmd_is_read  <= 1'b0;
            cmd_is_write <= 1'b0;
            cmd_valid    <= 1'b0;
            cmd_writable <= 1'b0;
        end else if (!cs_active) begin
            cmd_addr_r   <= 4'h0;
            cmd_is_read  <= 1'b0;
            cmd_is_write <= 1'b0;
            cmd_valid    <= 1'b0;
            cmd_writable <= 1'b0;
        end else if (byte_done && byte_num == 2'd0) begin
            cmd_addr_r   <= rx_shift[7:4];
            cmd_is_read  <= (rx_shift[3:0] == CMD_READ);
            cmd_is_write <= (rx_shift[3:0] == CMD_WRITE);
            cmd_valid    <= reg_addr_valid;
            cmd_writable <= reg_writable;
        end
    end

    //=========================================================================
    // TX Shift Register - THE KEY FIX
    //
    // Load new data on byte_done_d1 (one cycle after byte boundary)
    // Skip the FIRST sck_fall after loading (that's still part of the old byte)
    // Then shift on subsequent sck_fall
    // MISO always outputs tx_shift[7]
    //=========================================================================
    logic [7:0] tx_shift;
    logic       tx_loaded;  // Flag: we just loaded, skip next sck_fall
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_shift  <= 8'h00;
            tx_loaded <= 1'b0;
        end else if (!cs_active) begin
            tx_shift  <= 8'h00;
            tx_loaded <= 1'b0;
        end else if (byte_done_d1) begin
            // Load new TX data one cycle after byte boundary
            // At this point byte_num has already incremented
            tx_loaded <= 1'b1;  // Mark that we just loaded
            case (byte_num)
                2'd1: begin
                    // Just finished CMD, prepare response for byte 1
                    if (cmd_is_read) begin
                        tx_shift <= cmd_valid ? reg_rdata : RESP_NAK;
                    end else if (cmd_is_write) begin
                        tx_shift <= (cmd_valid && cmd_writable) ? RESP_ACK : RESP_NAK;
                    end else begin
                        tx_shift <= RESP_NAK;
                    end
                end
                2'd3: begin
                    // Just finished DATA byte, prepare final ACK
                    tx_shift <= RESP_ACK;
                end
                default: begin
                    tx_shift <= 8'h00;
                end
            endcase
        end else if (sck_fall) begin
            if (tx_loaded) begin
                // Skip this sck_fall - it's the trailing edge of the old byte
                tx_loaded <= 1'b0;
            end else begin
                // Normal shift for bits 1-7
                tx_shift <= {tx_shift[6:0], 1'b0};
            end
        end
    end

    //=========================================================================
    // MISO output - always MSB of shift register
    //=========================================================================
    assign spi_miso = cs_active ? tx_shift[7] : 1'b0;

    //=========================================================================
    // Register interface
    //=========================================================================
    assign reg_addr = (byte_num == 2'd0) ? rx_shift[7:4] : cmd_addr_r;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_rd <= 1'b0;
        end else begin
            reg_rd <= byte_done && (byte_num == 2'd0) && (rx_shift[3:0] == CMD_READ);
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_wr    <= 1'b0;
            reg_wdata <= 8'h00;
        end else if (byte_done && byte_num == 2'd2 && cmd_is_write && cmd_valid && cmd_writable) begin
            reg_wr    <= 1'b1;
            reg_wdata <= rx_shift;
        end else begin
            reg_wr <= 1'b0;
        end
    end

endmodule