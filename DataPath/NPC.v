module NPC(
    input clk,                  //时钟
    input reset,                //是否重置地址。0-初始化PC，否则接受新地址
    input [1:0] PCSrc,          //数据选择器输入
    input [31:0] RegJump,
    input [31:0] immediate,
    input [25:0] addr,
    output reg [31:0] nextPC,        //新指令地址
    input [31:0] curPC      //当前指令的地址
);

    initial begin
        nextPC <= 0;
    end

    parameter Seq = 2'b00;
    parameter Branch = 2'b01;
    parameter Jump = 2'b10;
    parameter JR = 2'b11;

    always@(*) begin//取下一个地址或清零
        if(reset) begin// reset == 0, PC = 0
            nextPC <= 0;
        end
        else begin
            case (PCSrc)
                Seq: nextPC <= {curPC[31:2] + 1, 2'b00};                         
                Branch: nextPC <= {curPC[31:2] + immediate[29:0], 2'b00};    
                Jump: nextPC <= {curPC[31:28], addr, 2'b00};                   //while use 延迟槽 {curPC[31:28], addr}
                JR: nextPC <= RegJump;                                  
                default: nextPC <= curPC;                                  
            endcase
        end
    end

endmodule