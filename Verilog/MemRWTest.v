/*
/  Jack Mravunac
/  MemRWTest.v
/  Contains I/O and self tests for the DPRAM
/  27 February 2020
*/

`timescale 100 ns / 1 ns

module MemRWTest(clk, ar, UniversalIn, DOut, Done, A_Button, Rd_Button, Wr_Button, IT_Switch,
	A, DIn, RD, WR, Done_LED, Internal_Pass_LED, Internal_Fail_LED, SevenSeg_Zero, SevenSeg_One, SevenSeg_Two, SevenSeg_Three);

input clk, ar, Done, A_Button, Rd_Button, Wr_Button, IT_Switch;
input [15:0] UniversalIn, DOut;

output reg [3:0] SevenSeg_Zero, SevenSeg_One, SevenSeg_Two, SevenSeg_Three;
output reg [9:0] A;
output reg [15:0] DIn;
output reg RD, WR, Done_LED, Internal_Pass_LED, Internal_Fail_LED;

parameter [2:0]   Idle = 3'b0, Address = 3'b001, Wr1 = 3'b010, Wr3 = 3'b011, Rd1 = 3'b100, Rd2 = 3'b101, Rd3 = 3'b110;
	reg [2:0] User_State;
	reg [2:0] IT_State;
	reg [2:0] delay;

always @(negedge ar or posedge clk)
	if(~ar) 
	 begin
		A = 10'b0;
		DIn = 16'b0;
		RD = 1'b0;
		WR = 1'b0;
		Done_LED = 1'b0;
		Internal_Pass_LED = 1'b0;
		Internal_Fail_LED = 1'b0;
		SevenSeg_Zero = 4'b0;
		SevenSeg_One = 4'b0;
		SevenSeg_Two = 4'b0;
		SevenSeg_Three = 4'b0;
	 end 
	else
	 begin
			if(IT_Switch)
			 begin
			
			 end
			else
			 begin
				case(User_State)
					Idle:
					begin
						if(A_Button)
							state = Address;
						else if(Rd_Button)
							state = Rd1;
						else if(Wr_Button)
							state = Wr1;
					end
					
					Address:
					begin
						A = UniversalIn[9:0];
						state = Idle;
					end
					
					Rd1:
					begin
						delay = 3'b0;
						Rd = 1'b1;
						state = Rd2;
					end
					
					Rd2:
					begin
						if(delay > 3'b110)
							state = Rd3;
						else
							delay = delay + 1;
					end
					
					Rd3:
					begin
						Rd= 1'b0;
						SevenSeg_Zero = DOut[3:0];
						SevenSeg_One = [7:4];
						SevenSeg_Two = [11:8];
						SevenSeg_Three = [15:12];
						state = Idle;
					end
			 end
	 
	 end



endmodule
