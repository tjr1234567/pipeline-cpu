`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:18 05/17/2024 
// Design Name: 
// Module Name:    EXE_MEM_register 
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
module EXE_MEM_register(exe_result,exe_rb,exe_wmem,exe_m2reg,exe_wreg,exe_rn,clk,clrn,
								mem_result,mem_rb,mem_wmem,mem_m2reg,mem_wreg,mem_rn
    );
	 input [31:0] exe_result,exe_rb;    // exe_result-alu计算结果,exe_rb-alu操作数b
	 input exe_m2reg,exe_wmem,exe_wreg; // exe_m2reg-选择信号alu计算结果或存储器内容,exe_wmem-写存储器信号,exe_wreg-写寄存器信号
	 input [4:0] exe_rn;                // exe_rn-写回寄存器号
	 
	 input clk,clrn;                    //clk-时钟信号；clrn-复位信号；
	 // MEM阶段对应信号
	 output [31:0] mem_result,mem_rb;
	 output [4:0] mem_rn;
	 output mem_m2reg,mem_wmem,mem_wreg;
	 
	 reg [31:0] mem_result,mem_rb;
	 reg [4:0] mem_rn;
	 reg mem_m2reg,mem_wmem,mem_wreg;
	 always@(posedge clk or negedge clrn)
		if(clrn == 0)                    // 置位信号为0，则将寄存器中的信号清零，否则将exe阶段的信号赋值给mem阶段相应字段
			begin
				mem_result<=0;
				mem_rb<=0;
				mem_wmem<=0;
				mem_m2reg<=0;
				mem_wreg<=0;
				mem_rn<=0;
			end
		else
			begin
				mem_result<=exe_result;
				mem_rb<=exe_rb;
				mem_wmem<=exe_wmem;
				mem_m2reg<=exe_m2reg;
				mem_wreg<=exe_wreg;
				mem_rn<=exe_rn;
			end


endmodule
