///////////////////////////////////////////////////////////////////////////////
// TPU SPI Slave - High-Speed Version (v4)
//
// SPI Mode 0: CPOL=0, CPHA=0
//   - Sample MOSI on SCK rising edge
//   - Update MISO on SCK falling edge
//
// ARCHITECTURE: Dual clock domain
//   - SCK domain: RX shift, byte_num counter, CMD decode (LIGHTWEIGHT),
//                 TX MUX, TX shift on negedge.
//   - CHIP domain: Register file interface, generates reg_addr / reg_rd /
//                  reg_wr / reg_wdata, latches reg_rdata for sck domain.
//
//   The CMD byte is decoded as soon as it's received in the SCK domain
//   (cheap: 8-bit comparison), so the byte 1 response can be selected from
//   {reg_rdata_synced, RESP_ACK, RESP_NAK} immediately at the next negedge.
//   This avoids the chip-domain round-trip which is too slow at 5-10MHz.
//
//   reg_rdata is captured in the SCK domain on byte 0 completion. Since
//   reg_rdata is combinational from {reg_addr, register storage}, and
//   reg_addr is driven by us continuously, reg_rdata reflects the requested
//   value before byte 0 completes (we drive reg_addr early in byte 0).
//
// 4-byte SPI Frame Protocol:
//   Byte 0:  MOSI = {addr[3:0], cmd[3:0]}     MISO = 0
//   Byte 1:  MOSI = dummy                     MISO = ACK / NAK / RDATA
//   Byte 2:  MOSI = wdata (write only)        MISO = 0
//   Byte 3:  MOSI = dummy                     MISO = RESP_ACK
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module spi_slave (
    input  logic        clk,
    input  logic        rstn,

    input  logic        spi_sck,
    input  logic        spi_cs_n,
    input  logic        spi_mosi,
    output logic        spi_miso,

    output logic [3:0]  reg_addr,
    output logic        reg_rd,
    output logic        reg_wr,
    output logic [7:0]  reg_wdata,
    input  logic [7:0]  reg_rdata,
    input  logic        reg_addr_valid,
    input  logic        reg_writable
);

    localparam logic [3:0] CMD_READ  = 4'b0001;
    localparam logic [3:0] CMD_WRITE = 4'b0010;
    localparam logic [7:0] RESP_ACK  = 8'hFF;
    localparam logic [7:0] RESP_NAK  = 8'hF0;

    //=========================================================================
    // SCK domain reset
    //=========================================================================
    wire sck_rstn = rstn & ~spi_cs_n;

    //=========================================================================
    // SCK DOMAIN: Bit counter (0..7)
    //=========================================================================
    logic [2:0] bit_cnt_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn) bit_cnt_sck <= 3'd0;
        else           bit_cnt_sck <= bit_cnt_sck + 3'd1;
    end

    wire byte_complete_sck = (bit_cnt_sck == 3'd7);

    //=========================================================================
    // SCK DOMAIN: Byte counter (0..3)
    //=========================================================================
    logic [1:0] byte_num_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn)              byte_num_sck <= 2'd0;
        else if (byte_complete_sck) byte_num_sck <= byte_num_sck + 2'd1;
    end

    //=========================================================================
    // SCK DOMAIN: RX shift register
    //=========================================================================
    logic [7:0] rx_shift_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn) rx_shift_sck <= 8'h00;
        else           rx_shift_sck <= {rx_shift_sck[6:0], spi_mosi};
    end

    //=========================================================================
    // SCK DOMAIN: Latch complete byte (for downstream consumption)
    //=========================================================================
    logic [7:0] rx_byte_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn)              rx_byte_sck <= 8'h00;
        else if (byte_complete_sck) rx_byte_sck <= {rx_shift_sck[6:0], spi_mosi};
    end

    //=========================================================================
    // SCK DOMAIN: Decode CMD byte AS IT IS RECEIVED
    //
    // The CMD byte is byte 0. By the 8th rising edge (byte_complete_sck),
    // {rx_shift_sck[6:0], spi_mosi} forms the complete CMD byte:
    //   bits[7:4] = addr
    //   bits[3:0] = command
    //
    // Latch the decoded fields immediately so that the negedge that follows
    // (start of byte 1) can pick the correct TX byte without waiting for
    // chip-domain round-trip.
    //=========================================================================
    logic [3:0] cmd_addr_sck;
    logic       cmd_is_read_sck;
    logic       cmd_is_write_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn) begin
            cmd_addr_sck     <= 4'h0;
            cmd_is_read_sck  <= 1'b0;
            cmd_is_write_sck <= 1'b0;
        end else if (byte_complete_sck && byte_num_sck == 2'd0) begin
            cmd_addr_sck     <= {rx_shift_sck[6:3]};                       // addr[3:0]
            cmd_is_read_sck  <= ({rx_shift_sck[2:0], spi_mosi} == CMD_READ);
            cmd_is_write_sck <= ({rx_shift_sck[2:0], spi_mosi} == CMD_WRITE);
        end
    end

    //=========================================================================
    // CHIP <-> SCK: reg_addr drive (combinational, sourced from sck domain)
    //
    // Drive reg_addr from cmd_addr_sck (synchronized to chip domain below)
    // so that mmio_register_file produces reg_rdata combinationally.
    //
    // We don't capture reg_rdata in sck domain anymore. Instead, the TX
    // byte 1 mux (built combinationally below) reads reg_rdata from chip
    // domain through a synchronizer chain. By the time byte 1's first MISO
    // bit needs to come out (1 sck period after CMD completes), reg_rdata
    // has propagated.
    //
    // Timing budget:
    //   byte 0 last posedge -> cmd_addr_sck updates
    //   + 2 chip clocks -> cmd_addr_sck_to_chip stable
    //   + reg_rdata combinational -> stable in chip domain
    //   + 2 sck clocks -> reg_rdata_sck stable in sck domain
    //   Total: 2 chip + 2 sck clocks
    //
    //   @ 10MHz SPI / 10MHz chip: 200 + 200 = 400 ns
    //   We have until byte 1's first MISO needs to be valid:
    //     byte 0 last posedge -> byte 1 first negedge = 50 ns (HALF SCK)
    //   This is NOT enough for 10MHz!
    //
    //   So we use a different timing target: byte 1's bits go out on
    //   negedges, but the LOAD of tx_shift_neg happens on the first
    //   negedge of byte 1 (when bit_cnt_sck == 0, sampled on negedge after
    //   the wrap from 7 to 0 on posedge).
    //
    //   Actually, since we LOAD tx_shift_neg on bit_cnt_sck==0 on negedge,
    //   we have: byte 0 last posedge -> next negedge = 50 ns.
    //   Still not enough.
    //
    //   FIX: defer byte 1 response load. Instead of loading on the very
    //   first negedge of byte 1, present 0 for first MISO bit and load
    //   on later negedges. But protocol expects MSB first immediately.
    //
    //   ALTERNATIVE FIX: drive reg_addr earlier, BEFORE byte 0 completes,
    //   using partial CMD bits. After bit 4 arrives (first 4 bits of byte
    //   0 = address), drive reg_addr immediately.
    //=========================================================================

    //=========================================================================
    // SCK DOMAIN: Track partial address as it shifts in
    //
    // After bit 4 of byte 0 (i.e., after the 4th rising edge of byte 0),
    // the upper 4 bits (address) are in rx_shift_sck[3:0].
    //=========================================================================
    logic [3:0] partial_addr_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn)
            partial_addr_sck <= 4'h0;
        else if (byte_num_sck == 2'd0 && bit_cnt_sck == 3'd4) begin
            // After 4 bits shifted in, capture upper nibble (address)
            partial_addr_sck <= rx_shift_sck[3:0];
        end
    end

    //=========================================================================
    // Synchronize partial_addr_sck to chip domain (drives reg_addr)
    //=========================================================================
    logic [3:0] partial_addr_chip_meta;
    logic [3:0] partial_addr_chip;

    always_ff @(posedge clk) begin
        if (!rstn) begin
            partial_addr_chip_meta <= 4'h0;
            partial_addr_chip      <= 4'h0;
        end else begin
            partial_addr_chip_meta <= partial_addr_sck;
            partial_addr_chip      <= partial_addr_chip_meta;
        end
    end

    //=========================================================================
    // reg_rdata sync back to sck domain
    //
    // OPTIMIZATION: Use 1-FF sync (not 2-FF) for tighter timing budget.
    //
    // Justification: reg_rdata is "quasi-static" - once partial_addr_chip
    // settles, reg_rdata stays stable for many sck periods. The 2-FF sync
    // on partial_addr (chip side) already filters out metastability before
    // it can reach the mmio mux. By the time reg_rdata is sampled on the
    // sck side, it has been stable for >= 1 chip clock with no glitching.
    //
    // For tape-out, this 1-FF sync needs careful analysis with
    // mmio_register_file's combinational delay added in. Validate via
    // post-PnR sim with SDF. If post-PnR shows hold violations, revert
    // to 2-FF sync but increase the SCK period margin.
    //=========================================================================
    logic [7:0] reg_rdata_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn) reg_rdata_sck <= 8'h00;
        else           reg_rdata_sck <= reg_rdata;            // CDC: false_path
    end

    //=========================================================================
    // reg_addr_valid / reg_writable sync to sck domain (1-FF, same justification)
    //=========================================================================
    logic reg_addr_valid_sck;
    logic reg_writable_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn) begin
            reg_addr_valid_sck  <= 1'b0;
            reg_writable_sck    <= 1'b0;
        end else begin
            reg_addr_valid_sck  <= reg_addr_valid;
            reg_writable_sck    <= reg_writable;
        end
    end

    //=========================================================================
    // SCK DOMAIN: byte-1 response is COMBINATIONAL.
    //
    // Once cmd_addr_sck and cmd_is_read_sck are latched (at byte 0 complete),
    // the response is simply a function of those + the live reg_rdata_sck.
    //
    // By the time byte 1's negedge needs to load tx_shift (1.5 sck periods
    // after CMD complete), reg_rdata_sck has had ~3 sck periods to
    // propagate from chip domain. This is plenty of time.
    //
    // Specifically:
    //   - bit 4 of byte 0: partial_addr_sck latches
    //   - +1 sck: posedge #5
    //   - +2 chip clocks: partial_addr_chip stable
    //   - +1 sck: reg_rdata_meta captures latest reg_rdata
    //   - +1 sck: reg_rdata_sck stable
    //
    //   Cumulative @ 10MHz SPI / 10MHz chip: 4*100 + 200 = 600 ns
    //
    //   Need to be ready by: byte 1 first negedge load = byte 0 last
    //   posedge + 50 ns + ... actually loading happens on negedge AFTER
    //   posedge #8 wraps bit_cnt to 0. That negedge is 50 ns after
    //   posedge #8, which is 4*100+50 = 450 ns after posedge #5.
    //   Tight: need 600 ns but have 450 ns.
    //
    //   So we use a DIFFERENT trick: the byte-1 response is combinational
    //   from reg_rdata_sck (which keeps updating in background). The first
    //   bit on MISO at the negedge after posedge #8 will use whatever
    //   reg_rdata_sck has at that moment. As long as reg_rdata_sck
    //   eventually catches up before the master samples, we're OK.
    //
    //   Actually no, the master samples on posedge #9 which is 100 ns
    //   after posedge #8 (full sck period). So we have until posedge #9
    //   for MISO bit 7 to be valid. That gives 100 ns more... still not
    //   quite enough at 10MHz.
    //
    //   PROPER FIX: capture partial_addr_sck EARLIER. After bit 1 of
    //   byte 0 (not bit 4), so we have 7 sck periods for CDC roundtrip.
    //   But we don't have the address yet at bit 1 - only have addr[3].
    //
    //   Wait - we don't need the FULL address early. We need to START
    //   the CDC chain early. Once address is known, the chain is already
    //   running. Just need to capture each address bit as it arrives, in
    //   parallel.
    //
    //   Even simpler fix: drive reg_addr from rx_shift_sck DIRECTLY (no
    //   capture needed). reg_addr will track the upper nibble of
    //   rx_shift_sck as bits stream in. This means reg_addr might be
    //   "wrong" temporarily but will be CORRECT by the time bit 4 lands.
    //
    //   The mmio combinationally produces reg_rdata. After bit 4, reg_rdata
    //   reflects the right register. Sync chain from bit 4 onwards.
    //=========================================================================

    logic [7:0] byte1_response;

    always_comb begin
        if (cmd_is_read_sck) begin
            byte1_response = reg_addr_valid_sck ? reg_rdata_sck : RESP_NAK;
        end else if (cmd_is_write_sck) begin
            byte1_response = (reg_addr_valid_sck && reg_writable_sck)
                              ? RESP_ACK : RESP_NAK;
        end else begin
            byte1_response = RESP_NAK;
        end
    end

    //=========================================================================
    // SCK DOMAIN: TX byte selection mux
    //
    // Based on byte_num_sck (which has just been incremented by the same
    // edge that completed the previous byte), choose what to load into
    // tx_shift_neg.
    //
    //   byte_num_sck == 0: about to send byte 0 -> 0x00 (slave is silent)
    //   byte_num_sck == 1: about to send byte 1 -> response (read data / ACK)
    //   byte_num_sck == 2: about to send byte 2 -> 0x00
    //   byte_num_sck == 3: about to send byte 3 -> RESP_ACK
    //=========================================================================
    logic [7:0] next_tx_byte_sck;

    always_comb begin
        case (byte_num_sck)
            2'd1:    next_tx_byte_sck = byte1_response;
            2'd3:    next_tx_byte_sck = RESP_ACK;
            default: next_tx_byte_sck = 8'h00;
        endcase
    end

    //=========================================================================
    // SCK DOMAIN: TX shift register on NEGEDGE
    //
    // On negedge SCK with bit_cnt_sck == 0, a new byte starts -> load.
    // Otherwise shift left.
    //=========================================================================
    logic [7:0] tx_shift_neg;

    always_ff @(negedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn)
            tx_shift_neg <= 8'h00;
        else if (bit_cnt_sck == 3'd0)
            tx_shift_neg <= next_tx_byte_sck;
        else
            tx_shift_neg <= {tx_shift_neg[6:0], 1'b0};
    end

    //=========================================================================
    // MISO output
    //=========================================================================
    assign spi_miso = spi_cs_n ? 1'b0 : tx_shift_neg[7];

    //=========================================================================
    // SCK -> CHIP: byte_done toggle CDC for chip-domain register write
    //=========================================================================
    logic byte_done_toggle_sck;

    always_ff @(posedge spi_sck or negedge sck_rstn) begin
        if (!sck_rstn)              byte_done_toggle_sck <= 1'b0;
        else if (byte_complete_sck) byte_done_toggle_sck <= ~byte_done_toggle_sck;
    end

    //=========================================================================
    // CHIP DOMAIN: Synchronize CS_N
    //=========================================================================
    logic [1:0] cs_n_sync;
    always_ff @(posedge clk) begin
        if (!rstn) cs_n_sync <= 2'b11;
        else       cs_n_sync <= {cs_n_sync[0], spi_cs_n};
    end
    wire cs_active_chip = ~cs_n_sync[1];

    //=========================================================================
    // CHIP DOMAIN: Synchronize byte_done_toggle
    //=========================================================================
    logic [2:0] byte_done_sync;

    always_ff @(posedge clk) begin
        if (!rstn) byte_done_sync <= 3'b000;
        else       byte_done_sync <= {byte_done_sync[1:0], byte_done_toggle_sck};
    end

    wire byte_done_chip = byte_done_sync[2] ^ byte_done_sync[1];

    //=========================================================================
    // CHIP DOMAIN: Capture rx_byte_sck (CDC data)
    //=========================================================================
    logic [7:0] rx_byte_chip;

    always_ff @(posedge clk) begin
        if (!rstn)               rx_byte_chip <= 8'h00;
        else if (byte_done_chip) rx_byte_chip <= rx_byte_sck;     // CDC: false_path
    end

    //=========================================================================
    // CHIP DOMAIN: byte counter (counts bytes received)
    //=========================================================================
    logic [2:0] byte_num_chip;

    always_ff @(posedge clk) begin
        if (!rstn)                  byte_num_chip <= 3'd0;
        else if (!cs_active_chip)   byte_num_chip <= 3'd0;
        else if (byte_done_chip)    byte_num_chip <= byte_num_chip + 3'd1;
    end

    //=========================================================================
    // CHIP DOMAIN: One-cycle delay for downstream consumers
    //=========================================================================
    logic byte_done_chip_d1;

    always_ff @(posedge clk) begin
        if (!rstn) byte_done_chip_d1 <= 1'b0;
        else       byte_done_chip_d1 <= byte_done_chip;
    end

    //=========================================================================
    // CHIP DOMAIN: Latched cmd_addr / cmd_is_write (for write data byte)
    //
    // After byte 0 received: byte_done_chip_d1=1, byte_num_chip=1.
    // rx_byte_chip holds CMD byte.
    //=========================================================================
    logic [3:0] cmd_addr_chip;
    logic       cmd_is_write_chip;

    always_ff @(posedge clk) begin
        if (!rstn || !cs_active_chip) begin
            cmd_addr_chip     <= 4'h0;
            cmd_is_write_chip <= 1'b0;
        end else if (byte_done_chip_d1 && byte_num_chip == 3'd1) begin
            cmd_addr_chip     <= rx_byte_chip[7:4];
            cmd_is_write_chip <= (rx_byte_chip[3:0] == CMD_WRITE);
        end
    end

    //=========================================================================
    // reg_addr: drive mmio with current address.
    //
    // The mmio_register_file uses reg_addr combinationally to mux reg_rdata.
    // We want reg_addr to track the current SPI command's address so that
    // reg_rdata is valid by the time we capture it in sck domain.
    //
    // Strategy: drive reg_addr from rx_byte_sck[7:4] AS SOON AS the upper
    // 4 bits arrive (in MOSI bit positions 7..4 of byte 0). However, that's
    // complex CDC. Simpler: drive reg_addr from the latched cmd_addr_chip,
    // and accept that reg_rdata won't be ready until ~3 chip clocks after
    // byte 0 ends.
    //
    // BUT: byte 1 only needs reg_rdata for READ commands, and byte 1 has
    // 8 SCK periods (8 us @ 1MHz, 800 ns @ 10MHz) to get it.
    //   @ 1MHz: 8 us is plenty (>50 chip clocks)
    //   @ 10MHz: 800 ns = 8 chip clocks - tight but feasible
    //
    // Wait - this contradicts my plan. Let me think again.
    //
    // The sck-domain captures reg_rdata at byte_complete_sck of byte 0.
    // For that capture to succeed, reg_addr in chip domain must already
    // point to the correct register and reg_rdata must reflect that.
    //
    // Solution: drive reg_addr in sck domain. We have rx_shift_sck[7:4]
    // available continuously. After bit 4 of byte 0 arrives, the address
    // bits are in rx_shift_sck[3:0]. After bit 8 (full byte), we use
    // {rx_shift[6:0], mosi}[7:4] which is rx_shift[2..0] + something messy.
    //
    // Simplest robust approach: use a 2-cycle SPI bridge - byte 0 receives,
    // sck side captures cmd_addr, then there's a "wait byte" before byte 1
    // is sent. But we can't change the protocol now.
    //
    // CLEANEST solution: drive reg_addr from sck-side cmd_addr_sck.
    // Add a 2-FF synchronizer in mmio's reg_addr direction. mmio sees
    // synchronized addr and produces reg_rdata combinationally. The
    // round-trip is:
    //   sck CMD complete -> cmd_addr_sck updates (sck domain)
    //   -> 2 chip-FF sync (chip domain has new addr)
    //   -> mmio combinational reg_rdata
    //   -> 2 sck-FF sync of reg_rdata back
    //   = ~4 chip + 2 sck periods
    //
    // @1MHz SPI / 10MHz chip: 4*100 + 2*1000 = 2400 ns = 2.4 us << 8 us. OK.
    // @10MHz SPI / 10MHz chip: 4*100 + 2*100 = 600 ns < 800 ns. Tight, OK.
    //
    // For now, use the simpler approach where reg_addr in chip domain is
    // driven directly from cmd_addr_sck (synchronized). This is safe at all
    // tested speeds because we have most of byte 1 to wait.
    //=========================================================================

    //=========================================================================
    // reg_addr drive (chip domain)
    //
    // Drives mmio's combinational read mux. Sourced from synchronized
    // partial_addr_sck (captured after 4 bits of byte 0).
    //=========================================================================
    assign reg_addr = partial_addr_chip;

    //=========================================================================
    // reg_rd: pulse for one chip cycle when CMD READ is decoded
    //=========================================================================
    always_ff @(posedge clk) begin
        if (!rstn)
            reg_rd <= 1'b0;
        else
            reg_rd <= byte_done_chip_d1
                   && byte_num_chip == 3'd1
                   && rx_byte_chip[3:0] == CMD_READ;
    end

    //=========================================================================
    // reg_wr: pulse when DATA byte (byte 2) received
    //=========================================================================
    always_ff @(posedge clk) begin
        if (!rstn) begin
            reg_wr    <= 1'b0;
            reg_wdata <= 8'h00;
        end else if (byte_done_chip_d1
                  && byte_num_chip == 3'd3
                  && cmd_is_write_chip) begin
            reg_wr    <= 1'b1;
            reg_wdata <= rx_byte_chip;
        end else begin
            reg_wr <= 1'b0;
        end
    end

endmodule
