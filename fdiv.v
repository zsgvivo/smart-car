module fdiv(clk0, clk1, clk2, clk3);
   input clk0;
	output clk1;
	output clk2;
	output clk3;
	
	reg clk1;//left
	reg clk2;//right
	reg clk3;//超声波
	
	reg [19:0]temp1;//clk1
	reg [19:0]temp2;//clk2
	reg [20:0]temp3;//clk3	
	
	always @ (posedge clk0)
	begin
	   temp1 <= temp1 + 20'b1;
		temp2 <= temp2 + 20'b1;
		temp3 <= temp3 + 21'b1;
		
		//clk1
		if(clk1 == 1'b1 && temp1 == 100000)
		begin
		   clk1 <= 1'b0;
			temp1 <= 20'b0;
		end
		else if(clk1 == 1'b0 && temp1 == 400000)
		begin
		   clk1 <= 1'b1;
			temp1 <= 20'b0;
		end
		
		//clk2
		if(clk2 == 1'b1 && temp2 == 100000)
		begin
		   clk2 <= 1'b0;
			temp2 <= 20'b0;
		end
		else if(clk2 == 1'b0 && temp2 == 400000)
		begin
		   clk2 <= 1'b1;
			temp2 <= 20'b0;
		end
		
		//clk3
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
endmodule