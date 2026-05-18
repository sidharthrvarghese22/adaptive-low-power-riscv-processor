module clock_gating(

    input clk,
    input enable,

    output gated_clk

);

assign gated_clk =
        clk & enable;

endmodule