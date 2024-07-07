`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:59 05/14/2019 
// Design Name: 
// Module Name:    SCCPU 
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
module SCCPU(Clock, Resetn, PC, if_inst, id_inst, adep, bdep, id_ra, id_rb, z, pcsource, 
				exe_ra,exe_rb,exe_result, 
				mem_mo, mem_wmem,        
				wb_wdi,wb_m2reg,wb_wreg, 
				id_rn,wb_rn,stall
    );//检查if阶段的指令内容,
		//id阶段的指令内容和取操作数情况（adep,bdep,id_ra,id_rb）
		//exe阶段的操作数和alu计算结果
		//mem阶段的访存结果和存储器操作信号
		//wb阶段的输出数据wdi,控制信号wb_m2reg,输出地址wb_rn
	 input Clock, Resetn;
	 output [31:0] PC, if_inst, id_inst, exe_ra,exe_rb,exe_result,mem_mo;
	 output [31:0] id_ra,id_rb;
	 output [4:0] id_rn,wb_rn;
	 output [31:0] wb_wdi;
	 output mem_wmem,wb_m2reg,wb_wreg;
	 output stall;
	 output [1:0] adep,bdep;//adep,bdep-数据源选择信号
	 output z;              //z-id阶段输出的零信号
	 output [1:0] pcsource; //pcsource-下一条指令地址的选择信号
	 
	 wire [31:0] bpc, jpc, if_pc4, id_pc4; 
	 wire [31:0] id_ra, exe_ra, id_rb, exe_rb, mem_rb, id_imm, exe_imm,mem_result,wb_wdi,wb_result;
	 wire id_m2reg, exe_m2reg, mem_m2reg, wb_m2reg, id_wmem, exe_wmem, mem_wmem, id_aluimm, 
			exe_aluimm, id_shift,exe_shift, z, id_wreg, exe_wreg, mem_wreg, wb_wreg;
	 wire [2:0] id_aluc,exe_aluc;
	 wire [4:0] exe_rn,mem_rn;
	 wire [31:0] mem_mo,wb_mo;

	 IF_STAGE stage1 (Clock, Resetn, pcsource, bpc, jpc, if_pc4, if_inst, PC, stall);
	 //添加IF和ID流水段间的寄存器r1,传递pc4,inst信号
	 IF_ID_register r1 (if_pc4,if_inst,Clock, Resetn,id_pc4,id_inst, stall);
	 
	 ID_STAGE stage2 (id_pc4, id_inst, wb_wdi, Clock, Resetn, bpc, jpc, pcsource,
				   id_m2reg, id_wmem, id_aluc, id_aluimm, id_ra, id_rb, id_imm, id_shift, z, id_wreg, 
					id_rn, wb_wreg, wb_rn, 
					exe_result, mem_result, mem_mo,//数据源（输入）
					exe_wreg,exe_rn,exe_m2reg,     //数据冒险检测信号（输入）
					mem_wreg,mem_rn,mem_m2reg,
					stall,adep,bdep);	             //流水线停顿信号，数据源选择信号（输出）
	 //添加ID和EXE流水段间的寄存器r2,传递m2reg,wmem,aluc,aluimm,ra,rb,imm,shift,wreg,rn信号
	 ID_EXE_register r2 (id_m2reg,id_wmem,id_aluc,id_aluimm,id_ra,id_rb,id_imm,id_shift,id_wreg,id_rn,
					Clock, Resetn,
					exe_m2reg,exe_wmem,exe_aluc,exe_aluimm,exe_ra,exe_rb,exe_imm,exe_shift,exe_wreg,exe_rn);
	 //EXE阶段去除零信号的输出
	 EXE_STAGE stage3 (exe_aluc, exe_aluimm, exe_ra, exe_rb, exe_imm, exe_shift, exe_result);
	 //添加EXE和MEM流水段间的寄存器r3,传递result,rb,wmem,m2reg,wreg,rn信号
	 EXE_MEM_register r3 (exe_result,exe_rb,exe_wmem,exe_m2reg,exe_wreg,exe_rn,Clock, Resetn,
								mem_result,mem_rb,mem_wmem,mem_m2reg,mem_wreg,mem_rn);
	 
	 MEM_STAGE stage4 (mem_wmem, mem_result[4:0], mem_rb, Clock, mem_mo);
	 //添加MEM和WB流水段间的寄存器r4,传递result,mo,m2reg,wreg,rn信号
	 MEM_WB_register r4 (mem_result,mem_mo,mem_m2reg,mem_wreg,mem_rn,Clock, Resetn,
								wb_result,wb_mo,wb_m2reg,wb_wreg,wb_rn);
	 
	 WB_STAGE stage5 (wb_result, wb_mo, wb_m2reg, wb_wdi);


endmodule
