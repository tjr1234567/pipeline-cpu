`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:36 05/17/2024 
// Design Name: 
// Module Name:    IF_ID_register 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IF_ID_register(if_pc4,if_inst,clk,clrn,id_pc4,id_inst,stall
    );
	 input [31:0] if_pc4,if_inst;  // if阶段信号作为输入：if_pc4-顺序下一条指令地址，if_inst-当前指令内容
	 input clk,clrn;               // clk-时钟信号，clrn-置位信号
	 input stall;
	 output [31:0] id_pc4,id_inst; // id阶段信号作为输出：id_pc4-顺序下一阶段指令地址，id_inst-当前指令内容
	 
	 reg [31:0] id_pc4,id_inst;
	 always@(posedge clk or negedge clrn)
		if(clrn == 0)               // 置位信号为0，则将寄存器中的信号清零，否则将if阶段的信号赋值给id阶段相应字段
			begin
				id_pc4<=0;
				id_inst<=0;
			end
		else
			begin
				if(stall == 0)
					begin
						id_pc4<=if_pc4;
						id_inst<=if_inst;
					end
			end

endmodule
