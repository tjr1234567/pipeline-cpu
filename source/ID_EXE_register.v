`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:35:19 05/17/2024 
// Design Name: 
// Module Name:    ID_EXE_register 
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
module ID_EXE_register(id_m2reg,id_wmem,id_aluc,id_aluimm,id_ra,id_rb,id_imm,id_shift,id_wreg,id_rn,clk,clrn,
							exe_m2reg,exe_wmem,exe_aluc,exe_aluimm,exe_ra,exe_rb,exe_imm,exe_shift,exe_wreg,exe_rn
    );
	 input [31:0] id_ra,id_rb,id_imm;                    // id_ra-寄存器操作数a,id_rb-寄存器操作数b,id_imm-立即数操作数
	 input [4:0] id_rn;                                  // id_rn-写回寄存器号 
	 input [2:0] id_aluc;                                // id_aluc-ALU控制信号
	 input id_m2reg,id_wmem,id_aluimm,id_shift,id_wreg; 
	 // id_m2reg-选择信号alu计算结果或存储器内容,id_wmem-写存储器信号,id_aluimm-控制使用立即数信号,id_shift-移位指令信号,id_wreg-写寄存器信号
	 input clk,clrn;                                     // clk-时钟信号，clrn-置位信号
	 // exe阶段对应信号
	 output [31:0] exe_ra,exe_rb,exe_imm;
	 output [4:0] exe_rn;
	 output [2:0] exe_aluc;
	 output exe_m2reg,exe_wmem,exe_aluimm,exe_shift,exe_wreg;
	 
	 reg [31:0] exe_ra,exe_rb,exe_imm;
	 reg [4:0] exe_rn;
	 reg [2:0] exe_aluc;
	 reg exe_m2reg,exe_wmem,exe_aluimm,exe_shift,exe_wreg;
	 always@(posedge clk or negedge clrn)
		if(clrn == 0)                                     // 置位信号为0，则将寄存器中的信号清零，否则将id阶段的信号赋值给exe阶段相应字段
			begin
				exe_m2reg<=0; exe_wmem<=0;
				exe_aluc<=0;  exe_aluimm<=0;
				exe_ra<=0;    exe_rb<=0;
				exe_imm<=0;   exe_shift<=0;
				exe_wreg<=0;  exe_rn<=0;
			end
		else
			begin
				exe_m2reg<=id_m2reg; exe_wmem<=id_wmem;
				exe_aluc<=id_aluc;   exe_aluimm<=id_aluimm;
				exe_ra<=id_ra;       exe_rb<=id_rb;
				exe_imm<=id_imm;     exe_shift<=id_shift;
				exe_wreg<=id_wreg;   exe_rn<=id_rn;
			end

endmodule
