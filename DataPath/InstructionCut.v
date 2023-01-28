module InstructionCut(
    input [31:0] instruction,
    output reg [5:0] op,
    output reg [5:0] func,
    output reg [4:0] rs,
    output reg [4:0] rt,
    output reg [4:0] rd,
    output reg [4:0] shamt,
    output reg [15:0] immediate,
    output reg [25:0] addr
);

    initial begin
        op = 6'b00000;
        rs = 5'b00000;
        rt = 5'b00000;
        rd = 5'b00000;
    end

    always@(instruction) begin
        op = instruction[31:26];
        rs = instruction[25:21];
        rt = instruction[20:16];
        rd = instruction[15:11];
        shamt = instruction[10:6];
        func = instruction[5:0];
        immediate = instruction[15:0];
        addr = instruction[25:0];
    end
endmodule