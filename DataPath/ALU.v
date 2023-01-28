module ALU (
    input [3:0] ALUctr,     //ALU操作控制端
    //input [3:0] OPctr,      //输出结果选择控制信号
    input [31:0] lhs,       //左操作数
    input [31:0] rhs,       //右操作数
    //input OVctr,            //是否需要溢出判断
    output [31:0] Result,   //运算结果
    output carry,           //进位
    output zero,            //是否为零
    output negative,        //是否为负数
    output overflow         //是否溢出 
);

    parameter Addu = 4'b0000;   //r = a + b unsigned                addu addiu
    parameter Add = 4'b0010;    //r = a + b signed                  add addi lw sw lb sb lbu
    parameter Subu = 4'b0001;   //r = a - b unsigned                subu
    parameter Sub = 4'b0011;    //r = a - b signed                  sub beq bne 

    parameter And = 4'b0100;    //r = a & b                         and andi
    parameter Or = 4'b0101;     //r = a | b                         or ori
    parameter Xor = 4'b0110;    //r = a ^ b                         xor xori
    parameter Nor = 4'b0111;    //r = ~(a | b)                      nor 

    parameter Slt = 4'b1000;    //r = (a - b < 0)? 1: 0 signed      slt slti
    parameter Sltu = 4'b1001;   //r = (a - b < 0)? 1: 0 unsigned    sltu sltiu
    
    parameter Sll = 4'b1010;    //r = b << a                        sll slv 
    parameter Srl = 4'b1011;    //r = b >>> a                       srl srlv 
    parameter Sra = 4'b1100;    //r = b >> a                        sra srav 

    parameter Lui = 4'b1110;    // r = {b[15:0], 16'b0}             lui
    parameter cmp = 4'b1111;    // r = a                            bgtz bgez bltz blez 

    reg signed [32:0] result;

    always@(ALUctr or lhs or rhs) begin
        case(ALUctr)
            Addu: begin
                result = lhs + rhs;
            end
            Subu: begin
                result = lhs - rhs;
            end
            Add: begin
                result = $signed(lhs) + $signed(rhs);
            end
            Sub: begin
                result = $signed(lhs) - $signed(rhs);
            end
            Sra: begin
                if(lhs == 0) {result[31:0], result[32]} = {rhs, 1'b0};
                else {result[31:0], result[32]} = $signed(rhs) >>> (lhs - 1);
            end
            Srl: begin
                if(lhs == 0) {result[31:0], result[32]} = {lhs, 1'b0};
                else {result[31:0], result[32]} = rhs >> (lhs - 1);
            end
            Sll: begin
                result = rhs << lhs;
            end
            And: begin
                result = lhs & rhs;
            end
            Or: begin
                result = lhs | rhs;
            end
            Xor: begin
                result = lhs ^ rhs;
            end
            Nor: begin
                result = ~(lhs | rhs);
            end
            Sltu: begin
                result = lhs < rhs? 1: 0;
            end
            Slt: begin
                result = $signed(lhs) < $signed(rhs)? 1: 0;
            end
            Lui: begin
                result = {rhs[15:0], 16'b0};
            end
            cmp: begin
                result = $signed(lhs);
            end
            default:
                result = 32'b0;
        endcase
    end
    
    assign Result = result[31:0];
    assign carry = result[32];
    assign zero = (result == 33'b0)? 1: 0;
    assign negative = result[31];
    assign overflow = (result[32] == result[31])? 0: 1;

endmodule