module writeback_mux(

    input [31:0] alu_result,
    input [31:0] mem_data,
    input mem_to_reg,

    output [31:0] writeback_data

);

assign writeback_data =
        mem_to_reg ? mem_data : alu_result;

endmodule