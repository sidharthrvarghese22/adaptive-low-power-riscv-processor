module instruction_memory(

    input [31:0] address,
    output [31:0] instruction

);

reg [31:0] memory [0:255];

initial begin

    //
    // LW x3,0(x0)
    //
    memory[0] = 32'b00000000000000000010000110000011;

    //
    // SW x3,4(x0)
    //
    memory[1] = 32'b00000000001100000010001000100011;

end

assign instruction = memory[address[9:2]];

endmodule