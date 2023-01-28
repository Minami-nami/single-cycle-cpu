module Extend # (
    parameter in_size = 16 
) (
    input ExtOp,
    input [in_size - 1:0] imm_in,
    output reg [31:0] imm_32
);
    wire signed [in_size - 1:0] signed_imm_in = imm_in;
    always @(ExtOp or imm_in) begin
        if (ExtOp) imm_32 = signed_imm_in;
        else imm_32 = imm_in;
    end

endmodule