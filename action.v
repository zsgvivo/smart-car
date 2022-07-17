module action(clk0, clk3, clk4, clk5, clk6, echo, rxdone, rxdata, rxdone_angle, rxdata_angle, key,
 leftw1, leftw2, rightw1, rightw2, uart_tx_data, uart_tx_en, test, dig, show);
   input clk0;
	//input clk1;
   //input clk2;
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
	output reg [3:0]dig;
	output reg [6:0]show;
	output reg [7:0]test;
	
	reg [5:0]state;//现状态
	reg dete;//检测echo上升沿
	reg [29:0]count;//echo记时
	reg echo1, echo2;//echo(t)&echo(t-1)
	reg [29:0]countall;
	wire [9:0]distance;//障碍物距离
   wire [3:0]barri;
	//reg remo;//1遥控0自主
	reg [7:0]rxall;//总读取数据
	reg [8*16-1:0]commend;//读取指令
	reg [3:0]cnt;
	reg [8*16-1:0]cc;
	reg [8*16-1:0]angle_commend;//读取指令
	reg [3:0]angle_cnt;
	reg [8*16-1:0]angle_info;
	reg en_changesignal;
	reg [29:0]inicount;
	reg [3:0]now;
	reg [1:0]choose;
	reg [29:0]t;	
	reg [10:0]x; //waiting
   reg [10:0]f; //aforw
	reg [11:0]mae;//前
	reg [11:0]usiro;//后
	reg [11:0]hidari;//左
	reg [11:0]migi;//右
	reg [1:0]nowtowards;
	
	wire [11:0]ainfo;

	assign ainfo = (angle_info[15:8]-48)*1000 + (angle_info[23:16]-48)*100 + (angle_info[31:24]-48)*10 + angle_info[47:40]-48;
	
	assign distance = countall * 17 / 50000;//障碍物距离
	assign barri = 1 + (distance + 5) / 30;
	
	initial
	begin
	   now <= 4'b1111;
	   choose <= 2'b00;
		show <= 7'b0;
		dig <= 4'b0001;
		t <= 0;
		nowtowards <= 0;
	end
	
	always @ (now)
	begin
		case (now)
			4'b0000 :
				show <= 7'b0111111;
			4'b0001 :
				show <= 7'b0000110;
			4'b0010 :
				show <= 7'b1011011;
			4'b0011 :
				show <= 7'b1001111;
			4'b0100 :
				show <= 7'b1100110;
			4'b0101 :
				show <= 7'b1101101;
			4'b0110 :
				show <= 7'b1111101;
			4'b0111 :
				show <= 7'b0000111;
			4'b1000 :
				show <= 7'b1111111;
			4'b1001 :
				show <= 7'b1101111;
			default : 
				show <= 7'b0000000;
		endcase
	end
	
	always @ (posedge clk6)
	begin
	   case(choose)
		   2'b00 :
			begin
			   now <= 0;
				dig <= 4'b1000;
				choose <= 2'b01;
			end
			2'b01 :
			begin
			   now <= distance / 100;
				dig <= 4'b0100;
				choose <= 2'b10;
			end
			2'b10 :
			begin
			   now <= (distance % 100) / 10;
				dig <= 4'b0010;
				choose <= 2'b11;
			end
			2'b11 :
			begin
			   now <= distance % 10;
				dig <= 4'b0001;
				choose <= 2'b00;
			end
			default : 
			begin
			   now <= 4'b1111;
				dig <= 4'b0001;
				choose <= 2'b00;
			end
		endcase
	end
	
   //接收蓝牙串口HC_05返回信息
	always @ (posedge clk0)
	begin
	   //cc <= 0;
		if(cc != 0)
		begin
		   t <= t + 1;
			if(t == 25000000)
			begin
		      cc <= 0;
			   t <= 0;
			end
		end
		if(rxdone == 1)
		begin
	      if(rxdata == 59)
		   begin
		      cc <= commend;
		      commend <= 0;
		   	cnt <= 0;
				t <= 0;
		   end
		   else
		   begin
			   //cc <= 0;
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
	
	
	//接收角度传感器返回值                                
	always @ (posedge clk0)
	begin
		if(rxdone_angle == 1)
		begin
	      if(rxdata_angle == 10)
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
	
	parameter standard = 44117;//超声波距离标准
   parameter stop = 6'b010000, forw = 6'b100000, left = 6'b001000, righ = 6'b000100;//四种状态
   parameter ystop = 6'b000010, ymove = 6'b000001;//摇杆控制状态
	parameter aforw = 6'b110000, aleft = 6'b001100, arigh = 6'b000011;//角度传感三种状态
	parameter wleft = 6'b111000, wrigh = 6'b000111;//左右微调
	parameter waiting = 6'b101010, angle_define = 6'b111111;
	parameter big = 40, sma = 30, turn = 80;
	
	initial
	begin
		state = stop;
		leftw1 = 1'b0;
		leftw2 = 1'b0;
		rightw1 = 1'b0;
		rightw2 = 1'b0;
		count = 50'b0;
		countall = 50'b0;
		echo1 = 1'b0;
		echo2 = 1'b0;
		dete = 1'b0;
		//remo = 1'b1;//1按键遥控
		uart_tx_data = 8'b0;
		uart_tx_en = 1'b0;
	end
	
	always @ (posedge clk0)
	begin
	   echo2 = echo1;
	   echo1 = echo;
		
		////通过蓝牙接收到的指令的不同进入不同状态
		//if(cc[7:0] == 67 && cc[15:8] == 74)
		//begin
		//   state <= ymove;
		//end
		//else if(cc[7:0] == 67 && cc[15:8] == 83)
		//begin
		//   state <= ystop;
		//end
		//if(cc[7:0] == 65 && cc[15:8] == 74)
		//begin
		//	if(cc[31:24] == 48)begin state <= stop; remo <= 1;end
		//	else if(cc[31:24] == 49)begin state <= forw; remo <= 1;end
		//	else if(cc[31:24] == 50)begin state <= left; remo <= 1;end
		//	else if(cc[31:24] == 51)begin state <= righ; remo <= 1;end
		//	else if(cc[31:24] == 52)begin remo <= 0;end
		//end
		if(cc[7:0] == 67 && cc[15:8] == 68)
		begin
		   if(cc[31:24] == 109)begin state <= aforw;end
			else if(cc[31:24] == 108)begin state <= aleft;end
			else if(cc[31:24] == 114)begin state <= arigh;end
			else if(cc[31:24] == 97)begin state <= angle_define;end
			else begin state <= stop;end
		end
		else if(key == 4'b0111)
		begin
		   state <= stop;
		end
		
		
	   if(state == stop)//停止状态
		begin
		   leftw1 = 1'b0;
		   leftw2 = 1'b0;
		   rightw1 = 1'b0;
		   rightw2 = 1'b0;
		   test <= 8'b10000000;
			
			begin
			uart_tx_en <= 1'b0;
			inicount <= countall;
			end
			f <= 0;
			x <= 0;
		   case ({echo2, echo1})//超声波测距
	      2'b01 : begin dete <= 1'b1; count <= count + 1; uart_tx_en <= 1'b0; end
	      2'b11 : begin count <= count + 1; uart_tx_en <= 1'b0; end
	      2'b10 : 
	      begin
			   if(cc[7:0] == 67 && cc[15:8] == 68 && cc[31:24] == 100 && dete == 1)
				begin
				   countall <= count;
					inicount <= count;
					dete <= 1'b0;
					count <= 0;
					uart_tx_en <= 1'b1;
		   		uart_tx_data <= 48 + barri;
				end
	         else if(dete == 1)
	      	begin 
		   	   countall <= count;
					inicount <= count;
					dete <= 1'b0;
					count <= 0;
	      	end
		   	else
		   	begin
		   	   dete <= 1'b0; count <= 0; uart_tx_en <= 1'b0;
		   	end
	      end
	      2'b00 : begin dete <= 1'b0; count <= 0; uart_tx_en <= 1'b0; end
	      endcase
		end
		
		//else if(state == forw)//按键遥控前进状态
		//begin
		//   leftw1 = clk1;
		//   leftw2 = ~clk1;
		//   rightw1 = clk2;
		//   rightw2 = ~clk2;
		//end
		//
		//else if(state == left)//按键遥控原地左转
		//begin
		//   leftw1 = ~clk1;
		//	leftw2 = clk1;
		//	rightw1 = clk2;
		//	rightw2 = ~clk2;
		//	
		//	count = 0;
		//	dete = 1'b0;
		//end
		//
		//else if(state == righ)//按键遥控原地右转
		//begin
		//   leftw1 = clk1;
		//	leftw2 = ~clk1;
		//	rightw1 = ~clk2;
		//	rightw2 = clk2;
		//	
		//	count = 0;
		//	dete = 1'b0;
		//end
		//
		//else if (state == ystop)//摇杆遥控停止状态
		//begin
		//   leftw1 = 1'b0;
		//   leftw2 = 1'b0;
		//   rightw1 = 1'b0;
		//   rightw2 = 1'b0;
		//	
		//	count = 0;
		//	dete = 1'b0;
		//end
		//
		//else if (state == ymove)//摇杆运动控制
		//begin
		//   leftw1 = clk4;
		//   leftw2 = ~clk4;
		//   rightw1 = clk5;
		//   rightw2 = ~clk5;
		//	
		//	count = 0;
		//	dete = 1'b0;
		//end
		
		else if (state == aforw)//前进30cm，利用超声波测距
		begin
		   leftw1 = clk4;
		   leftw2 = ~clk4;
		   rightw1 = clk5;
		   rightw2 = ~clk5;
			x <= 0;	
			begin
			uart_tx_en <= 1'b0;
			uart_tx_data <= 0;
			end
			test <= 8'b00000001;
			
			//走直线矫正
			if(nowtowards == 0)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(mae < 100 && mae + 1800 - ainfo >= big)
					begin
					   state <= wrigh;
					end
				   else if(ainfo + 1800 > mae && ainfo - mae + 1800 >= big)
					begin
					   state <= wleft;
					end
					else if(ainfo + 1800 < mae && mae - 1800 - ainfo >= big)
					begin
					   state <= wrigh;
					end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(mae > 3500 && 5400 - mae - ainfo >= big)
					begin
					   state <= wleft;
					end
				   else if(1800 - ainfo > mae && 1800 - ainfo - mae >= big)
					begin
					   state <= wleft;
					end
					else if(1800 - ainfo < mae && mae - 1800 + ainfo >= big)
					begin
					   state <= wrigh;
					end
				end
			end
			
			else if(nowtowards == 1)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(hidari < 100 && hidari + 1800 - ainfo >= big)
					begin
					   state <= wrigh;
					end
				   else if(ainfo + 1800 > hidari && ainfo - hidari + 1800 >= big)
					begin
					   state <= wleft;
					end
					else if(ainfo + 1800 < hidari && hidari - 1800 - ainfo >= big)
					begin
					   state <= wrigh;
					end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(hidari > 3500 && 5400 - hidari - ainfo >= big)
					begin
					   state <= wleft;
					end
				   else if(1800 - ainfo > hidari && 1800 - ainfo - hidari >= big)
					begin
					   state <= wleft;
					end
					else if(1800 - ainfo < hidari && hidari - 1800 + ainfo >= big)
					begin
					   state <= wrigh;
					end
				end
			end
			
			else if(nowtowards == 2)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(usiro < 100 && usiro + 1800 - ainfo >= big)
					begin
					   state <= wrigh;
					end
				   else if(ainfo + 1800 > usiro && ainfo - usiro + 1800 >= big)
					begin
					   state <= wleft;
					end
					else if(ainfo + 1800 < usiro && usiro - 1800 - ainfo >= big)
					begin
					   state <= wrigh;
					end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(usiro > 3500 && 5400 - usiro - ainfo >= big)
					begin
					   state <= wleft;
					end
				   else if(1800 - ainfo > usiro && 1800 - ainfo - usiro >= big)
					begin
					   state <= wleft;
					end
					else if(1800 - ainfo < usiro && usiro - 1800 + ainfo >= big)
					begin
					   state <= wrigh;
					end
				end
			end
			
			else if(nowtowards == 3)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(migi < 100 && migi + 1800 - ainfo >= big)
					begin
					   state <= wrigh;
					end
				   else if(ainfo + 1800 > migi && ainfo - migi + 1800 >= big)
					begin
					   state <= wleft;
					end
					else if(ainfo + 1800 < migi && migi - 1800 - ainfo >= big)
					begin
					   state <= wrigh;
					end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(migi > 3500 && 5400 - migi - ainfo >= big)
					begin
					   state <= wleft;
					end
				   else if(1800 - ainfo > migi && 1800 - ainfo - migi >= big)
					begin
					   state <= wleft;
					end
					else if(1800 - ainfo < migi && migi - 1800 + ainfo >= big)
					begin
					   state <= wrigh;
					end
				end
			end
			
	      case ({echo2, echo1})//超声波测距，保证走30cm
	      2'b01 : begin dete <= 1'b1; count <= count + 1; uart_tx_en <= 1'b0;end
	      2'b11 : begin count <= count + 1; uart_tx_en <= 1'b0;end
	      2'b10 : 
	      begin
			if((inicount > count && inicount - count >= 76000 && dete == 1) || count <= 42000)
	      	begin
				   f <= f + 1;
				   countall <= count;
					count <= 0;
					dete <= 0;
					if(f == 5)
					begin
					   f <= 0;
				      state <= waiting;
					end
	      	end
				else if(dete == 1)
				begin
				   f <= 0;
				   countall <= count;
					count <= 0;
					dete <= 0;
					uart_tx_en <= 1'b0;
					uart_tx_data <= 0;
				end
				else
				begin
					count <= 0;
					dete <= 0;
					uart_tx_en <= 1'b0;
					uart_tx_data <= 0;
				end
			end
	      2'b00 : begin dete <= 1'b0; count <= 0; uart_tx_en <= 1'b0;end
	      endcase
		end
		
	   else if (state == aleft)//左转到指定角度，正常情况下旋转九十度
		begin
		   leftw1 = ~clk4;
			leftw2 = clk4;
			rightw1 = clk5;
			rightw2 = ~clk5;
			x <= 0;
	      f <= 0;	
			count = 0;
			dete = 1'b0;
			begin
			uart_tx_en <= 1'b0;
			end
			test <= 8'b00001000;
			
			if(nowtowards == 0)
			begin
			   if(angle_info[7:0] == 43 && 1800 + ainfo - hidari <= turn)
				begin
				   state <= waiting;
					nowtowards <= 1;
				end
				else if(angle_info[7:0] == 45 && hidari <= 1800 && 1800 - ainfo - hidari <= turn)
				begin
				   state <= waiting;
					nowtowards <= 1;
				end
				else if(angle_info[7:0] == 45 && hidari >= 2700 && 5400 - ainfo - hidari <= turn)
				begin
				   state <= waiting;
					nowtowards <= 1;
				end
				else
				begin
				   state <= aleft;
				end
			end
			
			else if(nowtowards == 1)
			begin
			   if(angle_info[7:0] == 43 && 1800 + ainfo - usiro <= turn)
				begin
				   state <= waiting;
					nowtowards <= 2;
				end
				else if(angle_info[7:0] == 45 && usiro <= 1800 && 1800 - ainfo - usiro <= turn)
				begin
				   state <= waiting;
					nowtowards <= 2;
				end
				else if(angle_info[7:0] == 45 && usiro >= 2700 && 5400 - ainfo - usiro <= turn)
				begin
				   state <= waiting;
					nowtowards <= 2;
				end
				else
				begin
				   state <= aleft;
				end
			end
			
			else if(nowtowards == 2)
			begin
			   if(angle_info[7:0] == 43 && 1800 + ainfo - migi <= turn)
				begin
				   state <= waiting;
					nowtowards <= 3;
				end
				else if(angle_info[7:0] == 45 && migi <= 1800 && 1800 - ainfo - migi <= turn)
				begin
				   state <= waiting;
					nowtowards <= 3;
				end
				else if(angle_info[7:0] == 45 && migi >= 2700 && 5400 - ainfo - migi <= turn)
				begin
				   state <= waiting;
					nowtowards <= 3;
				end
				else
				begin
				   state <= aleft;
				end
			end
			
			else if(nowtowards == 3)
			begin
			   if(angle_info[7:0] == 43 && 1800 + ainfo - mae <= turn)
				begin
				   state <= waiting;
					nowtowards <= 0;
				end
				else if(angle_info[7:0] == 45 && mae <= 1800 && 1800 - ainfo - mae <= turn)
				begin
				   state <= waiting;
					nowtowards <= 0;
				end
				else if(angle_info[7:0] == 45 && mae >= 2700 && 5400 - ainfo - mae <= turn)
				begin
				   state <= waiting;
					nowtowards <= 0;
				end
				else
				begin
				   state <= aleft;
				end
			end
		end
		
		else if (state == arigh)//右转九十度到指定角度，正常情况下旋转九十度
		begin
		   leftw1 = clk4;
			leftw2 = ~clk4;
			rightw1 = ~clk5;
			rightw2 = clk5;
			f <= 0;
			x <= 0;		
			count = 0;
			dete = 1'b0;
			begin
			uart_tx_en <= 1'b0;
			end
			test <= 8'b00000100;
			
			if(nowtowards == 0)
			begin
			   if(angle_info[7:0] == 43 && migi >= 1800 && migi - 1800 - ainfo <= 60)
				begin
				   state <= waiting;
					nowtowards <= 3;
				end
				else if(angle_info[7:0] == 43 && migi <= 900 && 1800 + migi - ainfo <= 60)
				begin
				   state <= waiting;
					nowtowards <= 3;
				end
				else if(angle_info[7:0] == 45 && migi + ainfo - 1800 <= 60)
				begin
				   state <= waiting;
					nowtowards <= 3;
				end
				else
				begin
				   state <= arigh;
				end
			end
			
			else if(nowtowards == 3)
			begin
			   if(angle_info[7:0] == 43 && usiro >= 1800 && usiro - 1800 - ainfo <= 60)
				begin
				   state <= waiting;
					nowtowards <= 2;
				end
				else if(angle_info[7:0] == 43 && usiro <= 900 && 1800 + usiro - ainfo <= 60)
				begin
				   state <= waiting;
					nowtowards <= 2;
				end
				else if(angle_info[7:0] == 45 && usiro + ainfo - 1800 <= 60)
				begin
				   state <= waiting;
					nowtowards <= 2;
				end
				else
				begin
				   state <= arigh;
				end
			end
			
			else if(nowtowards == 2)
			begin
			   if(angle_info[7:0] == 43 && hidari >= 1800 && hidari - 1800 - ainfo <= 60)
				begin
				   state <= waiting;
					nowtowards <= 1;
				end
				else if(angle_info[7:0] == 43 && hidari <= 900 && 1800 + hidari - ainfo <= 60)
				begin
				   state <= waiting;
					nowtowards <= 1;
				end
				else if(angle_info[7:0] == 45 && hidari + ainfo - 1800 <= 60)
				begin
				   state <= waiting;
					nowtowards <= 1;
				end
				else
				begin
				   state <= arigh;
				end
			end
			
			else if(nowtowards == 1)
			begin
			   if(angle_info[7:0] == 43 && mae >= 1800 && mae - 1800 - ainfo <= 60)
				begin
				   state <= waiting;
					nowtowards <= 0;
				end
				else if(angle_info[7:0] == 43 && mae <= 900 && 1800 + mae - ainfo <= 60)
				begin
				   state <= waiting;
					nowtowards <= 0;
				end
				else if(angle_info[7:0] == 45 && mae + ainfo - 1800 <= 60)
				begin
				   state <= waiting;
					nowtowards <= 0;
				end
				else
				begin
				   state <= arigh;
				end
			end
		end
		
		//矫正
		else if (state == wleft)//向右偏后向左回调
		begin
		   leftw1 = ~clk4;
			leftw2 = clk4;
			rightw1 = clk5;
			rightw2 = ~clk5;
			test <= 8'b01000000;
			uart_tx_en <= 1'b0;
			
			if(nowtowards == 0)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(ainfo + 1800 > mae && ainfo - mae + 1800 <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wleft;
				   end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(mae > 3500 && 5400 - mae - ainfo <= sma)
					begin
					   state <= aforw;
					end
				   else if(1800 - ainfo > mae && 1800 - ainfo - mae <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wleft;
				   end
				end
			end
//
         else if(nowtowards == 1)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(ainfo + 1800 > hidari && ainfo - hidari + 1800 <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wleft;
				   end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(hidari > 3500 && 5400 - hidari - ainfo <= sma)
					begin
					   state <= aforw;
					end
				   else if(1800 - ainfo > hidari && 1800 - ainfo - hidari <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wleft;
				   end
				end
			end
			
			else if(nowtowards == 2)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(ainfo + 1800 > usiro && ainfo - usiro + 1800 <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wleft;
				   end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(usiro > 3500 && 5400 - usiro - ainfo <= sma)
					begin
					   state <= aforw;
					end
				   else if(1800 - ainfo > usiro && 1800 - ainfo - usiro <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wleft;
				   end
				end
			end
			
			else if(nowtowards == 3)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(ainfo + 1800 > migi && ainfo - migi + 1800 <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wleft;
				   end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(migi > 3500 && 5400 - migi - ainfo <= sma)
					begin
					   state <= aforw;
					end
				   else if(1800 - ainfo > migi && 1800 - ainfo - migi <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wleft;
				   end
				end
			end
			
			count = 0;
			dete = 1'b0;
		end
		
		else if (state == wrigh)//向左偏移后向右回调
		begin
		   leftw1 = clk4;
			leftw2 = ~clk4;
			rightw1 = ~clk5;
			rightw2 = clk5;
//
			test <= 8'b00100000;
			uart_tx_en <= 1'b0;
			
			if(nowtowards == 0)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(mae < 100 && mae + 1800 - ainfo <= sma)
					begin
					   state <= aforw;
					end
					else if(ainfo + 1800 < mae && mae - 1800 - ainfo <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wrigh;
				   end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(1800 - ainfo < mae && mae - 1800 + ainfo <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wrigh;
				   end
				end
			end
			
			else if(nowtowards == 1)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(hidari < 100 && hidari + 1800 - ainfo <= sma)
					begin
					   state <= aforw;
					end
					else if(ainfo + 1800 < hidari && hidari - 1800 - ainfo <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wrigh;
				   end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(1800 - ainfo < hidari && hidari - 1800 + ainfo <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wrigh;
				   end
				end
			end
			
			else if(nowtowards == 2)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(usiro < 100 && usiro + 1800 - ainfo <= sma)
					begin
					   state <= aforw;
					end
					else if(ainfo + 1800 < usiro && usiro - 1800 - ainfo <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wrigh;
				   end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(1800 - ainfo < usiro && usiro - 1800 + ainfo <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wrigh;
				   end
				end
			end
			
			if(nowtowards == 3)
			begin
			   if(angle_info[7:0] == 43)
				begin
				   if(migi < 100 && migi + 1800 - ainfo <= sma)
					begin
					   state <= aforw;
					end
					else if(ainfo + 1800 < migi && migi - 1800 - ainfo <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wrigh;
				   end
				end
				else if(angle_info[7:0] == 45)
				begin
				   if(1800 - ainfo < migi && migi - 1800 + ainfo <= sma)
					begin
					   state <= aforw;
					end
					else
					begin
					   state <= wrigh;
				   end
				end
			end
			
			count = 0;
			dete = 1'b0;
			
		end
		
		else if(state == waiting)//等待状态，每个动作停止后探测距离并发送动作完成信号
		begin
		   leftw1 = 1'b0;
		   leftw2 = 1'b0;
			rightw1 = 1'b0;
			rightw2 = 1'b0;
			test <= 8'b00010000;
			f <= 0;
			case ({echo2, echo1})
	      2'b01 : begin dete <= 1'b1; count <= count + 1; uart_tx_en <= 1'b0; end
	      2'b11 : begin count <= count + 1; uart_tx_en <= 1'b0; end
	      2'b10 : 
	      begin
	         if(dete == 1)
				begin
				   x <= x + 1;
				   inicount <= count;
					countall <= count;
					count <= 0;
					dete <= 0;
					if(x == 5)
					begin
						inicount <= count;
						countall <= count;
					   uart_tx_en <= 1'b1;
					   uart_tx_data <= 90;
					end
					else if(x == 6)
					begin
					   x <= 0;
						inicount <= count;
						countall <= count;
					   uart_tx_en <= 1'b1;
					   uart_tx_data <= 90;
					   state <= stop;
					end
				end
				else
				begin
					count <= 0;
					dete <= 0;
					uart_tx_en <= 1'b0;
				end
			end
	      2'b00 : begin dete <= 1'b0; count <= 0; uart_tx_en <= 1'b0; end
	      endcase
		end
		
		else if(state == angle_define)//初始化四个方向的角度
		begin
			nowtowards <= 0;
			begin
				if(ainfo >= 0 && ainfo < 900)
				begin
				   if(angle_info[7:0] == 43)
					begin
					   mae <= 1800 + ainfo;
						hidari <= 900 + ainfo;
					   migi <= ainfo + 2700;
					   usiro <= ainfo;
					   state <= stop;	
					end
					else if(angle_info[7:0] == 45)
					begin
					   mae <= 1800 - ainfo;
						hidari <= 900 - ainfo;
					   migi <= 2700 - ainfo;
					   usiro <= 3600 - ainfo;	
						state <= stop;	
					end
				end
				
				else if(ainfo >= 900 && ainfo <= 1800)
				begin
				   if(angle_info[7:0] == 43)
					begin
					   mae <= 1800 + ainfo;
						hidari <= 900 + ainfo;
					   migi <= 2700 - ainfo;
					   usiro <= ainfo - 900;
						state <= stop;	
					end
				   else if(angle_info[7:0] == 45)
					begin
					   mae <= 1800 - ainfo;
						hidari <= 4500 - ainfo;
					   migi <= 2700 - ainfo;
					   usiro <= 3600 - ainfo;	
						state <= stop;	
					end	
				end
			end
		end
	end
endmodule