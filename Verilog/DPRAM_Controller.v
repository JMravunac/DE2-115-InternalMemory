/*
/  Jack Mravunac
/  DPRAM_Controller.v
/  Controller for the DPRAM
/  27 February 2020
*/

module DPRAM_Controller(clk, RD, WR, A, DIn, Q
	DOut, Data, Wr_A, Rd_A, Done, WE)
	
	input clk, RD, WR;
	input [9:0] A;
	input [15:0] DIn, Q;
	
	output [15:0] DOut, Data;
	output [9:0] Wr_A, Rd_A;
	output Done, WE;

endmodule
