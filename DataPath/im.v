module im_4k(
    input [11:2] IAddr,         //地址
    //input [31:0] IDataIn,       //输入数据
    //input InsMemRW,             //状态为'0'，写指令寄存器，否则为读指令寄存器
    output reg[31:0] IDataOut   //输出数据
);

    reg [31:0] rom[1023:0];  //1MB

    initial begin
        $readmemh("instructions.txt", rom);
    end

    always@(IAddr) begin
        IDataOut = rom[IAddr];
    end

endmodule