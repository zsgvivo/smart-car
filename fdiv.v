module fdiv(clk0, clk1, clk2);
   input clk0;
	output clk1;//1ms 
	output clk2;//2ms
	
	reg clk1;
	reg clk2;
	reg [19:0]temp1;
	reg [19:0]temp2;
	
	
	always @ (posedge clk0)
	begin
	   temp1 <= temp1 + 20'b1;
		temp2 <= temp2 + 20'b1;
		
		if(clk1 == 1'b1 && temp1 == 60000)
		begin
		   clk1 <= 1'b0;
			temp1 <= 20'b0;
		end
		else if(clk1 == 1'b0 && temp1 == 940000)
		begin
		   clk1 <= 1'b1;
			temp1 <= 20'b0;
		end
		
		if(clk2 == 1'b1 && temp2 == 90000)
		begin
		   clk2 <= 1'b0;
			temp2 <= 20'b0;
		end
		else if(clk2 == 1'b0 && temp2 == 910000)
		begin
		   clk2 <= 1'b1;
			temp2 <= 20'b0;
		end
	end
endmodule