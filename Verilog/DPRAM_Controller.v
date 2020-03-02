/*
/  Jack Mravunac
/  DPRAM_Controller.v
/  Controller for the DPRAM
/  27 February 2020
*/

`timescale 100 ns / 1 ns

module DPRAM_Controller(clk, ar, RD, WR, A, DIn, Q,
	DOut, Data, Wr_A, Rd_A, Done, WE);
	
	input clk, RD, WR, ar;
	input [9:0] A;
	input [15:0] DIn, Q;
	
	output reg [15:0] DOut, Data;
	output reg [9:0] Wr_A, Rd_A;
	output reg Done, WE;
	
	parameter [2:0]   Idle = 3'b0, Wr1 = 3'b001, Wr2 = 3'b010, Wr3 = 3'b011, Rd1 = 3'b100, Rd2 = 3'b101, Rd3 = 3'b110;
	reg [2:0] state;
	reg [1:0] delay;

	
	always @(negedge ar or posedge clk)
		if(~ar)
		 begin
			state = Idle;
			DOut = 16'b0;
			Data = 16'b0;
			Wr_A = 10'b0;
			Rd_A = 10'b0;
			Done = 1'b0;
			WE = 1'b0;
		 end
		else
		 begin
				case(state)
					Idle:
					begin
						Done = 1'b0;
						if(RD)
							state = Rd1;
						  else if(WR)
							state = Wr1;
							
						
					end
					
					Wr1:
					begin
						Data = DIn;
						Wr_A = A;
						WE = 1'b0;
						state = Wr2;
					end
					
					Wr2:
					begin
						WE = 1'b1;
						state = Wr3;
					end
					
					Wr3:
					begin
						WE = 1'b0;
						state = Idle;
					end
					
					Rd1:
					begin
						Rd_A = A;
						delay = 2'b0;
						state = Rd2;
					end
					
					Rd2:
					begin
						if(delay > 2'b10)
							state = Rd3;
						else
							delay = delay + 1;
					end
					
					Rd3:
					begin
						DOut = Q;
						delay = 2'b0;
						state = Idle;
					end
					
					default:
					begin
						state = Idle;
					end
				endcase
		 end

endmodule
