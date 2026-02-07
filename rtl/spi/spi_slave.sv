//////////////////////////////////////////////////////////////////////////////
// TPU SPI Slave - Clean Implementation
// 
// SPI Mode 0: CPOL=0, CPHA=0
//   - Sample MOSI on SCK rising edge
//   - Update MISO on SCK falling edge
//
// Key insight: Use byte counters instead of complex state tracking
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
    // Input synchronizers (2-stage FF + edge detect)
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
    // Global bit counter (0-7, increments on sck_rise, wraps)
    //=========================================================================
    logic [2:0] bit_cnt;
    logic       byte_complete;  // Pulse when bit_cnt wraps from 7 to 0
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'd0;
        end else if (!cs_active) begin
            bit_cnt <= 3'd0;
        end else if (sck_rise) begin
            bit_cnt <= bit_cnt + 3'd1;
        end
    end
    
    // Detect byte complete (bit_cnt was 7, now is 0)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_complete <= 1'b0;
        end else begin
            byte_complete <= cs_active && sck_rise && (bit_cnt == 3'd7);
        end
    end

    //=========================================================================
    // RX shift register
    //=========================================================================
    logic [7:0] rx_shift;
    logic [7:0] rx_byte;  // Latched complete byte
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_shift <= 8'h00;
        end else if (!cs_active) begin
            rx_shift <= 8'h00;
        end else if (sck_rise) begin
            rx_shift <= {rx_shift[6:0], mosi_bit};
        end
    end
    
    // Latch complete byte
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_byte <= 8'h00;
        end else if (byte_complete) begin
            rx_byte <= rx_shift;
        end
    end

    //=========================================================================
    // Byte counter (which byte in transaction: 0=CMD, 1=RESP, 2=DATA, 3=ACK)
    //=========================================================================
    logic [1:0] byte_num;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_num <= 2'd0;
        end else if (!cs_active) begin
            byte_num <= 2'd0;
        end else if (byte_complete) begin
            byte_num <= byte_num + 2'd1;
        end
    end

    //=========================================================================
    // Command decode (latch on byte 0 complete)
    //=========================================================================
    logic [3:0] cmd_addr_r;
    logic [3:0] cmd_opcode_r;
    logic       cmd_is_read;
    logic       cmd_is_write;
    logic       cmd_valid;      // Address exists
    logic       cmd_writable;   // Address is writable
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cmd_addr_r   <= 4'h0;
            cmd_opcode_r <= 4'h0;
            cmd_is_read  <= 1'b0;
            cmd_is_write <= 1'b0;
            cmd_valid    <= 1'b0;
            cmd_writable <= 1'b0;
        end else if (!cs_active) begin
            cmd_addr_r   <= 4'h0;
            cmd_opcode_r <= 4'h0;
            cmd_is_read  <= 1'b0;
            cmd_is_write <= 1'b0;
            cmd_valid    <= 1'b0;
            cmd_writable <= 1'b0;
        end else if (byte_complete && byte_num == 2'd0) begin
            // Latch command info
            cmd_addr_r   <= rx_shift[7:4];
            cmd_opcode_r <= rx_shift[3:0];
            cmd_is_read  <= (rx_shift[3:0] == CMD_READ);
            cmd_is_write <= (rx_shift[3:0] == CMD_WRITE);
            cmd_valid    <= reg_addr_valid;
            cmd_writable <= reg_writable;
        end
    end

    //=========================================================================
    // TX data (what to send back)
    // Prepare on falling edge after byte_complete
    //=========================================================================
    logic [7:0] tx_data;
    logic [2:0] tx_bit_idx;  // Which bit to output (7 downto 0)
    
    // TX bit index: counts down from 7 on each falling edge
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_bit_idx <= 3'd7;
        end else if (!cs_active) begin
            tx_bit_idx <= 3'd7;
        end else if (byte_complete) begin
            tx_bit_idx <= 3'd7;  // Reset for next byte
        end else if (sck_fall) begin
            tx_bit_idx <= tx_bit_idx - 3'd1;
        end
    end
    
    // TX data loading
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_data <= 8'h00;
        end else if (!cs_active) begin
            tx_data <= 8'h00;
        end else if (byte_complete) begin
            case (byte_num)
                2'd0: begin
                    // CMD byte done, prepare response for byte 1
                    if (rx_shift[3:0] == CMD_READ) begin
                        // Read: send data or NAK
                        tx_data <= reg_addr_valid ? reg_rdata : RESP_NAK;
                    end else if (rx_shift[3:0] == CMD_WRITE) begin
                        // Write: send ACK or NAK
                        tx_data <= (reg_addr_valid && reg_writable) ? RESP_ACK : RESP_NAK;
                    end else begin
                        // Invalid opcode
                        tx_data <= RESP_NAK;
                    end
                end
                2'd2: begin
                    // DATA byte done (during write), prepare ACK
                    tx_data <= RESP_ACK;
                end
                default: begin
                    tx_data <= 8'h00;
                end
            endcase
        end
    end

    //=========================================================================
    // Register interface
    //=========================================================================
    // reg_addr: during CMD byte, use rx_shift; after that, use latched
    assign reg_addr = (byte_num == 2'd0) ? rx_shift[7:4] : cmd_addr_r;
    
    // reg_rd: pulse when CMD byte complete and it's a read
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_rd <= 1'b0;
        end else begin
            reg_rd <= byte_complete && (byte_num == 2'd0) && (rx_shift[3:0] == CMD_READ);
        end
    end
    
    // reg_wr: pulse when DATA byte complete during write
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_wr    <= 1'b0;
            reg_wdata <= 8'h00;
        end else if (byte_complete && byte_num == 2'd2 && cmd_is_write && cmd_valid && cmd_writable) begin
            reg_wr    <= 1'b1;
            reg_wdata <= rx_shift;
        end else begin
            reg_wr <= 1'b0;
        end
    end

    //=========================================================================
    // MISO output
    //=========================================================================
    assign spi_miso = cs_active ? tx_data[tx_bit_idx] : 1'b0;

endmodule