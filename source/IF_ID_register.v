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
	 input [31:0] if_pc4,if_inst;  // if�׶��ź���Ϊ���룺if_pc4-˳����һ��ָ���ַ��if_inst-��ǰָ������
	 input clk,clrn;               // clk-ʱ���źţ�clrn-��λ�ź�
	 input stall;
	 output [31:0] id_pc4,id_inst; // id�׶��ź���Ϊ�����id_pc4-˳����һ�׶�ָ���ַ��id_inst-��ǰָ������
	 
	 reg [31:0] id_pc4,id_inst;
	 always@(posedge clk or negedge clrn)
		if(clrn == 0)               // ��λ�ź�Ϊ0���򽫼Ĵ����е��ź����㣬����if�׶ε��źŸ�ֵ��id�׶���Ӧ�ֶ�
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
