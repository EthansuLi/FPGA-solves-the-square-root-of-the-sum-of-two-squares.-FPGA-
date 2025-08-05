module sqrt(
	input				clk			,
	input				rst_n		,
	input 				sqrt_en		, // 输入数据有效
	input   	[15:0]	din			, // 上游模块支持-128~127，平方15bit，两数和最大到16bit(128*128*2)
	output	reg 		valid		,
	output 	reg [7:0]  	sqrt_out	,
	output  reg [15:0]  remain_out
);


reg [3:0] state;
reg [15:0] remain_tmp;
reg [7:0] sqrt_tmp;
always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		state <= 'd0;
		sqrt_tmp <= 'd0;
		remain_tmp <= 'd0;
	end
	else if(sqrt_en) begin
		remain_tmp <= din;
		state <= 1'b1;
		sqrt_tmp <= 'd0;
	end
	else begin
		case(state)
			1 : begin 
				if(remain_tmp[15:14] >= 2'b01) begin // 开始阶段0：假设Q7==1，判断Q7和当前的余数谁大
					sqrt_tmp <= {sqrt_tmp[6:0],1'b1};
					remain_tmp <= remain_tmp - {2'b01,14'h0};
				end
				else begin
					sqrt_tmp <= {sqrt_tmp[6:0],1'b0};
					remain_tmp <= remain_tmp;
				end
				state <= state + 1'b1;
			end
			2 : begin 
				if(remain_tmp[15:12] >= {sqrt_tmp[0],2'b01}) begin // 阶段1：假设Q6==1,Q7左移一位（Q6前1位补0），余数每次向后拓展两位，判断Q6和当前的余数谁大
					sqrt_tmp <= {sqrt_tmp[6:0],1'b1};
					remain_tmp <= remain_tmp - {sqrt_tmp[0],2'b01,12'h0};
				end
				else begin
					sqrt_tmp <= {sqrt_tmp[6:0],1'b0};
					remain_tmp <= remain_tmp;
				end
				state <= state + 1'b1;
			end
			3 : begin 
				if(remain_tmp[15:10] >= {sqrt_tmp[1:0],2'b01}) begin 
					sqrt_tmp <= {sqrt_tmp[6:0],1'b1};
					remain_tmp <= remain_tmp - {sqrt_tmp[1:0],2'b01,10'h0};
				end
				else begin
					sqrt_tmp <= {sqrt_tmp[6:0],1'b0};
					remain_tmp <= remain_tmp;
				end
				state <= state + 1'b1;
			end
			4 : begin 
				if(remain_tmp[15:8] >= {sqrt_tmp[2:0],2'b01}) begin 
					sqrt_tmp <= {sqrt_tmp[6:0],1'b1};
					remain_tmp <= remain_tmp - {sqrt_tmp[2:0],2'b01,8'h0};
				end
				else begin
					sqrt_tmp <= {sqrt_tmp[6:0],1'b0};
					remain_tmp <= remain_tmp;
				end
				state <= state + 1'b1;
			end
			5 : begin 
				if(remain_tmp[15:6] >= {sqrt_tmp[3:0],2'b01}) begin 
					sqrt_tmp <= {sqrt_tmp[6:0],1'b1};
					remain_tmp <= remain_tmp - {sqrt_tmp[3:0],2'b01,6'h0};
				end
				else begin
					sqrt_tmp <= {sqrt_tmp[6:0],1'b0};
					remain_tmp <= remain_tmp;
				end
				state <= state + 1'b1;
			end
			6 : begin 
				if(remain_tmp[15:4] >= {sqrt_tmp[4:0],2'b01}) begin 
					sqrt_tmp <= {sqrt_tmp[6:0],1'b1};
					remain_tmp <= remain_tmp - {sqrt_tmp[4:0],2'b01,4'h0};
				end
				else begin
					sqrt_tmp <= {sqrt_tmp[6:0],1'b0};
					remain_tmp <= remain_tmp;
				end
				state <= state + 1'b1;
			end
			7 : begin 
				if(remain_tmp[15:2] >= {sqrt_tmp[5:0],2'b01}) begin 
					sqrt_tmp <= {sqrt_tmp[6:0],1'b1};
					remain_tmp <= remain_tmp - {sqrt_tmp[5:0],2'b01,2'h0};
				end
				else begin
					sqrt_tmp <= {sqrt_tmp[6:0],1'b0};
					remain_tmp <= remain_tmp;
				end
				state <= state + 1'b1;
			end
			8: begin 
				if(remain_tmp[15:0] >= {sqrt_tmp[6:0],2'b01}) begin 
					sqrt_tmp <= {sqrt_tmp[6:0],1'b1};
					remain_tmp <= remain_tmp - {sqrt_tmp[6:0],2'b01};
				end
				else begin
					sqrt_tmp <= {sqrt_tmp[6:0],1'b0};
					remain_tmp <= remain_tmp;
				end
				state <= state + 1;
			end
			9: state <= 'd0;
		endcase
	end
end


always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		valid <= 1'b0;
		sqrt_out <= 'd0;
		remain_out <= 'd0;
	end
	else if(state == 'd9) begin
		valid <= 1'b1;
		sqrt_out <= sqrt_tmp;
		remain_out <= remain_tmp;
	end
	else begin
		valid <= 1'b0;
		sqrt_out <= 'd0;
		remain_out <= 'd0;
	end
end

endmodule