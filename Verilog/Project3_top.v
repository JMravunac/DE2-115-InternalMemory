/*
/  Jack Mravunac
/  Project3_top.v
/  Top file for DPRAM controller project
/  27 February 2020
*/

`timescale 100 ns / 1 ns

module Project3_top(clk, ar, universalIn, A_Button, Rd_Button, Wr_Button, IT_Switch,
	Done_LED, Internal_Pass_LED, Internal_Fail_LED, SevenSeg_Zero_Out, SevenSeg_One_Out, SevenSeg_Two_Out, SevenSeg_Three_Out);

input clk, ar, A_Button, Rd_Button, Wr_Button, IT_Switch;
input [15:0] universalIn;

output Done_LED, Internal_Pass_LED, Internal_Fail_LED;
output [6:0] SevenSeg_Zero_Out, SevenSeg_One_Out, SevenSeg_Two_Out, SevenSeg_Three_Out;

wire [3:0] SevenSeg_Zero, SevenSeg_One, SevenSeg_Two, SevenSeg_Three;
wire [15:0] DOut, DIn, Q, Data;
wire [9:0] A, WriteA, ReadA;
wire Done, RD, WR, WE;


MemRWTest TestUnit(.clk(clk), .ar(ar), .UniversalIn(universalIn), .DOut(DOut), .Done(Done), .A_Button(A_Button), .Rd_Button(Rd_Button), .Wr_Button(Wr_Button), .IT_Switch(IT_Switch),
	.A(A), .DIn(DIn), .RD(RD), .WR(WR), .Done_LED(Done_LED), .Internal_Pass_LED(Internal_Pass_LED), .Internal_Fail_LED(Internal_Fail_LED),
	.SevenSeg_Zero(SevenSeg_Zero), .SevenSeg_One(SevenSeg_One), .SevenSeg_Two(SevenSeg_Two), .SevenSeg_Three(SevenSeg_Three));
	
sevseg_dec SegZero(.x_in(SevenSeg_Zero), .segs(SevenSeg_Zero_Out));

sevseg_dec SegOne(.x_in(SevenSeg_One), .segs(SevenSeg_One_Out));

sevseg_dec SegTwo(.x_in(SevenSeg_Two), .segs(SevenSeg_Two_Out));

sevseg_dec SegThree(.x_in(SevenSeg_Three), .segs(SevenSeg_Three_Out));

DPRAM_Controller Controller(.clk(clk), .ar(ar), .RD(RD), .WR(WR), .A(A), .DIn(DIn), .Q(Q),
	.DOut(DOut), .Data(Data), .Wr_A(WriteA), .Rd_A(ReadA), .Done(Done), .WE(WE));

DPRAM Ram(.clock(clk), .data(Data), .rdaddress(ReadA), .wraddress(WriteA), .wren(WE),
	.q(Q));

endmodule