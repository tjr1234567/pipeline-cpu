`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:48 05/15/2019 
// Design Name: 
// Module Name:    ID_STAGE 
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
module ID_STAGE(pc4,inst,
              wdi,clk,clrn,bpc,jpc,pcsource,
				  m2reg,wmem,aluc,aluimm,a,b,imm,
				  shift,rsrtequ,
				  id_wreg, id_rn, wb_wreg, wb_rn,
				  exe_result,mem_result,mem_mo,  //exe�׶εĽ����mem�׶ε�ALU�����mem�׶εķô�����Forwarding��
				  exe_wreg,exe_rn,exe_m2reg,     //exe�׶ε�ָ��д�Ĵ����źţ�Ŀ�ļĴ�����ַ������ѡ���ź�(Forwarding)
				  mem_wreg,mem_rn,mem_m2reg,     //mem�׶ε�ָ��д�Ĵ����źţ�Ŀ�ļĴ�����ַ������ѡ���ź�(Forwarding)
				  stall,adep,bdep                //���stall�źţ���֪IF�׶Σ�adep��bdep��Ϊ����Դѡ���ź�
    );
	 input [31:0] pc4,inst,wdi;		//pc4-PCֵ���ڼ���jpc��inst-��ȡ��ָ�wdi-��Ĵ���д�������
	 input clk,clrn;		            //clk-ʱ���źţ�clrn-��λ�źţ�
	 input [4:0] wb_rn;
	 input wb_wreg;
	 input [31:0] exe_result,mem_result,mem_mo;   //exe�׶εĽ����mem�׶ε�ALU�����mem�׶εķô�����Ϊѡ������Դ
	 input [4:0] exe_rn,mem_rn;
	 input exe_wreg,exe_m2reg,mem_wreg,mem_m2reg; //����Ƿ�EXE�׶κ�MEM�׶ε�ָ���뵱ǰָ��������ݳ�ͻ
	 
	 output [31:0] bpc,jpc,a,b,imm;		//bpc-branch_pc��jpc-jump_pc��a-�Ĵ���������a��b-�Ĵ���������b��imm-������������
	 output [4:0] id_rn;
	 output [2:0] aluc;		            //ALU�����ź�
	 output [1:0] pcsource;		         //��һ��ָ���ַѡ��
	 output [1:0] adep,bdep;            //����Դѡ���ź�
	 output m2reg,wmem,aluimm,shift,id_wreg;		
	 output stall;                      //��ˮ����ͣ�ź�
	 output rsrtequ;		               //branch�����ź�
	 
	 wire wreg;
	 wire [4:0] rn;		               //д�ؼĴ�����
	 wire [5:0] op,func;
	 wire [4:0] rs,rt,rd;
	 wire [31:0] qa,qb,br_offset;
	 wire [15:0] ext16;
	 wire regrt,sext,e;
	 
	 assign adep = ((exe_rn != 5'b0) & exe_wreg & (exe_rn == rs) &  ~exe_m2reg) ? 2'b01 :               ((mem_rn != 5'b0) & mem_wreg & (mem_rn == rs) & ~mem_m2reg) ? 2'b10 :                   ((mem_rn != 5'b0) & mem_wreg & (mem_rn == rs) &  mem_m2reg) ? 2'b11 : 2'b00;  
					// 2'b01 ѡexe_result,2'b10 ѡmem_result,2'b11 ѡmem_mo(load),2b'00 ֱ��ѡregfile���
	 assign bdep = ((exe_rn != 5'b0) & exe_wreg & (exe_rn == rt) &  ~exe_m2reg) ? 2'b01 :               ((mem_rn != 5'b0) & mem_wreg & (mem_rn == rt) & ~mem_m2reg) ? 2'b10 :                   ((mem_rn != 5'b0) & mem_wreg & (mem_rn == rt) &  mem_m2reg) ? 2'b11 : 2'b00;   
					// 2'b01 ѡexe_result,2'b10 ѡmem_result,2'b11 ѡmem_mo(load),2b'00 ֱ��ѡregfile���
	 
	 assign stall = (exe_rn !=0)&((rs == exe_rn) | (rt == exe_rn)&~regrt) & (exe_wreg&exe_m2reg);
					//��EXE��ָ���뵱ǰָ����ڳ�ͻ������loadָ������Ҫ��ͣ��ˮ��
	 mux32_4_1 fwa_mux(qa,exe_result,mem_result,mem_mo,adep,a);
	 mux32_4_1 fwb_mux(qb,exe_result,mem_result,mem_mo,bdep,b);	 assign id_wreg = ~stall & wreg;                           //����ˮ����ͣ��ǰָ������
	 assign wmem = ~stall & wmem_org;
	 
	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	 
	 Control_Unit cu(rsrtequ,func,                         //���Ʋ���
	             op,wreg,m2reg,wmem_org,aluc,regrt,aluimm,
					 sext,shift);
			 
    Regfile rf (rs,rt,wdi,wb_rn,wb_wreg,clk,clrn,qa,qb);  //�Ĵ����ѣ���32��32λ�ļĴ�����0�żĴ�����Ϊ0
	 assign rsrtequ = ~|( a ^ b );
							 //�ж����������Ƿ����
	 assign pcsource = (inst[31:26] == 6'b001111 && rsrtequ) || (inst[31:26] == 6'b010000 && ~rsrtequ) ? 2'b01: 
							 (inst[31:26] == 6'b010010) ? 2'b10 : 2'b00;
							 //branchָ����������������pcsourceΪ01��jumpָ����pcsourceΪ10��˳��ִ����pcsourceΪ00
							 
	 mux5_2_1 des_reg_num (rd,rt,regrt,rn);         //ѡ��Ŀ�ļĴ�����������rd,����rt
	 assign e=sext&inst[25];                        //������չ��0��չ
	 assign ext16={16{e}};                          //������չ
	 assign imm={ext16,inst[25:10]};		            //�����������з�����չ

	 assign br_offset={imm[29:0],2'b00};            //����ƫ�Ƶ�ַ
	 add32 br_addr (pc4,br_offset,bpc);	            //beq,bneָ���Ŀ���ַ�ļ���
	 assign jpc={pc4[31:28],inst[25:0],2'b00};		//jumpָ���Ŀ���ַ�ļ���
	 assign id_rn = rn;
	 
endmodule
