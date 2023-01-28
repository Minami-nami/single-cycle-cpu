module mips (
    input clk,
    input rst//
);
    wire Branch, Jump, R, RegDst, J, JumpReg, link, byte, ALUSrc, RegWr, MemWr, MemRd, Extop, SigCtr, useshamt;
    wire [3:0] ALUctr;
    wire [1:0] PCSrc;
    wire [31:0] instruction;
    wire zero, negative;
    
    datapath dp (
        .clk(clk),//时钟
        .rst(rst),//清零信号
        .Branch(Branch),
        .Jump(Jump),
        .R(R),
        .RegDst(RegDst),
        .J(J),
        .JumpReg(JumpReg),
        .link(link),
        .byte(byte),
        .ALUSrc(ALUSrc),
        .RegWr(RegWr),//寄存器是否写
        .MemWr(MemWr),//数据存储器写
        .MemRd(MemRd),//数据存储器读
        .Extop(Extop),//是否符号拓展
        .SigCtr(SigCtr),//读字节时是否符号拓展
        .useshamt(useshamt),
        .ALUctr(ALUctr),//ALU控制信号
        .Instruction(instruction),
        .zero(zero),
        .negative(negative),
        .PCSrc(PCSrc)
    );

    ControlUnit ctrl (
        .ins(instruction),
        .useshamt(useshamt),//是否移位
        .R(R),//R型
        .RegDst,//I型
        .J,//J型
        .Branch(Branch),//分支语句
        .Jump(Jump),//无条件跳转语句
        .RegWr(RegWr),//寄存器写
        .byte(byte),//存储器是否读/写字节
        .MemWr(MemWr),//存储器是否写
        .MemRd(MemRd),//存储器是否读
        .Extop(Extop),//符号拓展
        .link(link),//是否需链接
        .JumpReg(JumpReg),//是否寄存器跳转
        .ALUSrc(ALUSrc),
        .ALUctr(ALUctr),//alu控制
        .SigCtr(SigCtr),//读字节是否符号拓展
        .negative(negative),
        .zero(zero),
        .PCSrc(PCSrc)
    );

endmodule