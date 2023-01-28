module testbench (//for mips.v
    
);
    
    reg clk, rst;

    mips test(
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        rst = 1;
        #20 rst = 0;
    end

    always #10 clk = ~clk;

endmodule
