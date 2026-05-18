module alu_control(

    input [1:0] alu_op,

    input [6:0] funct7,
    input [2:0] funct3,

    output reg [3:0] alu_sel

);

always @(*) begin

    case(alu_op)

        //
        // LOAD / STORE
        //
        2'b00:
            alu_sel = 4'b0000;

        //
        // BRANCH
        //
        2'b01:
            alu_sel = 4'b0001;

        //
        // R-TYPE
        //
        2'b10: begin

            case({funct7, funct3})

                //
                // ADD
                //
                10'b0000000000:
                    alu_sel = 4'b0000;

                //
                // SUB
                //
                10'b0100000000:
                    alu_sel = 4'b0001;

                //
                // AND
                //
                10'b0000000111:
                    alu_sel = 4'b0010;

                //
                // OR
                //
                10'b0000000110:
                    alu_sel = 4'b0011;

                default:
                    alu_sel = 4'b0000;

            endcase

        end

        default:
            alu_sel = 4'b0000;

    endcase

end

endmodule