// Ray Xu
// CISL
// Jan 2022

// Implements a synthesizable 256-bit R/W full-duplex SPI slow-control block.
// Compatible with FTDI FT232H in SPI, mode 0, CS active low.

// Mode 0: data will be read in on the rising edge of SCLK, and data will be clocked out on the falling edge of SCLK.

// output register "slow_control" and input wire "slow_control_readin" are registered outputs and inputs respectively according to CS signal

`timescale 1ns/1ns			// Time units in nS

module slow_control_256(
	// FTDI chip connections.  The pin names are with respect to FTDI signal names.
	input SCLK,
	input DO,
	output wire DI,
	input CS_activelow,
	// Interface to your chip.
	output reg [255:0] slow_control);

// Internal signals: write
reg [255:0] shiftreg_write;	// Shift registeres for writing to "slow_control" and reading from slow_control_readin.

// Shift-in from DO to slow_control output
always @(posedge SCLK)		shiftreg_write[255:0] <= {shiftreg_write[254:0], DO};	// Shift DO into the LSB
always @(posedge CS_activelow)	slow_control[255:0] <= shiftreg_write[255:0];		// Register out from shiftreg_write when CS goes from active to inactive

// Loopback for readback
wire [255:0] slow_control_readin;	// Read-in signal for read operation.  By default this is loopbacked to the write output slow_control.
assign slow_control_readin[255:0] = slow_control[255:0];

// Internal signals: read
reg [255:0] shiftreg_read;
/*
// CODE OPTION A (DOESNT WORK)
// Shift DI from the MSB on negedge SCLK; otherwise preset values on CS inactive state
always @(negedge SCLK or posedge CS_activelow)
begin
	// Asynchronous preset to load the registered data into the shift register
	if (CS_activelow)	shiftreg_read[1023:0] <= slow_control_readin[1023:0];
	else			shiftreg_read[1023:0] <= shiftreg_read[1022:0] << 1;
end
assign DI = shiftreg_read[1023];
*/

// CODE OPTION B 
integer i;	// dummy variable
reg [7:0] counter;	// width = ceil(log2(max # of control bits))
reg [255:0] bmask;	// Read bit mask

// Register in from 'slow_control_readin' when CS goes from inactive to active
always @(negedge CS_activelow)		shiftreg_read[255:0] <= slow_control_readin[255:0];
// Async reset counter when CS is inactive, otherwise decrement counter.  This imitates a MSB-first shift out
always @(negedge SCLK or posedge CS_activelow)
begin
	if (CS_activelow)	counter[7:0] <= 8'b11111111;
	else			counter[7:0] <= counter[7:0] - 1'd1;
end
// Decode counter output
always @(*)
begin
	// https://stackoverflow.com/questions/58192902/what-will-be-a-good-way-to-write-10bits-decoder
	for (i = 0; i < 256; i=i+1) begin
		// (in < i) returns a 1-bit value
		bmask[i] = (counter[7:0] == i);
	end
end
// Serial output is a MUX according to bmask
assign DI = |(bmask[255:0] & shiftreg_read[255:0]);













endmodule
