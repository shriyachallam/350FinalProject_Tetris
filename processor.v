/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    
    // Declare primary wires for handling the Program Counter (PC) and instructions
    wire [31:0] PC_increment, decode_instruction, PC_out_FD, new_PC_output, temporary_PC_value;
    wire cout; // Carry out from the increment operation
    wire pipeline_flush, branch_PC_overflow, overflow_next_pc; // Flags for pipeline control and overflow detection
    wire [31:0] branch_PC, next_pc_value; // Computed branch address and next PC value

    // Increment the PC by 1 to point to the next instruction
    add increment(.s(PC_increment), .cout(cout), .a(address_imem), .b(32'b1), .c0(1'b0)); 

    // Determine if the pipeline should be flushed based on branch or jump conditions
    assign pipeline_flush = (is_execute_blt && comparison_less_than && comparison_not_equal) || (is_execute_bne && comparison_not_equal);

    // Calculate the target PC for branch instructions
    add PC_branch_adder(.s(branch_PC), .cout(branch_PC_overflow), .a(sign_extended_intermediate), .b(PC_out_DX), .c0(1'b1)); 

    // Select the new PC output, choosing between the branch target and the next sequential instruction
    assign new_PC_output = (pipeline_flush & !(address_imem == 32'b0 || address_imem == 32'b1)) ? branch_PC : PC_increment; 

    // Update the PC register based on jump conditions or the selected new PC output
    register_32 PC(.in(check_jump ? final_address : new_PC_output), .out(address_imem), .clock(~clock), .reset(reset), .enable(!pipeline_stall & !operation_in_progress & !detect_hazard)); 

    // Calculate the jump address based on the instruction type or register data (for jr instruction)
    wire [31:0] target_jump_address = flag_decode_jump_reg ? data_readRegB : q_imem[26:0]; 

    // Determine the data for BEX instruction, selecting between different stages or register data
    wire [31:0] bex_data = is_execute_setx ? execute_instruction[26:0] : (is_memory_setx ? execute_mem_inst[26:0] : (is_write_setx ? memory_write_inst[26:0] : data_readRegB)); 

    // Finalize the address for jumps, taking into account BEX conditions
    wire [31:0] final_address = (flag_decode_branch_exclusive && !(bex_data == 32'b0)) ? decode_instruction[26:0] : target_jump_address; 

    // Check for any jump conditions based on instruction decoding or special flags
    wire check_jump;

    // Detect any potential hazards that may necessitate stalling or flushing
    wire detect_hazard = is_fetch_jr && ((q_imem[26:22] == decode_instruction[26:22] || flag_decode_jump_and_link) || (q_imem[26:22] == execute_instruction[26:22] || flag_execute_jump_and_link) || (q_imem[26:22] == execute_mem_inst[26:22] || is_memory_jal));

    // Handle JAL instruction by replacing it with the new PC output when necessary
    wire [31:0] check_fetch_jal, FD_in, new_FD_in, flag_fetch_jump_reg;    

    // Determine if a jump is required and prepare JAL instruction replacement if needed
    assign check_jump = (is_fetch_jump | is_fetch_jal | flag_decode_jump_reg | (flag_decode_branch_exclusive && !(bex_data == 32'b0)));
    assign flag_fetch_jump_reg[31:27] = 5'b00011; 
    assign flag_fetch_jump_reg[26:0] = new_PC_output;

    // Temporary PC value used for hazard detection, reset to IMEM address if no hazard detected
    assign temporary_PC_value = detect_hazard ? 32'b0 : address_imem;

    // Check and prepare JAL instruction based on fetch conditions
    assign check_fetch_jal = is_fetch_jal ? flag_fetch_jump_reg : q_imem;

    // Update FD stage inputs based on hazard detection and jump checks
    assign FD_in = detect_hazard ? 32'b0 : check_fetch_jal;
    assign new_FD_in = (flag_decode_jump_reg | pipeline_flush | (flag_decode_branch_exclusive && !(bex_data == 32'b0))) ? 32'b0 : FD_in; // Insert NOP if necessary

    // Register block to update FD stage with the computed temporary PC and instruction data
    register_32_2 FD(.in_1(temporary_PC_value), .in_2(new_FD_in), .out_1(PC_out_FD), .out_2(decode_instruction), .clock(~clock), .enable(!operation_in_progress & !pipeline_stall), .reset(reset)); 
    
    // Define registers and flags used in instruction decoding and execution
    wire [4:0] source_register, target_register, destination_register;
    wire using_rd;
    wire [31:0] execute_instruction, reg_A, reg_B, PC_out_DX;
    wire flag_decode_jump_reg, flag_decode_jump_and_link, flag_decode_branch_exclusive, flag_execute_jump_and_link, is_execute_setx;

    // Extract register addresses from the decoded instruction
    assign destination_register = decode_instruction[26:22];
    assign source_register = decode_instruction[21:17];
    assign target_register = decode_instruction[16:12];
    // Assign the source register to be read from register A
    assign ctrl_readRegA = source_register;

    // Determine if the destination register is used based on the opcode
    assign using_rd = (decode_instruction[31:27] == 5'b00111) || (decode_instruction[31:27] == 5'b00100) || (decode_instruction[31:27] == 5'b00110) || (decode_instruction[31:27] == 5'b00010);
    // Choose the correct register to be read as register B, with special handling for branch exclusive instructions
    assign ctrl_readRegB = flag_decode_branch_exclusive ? 5'b11110 : (is_decode_r_type ? target_register : destination_register); 

    // Update decode stage registers, handling pipeline flush and stall conditions
    register_32_4 DX(.in_1(!pipeline_flush ? (pipeline_stall ? 32'b0 : PC_out_FD) : 32'b0), .in_2(!pipeline_flush ? (pipeline_stall ? 32'b0 : decode_instruction) : 32'b0), .in_3(!pipeline_flush ? (pipeline_stall ? 32'b0 : data_readRegA) : 32'b0), .in_4(!pipeline_flush ? (pipeline_stall ? 32'b0 : data_readRegB) : 32'b0), .out_1(PC_out_DX), .out_2(execute_instruction), .out_3(reg_A), .out_4(reg_B), .clock(~clock), .enable(!operation_in_progress || operation_complete), .reset(reset));

    // Define ALU operation wires and flags for arithmetic and logic operations
    wire [31:0] execute_mem_inst, ALU_out_XM, execute_b_data, sign_extended_intermediate, ALU_B_in, alu_res, overflow;
    wire [16:0] intermediate;
    wire [4:0] shamt, alu_operation, operation_code, alu_operation_test, decision_operation, new_alu_operation; 
    wire extended_sign, comparison_not_equal, comparison_less_than;
            
    // Select the ALU operation based on the instruction's function field
    wire [4:0] alu_operation_selected = execute_instruction[6:2];

    // Determine if sign extension is needed based on the instruction's opcode
    assign extended_sign = (execute_instruction[31:27] == 5'b00111) || (execute_instruction[31:27] == 5'b01000) || (execute_instruction[31:27] == 5'b00101);
    // Extend the immediate value for operations that require it
    bit32_sign_extender extend_immed(sign_extended_intermediate, intermediate);
    // Choose the correct ALU operand B, using the extended immediate value if needed
    assign ALU_B_in = extended_sign ? sign_extended_intermediate : reg_B;

    // Extract the immediate value from the instruction
    assign intermediate = execute_instruction[16:0]; 
    // Reaffirm the chosen ALU operation for testing or debugging
    assign alu_operation_test = execute_instruction[6:2]; 

    // Check if the instruction is of R-type based on the opcode field
    wire r_type_instruction = ~execute_instruction[31] & ~execute_instruction[30] & ~execute_instruction[29] & ~execute_instruction[28] & ~execute_instruction[27];
    // Select the default ALU operation (e.g., add) if the instruction is not R-type
    assign new_alu_operation = ~r_type_instruction ? 5'b00000 : alu_operation_selected;

    // Determine the final ALU operation code, considering branch-less-than and branch-not-equal special cases
    wire [4:0] ALU_opcode = (is_execute_blt || is_execute_bne) ? 5'b00001 : (is_execute_r_type ? execute_instruction[6:2] : 5'b00000);
    // Finalize ALU operand B for execution
    wire [31:0] final_ALU_operand_B;
    assign final_ALU_operand_B = extended_sign ? sign_extended_intermediate : ALU_operand_B;

    // Perform the ALU operation with operands A and B, setting flags for comparison results and overflow detection
    alu alu_main(.data_operandA(AL_operand_A), .data_operandB(final_ALU_operand_B), .ctrl_ALUopcode(ALU_opcode), .ctrl_shiftamt(execute_instruction[11:7]), .data_result(alu_res), .isNotEqual(comparison_not_equal), .isLessThan(comparison_less_than), .overflow(overflow)); 

    wire [31:0] ALU_operand_A, ALU_operand_B;
    wire [1:0] ALU_operand_A_CTRL, ALU_operand_B_CTRL;
    assign ALU_operand_A_CTRL[0] = (MW_with_rd && DX_with_rs && (memory_write_inst[26:22] == execute_instruction[21:17]) && (|memory_write_inst[26:22])) || (is_write_jal && (execute_instruction[21:17] == 5'b11111));
    assign ALU_operand_A_CTRL[1] = (XM_with_rd && DX_with_rs && (execute_mem_inst[26:22] == execute_instruction[21:17]) && (|execute_mem_inst[26:22])) || (is_memory_jal && (execute_instruction[21:17] == 5'b11111));
    mux_4 ALU_operand_A_mux(ALU_operand_A, ALU_operand_A_CTRL, reg_A, data_writeReg, ALU_out_XM, ALU_out_XM); 

    wire[4:0] operand_B_reg = (is_execute_lw || is_execute_sw || is_execute_bne || is_execute_blt) ? execute_instruction[26:22] : execute_instruction[16:12];
    assign ALU_operand_B_CTRL[1] = (XM_with_rd && (is_execute_r_type || is_execute_lw || is_execute_sw || is_execute_blt || is_execute_bne) && (execute_mem_inst[26:22] == operand_B_reg) && (|execute_mem_inst[26:22])) || (is_memory_jal && (operand_B_reg == 5'b11111));
    assign ALU_operand_B_CTRL[0] = (MW_with_rd && (is_execute_r_type || is_execute_lw || is_execute_sw || is_execute_blt || is_execute_bne) && (memory_write_inst[26:22] == operand_B_reg) && (|memory_write_inst[26:22])) || (is_write_jal && (operand_B_reg == 5'b11111));
    mux_4 ALU_operand_B_mux(ALU_operand_B, ALU_operand_B_CTRL, reg_B, data_writeReg, ALU_out_XM, ALU_out_XM);

    wire [31:0] R_exception, XM_aluout_in;
    wire exception_ex, exception;

    mux_8 r_excep(R_exception, execute_instruction[4:2], 32'd5, 32'd4, 32'b0, 32'b0, 32'b0, 32'b0, 32'd3, 32'd1);
    assign exception_ex = (execute_instruction[31:27] == 5'b00101) ? 32'd2 : R_exception;
    assign exception = overflow | (operation_overflow & operation_in_progress);
    assign XM_aluout_in = exception ? exception_ex : alu_res; 

    wire operation_in_progress, operation_complete;

    wire [31:0] operation_result;
    wire operation_overflow;
    wire ctrl_MULT = (ALU_opcode == 5'b00110) && !operation_in_progress && (execute_instruction[31:27] == 5'b00000);
    wire ctrl_DIV = (ALU_opcode == 5'b00111) && !operation_in_progress && (execute_instruction[31:27] == 5'b00000);
    dffe_ref operation_status_latch(.q(operation_in_progress), .d(ctrl_MULT | ctrl_DIV), .clk(clock), .en(ctrl_MULT | ctrl_DIV | operation_complete), .clr(reset));
    multdiv multdiv_stage(.data_operandA(ALU_operand_A), .data_operandB(ALU_operand_B), .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV), .clock(clock), .data_result(operation_result), .data_exception(operation_overflow), .data_resultRDY(operation_complete));
   
    wire [31:0] output_stage_execute = (operation_complete && operation_in_progress) ? operation_result : execute_memory_output; 

    wire [31:0] execute_memory_output, execute_memory_instruction;
    add increment_PC_adder(.s(next_pc_value), .cout(overflow_next_pc), .a(PC_out_DX), .b(32'b0), .c0(1'b1));
    assign execute_memory_output = exception ? XM_aluout_in : (is_execute_setx ? {5'b0, execute_instruction[26:0]} : (flag_execute_jump_and_link ? next_pc_value : alu_res));
    assign execute_memory_instruction = (is_execute_setx | exception) ? 32'b00000111100000000000000000000000 : (flag_execute_jump_and_link ? 32'b00000111110000000000000000000000: execute_instruction);

    register_32_3 XM(.in_1(execute_memory_instruction), .in_2(ALU_operand_B), .in_3(exception ? 32'b1 : output_stage_execute), .out_1(execute_mem_inst), .out_2(execute_b_data), .out_3(ALU_out_XM), .clock(~clock), .enable(!operation_in_progress || operation_complete), .reset(reset));

    assign address_dmem = ALU_out_XM; 
    assign wren = ~execute_mem_inst[31] && ~execute_mem_inst[30] && execute_mem_inst[29] && execute_mem_inst[28] && execute_mem_inst[27];

    wire [1:0] mem_write_enable, write_mem_bypass;
    assign mem_write_enable = (memory_write_inst[31:27] != 5'b00111) & ~pipeline_stall; // not sw
    assign write_mem_bypass = (execute_mem_inst[26:22] == memory_write_inst[26:22]) & mem_write_enable & (memory_write_inst[26:22] != 5'b0);
    assign data = write_mem_bypass ? (load_word ? data_memory_out : alu_memory_out) : execute_b_data; 

    wire[31:0] memory_write_inst, alu_memory_out, data_memory_out;
    wire load_word;
    
    register_32_3 MW(.in_1(execute_mem_inst), .in_2(ALU_out_XM), .in_3(q_dmem), .out_1(memory_write_inst), .out_2(alu_memory_out), .out_3(data_memory_out), .clock(~clock), .enable(!operation_in_progress || operation_complete), .reset(reset));

    assign load_word = memory_write_inst[31:27] == 5'b01000; 
        
    assign ctrl_writeEnable = is_write_r_type || is_write_addi || is_write_jal || is_write_setx || is_write_lw;
    assign data_writeReg = load_word ? data_memory_out : alu_memory_out;
    assign ctrl_writeReg = memory_write_inst[26:22];
        
    wire [4:0] hazard_detect1, hazard_detect2;
    wire rs_not_used = &(!decode_instruction[21:17]); 
    wire rt_not_used = &(!decode_instruction[16:12]);
    xnor hazard_detection_gate1[4:0](hazard_detect1, decode_instruction[21:17], execute_instruction[26:22]);
    xnor hazard_detection_gate2[4:0](hazard_detect2, decode_instruction[16:12], execute_instruction[26:22]); 

    wire hazard_check1 = &hazard_detect1 & !rs_not_used & (is_decode_r_type | is_decode_addi | is_decode_lw | is_decode_sw | flag_decode_jump_reg);
    wire hazard_check2 = &hazard_detect2 & !is_decode_r_type & !rt_not_used; 

    wire pipeline_stall = is_execute_lw && (hazard_check1 || hazard_check2);

    
    wire is_fetch_jump = (q_imem[31:27] == 5'b00001);
    wire is_fetch_jal = (q_imem[31:27] == 5'b00011);
    wire is_fetch_jr = (q_imem[31:27] == 5'b00100);
    
    wire is_decode_r_type = &(!decode_instruction[31:27]);
    wire is_decode_addi = (decode_instruction[31:27] == 5'b00101); 
    wire is_decode_lw = (decode_instruction[31:27] == 5'b01000);
    wire is_decode_sw = (decode_instruction[31:27] == 5'b00111); 
    assign flag_decode_jump_reg = (decode_instruction[31:27] == 5'b00100);
    assign flag_decode_jump_and_link = (decode_instruction[31:27] == 5'b00011);
    assign flag_decode_branch_exclusive = (decode_instruction[31:27] == 5'b10110);
    
    wire is_execute_r_type = &(!execute_instruction[31:27]);
    wire is_execute_addi = (execute_instruction[31:27] == 5'b00101); 
    wire is_execute_lw = (execute_instruction[31:27] == 5'b01000);
    wire is_execute_sw = (execute_instruction[31:27] == 5'b00111); 
    assign flag_execute_jump_and_link = (execute_instruction[31:27] == 5'b00011);
    wire is_execute_bne = (execute_instruction[31:27] == 5'b00010); 
    wire is_execute_blt = (execute_instruction[31:27] == 5'b00110);
    assign is_execute_setx = (execute_instruction[31:27] == 5'b10101);
    
    wire is_memory_r_type = &(!execute_mem_inst[31:27]);
    wire is_memory_addi = (execute_mem_inst[31:27] == 5'b00101); 
    wire is_memory_lw = (execute_mem_inst[31:27] == 5'b01000);
    wire is_memory_sw = (execute_mem_inst[31:27] == 5'b00111); 
    assign is_memory_setx = (execute_mem_inst[31:27] == 5'b10101);
    assign is_memory_jal = (execute_mem_inst[31:27] == 5'b00011);

    wire is_write_r_type = &(!memory_write_inst[31:27]);
    wire is_write_addi = (memory_write_inst[31:27] == 5'b00101); 
    wire is_write_lw = (memory_write_inst[31:27] == 5'b01000);
    assign is_write_setx = (memory_write_inst[31:27] == 5'b10101);
    assign is_write_jal = (memory_write_inst[31:27] == 5'b00011);

    wire XM_with_rd = is_memory_r_type || is_memory_addi || is_memory_lw || is_memory_setx;
    wire DX_with_rs = is_execute_r_type || is_execute_addi || is_execute_lw || is_execute_sw || is_execute_bne || is_execute_blt;
    wire MW_with_rd = is_write_r_type || is_write_addi || is_write_lw || is_write_setx;    

endmodule