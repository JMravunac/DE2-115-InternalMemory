/*
/  Jack Mravunac
/  MemRWTest.v
/  Contains I/O and self tests for the DPRAM
/  27 February 2020
*/

module MemRWTest(clk, ar, UniversalIn, DOut, Done, A_Button, Rd_Button, Wr_Button, IT_Button,
	A, DIn, RD, WR, Done_LED, Internal_Pass_LED, Internal_Fail_LED, SevenSeg_Zero, SevenSeg_One, SevenSeg_Two, SevenSeg_Three)

input clk, ar, Done, A_Button, Rd_Button, Wr_Button, IT_Button;
input [15:0] UniversalIn, DOut;

output [3:0] SevenSeg_Zero, SevenSeg_One, SevenSeg_Two, SevenSeg_Three;
output [9:0] A;
output Done_LED, Internal_Pass_LED, Internal_Fail_LED;

always @(clk)
	if(~ar) begin
		A = 10'b0;
		DIn = 16'b0;
	end else if(A_Button) begin
		A = UniversalIn[9:0];
	end else begin
		DIn = UniversalIn;
	end
end


endmodule
