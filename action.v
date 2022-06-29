module action(clk0, clk1, clk2, key, ssig, leftw, rightw);
   input clk0;
	input clk1;
	input clk2;
	
	input [3:0]key;
	input ssig;
	
	output reg leftw;
	output reg rightw;
	
	reg [3:0]state;
	
   parameter stop = 4'b0111, forw = 4'b1101, left = 4'b1011, righ = 4'b1110;
	
	initial
	begin
		state = stop;
		leftw = 1'b0;
		rightw = 1'b0;
	end
	
	always @ (posedge clk0)
	begin
	   if(key == 4'b1110 || key == 4'b1101 || key == 4'b1011 || key == 4'b0111)
		begin
		   state = key;
		end
		
		if(ssig == 1'b1)
		begin 
		   state = left;
		end
		else 
		begin
		   state = forw;
		end
		
	   if(state == stop)//stop
		begin
		   leftw = 1'b0;
			rightw = 1'b0;
		end
		
		else if(state == forw)//forward
		begin
		   leftw = clk2;
			rightw = clk1;
		end
		
		else if(state == left)//turn left
		begin
		   leftw = clk1;
			rightw = clk1;
		end
		
		else if(state == righ)//turn right
		begin
		   leftw = clk2;
			rightw = clk2;
		end
		
	end
endmodule