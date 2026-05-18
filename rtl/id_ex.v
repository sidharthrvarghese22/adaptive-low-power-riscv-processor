module id_ex(

    input clk,
    input reset,

    input [31:0] read_data1_in,
    input [31:0] read_data2_in,

    input [31:0] imm_in,

    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,

    output reg [31:0] imm_out

);

always @(posedge clk or posedge reset) begin

    if(reset) begin

        read_data1_out <= 0;
        read_data2_out <= 0;

        imm_out <= 0;

    end

    else begin

        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;

        imm_out <= imm_in;

    end

end

endmodule