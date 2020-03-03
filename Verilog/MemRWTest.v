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

parameter [2:0]   Idle = 3'b0, Address = 3'b001, Wr1 = 3'b010, Wr2 = 3'b111, Wr3 = 3'b011, Rd1 = 3'b100, Rd2 = 3'b101, Rd3 = 3'b110;
parameter [2:0]   Idle2 = 3'b0, AddrImp = 3'b001, Write = 3'b010, Read = 3'b011, Check = 3'b100, Success = 3'b101, Fail = 3'b110;
	reg [2:0] User_State;
	reg [2:0] IT_State;
	reg [2:0] delay, delay2, delay3;
	reg [9:0] testAddr;
	reg [15:0] testData;

always @(negedge ar or posedge clk)
	if(~ar) 
	 begin
		A = 10'b0;
		DIn = 16'b0;
		RD = 1'b0;
		WR = 1'b0;
		testAddr = 10'b0;
		testData = 16'b0;
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
				case(IT_State)
					Idle2:
					 begin
						if(~A_Button)
							IT_State = AddrImp;
					 end
					 
					AddrImp:
					 begin
						testAddr = testAddr + 1;
						testData = testAddr * 15;
						delay2 = 3'b0;
						delay3 = 3'b0;
						A = testAddr;
						DIn = testData;
						IT_State = Write;
					 end
					 
					Write:
					 begin
						WR = 1'b1;
						if(delay2 > 3'b110)
						begin
							if(testAddr > 1022)
							begin
								testAddr = 0;
								testData = 0;
								
								IT_State = Read;
							end
							else
								IT_State = AddrImp;
						end
						else
							delay2 = delay2 + 1;
					 end
					
					Read:
					 begin
						WR = 1'b0;
						delay2 = 3'b0;
						A = testAddr;
						RD = 1'b1;
						if(delay3 > 3'b110)
						begin
							RD = 1'b0;
							delay3 = 3'b0;
							IT_State = Check;
						end
						else
							delay3 = delay3 + 1;
					 
					 end
					 
					Check:
					 begin
					 
						testData = testAddr * 15;
						if(testData != DOut)
							IT_State = Fail;
						else
						begin
							if(testAddr > 1022)
								IT_State = Success;
							else
							begin
								testAddr = testAddr + 1;
								IT_State = Read;
							end
						end
						
					 end
					 
					Success:
					 begin
						Internal_Pass_LED = 1'b1;
						Internal_Fail_LED = 1'b0;
						IT_State = Idle2;
					 end
					 
					Fail:
					 begin
						Internal_Pass_LED = 1'b0;
						Internal_Fail_LED = 1'b1;
						IT_State = Idle2;
					 end
					
					default:
					 begin
						IT_State = Idle2;
					 end
					endcase
			 end
			else
			 begin
				case(User_State)
					Idle:
					begin
						if(~A_Button)
							User_State = Address;
						else if(~Rd_Button)
							User_State = Rd1;
						else if(~Wr_Button)
							User_State = Wr1;
					end
					
					Address:
					begin
						A = UniversalIn[9:0];
						User_State = Idle;
					end
					
					Rd1:
					begin
						Done_LED = 1'b0;
						delay = 3'b0;
						RD = 1'b1;
						User_State = Rd2;
					end
					
					Rd2:
					begin
						if(delay > 3'b110)
							User_State = Rd3;
						else
							delay = delay + 1;
					end
					
					Rd3:
					begin
						RD = 1'b0;
						SevenSeg_Zero = DOut[3:0];
						SevenSeg_One = DOut[7:4];
						SevenSeg_Two = DOut[11:8];
						SevenSeg_Three = DOut[15:12];
						Done_LED = 1'b1;
						User_State = Idle;
					end

					Wr1:
					begin
						Done_LED = 1'b0;
						DIn = UniversalIn[15:0];
						User_State = Wr2;
					end

					Wr2:
					begin
						WR = 1'b1;
						User_State = Wr3;
					end

					Wr3:
					begin
						WR = 1'b0;
						Done_LED = 1'b1;
						User_State = Idle;
					end
					
					default:
					begin
						User_State = Idle;
					end
				endcase
			 end
	 
	 end



endmodule
