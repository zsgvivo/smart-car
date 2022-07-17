module main(clk0, key, echo, rx, rx_angle, rst,
 leftw1, leftw2, rightw1, rightw2, clk3, tx, test, dig, show, a, b, c, d, e, f, g, h);
	input clk0;//50MHz
	input [3:0]key;//按键控制
	input echo;//超声波回声信号
	input rx;//外部传到fpga读取的信息
	input rx_angle;//GY-26传到fpga读取的信息
	input rst;//reset
	
	output wire leftw1, leftw2;//左轮制动
	output wire rightw1, rightw2;//右轮制动
	output wire clk3;//超声波输入信号
	output wire tx;//fpga传出信息
	output wire [3:0]dig;
	output wire [6:0]show;
	
	output wire [7:0]test;
	output wire a, b, c, d, e, f, g, h;
	assign a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0; 
	
	
	wire clk4, clk5, clk6;//左右轮速度PWM
	fdiv fd(clk0, rxdone, rxdata, clk3, clk4, clk5, clk6);
	
	wire [7:0]uart_tx_data;//待发送数据
	wire uart_tx_en;//发送使能
	wire [7:0]txdetectangle;//待发送数据
	wire txangle_en;//发送使能
	action ac(clk0, clk3, clk4, clk5, clk6, echo, rxdone, rxdata, rxdone_angle, rxdata_angle, key, 
 leftw1, leftw2, rightw1, rightw2, uart_tx_data, uart_tx_en, test, dig, show);
	
	wire rxdone;
	wire [7:0]rxdata;//读取完成标志和读取到的数据
	uart_rx urx(clk0, rst, rx, rxdone, rxdata);
	uart_tx utx(clk0, rst, uart_tx_data, uart_tx_en, tx);
	
	wire rxdone_angle;
	wire [7:0]rxdata_angle;
	uart_rx_angle urx_a(clk0, rst, rx_angle, rxdone_angle, rxdata_angle);
	//uart_tx_angle utx_a(clk0, rst, txdetectangle, txangle_en, tx_angle);
	
endmodule