// Ray Xu
// CISL
// Jan 2022

/*
For Cadence AMS simulation only.

This file:
(1) Implements testbench behavior
(2) breaks out relevant testbench signals as top-level ports
*/

`timescale 1ns/1ns			// Time units in nS

module slow_control_256_checker(
	// DUT signals
	output wire DO,
	input wire DI,
	output wire SCLK,
	output wire CS,
	input wire [255:0] sc,
	// Testbench signals
	output reg test_pass
);

// SIMULATION SWITCHES (only uncomment one)
`define SIM_BEHAV	// Uncomment for behavioral level simulation
//`define SIM_POSTSYNTH	// Uncomment for post-synthesis simulation
//`define SIM_POSTPNR	// Uncomment for post-place&route simulation
//`define SIM_TRANSISTOR	// Uncomment for transistor level simulation


// SDF corner for post-pnr only
//`define SDF_CORNER 	"TYPICAL"		// Valid values: TYPICAL, MINIMUM, MAXIMUM



// There are two types of tests: 'SC' and 'SPIREADBACK'.  
// Test 'SC' looks at the chip DUT slow-control parallel data output and compares it against the golden.
// Test 'SPIREADBACK' looks at the data read back serially and compares it against the golden.

// FTDI emulator signals
wire read_strobe;
reg write_strobe;
wire [255:0] read_data;
reg [255:0] write_data;	// This is also golden slow control data
// Testbench signals
integer tbfile;


// FTDI emulator
ftdi_MPSSE_SPI_emu U_EMU(
	// FTDI chip connections
	.SCLK(SCLK),
	.DO(DO),
	.DI(DI),
	.CS(CS),
	// Testbench connections
	.write_strobe(write_strobe),
	.write_data(write_data),
	.read_strobe(read_strobe),
	.read_data(read_data)
);

