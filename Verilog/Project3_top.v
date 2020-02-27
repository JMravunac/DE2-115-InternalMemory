/*
/  Jack Mravunac
/  Project3_top.v
/  Top file for DPRAM controller project
/  27 February 2020
*/

module Project3_top(clk, ar, universalIn, A_Button, Rd_Button, Wr_Button, IT_Button,
	Done_LED, Internal_Pass_LED, Internal_Fail_LED, SevenSeg_Zero, SevenSeg_One, SevenSeg_Two, SevenSeg_Three)

input clk, ar, A_Button, Rd_Button, Wr_Button, IT_Button;
input [15:0] universalIn;

output Done_LED, Internal_Pass_LED, Internal_Fail_LED;
output [6:0] SevenSeg_Zero, SevenSeg_One, SevenSeg_Two, SevenSeg_Three;

wire [15:0] DOut, DIn;
wire [9:0] A;
wire Done, RD, WR;

MemRWTest TestUnit(.clk(clk), .ar(ar), .UniversalIn(universalIn), .DOut(DOut), .Done(Done), .A_Button(A_Button), .Rd_Button(Rd_Button), .Wr_Button.(Wr_Button), .IT_Button(IT_Button),
	.A(A), .DIn(DIn), .RD(RD), .WR(WR), .Done_LED(Done_LED), .Internal_Pass_LED(Internal_Pass_LED), .Internal_Fail_LED(Internal_Fail_LED),
	.SevenSeg_Zero(SevenSeg_Zero), .SevenSeg_One(SevenSeg_One), .SevenSeg_Two(SevenSeg_Two), .SevenSeg_Three(SevenSegThree));

DPRAM_Controller Controller(.clk(), .RD(RD), .WR(WR), .A(A), .DIn(DIn), .Q()
	.DOut(DOut), .Data(), .Wr_A(), .Rd_A(), .Done(Done), .WE());

DPRAM Ram(.clock(), .data(), .rdaddress(), .wraddress(), .wren(), .q());

endmodule