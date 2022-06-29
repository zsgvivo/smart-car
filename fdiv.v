module fdiv(clk0, clk1, clk2);
   input clk0;
	output clk1;
	output clk2;
	
	reg clk1;//顺时针
	reg clk2;//逆时针
	reg [19:0]temp1;//clk1
	reg [19:0]temp2;//clk2
	
	
	always @ (posedge clk0)
	begin
	   temp1 <= temp1 + 20'b1;
		temp2 <= temp2 + 20'b1;
		
		if(clk1 == 1'b1 && temp1 == 53700)
		begin
		   clk1 <= 1'b0;
			temp1 <= 20'b0;
		end
		else if(clk1 == 1'b0 && temp1 == 946300)
		begin
		   clk1 <= 1'b1;
			temp1 <= 20'b0;
		end
		
		if(clk2 == 1'b1 && temp2 == 100000)
		begin
		   clk2 <= 1'b0;
			temp2 <= 20'b0;
		end
		else if(clk2 == 1'b0 && temp2 == 900000)
		begin
		   clk2 <= 1'b1;
			temp2 <= 20'b0;
		end
	end
endmodule