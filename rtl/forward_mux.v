module forward_mux(

    input [31:0] normal_data,
    input [31:0] ex_mem_data,
    input [31:0] mem_wb_data,

    input [1:0] forward_sel,

    output reg [31:0] out_data

);

always @(*) begin

    case(forward_sel)

        2'b00:
            out_data = normal_data;

        2'b10:
            out_data = ex_mem_data;

        2'b01:
            out_data = mem_wb_data;

        default:
            out_data = normal_data;

    endcase

end

endmodule