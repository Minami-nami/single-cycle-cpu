module PC(
    input clk,                  //时钟
    input reset,                //是否重置地址。0-初始化PC，否则接受新地址
    input [31:0] nextPC,        //新指令地址
    output reg [31:0] curPC      //当前指令的地址
);

    initial begin
        curPC <= 0;
    end

    always@(posedge clk or posedge reset) begin//取下一个地址或清零
        if(reset) begin// reset == 0, PC = 0
            curPC <= 0;
        end
        else begin
            curPC <= nextPC;
        end
    end

endmodule