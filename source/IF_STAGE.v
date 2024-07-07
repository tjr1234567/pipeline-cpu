`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:34:26 05/14/2019 
// Design Name: 
// Module Name:    IF_STAGE 
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
module IF_STAGE(clk,clrn,pcsource,bpc,jpc,pc4,inst, PC,stall
    );
	 input clk, clrn;
	 input [31:0] bpc,jpc;
	 input [1:0] pcsource;  //��һָ��ѡ���ź�
	 input stall;           //��ˮ����ͣ�ź�
	 
	 output [31:0] pc4,inst;
	 output [31:0] PC;
	 
	 wire [31:0] pc;		
	 wire [31:0] npc;		   //��һ��ָ���ַ
	 wire [31:0] inst_org;  //pc��Ӧ��ָ������
	 
 	 dff32 program_counter(npc,clk,clrn,pc,stall);     //����32λ��D������ʵ��PC
	 add32 pc_plus4(pc,32'h4,pc4);                     //32λ�ӷ�������������PC+4
	 mux32_4_1 next_pc(pc4,bpc,jpc,32'b0,pcsource,npc);//����pcsource�ź�ѡ����һ��ָ��ĵ�ַ
	 Inst_ROM inst_mem(pc[7:2],inst_org);              //ָ��洢��
	 
	 assign PC=pc;
	 assign inst = (pcsource ==2'b01 || pcsource ==2'b10) ? 32'h0 : inst_org;
	 //��PCsource��Ϊ0����ϵ���ǰָ�����ָ����������
	 
endmodule
