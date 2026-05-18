`timescale 1ns/1ps

module cpu_tb;

reg clk;
reg reset;

//
// Instantiate CPU
//
cpu_top uut(
    .clk(clk),
    .reset(reset)
);

//
// Clock generation
//
always #5 clk = ~clk;

initial begin

    //
    // Create waveform file
    //
    $dumpfile("wave.vcd");

    //
    // Dump ALL signals
    //
    $dumpvars(0, cpu_tb);

    //
    // Dump CPU internals
    //
    $dumpvars(0, uut);

    //
    // Program counter
    //
    $dumpvars(0, uut.pc_current);
    $dumpvars(0, uut.pc_next);

    //
    // Instruction fetch
    //
    $dumpvars(0, uut.instruction);

    //
    // Control signals
    //
    $dumpvars(0, uut.reg_write);
    $dumpvars(0, uut.alu_src);
    $dumpvars(0, uut.mem_read);
    $dumpvars(0, uut.mem_write);
    $dumpvars(0, uut.mem_to_reg);
    $dumpvars(0, uut.branch);

    //
    // ALU control
    //
    $dumpvars(0, uut.alu_op);
    $dumpvars(0, uut.alu_sel);

    //
    // Register file
    //
    $dumpvars(0, uut.read_data1);
    $dumpvars(0, uut.read_data2);

    //
    // Immediate generator
    //
    $dumpvars(0, uut.imm_out);

    //
    // ALU
    //
    $dumpvars(0, uut.alu_input2);
    $dumpvars(0, uut.alu_result);
    $dumpvars(0, uut.zero);

    //
    // Data memory
    //
    $dumpvars(0, uut.mem_data);

    //
    // Writeback stage
    //
    $dumpvars(0, uut.writeback_data);

    //
    // Initial conditions
    //
    clk = 0;
    reset = 1;

    //
    // Hold reset
    //
    #20;

    reset = 0;

    //
    // Run simulation
    //
    #300;

    //
    // Finish simulation
    //
    $finish;

end

endmodule