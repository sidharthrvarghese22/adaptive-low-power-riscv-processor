module mac_unit(
    input clk,
    input enable,
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    output reg [31:0] result
);

always @(posedge clk) begin
    if(enable)
        result <= (a * b) + c;
end

endmodule