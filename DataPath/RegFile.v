module RegFile (
    input clk,              //激励信号
    input reset,
    input [4:0] RA,         //读取寄存器位置1
    input [4:0] RB,         //读取寄存器位置2
    input [4:0] RW,         //写入寄存器位置
    input wEn,              //使能-是否写入
    input [31:0] busW,      //输入
    output [31:0] busA,     //输出A
    output [31:0] busB      //输出B
);
    
    reg [31:0] R[31:0];
    integer i;

    assign busA = R[RA];
    assign busB = R[RB];

    initial begin
        for (i = 0; i < 32; i = i + 1) 
            R[i] <= 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) 
                R[i] <= 0;
        end
        else if (wEn && RW) begin
            R[RW] <= busW;
        end
    end

endmodule