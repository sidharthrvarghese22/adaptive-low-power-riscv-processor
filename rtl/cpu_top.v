module cpu_top(

    input clk,
    input reset

);

//
// PROGRAM COUNTER
//
wire [31:0] pc_current;
wire [31:0] pc_next;

//
// INSTRUCTION FETCH
//
wire [31:0] instruction;

//
// IF/ID PIPELINE REGISTER
//
wire [31:0] if_id_pc;
wire [31:0] if_id_instruction;

//
// CONTROL SIGNALS
//
wire reg_write;
wire alu_src;

wire mem_read;
wire mem_write;

wire mem_to_reg;

wire branch;

wire [1:0] alu_op;

//
// REGISTER FILE
//
wire [31:0] read_data1;
wire [31:0] read_data2;

wire [31:0] writeback_data;

//
// IMMEDIATE GENERATOR
//
wire [31:0] imm_out;

//
// ID/EX PIPELINE REGISTER
//
wire [31:0] id_ex_read_data1;
wire [31:0] id_ex_read_data2;

wire [31:0] id_ex_imm;

//
// FORWARDING
//
wire [1:0] forward_a;
wire [1:0] forward_b;

wire [31:0] forwarded_a;
wire [31:0] forwarded_b;

//
// HAZARD
//
wire stall;

//
// ALU INPUT
//
wire [31:0] alu_input2;

//
// ALU CONTROL
//
wire [3:0] alu_sel;

//
// ALU
//
wire [31:0] alu_result;

wire zero;

//
// EX/MEM
//
wire [31:0] ex_mem_alu_result;

//
// MEMORY
//
wire [31:0] mem_data;

//
// MEM/WB
//
wire [31:0] mem_wb_mem_data;

//
// BRANCH LOGIC
//
wire branch_taken;

wire [31:0] branch_target;

wire flush;
//
// Gated clocks
//
wire mem_stage_clk;
wire pipeline_clk;
//
// PC UPDATE
//
assign branch_taken =
        branch & zero;

assign branch_target =
        if_id_pc + imm_out;

assign flush =
        branch_taken;

assign pc_next =
        branch_taken ?
        branch_target :
        (pc_current + 4);

//
// PROGRAM COUNTER
//
pc PC(

    .clk(clk),
    .reset(reset),

    .pc_next(pc_next),
    .pc_current(pc_current)

);

//
// INSTRUCTION MEMORY
//
instruction_memory IMEM(

    .address(pc_current),
    .instruction(instruction)

);

//
// IF/ID PIPELINE REGISTER
//
if_id IF_ID(

    .clk(clk),
    .reset(reset),

    .flush(flush),

    .pc_in(pc_current),
    .instruction_in(instruction),

    .pc_out(if_id_pc),
    .instruction_out(if_id_instruction)

);

//
// CONTROL UNIT
//
control_unit CONTROL(

    .opcode(if_id_instruction[6:0]),

    .reg_write(reg_write),
    .alu_src(alu_src),

    .mem_read(mem_read),
    .mem_write(mem_write),

    .mem_to_reg(mem_to_reg),

    .branch(branch),

    .alu_op(alu_op)

);

//
// REGISTER FILE
//
regfile REGFILE(

    .clk(clk),

    .reg_write(reg_write),

    .rs1(if_id_instruction[19:15]),
    .rs2(if_id_instruction[24:20]),

    .rd(if_id_instruction[11:7]),

    .write_data(writeback_data),

    .read_data1(read_data1),
    .read_data2(read_data2)

);

//
// IMMEDIATE GENERATOR
//
immediate_generator IMMGEN(

    .instruction(if_id_instruction),
    .imm_out(imm_out)

);

//
// ID/EX PIPELINE REGISTER
//
id_ex ID_EX(

    .clk(clk),
    .reset(reset),

    .read_data1_in(read_data1),
    .read_data2_in(read_data2),

    .imm_in(imm_out),

    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),

    .imm_out(id_ex_imm)

);

//
// FORWARDING UNIT
//
forwarding_unit FU(

    .rs1(if_id_instruction[19:15]),
    .rs2(if_id_instruction[24:20]),

    .ex_mem_rd(if_id_instruction[11:7]),
    .mem_wb_rd(if_id_instruction[11:7]),

    .ex_mem_regwrite(reg_write),
    .mem_wb_regwrite(reg_write),

    .forward_a(forward_a),
    .forward_b(forward_b)

);

//
// HAZARD DETECTION
//
hazard_detection HDU(

    .id_ex_memread(mem_read),

    .id_ex_rd(if_id_instruction[11:7]),

    .if_id_rs1(if_id_instruction[19:15]),
    .if_id_rs2(if_id_instruction[24:20]),

    .stall(stall)

);

//
// ALU INPUT MUX
//
mux ALUMUX(

    .a(id_ex_read_data2),
    .b(id_ex_imm),

    .sel(alu_src),

    .y(alu_input2)

);

//
// FORWARD MUX A
//
forward_mux FWD_A(

    .normal_data(id_ex_read_data1),

    .ex_mem_data(ex_mem_alu_result),

    .mem_wb_data(writeback_data),

    .forward_sel(forward_a),

    .out_data(forwarded_a)

);

//
// FORWARD MUX B
//
forward_mux FWD_B(

    .normal_data(alu_input2),

    .ex_mem_data(ex_mem_alu_result),

    .mem_wb_data(writeback_data),

    .forward_sel(forward_b),

    .out_data(forwarded_b)

);

//
// ALU CONTROL
//
alu_control ALUCTRL(

    .alu_op(alu_op),

    .funct7(if_id_instruction[31:25]),
    .funct3(if_id_instruction[14:12]),

    .alu_sel(alu_sel)

);

//
// ALU
//
alu ALU(

    .a(forwarded_a),
    .b(forwarded_b),

    .alu_sel(alu_sel),

    .result(alu_result),
    .zero(zero)

);

//
// EX/MEM PIPELINE REGISTER
//
ex_mem EX_MEM(

    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result),

    .alu_result_out(ex_mem_alu_result)

);

//
// MEMORY STAGE CLOCK GATING
//
clock_gating MEM_CLK_GATE(

    .clk(clk),

    .enable(mem_read | mem_write),

    .gated_clk(mem_stage_clk)

);

//
// PIPELINE CLOCK GATING
//
clock_gating PIPE_CLK_GATE(

    .clk(clk),

    .enable(~stall),

    .gated_clk(pipeline_clk)

);
//
// DATA MEMORY
//
data_memory DMEM(

    .clk(mem_stage_clk),
    .mem_write(mem_write),
    .mem_read(mem_read),

    .address(ex_mem_alu_result),

    .write_data(id_ex_read_data2),

    .read_data(mem_data)

);

//
// MEM/WB PIPELINE REGISTER
//
mem_wb MEM_WB(

    .clk(pipeline_clk),
    .reset(reset),

    .mem_data_in(mem_data),

    .mem_data_out(mem_wb_mem_data)

);

//
// WRITEBACK MUX
//
writeback_mux WBMUX(

    .alu_result(ex_mem_alu_result),
    .mem_data(mem_wb_mem_data),

    .mem_to_reg(mem_to_reg),

    .writeback_data(writeback_data)

);

endmodule