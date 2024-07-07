`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:35 05/17/2024 
// Design Name: 
// Module Name:    MEM_WB_register 
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
module MEM_WB_register(mem_result,mem_mo,mem_m2reg,mem_wreg,mem_rn,clk,clrn,
								wb_result,wb_mo,wb_m2reg,wb_wreg,wb_rn
    );
	 input [31:0] mem_result,mem_mo;     // mem_result-alu������,mem_mo-�洢��ֵ
	 input [4:0] mem_rn;                 // mem_rn-д�ؼĴ�����
	 input mem_m2reg,mem_wreg;           // mem_m2reg-ѡ���ź�alu��������洢������,mem_wreg-д�Ĵ����ź�
	 
	 input clk,clrn;                     // clk-ʱ���źţ�clrn-��λ�źţ�
	 // wb�׶ζ�Ӧ�ź�
	 output [31:0] wb_result,wb_mo;
	 output [4:0] wb_rn;
	 output wb_m2reg,wb_wreg;
	 
	 reg [31:0] wb_result,wb_mo;
	 reg [4:0] wb_rn;
	 reg wb_m2reg,wb_wreg;
	 always@(posedge clk or negedge clrn)
		if(clrn == 0)                     // ��λ�ź�Ϊ0���򽫼Ĵ����е��ź����㣬����exe�׶ε��źŸ�ֵ��wb�׶���Ӧ�ֶ�
			begin                 
				wb_result<=0;
				wb_mo<=0;
				wb_m2reg<=0;
				wb_wreg<=0;
				wb_rn<=0;
			end
		else
			begin
				wb_result<=mem_result;
				wb_mo<=mem_mo;
				wb_m2reg<=mem_m2reg;
				wb_wreg<=mem_wreg;
				wb_rn<=mem_rn;
			end


endmodule
