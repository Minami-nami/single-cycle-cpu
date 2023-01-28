module dm_4k(
        /*
            Daddr，数据存储器地址输入端口
            DataIn，数据存储器数据输入端口
            DataOut，数据存储器数据输出端口
            mRD，数据存储器读控制信号，为0读
            mWR，数据存储器写控制信号，为0写
        */
        input mRD,
        input mWR,
        input clk,
        input Byte,
        input SigCtr,
        input [11:0] DAddr,
        input [31:0] DataIn,
        output reg[31:0] DataOut
    );


    reg [31:0] ram [1023:0];   //1MB

    always@(mRD or DAddr or SigCtr or Byte) begin        //读
        if (mRD) begin
            if(Byte) begin
                if(DAddr[1:0]==2'b00)
                    DataOut = (SigCtr == 1)? ((ram[DAddr[11:2]][7] == 1)? {24'hffffff, ram[DAddr[11:2]][7:0]}: {24'b0, ram[DAddr[11:2]][7:0]}): {24'b0, ram[DAddr[11:2]][7:0]};
                else if(DAddr[1:0]==2'b01)
                    DataOut = (SigCtr == 1)? ((ram[DAddr[11:2]][15] == 1)? {24'hffffff, ram[DAddr[11:2]][15:8]}: {24'b0, ram[DAddr[11:2]][15:8]}): {24'b0, ram[DAddr[11:2]][15:8]};
                else if(DAddr[1:0]==2'b10)
                    DataOut = (SigCtr == 1)? ((ram[DAddr[11:2]][23] == 1)? {24'hffffff, ram[DAddr[11:2]][23:16]}: {24'b0, ram[DAddr[11:2]][23:16]}): {24'b0, ram[DAddr[11:2]][23:16]};
                else if(DAddr[1:0]==2'b11)
                    DataOut = (SigCtr == 1)? ((ram[DAddr[11:2]][31] == 1)? {24'hffffff, ram[DAddr[11:2]][31:24]}: {24'b0, ram[DAddr[11:2]][31:24]}): {24'b0, ram[DAddr[11:2]][31:24]};
            end
            else begin
                DataOut = ram[DAddr[11:2]];
            end  
        end
    end

    always@(posedge clk)        //写
    begin   
        if (mWR) begin
            if(Byte) begin
                if(DAddr[1:0]==2'b00)
                    ram[DAddr[11:2]][7:0] <= DataIn[7:0];
                else if(DAddr[1:0]==2'b01)
                    ram[DAddr[11:2]][15:8] <= DataIn[7:0];
                else if(DAddr[1:0]==2'b10)
                    ram[DAddr[11:2]][23:16] <= DataIn[7:0];
                else if(DAddr[1:0]==2'b11)
                    ram[DAddr[11:2]][31:24] <= DataIn[7:0];
            end
            else begin
                ram[DAddr[11:2]] <= DataIn;
            end  
        end
    end

endmodule