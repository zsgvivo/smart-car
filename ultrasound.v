module ultrasound(clk0, echo, clk3, ssig);
   input clk0;
	input echo;
	
	output reg clk3;//超声波测距触发信号
	output reg ssig;
	
	reg [20:0]temp3;//clk3
	reg [99:0]count;//echo
	reg echo1, echo2;
	
	parameter standard = 44117;
	
	initial
	begin
	   ssig = 1'b0;
		count = 100'b0;
		echo1 = 1'b0;
		echo2 = 1'b0;
	end
	
	always @ (posedge clk0)
	begin
	   temp3 <= temp3 + 21'b1;
		
		if(clk3 == 1'b1 && temp3 == 550)
		begin
		   clk3 <= 1'b0;
			temp3 <= 21'b0;
		end
		else if(clk3 == 1'b0 && temp3 == 999450)
		begin
		   clk3 <= 1'b1;
			temp3 <= 21'b0;
		end
   end

   always @ (posedge clk0)	
	begin
	   echo2 = echo1;
		echo1 = echo;
		
		case ({echo2, echo1})
		2'b01 : count = count + 1;
		2'b11 : count = count + 1;
		2'b10 : 
		begin
		   if(count <= standard)
			begin 
			   ssig = 1'b1; 
				//count = 0;
			end
			else 
			begin 
			   ssig = 1'b0;
				//count = 0;
			end
		end
		2'b00 : count = 0;
		endcase
	end
endmodule
		   