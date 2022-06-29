module main(clk0, key, echo, leftw1, leftw2, rightw1, rightw2, clk3, a, b, c, d);
	input clk0;
	input [3:0]key;
	input echo;
	
	output wire leftw1, leftw2;
	output wire rightw1, rightw2;
	output wire clk3;
	output wire a, b, c, d;
	
	wire clk1, clk2;
	fdiv fd(clk0, clk1, clk2, clk3);

	//wire ssig;
	//ultrasound ul(clk0, echo, clk3, ssig);
	
	action ac(clk0, clk1, clk2, clk3, echo, key, leftw1, leftw2, rightw1, rightw2, a, b, c, d);
	
endmodule