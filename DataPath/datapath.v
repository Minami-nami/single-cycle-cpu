module datapath (
    input clk,//时钟
    input rst,//清零信号
    input Branch,
    input Jump,
    input R,
    input RegDst,
    input J,
    input JumpReg,
    input link,
    input byte,
    //input MemtoReg,//是否读入寄存器
    input ALUSrc,
    input RegWr,//寄存器是否写
    input MemWr,//数据存储器写
    input MemRd,//数据存储器读
    input Extop,//是否符号拓展
    input SigCtr,//读字节时是否符号拓展
    input useshamt,
    input [1:0] PCSrc,
    input [3:0] ALUctr,//ALU控制信号
    output [31:0] Instruction,
    output zero,
    output negative//
);
    wire [31:0] pc, next_pc, REG_READ_A, REG_READ_B, ALU_IN_A, ALU_IN_B, REG_WRITE, DATAMEM_READ, ALU_OUT;
    wire [31:0] extended_shamt, imm32;
    wire [15:0] imm16;
    wire [25:0] addr;
    wire [4:0] rs, rt, rd, shamt, REG_WRITE_ADDR;
    wire [5:0] func, op;
    wire overflow, carry;

    assign REG_WRITE = (link == 1)? (pc + 4): ((MemRd == 1)? DATAMEM_READ: ALU_OUT);       //写入寄存器
    assign REG_WRITE_ADDR = (link == 1)? 5'b11111: ((RegDst == 1)? rd: rt);
    assign ALU_IN_A = (useshamt == 0)? REG_READ_A: extended_shamt;
    assign ALU_IN_B = (ALUSrc == 0)? REG_READ_B: imm32;
    
    //Extend
    Extend # (.in_size(5)) shamt_ext (
        .ExtOp(1'b1),
        .imm_in(shamt),
        .imm_32(extended_shamt)
    );

    Extend imm16_ext (
        .ExtOp(Extop),
        .imm_in(imm16),
        .imm_32(imm32)
    );

    //Instruction Memory------------Read Instruction
    im_4k insmem (
        .IAddr(pc[11:2]),
        .IDataOut(Instruction)
    );

    //ALU
    ALU alu (
        .ALUctr(ALUctr),
        .lhs(ALU_IN_A),
        .rhs(ALU_IN_B),
        .Result(ALU_OUT),
        .carry(carry),
        .zero(zero),
        .negative(negative),
        .overflow(overflow)
    );

    //RegFile
    RegFile regfile (
        .clk(clk),
        .reset(rst),
        .RA(rs),
        .RB(rt),
        .RW(REG_WRITE_ADDR),
        .wEn(RegWr),
        .busW(REG_WRITE),
        .busA(REG_READ_A),
        .busB(REG_READ_B)
    );

    //Save or Load Word/Byte
    dm_4k datamem (
        .mRD(MemRd),
        .mWR(MemWr),
        .clk(clk),
        .Byte(byte),
        .SigCtr(SigCtr),
        .DAddr(ALU_OUT[11:0]), //alu计算结果作为地址
        .DataIn(REG_READ_B),
        .DataOut(DATAMEM_READ)
    );

    //Get PC
    PC ProgramCounter (
        .clk(clk),
        .reset(rst),
        .nextPC(next_pc),
        .curPC(pc)
    );

    //calc nextpc
    NPC npc (
        .clk(clk),
        .reset(rst),
        .nextPC(next_pc),
        .PCSrc(PCSrc),
        .immediate(imm32),
        .RegJump(REG_READ_A),
        .curPC(pc),
        .addr(addr)
    );


    //Cut Instruction
    InstructionCut get_ins (
        .instruction(Instruction),
        .op(op),
        .func(func),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .shamt(shamt),
        .immediate(imm16),
        .addr(addr)
    );

    

endmodule