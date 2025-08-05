module a2_add_b2(
	input 				clk 	,
	input 				rst_n	,
	input 		[7:0]	a		, // 有符号数
	input 		[7:0]	b		, // 有符号数
	input 				i_vld	,
	output				o_vld	,
	output		[7:0]	sqrt	,
	output		[15:0]  remain
);

	reg [7:0] a_tmp;
	reg [7:0] b_tmp;
	wire [7:0] ua;
	wire [7:0] ub;
	wire [6:0] f_a;
	wire [6:0] f_b;
	reg [14:0] a_tmp_2; // 平方
	reg [14:0] b_tmp_2; // 平方
	wire [15:0] add;
	reg vld_d0;
	reg sqrt_en;
	assign ua = {1'b0,a_tmp[6:0]};
	assign ub = {1'b0,b_tmp[6:0]};
	assign f_a = ~(a_tmp[6:0])+1'b1;
	assign f_b = ~(b_tmp[6:0])+1'b1;
	always@(posedge clk or negedge rst_n) begin // 1拍
		if(~rst_n) begin
			a_tmp <= 'd0;
			b_tmp <= 'd0;
		end
		else if(i_vld) begin
			a_tmp <= a;
			b_tmp <= b;
		end	
	end

	always@(posedge clk or negedge rst_n) begin // 1拍
		if(~rst_n) begin
			a_tmp_2 <= 'd0;
			b_tmp_2 <= 'd0;
		end
		else begin // 负数
			if(a_tmp == 8'b10000000 )
				a_tmp_2 <= ({1'b1,f_a}) * ({1'b1,f_a});
			else if(b_tmp[7] == 1)
				a_tmp_2 <= (f_a) * (f_a);
			else
				a_tmp_2 <= ua * ua;
			if(b_tmp == 8'b10000000 )
				b_tmp_2 <= ({1'b1,f_b}) * ({1'b1,f_b});
			else if(b_tmp[7] == 1)
				b_tmp_2 <= (f_b) * (f_b);
			else
				b_tmp_2 <= ub * ub;
		end	
	end
	always@(posedge clk or negedge rst_n) begin // 1拍
		if(~rst_n) begin
			vld_d0 <= 1'b0;
			sqrt_en <= 1'b0;
		end
		else begin
			vld_d0 <= i_vld;
			sqrt_en <= vld_d0;
		end		
	end
	assign add = a_tmp_2 + b_tmp_2;
	
	
	sqrt u_sqrt(
	.clk			(clk		),
	.rst_n			(rst_n		),
	.sqrt_en		(sqrt_en	), // 输入数据有效
	.din			(add		), // 上游模块支持-128~127，平方15bit，两数和最大到16bit(128*128*2)
	.valid			(o_vld		),
	.sqrt_out		(sqrt	),
	.remain_out     (remain )
);
	
endmodule