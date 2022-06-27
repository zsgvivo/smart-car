module main(clk0, key, leftw, rightw, a, b, c, d);
	input clk0;
	input [3:0]key;
	
	output wire leftw;
	output wire rightw;
	
	output wire a;
	output wire b;
	output wire c;
	output wire d;
	
	wire clk1;
	wire clk2;
	
	fdiv fd(clk0, clk1, clk2);
	
	action ac(clk1, clk2, key, leftw, rightw, a, b, c, d);
	
endmodule