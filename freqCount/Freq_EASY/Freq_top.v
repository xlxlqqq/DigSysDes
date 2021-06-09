`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/06/09 08:47:06
// Design Name: 
// Module Name: Freq_top
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

module Freq_top(
    input clk,
    input rst,
    input wire Signals,
    output [7:0]seg_data,
    output [7:0]seg_data2,
    output [7:0]seg_cs,
    output reg led
    );

reg [26:0] count;  //��Ƶ����Ҫ�ļĴ�����100MHZ��27λ��
reg flag;

always @(posedge clk or negedge rst)begin 
    if(!rst) begin
        led <= 1;
        end
    else if(count == 99999999)begin //1����100M��
        flag <= 0;
        count<=27'b0;
        led <= ~led;
        
        end
    else begin
        count<=count+27'b1;
        flag <= 1;
        end
end
reg [31:0] data;//�������ʾ
reg [19:0] Hz;  //������λƵ��

//Signals�ӵĹܽŲ����ǿ������ʱ�ӹܽţ�
//����ʱ�ӹܽŵ�clk��û�г����������¼����У����Ա���
reg getSignals;
always @(posedge clk) begin
    getSignals = Signals;
end

always @(posedge getSignals or negedge flag) 
begin
    if(!flag) begin
        Hz <= 0;
    end
    else begin
        Hz <= Hz+1;
    end
end

always @ (negedge flag)begin
    data[31:28] = Hz / 100000;
    data[27:24] = (Hz % 100000) / 10000;
    data[23:20] = (Hz % 10000) / 1000;
    data[19:16] = (Hz % 1000) / 100;
    data[15:12] = (Hz % 100) / 10;
    data[11:8]  = Hz % 10;
    data[7:4] <= 04'he;
    data[3:0] <= 2;
end
    

number 
    u1(  
        .clk(clk),
        .rst(rst),
        .data(data),
        .seg_data(seg_data),
        .seg_data2(seg_data2),
        .seg_cs(seg_cs)
    );
endmodule
