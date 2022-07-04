module action(clk0, clk1, clk2, clk3, clk4, clk5, clk6, echo, rxdone, rxdata, rxdone_angle, rxdata_angle, key,
 leftw1, leftw2, rightw1, rightw2, uart_tx_data, uart_tx_en, txdetectangle, txangle_en, test);
   input clk0;
	input clk1;
	input clk2;
	input clk3;
	input clk4;
	input clk5;
	input clk6;
	input echo;
	input rxdone;
	input [7:0]rxdata;
	input rxdone_angle;
	input [7:0]rxdata_angle;
	
	input [3:0]key;
	
	output reg leftw1, leftw2;
	output reg rightw1, rightw2;
	output reg [7:0]uart_tx_data;//待发送数据，前方障碍物距离格数
	output reg uart_tx_en;//发送使能信号
	output reg [7:0]txdetectangle;//待发送数据，前方障碍物距离格数
	output reg txangle_en;//发送使能信号
	
	output reg [7:0]test;
	//output reg a, b, c, d;
	
	reg [3:0]state;//现状态
	reg dete;//检测echo上升沿
	reg [59:0]count;//echo记时
	reg echo1, echo2;//echo(t)&echo(t-1)
	reg [59:0]countall;
	wire [9:0]distance;//障碍物距离
   wire [3:0]barri;
	reg remo;//1遥控0自主
	reg [7:0]rxall;//总读取数据
	reg [8*16-1:0]commend;//读取指令
	reg [3:0]cnt;
	reg [8*16-1:0]cc;
	reg [8*16-1:0]angle_commend;//读取指令
	reg [3:0]angle_cnt;
	reg [8*16-1:0]angle_info;
   reg [8*16-1:0]angle_infostart;//状态开始初始角度
	reg en_changesignal;
	reg [59:0]inicount;
	
	wire [11:0]ainfo;
	wire [11:0]ainfostart;

	assign ainfo = (angle_info[15:8]-48)*1000 + (angle_info[23:16]-48)*100 + (angle_info[31:24]-48)*10 + angle_info[47:40]-48;
	assign ainfostart = (angle_infostart[15:8]-48)*1000 + (angle_infostart[23:16]-48)*100 + (angle_infostart[31:24]-48)*10 + angle_infostart[47:40]-48;
	
	assign distance = countall * 17 / 50000;//障碍物距离
	assign barri = 1 + distance / 30;
	
   //HC_05返回信息检测
	always @ (posedge clk0)
	begin
		if(rxdone == 1)
		begin
	      if(rxdata == 59)
		   begin
		      cc <= commend;
		      commend <= 0;
		   	cnt <= 0;
		   end
		   else
		   begin
			   cc <= 0;
		      cnt <= cnt + 1;
		   end
		   
		   case (cnt)
		   'd0 : commend[7:0] <= rxdata;
		   'd1 : commend[15:8] <= rxdata;
		   'd2 : commend[23:16] <= rxdata;
		   'd3 : commend[31:24] <= rxdata;
		   'd4 : commend[39:32] <= rxdata;
		   'd5 : commend[47:40] <= rxdata;
		   'd6 : commend[55:48] <= rxdata;
		   'd7 : commend[63:56] <= rxdata;
		   'd8 : commend[71:64] <= rxdata;
		   'd9 : commend[79:72] <= rxdata;
		   'd10 : commend[87:80] <= rxdata;
		   'd11 : commend[95:88] <= rxdata;
		   'd12 : commend[103:96] <= rxdata;
		   'd13 : commend[111:104] <= rxdata;
		   'd14 : commend[119:112] <= rxdata;
		   'd15 : commend[127:120] <= rxdata;
		   endcase
		end
	end 
	
	//发送探测角度的信号
	always @ (posedge clk6)
	begin
	   txdetectangle <= 8'b00110001;
	   if(en_changesignal == 1)
		begin
		   en_changesignal <= ~en_changesignal;
	      txangle_en <= 1;
		end
		else 
		begin
	      en_changesignal <= ~en_changesignal;
	      txangle_en <= 0;
		end
	end
	
	//GY-26角度传感器返回值检测
	always @ (posedge clk0)
	begin
		if(rxdone_angle == 1)
		begin
	      if(rxdata_angle == 13)
		   begin
		      angle_info <= angle_commend;
		      angle_commend <= 0;
		   	angle_cnt <= 0;
		   end
		   else
		   begin
		      angle_cnt <= angle_cnt + 1;
		   end
		   
		   case (angle_cnt)
		   'd0 : angle_commend[7:0] <= rxdata_angle;
		   'd1 : angle_commend[15:8] <= rxdata_angle;
		   'd2 : angle_commend[23:16] <= rxdata_angle;
		   'd3 : angle_commend[31:24] <= rxdata_angle;
		   'd4 : angle_commend[39:32] <= rxdata_angle;
		   'd5 : angle_commend[47:40] <= rxdata_angle;
		   'd6 : angle_commend[55:48] <= rxdata_angle;
		   'd7 : angle_commend[63:56] <= rxdata_angle;
		   'd8 : angle_commend[71:64] <= rxdata_angle;
		   'd9 : angle_commend[79:72] <= rxdata_angle;
		   'd10 : angle_commend[87:80] <= rxdata_angle;
		   'd11 : angle_commend[95:88] <= rxdata_angle;
		   'd12 : angle_commend[103:96] <= rxdata_angle;
		   'd13 : angle_commend[111:104] <= rxdata_angle;
		   'd14 : angle_commend[119:112] <= rxdata_angle;
		   'd15 : angle_commend[127:120] <= rxdata_angle;
		   endcase
		end
	end 
	
	//always @ (barri)
	//begin
	//   case(barri)
	//	4'b0001 : begin a <= 1'b1; b <= 1'b0; c <= 1'b0; d <= 1'b0;end
	//	4'b0010 : begin a <= 1'b0; b <= 1'b1; c <= 1'b0; d <= 1'b0;end
	//	4'b0011 : begin a <= 1'b0; b <= 1'b0; c <= 1'b1; d <= 1'b0;end
	//	4'b0100 : begin a <= 1'b0; b <= 1'b0; c <= 1'b0; d <= 1'b1;end
	//	default : begin a <= 1'b0; b <= 1'b0; c <= 1'b0; d <= 1'b0;end
	//	endcase
	//end
	
	parameter standard = 44117;//超声波距离标准
   parameter stop = 4'b0111, forw = 4'b1101, left = 4'b1011, righ = 4'b1110;//四种状态
	parameter ystop = 4'b0001, ymove = 4'b0010;//摇杆控制状态
	parameter astop = 4'b0011, aforw = 4'b0100, aleft = 4'b0101, arigh = 4'b0110;//角度传感四种状态
	parameter wleft = 4'b0111, wrigh = 4'b1000;//左右微调
	
	initial
	begin
		state = stop;
		leftw1 = 1'b0;
		leftw2 = 1'b0;
		rightw1 = 1'b0;
		rightw2 = 1'b0;
		count = 60'b0;
		countall = 60'b0;
		echo1 = 1'b0;
		echo2 = 1'b0;
		dete = 1'b0;
		remo = 1'b1;//1按键遥控
		uart_tx_data = 8'b0;
		uart_tx_en = 1'b0;
	end
	
	always @ (posedge clk0)
	begin
	   echo2 = echo1;
	   echo1 = echo;
		
	   if(key == 4'b1110 || key == 4'b1101 || key == 4'b1011 || key == 4'b0111)
		begin
		   state <= key;
		end
		else if(cc[7:0] == 67 && cc[15:8] == 74)
		begin
		   state <= ymove;
		end
		else if(cc[7:0] == 67 && cc[15:8] == 83)
		begin
		   state <= ystop;
		end
		else if(cc[7:0] == 65 && cc[15:8] == 74)
		begin
			if(cc[31:24] == 48)begin state <= stop; remo <= 1;end
			else if(cc[31:24] == 49)begin state <= forw; remo <= 1;end
			else if(cc[31:24] == 50)begin state <= left; remo <= 1;end
			else if(cc[31:24] == 51)begin state <= righ; remo <= 1;end
			else if(cc[31:24] == 52)begin remo <= 0;end
		end
		else if(cc[7:0] == 67 && cc[15:8] == 68)
		begin
		   if(cc[31:24] == 109)begin state <= aforw;end
			else if(cc[31:24] == 108)begin state <= aleft;end
			else if(cc[31:24] == 114)begin state <= arigh;end
			//else if(cc[31:24] == 100)begin end
			else begin state <= astop;end
		end
		
		//if(rxdone == 1)
		//begin
      //   rxall <= rxdata;
      //end
		//
		//case (rxall)
		//8'b00000000 : begin remo <= 0;end
		//8'b00110000 : begin state <= stop; remo <= 1;end
	   //8'b00110001 : begin state <= forw; remo <= 1;end
		//8'b00110010 : begin state <= left; remo <= 1;end
		//8'b00110011 : begin state <= righ; remo <= 1;end
		//8'b00110100 : begin remo <= 0;end
		//default : begin state <= stop; remo <= 1;end
		//endcase
		
		//if(1)
		//begin
		//   case ({echo2, echo1})
	   //   2'b01 : begin dete = 1'b1; count = count + 1; state <= stop; uart_tx_en = 1'b0;end
	   //   2'b11 : begin count = count + 1; state <= stop; uart_tx_en = 1'b0;end
	   //   2'b10 : 
	   //   begin
	   //      if(dete == 1)
	   //   	begin 
		//		   countall <= count;
		//			uart_tx_en <= 1'b1;
		//			uart_tx_data <= 48 + barri;
	   //   	end
		//		else
		//		begin
		//		   dete = 1'b0; count = 0; uart_tx_en <= 1'b0;
		//		end
	   //   end
	   //   2'b00 : begin dete = 1'b0; count = 0; uart_tx_en <= 1'b0; end
	   //   endcase
		//end
		
	   if(state == stop)//stop
		begin
		   leftw1 = 1'b0;
		   leftw2 = 1'b0;
		   rightw1 = 1'b0;
		   rightw2 = 1'b0;
			
			uart_tx_en <= 1'b0;
			angle_infostart <= angle_info;//初始角度值赋值
			inicount <= countall;
			
		   case ({echo2, echo1})
	      2'b01 : begin dete = 1'b1; count = count + 1; state <= stop; uart_tx_en <= 1'b0;end
	      2'b11 : begin count = count + 1; state <= stop; uart_tx_en <= 1'b0;end
	      2'b10 : 
	      begin
	         if(dete == 1)
	      	begin 
		   	   countall <= count;
		   		//uart_tx_en <= 1'b1;
		   		//uart_tx_data <= 48 + barri;
	      	end
		   	else
		   	begin
		   	   dete = 1'b0; count = 0; uart_tx_en <= 1'b0;
		   	end
	      end
	      2'b00 : begin dete = 1'b0; count = 0; uart_tx_en <= 1'b0; end
	      endcase
				
			//if(remo == 0)
			//begin
			//   case ({echo2, echo1})
	      //   2'b01 : begin dete = 1'b1; count = count + 1; state <= stop; end
	      //   2'b11 : begin count = count + 1; state <= stop; end
	      //   2'b10 : 
	      //   begin
	      //      if(count <= standard && dete == 1)
	      //   	begin 
			//		   countall <= count;
			//   	   state <= left;	
	      //   	end
	      //   	else if(dete == 1)
	      //   	begin 
			//		   countall <= count;
			//   		state <= forw;
	      //   	end
			//   	else 
			//   	begin
			//   	   state <= stop;
			//   	end
	      //   end
	      //   2'b00 : begin dete = 1'b0; count = 0; state <= stop; end
	      //   endcase
			//end
		end
		
		else if(state == forw)//forward
		begin
		   leftw1 = clk1;
		   leftw2 = ~clk1;
		   rightw1 = clk2;
		   rightw2 = ~clk2;
	      
			//if(remo == 0)
			//begin
	      //   case ({echo2, echo1})
	      //   2'b01 : begin dete = 1'b1; count = count + 1; state <= forw; end
	      //   2'b11 : begin count = count + 1; state <= forw; end
	      //   2'b10 : 
	      //   begin
	      //      if(count <= standard && dete == 1)
	      //   	begin 
			//		   countall <= count;
			//   	   state <= stop;	
	      //   	end
	      //   	else if(dete == 1)
	      //   	begin 
	      //   	   countall <= count;
			//   		state <= forw;
	      //   	end
			//		else
			//		begin 
			//   		state <= forw;
	      //   	end
	      //   end
	      //   2'b00 : begin dete = 1'b0; count = 0; state <= forw; end
	      //   endcase
			//end
		end
		
		else if(state == left)//turn left
		begin
		   leftw1 = ~clk1;
			leftw2 = clk1;
			rightw1 = clk2;
			rightw2 = ~clk2;
			
			count = 0;
			dete = 1'b0;
		end
		
		else if(state == righ)//turn right
		begin
		   leftw1 = clk1;
			leftw2 = ~clk1;
			rightw1 = ~clk2;
			rightw2 = clk2;
			
			count = 0;
			dete = 1'b0;
		end
		
		else if (state == ystop)//摇杆停止控制
		begin
		   leftw1 = 1'b0;
		   leftw2 = 1'b0;
		   rightw1 = 1'b0;
		   rightw2 = 1'b0;
			
			count = 0;
			dete = 1'b0;
		end
		
		else if (state == ymove)//摇杆运动控制
		begin
		   leftw1 = clk4;
		   leftw2 = ~clk4;
		   rightw1 = clk5;
		   rightw2 = ~clk5;
			
			count = 0;
			dete = 1'b0;
		end
		
		else if (state == astop)
		begin
		   leftw1 = 1'b0;
		   leftw2 = 1'b0;
		   rightw1 = 1'b0;
		   rightw2 = 1'b0;
			
			uart_tx_en <= 1'b0;
			angle_infostart <= angle_info;//初始角度值赋值
			inicount <= countall;
			
			if(cc[31:24] == 100)
		   begin
		      case ({echo2, echo1})
	         2'b01 : begin dete = 1'b1; count = count + 1; state <= astop; uart_tx_en <= 1'b0;end
	         2'b11 : begin count = count + 1; state <= astop; uart_tx_en <= 1'b0;end
	         2'b10 : 
	         begin
	            if(dete == 1)
	         	begin 
		   		   countall <= count;
		   			uart_tx_en <= 1'b1;
		   			uart_tx_data <= 48 + barri;
	         	end
		   		else
		   		begin
		   		   dete = 1'b0; count = 0; uart_tx_en <= 1'b0;
		   		end
	         end
	         2'b00 : begin dete = 1'b0; count = 0; uart_tx_en <= 1'b0; end
	         endcase
		   end
	   end
		
		else if (state == aforw)
		begin
		   leftw1 = clk1;
		   leftw2 = ~clk1;
		   rightw1 = clk2;
		   rightw2 = ~clk2;

			uart_tx_en <= 1'b0;
			inicount <= countall;
			
			if(ainfo > ainfostart)
			begin
			   if(ainfo - ainfostart >= 50 && ainfo - ainfostart < 3000)
				begin
				   state <= wleft;
				end
				else if (3600 + ainfostart - ainfo >= 50)
				begin
				   state <= wrigh;
			   end
				else
				begin
				   state <= aforw;
				end
			end
			else
			begin
			   if(ainfostart - ainfo >= 50 && ainfostart - ainfo < 3000)
				begin
				   state <= wrigh;
				end
				else if (3600 - ainfostart + ainfo >= 50)
				begin
				   state <= wleft;
			   end
				else
				begin
				   state <= aforw;
				end
			end
			
	      case ({echo2, echo1})
	      2'b01 : begin dete = 1'b1; count = count + 1; state <= aforw; uart_tx_en <= 1'b0;end
	      2'b11 : begin count = count + 1; state <= aforw; uart_tx_en <= 1'b0;end
	      2'b10 : 
	      begin
	         if(inicount - count >= 88235 && dete == 1)
	      	begin
				   countall <= count;
				   state <= astop;
					uart_tx_en <= 1'b1;
					uart_tx_data <= 90;
	      	end
				else
				begin
				   state <= aforw;
					uart_tx_en <= 1'b0;
				end
			end
	      2'b00 : begin dete = 1'b0; count = 0; state <= aforw; uart_tx_en <= 1'b0;end
	      endcase
		end
		
		else if (state == aleft)
		begin
		   leftw1 = ~clk1;
			leftw2 = clk1;
			rightw1 = clk2;
			rightw2 = ~clk2;
			
			uart_tx_en <= 1'b0;
			
			if(angle_info - angle_infostart >= 850 && angle_info - angle_infostart <= 950)
			begin
			   state <= astop;
				uart_tx_en <= 1'b1;
				uart_tx_data <= 90;
			end
			else if(angle_infostart - angle_info >= 2650 && angle_infostart - angle_info <= 2750)
			begin
			   state <= astop;
				uart_tx_en <= 1'b1;
				uart_tx_data <= 90;
			end
			else
			begin
			   state <= aleft;
			end
			
			count = 0;
			dete = 1'b0;
		end
		
		else if (state == arigh)
		begin
		   leftw1 = clk1;
			leftw2 = ~clk1;
			rightw1 = ~clk2;
			rightw2 = clk2;
			
			uart_tx_en <= 1'b0;
			
			if(angle_info - angle_infostart >= 2650 && angle_info - angle_infostart <= 2750)
			begin
			   state <= astop;
				uart_tx_en <= 1'b1;
				uart_tx_data <= 90;
			end
			else if(angle_infostart - angle_info >= 850 && angle_infostart - angle_info <= 950)
			begin
			   state <= astop;	
				uart_tx_en <= 1'b1;
				uart_tx_data <= 90;
			end
			else
			begin
			   state <= arigh;
			end
			
			count = 0;
			dete = 1'b0;
			
		   test <= angle_info[23:16];
		end
		
		else if (state == wleft)
		begin
		   leftw1 = ~clk1;
			leftw2 = clk1;
			rightw1 = clk2;
			rightw2 = ~clk2;
			
			uart_tx_en <= 1'b0;
			
			if(ainfo > ainfostart)
			begin
			   if(ainfo - ainfostart < 5 || 3600 + ainfostart - ainfo < 5)
				begin
				   state <= aforw;
				end
				else
				begin
				   state <= wleft;
				end
			end
			else
			begin
				if(ainfostart - ainfo < 5 || 3600 - ainfostart + ainfo < 5)
				begin
				   state <= aforw;
				end
				else
				begin
				   state <= wleft;
				end
			end
			
			count = 0;
			dete = 1'b0;
		end
		
		else if (state == wrigh)
		begin
		   leftw1 = clk1;
			leftw2 = ~clk1;
			rightw1 = ~clk2;
			rightw2 = clk2;

			uart_tx_en <= 1'b0;
			
			if(ainfo > ainfostart)
			begin
			   if(ainfo - ainfostart < 5 || 3600 + ainfostart - ainfo < 5)
				begin
				   state <= aforw;
				end
				else
				begin
				   state <= wrigh;
				end
			end
			else
			begin
				if(ainfostart - ainfo < 5 || 3600 - ainfostart + ainfo < 5)
				begin
				   state <= aforw;
				end
				else
				begin
				   state <= wrigh;
				end
			end
			
			count = 0;
			dete = 1'b0;
			
		end
		
	end
endmodule