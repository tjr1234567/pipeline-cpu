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
    );//���if�׶ε�ָ������,
		//id�׶ε�ָ�����ݺ�ȡ�����������adep,bdep,id_ra,id_rb��
		//exe�׶εĲ�������alu������
		//mem�׶εķô����ʹ洢�������ź�
		//wb�׶ε��������wdi,�����ź�wb_m2reg,�����ַwb_rn
	 input Clock, Resetn;
	 output [31:0] PC, if_inst, id_inst, exe_ra,exe_rb,exe_result,mem_mo;
	 output [31:0] id_ra,id_rb;
	 output [4:0] id_rn,wb_rn;
	 output [31:0] wb_wdi;
	 output mem_wmem,wb_m2reg,wb_wreg;
	 output stall;
	 output [1:0] adep,bdep;//adep,bdep-����Դѡ���ź�
	 output z;              //z-id�׶���������ź�
	 output [1:0] pcsource; //pcsource-��һ��ָ���ַ��ѡ���ź�
	 
	 wire [31:0] bpc, jpc, if_pc4, id_pc4; 
	 wire [31:0] id_ra, exe_ra, id_rb, exe_rb, mem_rb, id_imm, exe_imm,mem_result,wb_wdi,wb_result;
	 wire id_m2reg, exe_m2reg, mem_m2reg, wb_m2reg, id_wmem, exe_wmem, mem_wmem, id_aluimm, 
			exe_aluimm, id_shift,exe_shift, z, id_wreg, exe_wreg, mem_wreg, wb_wreg;
	 wire [2:0] id_aluc,exe_aluc;
	 wire [4:0] exe_rn,mem_rn;
	 wire [31:0] mem_mo,wb_mo;

	 IF_STAGE stage1 (Clock, Resetn, pcsource, bpc, jpc, if_pc4, if_inst, PC, stall);
	 //���IF��ID��ˮ�μ�ļĴ���r1,����pc4,inst�ź�
	 IF_ID_register r1 (if_pc4,if_inst,Clock, Resetn,id_pc4,id_inst, stall);
	 
	 ID_STAGE stage2 (id_pc4, id_inst, wb_wdi, Clock, Resetn, bpc, jpc, pcsource,
				   id_m2reg, id_wmem, id_aluc, id_aluimm, id_ra, id_rb, id_imm, id_shift, z, id_wreg, 
					id_rn, wb_wreg, wb_rn, 
					exe_result, mem_result, mem_mo,//����Դ�����룩
					exe_wreg,exe_rn,exe_m2reg,     //����ð�ռ���źţ����룩
					mem_wreg,mem_rn,mem_m2reg,
					stall,adep,bdep);	             //��ˮ��ͣ���źţ�����Դѡ���źţ������
	 //���ID��EXE��ˮ�μ�ļĴ���r2,����m2reg,wmem,aluc,aluimm,ra,rb,imm,shift,wreg,rn�ź�
	 ID_EXE_register r2 (id_m2reg,id_wmem,id_aluc,id_aluimm,id_ra,id_rb,id_imm,id_shift,id_wreg,id_rn,
					Clock, Resetn,
					exe_m2reg,exe_wmem,exe_aluc,exe_aluimm,exe_ra,exe_rb,exe_imm,exe_shift,exe_wreg,exe_rn);
	 //EXE�׶�ȥ�����źŵ����
	 EXE_STAGE stage3 (exe_aluc, exe_aluimm, exe_ra, exe_rb, exe_imm, exe_shift, exe_result);
	 //���EXE��MEM��ˮ�μ�ļĴ���r3,����result,rb,wmem,m2reg,wreg,rn�ź�
	 EXE_MEM_register r3 (exe_result,exe_rb,exe_wmem,exe_m2reg,exe_wreg,exe_rn,Clock, Resetn,
								mem_result,mem_rb,mem_wmem,mem_m2reg,mem_wreg,mem_rn);
	 
	 MEM_STAGE stage4 (mem_wmem, mem_result[4:0], mem_rb, Clock, mem_mo);
	 //���MEM��WB��ˮ�μ�ļĴ���r4,����result,mo,m2reg,wreg,rn�ź�
	 MEM_WB_register r4 (mem_result,mem_mo,mem_m2reg,mem_wreg,mem_rn,Clock, Resetn,
								wb_result,wb_mo,wb_m2reg,wb_wreg,wb_rn);
	 
	 WB_STAGE stage5 (wb_result, wb_mo, wb_m2reg, wb_wdi);


endmodule
