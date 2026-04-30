///////////////////////////////////////////////////////////////////////////////
// tpu_bus_master.sv
//
// TPU Bus Master - Polling Version, shared AB bus (FPGA Side)
//
// CPU writes A and B simultaneously in one AXI transaction via DATA_AB.
// Channel C is independent (read only).
// CDC via toggle-handshake per transaction (100 MHz AXI <-> 10 MHz BUS).
//
// Software usage (pseudocode):
//
//   // --- Write Matrix A and B simultaneously (4096 bytes each) ---
//   START = START_AB;
//   while (!(STATUS & READY_AB));
//   for (int i = 0; i < 4096; i++) {
//       while (!(STATUS & READY_AB));
//       DATA_AB = ((uint32_t)b_buf[i] << 8) | a_buf[i];  // one AXI write
//   }
//
//   // --- Read Matrix C (4096 bytes) ---
//   START = START_C;
//   while (!(STATUS & READY_C));
//   for (int i = 0; i < 4096; i++) {
//       while (!(STATUS & READY_C));
//       DATA_C = 0;                   // trigger CHC_RD
//       while (!(STATUS & READY_C));  // wait for capture
//       buf[i] = DATA_C & 0xFF;
//   }
//
// Register Map (AXI-Lite, 32-bit, byte-addressed):
//
//   0x00  STATUS   [0]=READY_AB  [1]=READY_C   (read-only)
//                  1 = channel idle, safe to issue next request
//
//   0x04  START    [0]=START_AB  [1]=START_C   (write-only, self-clearing)
//                  Resets slave address counter. Poll READY before first byte.
//
//   0x08  DATA_AB  [15:8]=B_byte  [7:0]=A_byte
//                  Write: simultaneously send one byte to SRAM_A and SRAM_B.
//                  Clears READY_AB until BUS domain acks.
//
//   0x0C  DATA_C   [7:0] = captured byte (read) / any value (write to trigger)
//                  Write: trigger one CHC_RD. Clears READY_C.
//                  Read:  return byte captured from CHC_RDATA (valid when READY_C=1).
//
// CDC: toggle-handshake.
//   AXI domain toggles req_*_tog -> 3-FF sync to BUS -> edge detect -> bus op
//   BUS domain toggles ack_*_tog -> 3-FF sync to AXI -> edge detect -> READY=1
//
// Timing per byte-pair (worst case):
//   3 BUS cycles sync req  = 300 ns
//   1 BUS cycle  bus op    = 100 ns  (2 extra for C read FSM)
//   3 AXI cycles sync ack  =  30 ns
//   ~430 ns/pair -> ~4096 pairs in ~1.8 ms
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tpu_bus_master #(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 7    // Vivado AXI-Lite default
)(
    //=========================================================================
    // AXI-Lite Slave Interface
    //=========================================================================
    input  logic                              S_AXI_ACLK,
    input  logic                              S_AXI_ARESETN,

    input  logic [C_S_AXI_ADDR_WIDTH-1:0]    S_AXI_AWADDR,
    input  logic                              S_AXI_AWVALID,
    output logic                              S_AXI_AWREADY,

    input  logic [C_S_AXI_DATA_WIDTH-1:0]    S_AXI_WDATA,
    input  logic [C_S_AXI_DATA_WIDTH/8-1:0]  S_AXI_WSTRB,
    input  logic                              S_AXI_WVALID,
    output logic                              S_AXI_WREADY,

    output logic [1:0]                        S_AXI_BRESP,
    output logic                              S_AXI_BVALID,
    input  logic                              S_AXI_BREADY,

    input  logic [C_S_AXI_ADDR_WIDTH-1:0]    S_AXI_ARADDR,
    input  logic                              S_AXI_ARVALID,
    output logic                              S_AXI_ARREADY,

    output logic [C_S_AXI_DATA_WIDTH-1:0]    S_AXI_RDATA,
    output logic [1:0]                        S_AXI_RRESP,
    output logic                              S_AXI_RVALID,
    input  logic                              S_AXI_RREADY,

    //=========================================================================
    // Bus Clock (10 MHz)
    //=========================================================================
    input  logic                              BUS_CLK,

    //=========================================================================
    // Bus Interface (to PMOD -> TPU bus_slave)
    //=========================================================================
    output logic                              BUS_RST_N,

    // AB Bus
    output logic                              CHAB_START,
    output logic [7:0]                        CHAB_WDATA_A,
    output logic [7:0]                        CHAB_WDATA_B,
    output logic [7:0]                        CHAB_WDATA_BIAS,  // [23:16] of DATA_AB
    output logic                              CHAB_WR,

    // C Bus
    output logic                              CHC_START,
    input  logic [7:0]                        CHC_RDATA,
    output logic                              CHC_RD
);

    //=========================================================================
    // Tie-offs
    //=========================================================================
    assign S_AXI_BRESP = 2'b00;
    assign S_AXI_RRESP = 2'b00;
    assign BUS_RST_N   = S_AXI_ARESETN;

    //=========================================================================
    // Register word addresses (addr[3:2])
    //=========================================================================
    localparam [1:0] ADDR_STATUS  = 2'd0;  // 0x00
    localparam [1:0] ADDR_START   = 2'd1;  // 0x04
    localparam [1:0] ADDR_DATA_AB = 2'd2;  // 0x08
    localparam [1:0] ADDR_DATA_C  = 2'd3;  // 0x0C

    //=========================================================================
    // AXI Clock Domain
    //=========================================================================
    logic ready_ab, ready_c;

    // Data latches
    logic [7:0] reg_data_a;        // latched A byte from DATA_AB[7:0]
    logic [7:0] reg_data_b;        // latched B byte from DATA_AB[15:8]
    logic [7:0] reg_data_bias;     // latched BIAS byte from DATA_AB[23:16]
    logic [7:0] reg_data_c_cap;    // captured byte from CHC_RDATA

    // Request toggles (AXI domain)
    logic req_sab_tog;   // START AB
    logic req_sc_tog;    // START C
    logic req_ab_tog;    // DATA AB write
    logic req_c_tog;     // DATA C read trigger

    // Ack toggles synced from BUS domain
    logic ack_sab_sync, ack_sc_sync;
    logic ack_ab_sync,  ack_c_sync;

    // Previous ack values for edge detection
    logic ack_sab_prev, ack_sc_prev;
    logic ack_ab_prev,  ack_c_prev;

    wire ack_sab_pulse = ack_sab_sync ^ ack_sab_prev;
    wire ack_sc_pulse  = ack_sc_sync  ^ ack_sc_prev;
    wire ack_ab_pulse  = ack_ab_sync  ^ ack_ab_prev;
    wire ack_c_pulse   = ack_c_sync   ^ ack_c_prev;

    logic [7:0] ack_c_data_sync;   // captured data synced back from BUS

    // Single-cycle clear-ready signals from write FSM
    logic clr_sab, clr_sc, clr_ab, clr_c;

    logic [7:0] ack_c_data_b;

    //=========================================================================
    // AXI-Lite Write FSM
    //=========================================================================
    typedef enum logic [1:0] { WR_IDLE, WR_DATA, WR_RESP } wr_state_t;
    wr_state_t wr_state;
    logic [C_S_AXI_ADDR_WIDTH-1:0] aw_addr_lat;

    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            wr_state      <= WR_IDLE;
            S_AXI_AWREADY <= 1'b0;
            S_AXI_WREADY  <= 1'b0;
            S_AXI_BVALID  <= 1'b0;
            aw_addr_lat   <= '0;
            reg_data_a    <= '0;
            reg_data_b    <= '0;
            reg_data_bias <= '0;
            req_sab_tog   <= 1'b0;
            req_sc_tog    <= 1'b0;
            req_ab_tog    <= 1'b0;
            req_c_tog     <= 1'b0;
            clr_sab <= 1'b0; clr_sc <= 1'b0;
            clr_ab  <= 1'b0; clr_c  <= 1'b0;
        end else begin
            clr_sab <= 1'b0; clr_sc <= 1'b0;
            clr_ab  <= 1'b0; clr_c  <= 1'b0;

            case (wr_state)
                WR_IDLE: begin
                    S_AXI_AWREADY <= 1'b0;
                    S_AXI_WREADY  <= 1'b0;
                    S_AXI_BVALID  <= 1'b0;
                    if (S_AXI_AWVALID) begin
                        S_AXI_AWREADY <= 1'b1;
                        aw_addr_lat   <= S_AXI_AWADDR;
                        wr_state      <= WR_DATA;
                    end
                end

                WR_DATA: begin
                    S_AXI_AWREADY <= 1'b0;
                    if (S_AXI_WVALID) begin
                        S_AXI_WREADY <= 1'b1;

                        case (aw_addr_lat[3:2])
                            ADDR_START: begin
                                if (S_AXI_WDATA[0] && ready_ab) begin
                                    req_sab_tog <= ~req_sab_tog;
                                    clr_sab     <= 1'b1;
                                end
                                if (S_AXI_WDATA[1] && ready_c) begin
                                    req_sc_tog <= ~req_sc_tog;
                                    clr_sc     <= 1'b1;
                                end
                            end
                            ADDR_DATA_AB: begin
                                if (ready_ab) begin
                                    reg_data_a    <= S_AXI_WDATA[7:0];
                                    reg_data_b    <= S_AXI_WDATA[15:8];
                                    reg_data_bias <= S_AXI_WDATA[23:16];
                                    req_ab_tog    <= ~req_ab_tog;
                                    clr_ab        <= 1'b1;
                                end
                            end
                            ADDR_DATA_C: begin
                                if (ready_c) begin
                                    req_c_tog <= ~req_c_tog;
                                    clr_c     <= 1'b1;
                                end
                            end
                            default: ;
                        endcase

                        wr_state <= WR_RESP;
                    end
                end

                WR_RESP: begin
                    S_AXI_WREADY <= 1'b0;
                    S_AXI_BVALID <= 1'b1;
                    if (S_AXI_BREADY) begin
                        S_AXI_BVALID <= 1'b0;
                        wr_state     <= WR_IDLE;
                    end
                end

                default: wr_state <= WR_IDLE;
            endcase
        end
    end

    //=========================================================================
    // READY flag management + ack edge detection
    //=========================================================================
    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            ready_ab       <= 1'b1;
            ready_c        <= 1'b1;
            reg_data_c_cap <= '0;
            ack_sab_prev   <= 1'b0; ack_sc_prev  <= 1'b0;
            ack_ab_prev    <= 1'b0; ack_c_prev   <= 1'b0;
        end else begin
            ack_sab_prev <= ack_sab_sync;
            ack_sc_prev  <= ack_sc_sync;
            ack_ab_prev  <= ack_ab_sync;
            ack_c_prev   <= ack_c_sync;

            // AB: ack from START or DATA restores ready
            if      (ack_sab_pulse || ack_ab_pulse) ready_ab <= 1'b1;
            else if (clr_sab || clr_ab)             ready_ab <= 1'b0;

            // C
            if (ack_sc_pulse || ack_c_pulse) begin
                ready_c <= 1'b1;
                if (ack_c_pulse)
                    reg_data_c_cap <= ack_c_data_b;
            end else if (clr_sc || clr_c) begin
                ready_c <= 1'b0;
            end
        end
    end

    //=========================================================================
    // AXI-Lite Read FSM
    //=========================================================================
    typedef enum logic [1:0] { RD_IDLE, RD_DATA } rd_state_t;
    rd_state_t rd_state;

    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            rd_state      <= RD_IDLE;
            S_AXI_ARREADY <= 1'b0;
            S_AXI_RVALID  <= 1'b0;
            S_AXI_RDATA   <= '0;
        end else begin
            case (rd_state)
                RD_IDLE: begin
                    S_AXI_ARREADY <= 1'b0;
                    S_AXI_RVALID  <= 1'b0;
                    if (S_AXI_ARVALID) begin
                        S_AXI_ARREADY <= 1'b1;
                        case (S_AXI_ARADDR[3:2])
                            ADDR_STATUS: S_AXI_RDATA <= {30'h0, ready_c, ready_ab};
                            ADDR_DATA_C: S_AXI_RDATA <= {24'h0, reg_data_c_cap};
                            default:     S_AXI_RDATA <= 32'h0;
                        endcase
                        rd_state <= RD_DATA;
                    end
                end

                RD_DATA: begin
                    S_AXI_ARREADY <= 1'b0;
                    S_AXI_RVALID  <= 1'b1;
                    if (S_AXI_RREADY) begin
                        S_AXI_RVALID <= 1'b0;
                        rd_state     <= RD_IDLE;
                    end
                end

                default: rd_state <= RD_IDLE;
            endcase
        end
    end

    //=========================================================================
    // CDC: Sync req toggles AXI -> BUS (3-FF)
    //=========================================================================
    logic req_sab_s1, req_sab_s2, req_sab_s3;
    logic req_sc_s1,  req_sc_s2,  req_sc_s3;
    logic req_ab_s1,  req_ab_s2,  req_ab_s3;
    logic req_c_s1,   req_c_s2,   req_c_s3;

    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            {req_sab_s3,req_sab_s2,req_sab_s1} <= 3'b0;
            {req_sc_s3, req_sc_s2, req_sc_s1 } <= 3'b0;
            {req_ab_s3, req_ab_s2, req_ab_s1 } <= 3'b0;
            {req_c_s3,  req_c_s2,  req_c_s1  } <= 3'b0;
        end else begin
            {req_sab_s3,req_sab_s2,req_sab_s1} <= {req_sab_s2,req_sab_s1,req_sab_tog};
            {req_sc_s3, req_sc_s2, req_sc_s1 } <= {req_sc_s2, req_sc_s1, req_sc_tog };
            {req_ab_s3, req_ab_s2, req_ab_s1 } <= {req_ab_s2, req_ab_s1, req_ab_tog };
            {req_c_s3,  req_c_s2,  req_c_s1  } <= {req_c_s2,  req_c_s1,  req_c_tog  };
        end
    end

    // Edge detect in BUS domain
    logic req_sab_prev_b, req_sc_prev_b, req_ab_prev_b, req_c_prev_b;

    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            req_sab_prev_b <= 1'b0; req_sc_prev_b <= 1'b0;
            req_ab_prev_b  <= 1'b0; req_c_prev_b  <= 1'b0;
        end else begin
            req_sab_prev_b <= req_sab_s3; req_sc_prev_b <= req_sc_s3;
            req_ab_prev_b  <= req_ab_s3;  req_c_prev_b  <= req_c_s3;
        end
    end

    wire req_sab_pulse_b = req_sab_s3 ^ req_sab_prev_b;
    wire req_sc_pulse_b  = req_sc_s3  ^ req_sc_prev_b;
    wire req_ab_pulse_b  = req_ab_s3  ^ req_ab_prev_b;
    wire req_c_pulse_b   = req_c_s3   ^ req_c_prev_b;

    //=========================================================================
    // BUS Clock Domain: Drive bus signals
    //=========================================================================
    logic ack_sab_tog_b, ack_sc_tog_b;
    logic ack_ab_tog_b,  ack_c_tog_b;

    // START AB
    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            CHAB_START   <= 1'b0;
            ack_sab_tog_b <= 1'b0;
        end else begin
            CHAB_START <= 1'b0;
            if (req_sab_pulse_b) begin
                CHAB_START    <= 1'b1;
                ack_sab_tog_b <= ~ack_sab_tog_b;
            end
        end
    end

    // START C
    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            CHC_START   <= 1'b0;
            ack_sc_tog_b <= 1'b0;
        end else begin
            CHC_START <= 1'b0;
            if (req_sc_pulse_b) begin
                CHC_START    <= 1'b1;
                ack_sc_tog_b <= ~ack_sc_tog_b;
            end
        end
    end

    // DATA AB
    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            CHAB_WR        <= 1'b0;
            CHAB_WDATA_A   <= '0;
            CHAB_WDATA_B   <= '0;
            CHAB_WDATA_BIAS<= '0;
            ack_ab_tog_b   <= 1'b0;
        end else begin
            CHAB_WR <= 1'b0;
            if (req_ab_pulse_b) begin
                CHAB_WDATA_A    <= reg_data_a;
                CHAB_WDATA_B    <= reg_data_b;
                CHAB_WDATA_BIAS <= reg_data_bias;
                CHAB_WR         <= 1'b1;
                ack_ab_tog_b    <= ~ack_ab_tog_b;
            end
        end
    end

    // DATA C: 3-state FSM for 1-cycle SRAM read latency
    //   C_IDLE -> C_RD (CHC_RD=1) -> C_CAPTURE (sample CHC_RDATA, ack)
    typedef enum logic [1:0] { C_IDLE, C_RD, C_CAPTURE } fsm_c_t;
    fsm_c_t fsm_c;

    always_ff @(posedge BUS_CLK or negedge BUS_RST_N) begin
        if (!BUS_RST_N) begin
            fsm_c        <= C_IDLE;
            CHC_RD       <= 1'b0;
            ack_c_tog_b  <= 1'b0;
            ack_c_data_b <= '0;
        end else begin
            CHC_RD <= 1'b0;
            case (fsm_c)
                C_IDLE: begin
                    if (req_c_pulse_b) begin
                        CHC_RD <= 1'b1;
                        fsm_c  <= C_RD;
                    end
                end
                C_RD: begin
                    // SRAM read in progress; deassert RD, data valid next cycle
                    fsm_c <= C_CAPTURE;
                end
                C_CAPTURE: begin
                    ack_c_data_b <= CHC_RDATA;
                    ack_c_tog_b  <= ~ack_c_tog_b;
                    fsm_c        <= C_IDLE;
                end
                default: fsm_c <= C_IDLE;
            endcase
        end
    end

    //=========================================================================
    // CDC: Sync ack toggles BUS -> AXI (3-FF)
    //=========================================================================
    logic ack_sab_m1, ack_sab_m2;
    logic ack_sc_m1,  ack_sc_m2;
    logic ack_ab_m1,  ack_ab_m2;
    logic ack_c_m1,   ack_c_m2;

    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            {ack_sab_sync,ack_sab_m2,ack_sab_m1} <= 3'b0;
            {ack_sc_sync, ack_sc_m2, ack_sc_m1 } <= 3'b0;
            {ack_ab_sync, ack_ab_m2, ack_ab_m1 } <= 3'b0;
            {ack_c_sync,  ack_c_m2,  ack_c_m1  } <= 3'b0;
        end else begin
            {ack_sab_sync,ack_sab_m2,ack_sab_m1} <= {ack_sab_m2,ack_sab_m1,ack_sab_tog_b};
            {ack_sc_sync, ack_sc_m2, ack_sc_m1 } <= {ack_sc_m2, ack_sc_m1, ack_sc_tog_b };
            {ack_ab_sync, ack_ab_m2, ack_ab_m1 } <= {ack_ab_m2, ack_ab_m1, ack_ab_tog_b };
            {ack_c_sync,  ack_c_m2,  ack_c_m1  } <= {ack_c_m2,  ack_c_m1,  ack_c_tog_b  };
        end
    end

    // ack_c_data: written 1 BUS cycle before ack_c_tog_b.
    // Sampled on ack_c_pulse in AXI domain (>=3 AXI cycles later). Safe.
    always_ff @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN)
            ack_c_data_sync <= '0;
        else if (ack_c_pulse)
            ack_c_data_sync <= ack_c_data_b;
    end

endmodule
