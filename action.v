module action(clk1, clk2, key, leftw, rightw, a, b, c, d);

	input clk1;
	input clk2;
	input [3:0]key;
	
	output reg leftw;
	output reg rightw;
	
	output reg a;
	output reg b;
	output reg c;
	output reg d;
	
	reg [3:0]state;
	
   parameter stop = 4'b1110, forw = 4'b1101, left = 4'b1011, righ = 4'b0111;
	
	initial
	begin
		state <= stop;
		leftw <= 1'b0;
		rightw <= 1'b0;
		a <= 1'b0;
		b <= 1'b0;
		c <= 1'b0;
		d <= 1'b0;
	end
	
	always @ (posedge clk2)
	begin
	   if (key == 4'b1110)
		begin
		   state <= stop; 
		end
		if (key == 4'b1101)
		begin
		   state <= forw;
		end
		if (key == 4'b1011)
		begin
		   state <= left;
		end
		if (key == 4'b0111)
		begin
		   state <= righ;
		end
	end
	
	always @ (posedge clk1)
	begin
	   if(state == stop)//stop
		begin
		   leftw <= 1'b0;
			rightw <= 1'b0;
			a <= 1'b1;
		end
		
		else if(state == forw)//forward
		begin
		   leftw <= clk1;
			rightw <= clk2;
			b <= 1'b1;
		end
		
		else if(state == left)//turn left
		begin
		   leftw <= clk2;
			rightw <= clk2;
			c <= 1'b1;
		end
		
		else if(state == righ)//turn right
		begin
		   leftw <= clk1;
			rightw <= clk1;
			d <= 1'b1;
		end
		
	end
endmodule