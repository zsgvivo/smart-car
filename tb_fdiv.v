`timescale 10ns / 1ns

module tb_fdiv;
	reg clk0;
	wire clk1;
	wire clk2;
	parameter Tburst = 100000000, Ton = 1, Toff = 1;
	
	fdiv fd(clk0, clk1, clk2);
	initial
	begin
		repeat (Tburst)
			begin
				#Toff clk0 = 1'b1;
				#Ton  clk0 = 1'b0;
			end
	end
endmodule