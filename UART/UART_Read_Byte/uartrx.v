`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/06/02 08:59:22
// Design Name: 
// Module Name: uartrx
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


module uartrx(
    clk,
    clk_bd,
    rx,
    dataout,
    rdsig,
    dataerror,
    frameerror);
    
input  clk;
input  clk_bd;
input  rx;
output dataout;       //�����������
output rdsig;         //����������Чָʾ
output dataerror;     //У�����ָʾ
output frameerror;    //֡����ָʾ

reg  [7:0] dataout;
reg  rdsig,dataerror,frameerror;
reg  [7:0]cnt;
reg  rxbuf, rxfall, receive;
parameter  paritymode = 1'b0;
reg  presult,busy;

//�����·rx���½���, ����rxΪ�ߵ�ƽ
always @(posedge clk) 
begin
    rxbuf <= rx;
    rxfall <= rxbuf & (~rx);
end

//����receive�ź�
always @(posedge clk ) 
     if (rxfall && (~busy))
        receive <= 1'b1; 
     else if(cnt == 8'd168)
        receive <= 1'b0;      


always @(posedge clk )
    if(receive)
    begin
        if(clk_bd)
        begin   
            case (cnt)
            8'd0:   begin   busy <= 1'b1;        rdsig <= 1'b0;                    end
            8'd24:  begin   dataout[0] <= rx; presult <= paritymode^rx;            end
            8'd40:  begin   dataout[1] <= rx; presult <= presult^rx;               end
            8'd56:  begin   dataout[2] <= rx; presult <= presult^rx;               end
            8'd72:  begin   dataout[3] <= rx; presult <= presult^rx;               end
            8'd88:  begin   dataout[4] <= rx; presult <= presult^rx;               end
            8'd104: begin   dataout[5] <= rx; presult <= presult^rx;               end
            8'd120: begin   dataout[6] <= rx; presult <= presult^rx;               end
            8'd136: begin   dataout[7] <= rx; presult <= presult^rx;  rdsig <= 1'b1; end
            8'd152: if(presult == rx)  dataerror <= 1'b0;
            else
                dataerror <= 1'b1;
            8'd168: if(1'b1 == rx)       frameerror <= 1'b0;
        else
            frameerror <= 1'b1;      
            endcase
        cnt <= cnt + 1;
        end
    end
    else
    begin
        cnt <= 8'd0;
        busy <= 1'b0;
        rdsig <= 1'b0;
    end      
endmodule



