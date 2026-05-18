module ex_mem(

    input clk,
    input reset,

    input [31:0] alu_result_in,

    output reg [31:0] alu_result_out

);

always @(posedge clk or posedge reset) begin

    if(reset)
        alu_result_out <= 0;

    else
        alu_result_out <= alu_result_in;

end

endmodule