initial 
begin
	test_pass = 1;
	// Logistics
	tbfile = $fopen("slow_control_256_tb.txt", "a");	
	$display("Time units = pS");
	$fwrite(tbfile, "Time units = pS\n");
	`ifdef SIM_BEHAV
		$display("Behavioral simulation");
		$fwrite(tbfile, "Behavioral simulation\n");
	`endif
	`ifdef SIM_POSTSYNTH
		$display("Post-synth simulation");
		$fwrite(tbfile, "Post-synth simulation\n");
		$sdf_annotate("./digital/slow_control_256/syn/output/slow_control_256.syn.sdf", U_DUT, , , "MAXIMUM", , );	// There is only one corner in synthesis which is the worst delay
	`endif
	`ifdef SIM_POSTPNR
		$display("Post-PNR simulation");
		$fwrite(tbfile, "Post-PNR simulation\n");
		$sdf_annotate("./digital/slow_control_256/pnr/output/slow_control_256.syn.sdf", U_DUT, , , `SDF_CORNER, , );
		$display("SDF corner: %s", `SDF_CORNER);
		$fwrite(tbfile, "SDF corner: %s\n", `SDF_CORNER);
	`endif
	`ifdef SIM_TRANSISTOR
		$display("Transistor level simulation");
		$fwrite(tbfile, "Transistor level simulation\n");
	`endif

	// Test 1: all-zeros
	$display("[T=%t] TEST 1: All-zeros: Begin", $time);
	$fwrite(tbfile, "[T=%t] TEST 1: All-zeros: Begin\n", $time);
	write_data[255:0] = {256{1'b0}};	
	write_strobe = 0;
	#100;
	write_strobe = 1;	// Write to slow-control
	$display("[T=%t] SPI Write hex: %h", $time, write_data);
	$fwrite(tbfile, "[T=%t] SPI Write hex: %h\n", $time, write_data);
	#100;
	write_strobe = 0;
	@(posedge read_strobe);	// Monitor DUT output, Readback SPI, did test pass SC?  SPI readback data won't represent the previous write since it is full-duplex
	$display("[T=%t] Slow-control monitor hex: %h", $time, sc);
	$fwrite(tbfile, "[T=%t] Slow-control monitor hex: %h\n", $time, sc);
	$display("[T=%t] SPI Readback hex: %h", $time, read_data);
	$fwrite(tbfile, "[T=%t] SPI Readback hex: %h\n", $time, read_data);
	if (sc == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 1: All-zeros: PASS SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 1: All-zeros: PASS SC\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 1: All-zeros: FAIL SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 1: All-zeros: FAIL SC\n", $time);
	end
	@(negedge read_strobe);
	#10000;
	write_strobe = 0;
	#100;
	write_strobe = 1;
	#100;
	write_strobe = 0;
	@(posedge read_strobe);	// Monitor DUT output, Readback SPI, did test pass SC and SPI readback?
	$display("[T=%t] Slow-control monitor hex: %h", $time, sc);
	$fwrite(tbfile, "[T=%t] Slow-control monitor hex: %h\n", $time, sc);
	$display("[T=%t] SPI Readback hex: %h", $time, read_data);
	$fwrite(tbfile, "[T=%t] SPI Readback hex: %h\n", $time, read_data);
	if (sc == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 1: All-zeros: PASS SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 1: All-zeros: PASS SC\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 1: All-zeros: FAIL SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 1: All-zeros: FAIL SC\n", $time);
	end
	if (read_data == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 1: All-zeros: PASS SPIREADBACK", $time);
		$fwrite(tbfile, "[T=%t] TEST 1: All-zeros: PASS SPIREADBACK\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 1: All-zeros: FAIL SPIREADBACK", $time);
		$fwrite(tbfile, "[T=%t] TEST 1: All-zeros: FAIL SPIREADBACK\n", $time);
	end
	@(negedge read_strobe);
	#10000;


	// Test 2: all-ones
	$display("[T=%t] TEST 2: All-ones: Begin", $time);
	$fwrite(tbfile, "[T=%t] TEST 2: All-ones: Begin\n", $time);
	write_data[255:0] = {256{1'b1}};	
	write_strobe = 0;
	#100;
	write_strobe = 1;	// Write to slow-control
	$display("[T=%t] SPI Write hex: %h", $time, write_data);
	$fwrite(tbfile, "[T=%t] SPI Write hex: %h\n", $time, write_data);
	#100;
	write_strobe = 0;
	@(posedge read_strobe);	// Monitor DUT output, Readback SPI, did test pass SC?  SPI readback data won't represent the previous write since it is full-duplex
	$display("[T=%t] Slow-control monitor hex: %h", $time, sc);
	$fwrite(tbfile, "[T=%t] Slow-control monitor hex: %h\n", $time, sc);
	$display("[T=%t] SPI Readback hex: %h", $time, read_data);
	$fwrite(tbfile, "[T=%t] SPI Readback hex: %h\n", $time, read_data);
	if (sc == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 2: All-ones: PASS SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 2: All-ones: PASS SC\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 2: All-ones: FAIL SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 2: All-ones: FAIL SC\n", $time);
	end
	@(negedge read_strobe);
	#10000;
	write_strobe = 0;
	#100;
	write_strobe = 1;
	#100;
	write_strobe = 0;
	@(posedge read_strobe);	// Monitor DUT output, Readback SPI, did test pass SC and SPI readback?
	$display("[T=%t] Slow-control monitor hex: %h", $time, sc);
	$fwrite(tbfile, "[T=%t] Slow-control monitor hex: %h\n", $time, sc);
	$display("[T=%t] SPI Readback hex: %h", $time, read_data);
	$fwrite(tbfile, "[T=%t] SPI Readback hex: %h\n", $time, read_data);
	if (sc == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 2: All-ones: PASS SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 2: All-ones: PASS SC\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 2: All-ones: FAIL SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 2: All-ones: FAIL SC\n", $time);
	end
	if (read_data == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 2: All-ones: PASS SPIREADBACK", $time);
		$fwrite(tbfile, "[T=%t] TEST 2: All-ones: PASS SPIREADBACK\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 2: All-ones: FAIL SPIREADBACK", $time);
		$fwrite(tbfile, "[T=%t] TEST 2: All-ones: FAIL SPIREADBACK\n", $time);
	end
	@(negedge read_strobe);
	#10000;



	// Test 3: pattern 1
	$display("[T=%t] TEST 3: PATTERN 1: Begin", $time);
	$fwrite(tbfile, "[T=%t] TEST 3: PATTERN 1: Begin\n", $time);
	write_data[255:0] = 256'h9123456789abcde7_9123456789abcde7_9123456789abcde7_9123456789abcde7;	
	write_strobe = 0;
	#100;
	write_strobe = 1;	// Write to slow-control
	$display("[T=%t] SPI Write hex: %h", $time, write_data);
	$fwrite(tbfile, "[T=%t] SPI Write hex: %h\n", $time, write_data);
	#100;
	write_strobe = 0;
	@(posedge read_strobe);	// Monitor DUT output, Readback SPI, did test pass SC?  SPI readback data won't represent the previous write since it is full-duplex
	$display("[T=%t] Slow-control monitor hex: %h", $time, sc);
	$fwrite(tbfile, "[T=%t] Slow-control monitor hex: %h\n", $time, sc);
	$display("[T=%t] SPI Readback hex: %h", $time, read_data);
	$fwrite(tbfile, "[T=%t] SPI Readback hex: %h\n", $time, read_data);
	if (sc == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 3: PATTERN 1: PASS SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 3: PATTERN 1: PASS SC\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 3: PATTERN 1: FAIL SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 3: PATTERN 1: FAIL SC\n", $time);
	end
	@(negedge read_strobe);
	#10000;
	write_strobe = 0;
	#100;
	write_strobe = 1;
	#100;
	write_strobe = 0;
	@(posedge read_strobe);	// Monitor DUT output, Readback SPI, did test pass SC and SPI readback?
	$display("[T=%t] Slow-control monitor hex: %h", $time, sc);
	$fwrite(tbfile, "[T=%t] Slow-control monitor hex: %h\n", $time, sc);
	$display("[T=%t] SPI Readback hex: %h", $time, read_data);
	$fwrite(tbfile, "[T=%t] SPI Readback hex: %h\n", $time, read_data);
	if (sc == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 3: PATTERN 1: PASS SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 3: PATTERN 1: PASS SC\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 3: PATTERN 1: FAIL SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 3: PATTERN 1: FAIL SC\n", $time);
	end
	if (read_data == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 3: PATTERN 1: PASS SPIREADBACK", $time);
		$fwrite(tbfile, "[T=%t] TEST 3: PATTERN 1: PASS SPIREADBACK\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 3: PATTERN 1: FAIL SPIREADBACK", $time);
		$fwrite(tbfile, "[T=%t] TEST 3: PATTERN 1: FAIL SPIREADBACK\n", $time);
	end
	@(negedge read_strobe);
	#10000;



	// Test 4: pattern 2
	$display("[T=%t] TEST 4: PATTERN 2: Begin", $time);
	$fwrite(tbfile, "[T=%t] TEST 4: PATTERN 2: Begin\n", $time);
	write_data[255:0] = 256'hfedcba9876543210_fedcba9876543210_fedcba9876543210_fedcba9876543210;
	write_strobe = 0;
	#100;
	write_strobe = 1;	// Write to slow-control
	$display("[T=%t] SPI Write hex: %h", $time, write_data);
	$fwrite(tbfile, "[T=%t] SPI Write hex: %h\n", $time, write_data);
	#100;
	write_strobe = 0;
	@(posedge read_strobe);	// Monitor DUT output, Readback SPI, did test pass SC?  SPI readback data won't represent the previous write since it is full-duplex
	$display("[T=%t] Slow-control monitor hex: %h", $time, sc);
	$fwrite(tbfile, "[T=%t] Slow-control monitor hex: %h\n", $time, sc);
	$display("[T=%t] SPI Readback hex: %h", $time, read_data);
	$fwrite(tbfile, "[T=%t] SPI Readback hex: %h\n", $time, read_data);
	if (sc == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 4: PATTERN 2: PASS SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 4: PATTERN 2: PASS SC\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 4: PATTERN 2: FAIL SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 4: PATTERN 2: FAIL SC\n", $time);
	end
	@(negedge read_strobe);
	#10000;
	write_strobe = 0;
	#100;
	write_strobe = 1;
	#100;
	write_strobe = 0;
	@(posedge read_strobe);	// Monitor DUT output, Readback SPI, did test pass SC and SPI readback?
	$display("[T=%t] Slow-control monitor hex: %h", $time, sc);
	$fwrite(tbfile, "[T=%t] Slow-control monitor hex: %h\n", $time, sc);
	$display("[T=%t] SPI Readback hex: %h", $time, read_data);
	$fwrite(tbfile, "[T=%t] SPI Readback hex: %h\n", $time, read_data);
	if (sc == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 4: PATTERN 2: PASS SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 4: PATTERN 2: PASS SC\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 4: PATTERN 2: FAIL SC", $time);
		$fwrite(tbfile, "[T=%t] TEST 4: PATTERN 2: FAIL SC\n", $time);
	end
	if (read_data == write_data)
	begin
		//test_pass = 1;
		$display("[T=%t] TEST 4: PATTERN 2: PASS SPIREADBACK", $time);
		$fwrite(tbfile, "[T=%t] TEST 4: PATTERN 2: PASS SPIREADBACK\n", $time);
	end
	else
	begin
		test_pass = 0;
		$display("[T=%t] TEST 4: PATTERN 2: FAIL SPIREADBACK", $time);
		$fwrite(tbfile, "[T=%t] TEST 4: PATTERN 2: FAIL SPIREADBACK\n", $time);
	end
	@(negedge read_strobe);


	

	// Logistics
	$display("[T=%t] DONE", $time);
	$fwrite(tbfile, "[T=%t] DONE\n", $time);
	$fclose(tbfile);
	$stop;

end


endmodule



