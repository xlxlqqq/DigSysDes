`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/05/26 11:07:50
// Design Name: 
// Module Name: uart_tx1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx1( 
    input    clk,            //100Mhz 
    input    rst_n,          //��λ
    input    btn_S2,         //�м䰴ť
    input    [7:0]sw_pin,    //�����8λ����
    input    PC_Uart_rxd,    // ���ڽ��� 
    output   PC_Uart_txd
    );                       // ���ڷ���    

wire btn_rise_pulse;

btn_rise_edge  u1(           //����һ��ģ����ʱȥ����ⰴ�������أ�
        .clk(clk),
        .rst_n(rst_n),
        .btn(btn_S2),
        .btn_rise_pulse(btn_rise_pulse)
    );

wire clk_bd;
                     
clk_baudrate #(.clks(100000000),
               .baudrate(9600))
                u2(.clkin(clk),
                   .rst_n(rst_n),
                   .clkout(clk_bd));

wire busy;

uarttx u3(.clk(clk),
          .clk_bd(clk_bd),               //������16��ʱ��
          .datain(sw_pin),               //���뿪��ֵ��Ϊ���͵�����
          .wrsig(btn_rise_pulse),        //����������������Ϊ����д�ź�
          .busy(busy),                   //���õ��źſ��Կ���
          .tx(PC_Uart_txd));             //���ڷ��͹ܽţ���Լ���ļ�һ��   

endmodule



