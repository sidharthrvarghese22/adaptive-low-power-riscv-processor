module clock_gate(
    input clk,
    input enable,
    output gated_clk
);

assign gated_clk = clk & enable;

endmodule