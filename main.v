module main(clk0, key, echo, leftw, rightw, clk3);
	input clk0;
	input [3:0]key;
	input echo;
	
	output wire leftw;
	output wire rightw;
	output wire clk3;
	
	wire clk1, clk2;
	fdiv fd(clk0, clk1, clk2);

	wire ssig;
	ultrasound ul(clk0, echo, clk3, ssig);
	
	action ac(clk0, clk1, clk2, key, ssig, leftw, rightw);
	
endmodule