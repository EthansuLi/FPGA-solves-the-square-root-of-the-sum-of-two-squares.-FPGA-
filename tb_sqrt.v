`timescale 1ns/1ps
module tb_sqrt;

reg clk;
reg rst_n;
reg [15:0] din;
reg sqrt_en;

reg [7:0] a;
reg [7:0] b;
wire			valid		 ;
wire	[7:0]	sqrt_out	 ;
wire	[15:0]	remain_out   ;
always #5 clk = ~clk;
/*
initial begin
	clk = 1'b0;
	rst_n = 1'b0;
	sqrt_en = 1'b0;
	din = 'd0;
	#200
	rst_n = 1'b1;
	#100
    din = 'd147;
	sqrt_en = 1'b1;
	#10
	sqrt_en = 1'b0;
	
	#100
    din = 'd256;
	sqrt_en = 1'b1;
	#10
	sqrt_en = 1'b0;
	
	#100
    din = 'd65432;
	sqrt_en = 1'b1;
	#10
	sqrt_en = 1'b0;
	
	#100
    din = 'd65535;
	sqrt_en = 1'b1;
	#10
	sqrt_en = 1'b0;
end



sqrt u_sqrt(
	.clk			(clk		),
	.rst_n			(rst_n		),
	.sqrt_en		(sqrt_en	), // 输入数据有效
	.din			(din		), // 上游模块支持-128~127，平方15bit，两数和最大到16bit(128*128*2)
	.valid			(valid		),
	.sqrt_out		(sqrt_out	),
	.remain_out     (remain_out)
);
*/

initial begin
	clk = 1'b0;
	rst_n = 1'b0;
	sqrt_en = 1'b0;
	a = 'd0;
	#200
	rst_n = 1'b1;
	
	#200
    a = 8'b10000000;
	b = 8'b10000000;
	sqrt_en = 1'b1;
	#10
	sqrt_en = 1'b0;
	
	#200
    a = 8'b11111111;
	b = 8'b11111111;
	sqrt_en = 1'b1;
	#10
	sqrt_en = 1'b0;
	
	#200
    a = 'd147;
	b = 8'b10101010;
	sqrt_en = 1'b1;
	#10
	sqrt_en = 1'b0;
end
 a2_add_b2 u_inst(
	.clk 	(clk),
	.rst_n	(rst_n),
	.a		(a), // 有符号数
	.b		(b), // 有符号数
	.i_vld	(sqrt_en),
	.o_vld	(valid),
	.sqrt	(sqrt_out),
	.remain (remain_out)
);
endmodule