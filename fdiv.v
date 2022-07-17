module fdiv(clk0, rxdone, rxdata, clk3, clk4, clk5, clk6);
   input clk0;//50MHz
	input rxdone;
	input [7:0]rxdata;
	
	//output reg clk1;//左轮固定速度
	//output reg clk2;//右轮固定速度
	output reg clk3;//超声波探测输入信号
	output reg clk4;//左轮摇杆速度
	output reg clk5;//右轮摇杆速度
	output reg clk6;//数码管显示位选驱动

	//reg [19:0]temp1;//clk1
	//reg [19:0]temp2;//clk2
	reg [25:0]temp3;//clk3
	reg [19:0]temp4;//clk4
	reg [19:0]temp5;//clk5	
	reg [19:0]temp6;//clk6	
	//reg [8*16-1:0]commend;//读取指令
	//reg [3:0]cnt;
	//reg [8*16-1:0]cc;
	//reg [19:0]lsd;//计数标准
	//reg [19:0]rsd;
	
	//always @ (posedge clk0)//摇杆控制变速
	//begin
	//   if(rxdone == 1)
	//   begin
	//      if(rxdata == 59)
	//	   begin
	//	      cc <= commend;
	//	      commend <= 0;
	//	   	cnt <= 0;
	//	   end
	//	   else
	//	   begin
	//	      cnt <= cnt + 1;
	//	   end
	//	   
	//	   case (cnt)
	//	   'd0 : commend[7:0] <= rxdata;
	//	   'd1 : commend[15:8] <= rxdata;
	//	   'd2 : commend[23:16] <= rxdata;
	//	   'd3 : commend[31:24] <= rxdata;
	//	   'd4 : commend[39:32] <= rxdata;
	//	   'd5 : commend[47:40] <= rxdata;
	//	   'd6 : commend[55:48] <= rxdata;
	//	   'd7 : commend[63:56] <= rxdata;
	//	   'd8 : commend[71:64] <= rxdata;
	//	   'd9 : commend[79:72] <= rxdata;
	//	   'd10 : commend[87:80] <= rxdata;
	//	   'd11 : commend[95:88] <= rxdata;
	//	   'd12 : commend[103:96] <= rxdata;
	//	   'd13 : commend[111:104] <= rxdata;
	//	   'd14 : commend[119:112] <= rxdata;
	//	   'd15 : commend[127:120] <= rxdata;
	//	   endcase
	//	   //test <= commend[55:48];
	//	   
	//	   if(cc[7:0] == 67 && cc[15:8] == 74)
	//	   begin
	//	      if(cc[31:24] == 45 && cc[71:64] == 45)
	//	   	begin
	//	   	   lsd <= 2250 - ((cc[39:32] - 48) * 10 + cc[55:48] - 48) * 50;
	//	   		rsd <= 23450;
	//	   	end
	//	   	
	//	   	else if(cc[31:24] == 43 && cc[71:64] == 45)
	//	   	begin
	//	   	   lsd <= 2250;
	//	   		rsd <= 23450 - ((cc[39:32] - 48) * 10 + cc[55:48] - 48) * 750;
	//	   	end
	//	   	
	//	   	else if(cc[31:24] == 45 && cc[71:64] == 43)
	//	   	begin
	//	   	   lsd <= 250 + ((cc[39:32] - 48) * 10 + cc[55:48] - 48) * 50;
	//	   		rsd <= 1550;
	//	   	end
	//	   	
	//	   	else if(cc[31:24] == 43 && cc[71:64] == 43)
	//	   	begin
	//	   	   lsd <= 250;
	//	   		rsd <= 1550 + ((cc[39:32] - 48) * 10 + cc[55:48] - 48) * 750;
	//	   	end
	//		end
	//		
	//		if(cc[7:0] == 67 && cc[15:8] == 68)
	//		begin
	//		   lsd <= 1007;
	//			rsd <= 10000;
	//		end
	//	end
	//end 
	
	always @ (posedge clk0)
	begin
	   //temp1 <= temp1 + 20'b1;
		//temp2 <= temp2 + 20'b1;
		temp3 <= temp3 + 26'b1;
		temp4 <= temp4 + 20'b1;
		temp5 <= temp5 + 20'b1;
		temp6 <= temp6 + 20'b1;
		
		////clk1(将clk2改为clk1频率的10倍)
		//if(clk1 == 1'b1 && temp1 == 400)//调小加快
		//begin
		//   clk1 <= 1'b0;
		//	temp1 <= 20'b0;
		//end
		//else if(clk1 == 1'b0 && temp1 == 4600)
		//begin
		//   clk1 <= 1'b1;
		//	temp1 <= 20'b0;
		//end
		//
		////clk2
		//if(clk2 == 1'b1 && temp2 == 3100)//调小加快
		//begin
		//   clk2 <= 1'b0;
		//	temp2 <= 20'b0;
		//end
		//else if(clk2 == 1'b0 && temp2 == 46900)
		//begin
		//   clk2 <= 1'b1;
		//	temp2 <= 20'b0;
		//end
		
		//clk3给超声波的输入信号
		if(clk3 == 1'b1 && temp3 == 550)
		begin
		   clk3 <= 1'b0;
			temp3 <= 21'b0;
	   end
		else if(clk3 == 1'b0 && temp3 == 3999450)
		begin
		   clk3 <= 1'b1;
			temp3 <= 21'b0;
		end
		
		//clk4左轮驱动
		if(clk4 == 1'b1 && temp4 == 820)//调小加快
		begin
		   clk4 <= 1'b0;
			temp4 <= 20'b0;
		end
		else if(clk4 == 1'b0 && temp4 == 1493)
		begin
		   clk4 <= 1'b1;
			temp4 <= 20'b0;
		end
		
		//clk5右轮驱动
		if(clk5 == 1'b1 && temp5 == 8000)//调小加快
		begin
		   clk5 <= 1'b0;
		   temp5 <= 20'b0;
		end
		else if(clk5 == 1'b0 && temp5 == 15000)
		begin
		   clk5 <= 1'b1;
			temp5 <= 20'b0;
		end
		
		//clk6数码管显示位选驱动
		if(clk6 == 1'b1 && temp6 == 5000)
		begin
		   clk6 <= 1'b0;
			temp6 <= 20'b0;
		end
		else if(clk6 == 1'b0 && temp6 == 5000)
		begin
		   clk6 <= 1'b1;
			temp6 <= 20'b0;
		end
	end
endmodule