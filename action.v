module action(clk0, clk1, clk2, clk3, echo, key, leftw1, leftw2, rightw1, rightw2, a, b, c, d);
   input clk0;
	input clk1;
	input clk2;
	input clk3;
	input echo;
	
	input [3:0]key;
	
	output reg leftw1, leftw2;
	output reg rightw1, rightw2;
	
	output reg a, b, c, d;
	
	reg [3:0]state;//现状态
	reg dete;//检测echo上升沿
	reg [99:0]count;//echo记时
	reg echo1, echo2;//echo(t)&echo(t-1)
	wire [9:0]distance;//障碍物距离
	
	assign distance = dete * echo2 * (~echo1) * count * 17 / 5000;//障碍物距离
	
	parameter standard = 44117;//超声波距离标准
   parameter stop = 4'b0111, forw = 4'b1101, left = 4'b1011, righ = 4'b1110;//四种状态
	
	initial
	begin
		state = stop;
		leftw1 = 1'b0;
		leftw2 = 1'b0;
		rightw1 = 1'b0;
		rightw2 = 1'b0;
		count = 100'b0;
		echo1 = 1'b0;
		echo2 = 1'b0;
		dete = 1'b0;
		a = 1'b0;
		b = 1'b0;
		c = 1'b0;
		d = 1'b0;
	end
	
	always @ (posedge clk0)
	begin
	   echo2 = echo1;
	   echo1 = echo;
		
	   if(key == 4'b1110 || key == 4'b1101 || key == 4'b1011 || key == 4'b0111)
		begin
		   state <= key;
		end
		
	   if(state == stop)//stop
		begin
		   leftw1 = 1'b0;
		   leftw2 = 1'b0;
		   rightw1 = 1'b0;
		   rightw2 = 1'b0;
			a = 1'b1;
			
			case ({echo2, echo1})
	      2'b01 : begin dete = 1'b1; count = count + 1; state <= stop; end
	      2'b11 : begin count = count + 1; state <= stop; end
	      2'b10 : 
	      begin
	         if(count <= standard && dete == 1)
	      	begin 
				   state <= left;	
	      	end
	      	else if(dete == 1)
	      	begin 
					state <= forw;
	      	end
				else 
				begin
				   state <= stop;
				end
	      end
	      2'b00 : begin dete = 1'b0; count = 0; state <= stop; end
	      endcase
		end
		
		else if(state == forw)//forward
		begin
		   leftw1 = clk1;
		   leftw2 = ~clk1;
		   rightw1 = clk2;
		   rightw2 = ~clk2;
			//leftw1 = 0;
			//leftw2 = 1;
			//rightw1 = 0;
			//rightw2 = 1;
			b = 1'b1;
	      
	      case ({echo2, echo1})
	      2'b01 : begin dete = 1'b1; count = count + 1; state <= forw; end
	      2'b11 : begin count = count + 1; state <= forw; end
	      2'b10 : 
	      begin
	         if(count <= standard && dete == 1)
	      	begin 
	      	   //ssig <= 1'b1;
				   state <= stop;	
	      	end
	      	else 
	      	begin 
	      	   //ssig <= 1'b0;
					state <= forw;
	      	end
	      end
	      2'b00 : begin dete = 1'b0; count = 0; state <= forw; end
	      endcase
		end
		
		else if(state == left)//turn left
		begin
		   leftw1 = ~clk1;
			leftw2 = clk1;
			rightw1 = clk2;
			rightw2 = ~clk2;
			//leftw1 = 1;
			//leftw2 = 0;
			//rightw1 = 0;
			//rightw2 = 1;
			c = 1'b1;
			
			count = 0;
			dete = 1'b0;
		end
		
		else if(state == righ)//turn right
		begin
		   leftw1 = clk1;
			leftw2 = ~clk1;
			rightw1 = ~clk2;
			rightw2 = clk2;
			//leftw1 = 0;
			//leftw2 = 1;
			//rightw1 = 1;
			//rightw2 = 0;
			d = 1'b1;
			
			count = 0;
			dete = 1'b0;
		end
		
	end
endmodule