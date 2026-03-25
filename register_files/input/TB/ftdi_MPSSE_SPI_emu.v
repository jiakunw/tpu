// Ray Xu
// CISL
// Jan 2022

// Task module that emulates the FTDI FT232H in SPI, mode 0, CS active low.
// Based on measurements on C232HM-EDHSL-0 cable



`timescale 1ns/1ns			// Time units in nS



module ftdi_MPSSE_SPI_emu #(
	parameter SPI_CLK_PERIOD = 1000,	// Clock period in nS
	parameter MSG_LEN = 256,			// Number of bits in each SPI read/write call to SPI_exchange()
	parameter CSActive_TO_CLK = 1400,	// CS-active -> RE clock time in nS
	parameter CLK_TO_CSDeactive = 1400,	// FE clock -> CS-deactive time in nS
	parameter OP_DELAY = 100		// Emulator delay between write_strobe -> SPI exchange and SPI exchange -> read_strobe, as well as read_strobe pulse width
	) (
	// FTDI chip connections
	output reg SCLK,
	output reg DO,
	input DI,
	output reg CS,
	// Testbench connections
	input write_strobe,
	input [MSG_LEN-1:0] write_data,
	output reg read_strobe,
	output reg [MSG_LEN-1:0] read_data);
// SPI properties



// Registor to latch the data when write_strobe is active
reg [MSG_LEN-1:0] MSG_WRITE;
// Register to store the data read from SPI slave
reg [MSG_LEN-1:0] MSG_READ;

// Testbench usage:
// To write to the SPI slave, set write_data then assert a posedge on write_strobe.
// The read data from SPI slave will appear on read_data and a read_strobe posedge will be asserted
initial begin
	read_strobe = 0;
end
always @(posedge write_strobe)
begin
	#(OP_DELAY);
	MSG_WRITE[MSG_LEN-1:0] = write_data[MSG_LEN-1:0];
	SPI_exchange(MSG_WRITE, MSG_READ);
	read_data[MSG_LEN-1:0] = MSG_READ[MSG_LEN-1:0];
	#(OP_DELAY);
	read_strobe = 1;
	#(OP_DELAY);
	read_strobe = 0;
end


	




task SPI_exchange;
// Task inputs to write over SPI
input [MSG_LEN-1:0] MSG_WRITE;
// Task outputs read in from SPI
output [MSG_LEN-1:0] MSG_READ;
begin
	$display("[time=%t nS] SPI start: write %d bits, hex %H", $time, MSG_LEN, MSG_WRITE);
	// Initial condition
	SCLK = 0;
	CS = 1;
	#(CSActive_TO_CLK);
	// First bit to be shifted out
	DO = MSG_WRITE[MSG_LEN-1];
	CS = 0;
	repeat(MSG_LEN)
	begin
		#(SPI_CLK_PERIOD/2) SCLK = 0;
		// Falling edge SCLK happens here: shift out data
		DO = MSG_WRITE[MSG_LEN-1];
		MSG_WRITE[MSG_LEN-1:0] = MSG_WRITE[MSG_LEN-1:0] << 1;
		#(SPI_CLK_PERIOD/2) SCLK = 1;
		// Rising edge SCLK happens here: shift in data
		MSG_READ[MSG_LEN-1:0] = MSG_READ[MSG_LEN-1:0] << 1;
		MSG_READ[0] = DI;
		
	end
	// final condition
	#(SPI_CLK_PERIOD/2) SCLK = 0;	// finish the period
	SCLK = 0;
	#(CLK_TO_CSDeactive);
	CS = 1;
	DO = 0;
	SCLK = 0;
	$display("[time=%t nS] SPI end: read %d bits, hex %H", $time, MSG_LEN, MSG_READ);
end
endtask

endmodule
