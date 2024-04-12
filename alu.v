module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] add_output, subtract_output, bitwise_and_output, bitwise_or_output, right_shift_output, left_shift_output;
    wire add_overflow, subtract_overflow;
    wire subtract_output_sign, subtract_output_sign_flipped;

    add add_operation(add_output, add_overflow, data_operandA, data_operandB, 1'b0); 
    subtract subtract_operation(data_operandA, data_operandB, 1'b1, subtract_output, subtract_overflow); 
    bitwise_and and_operation(data_operandA, data_operandB, bitwise_and_output);
    bitwise_or or_operation(data_operandA, data_operandB, bitwise_or_output);
    right_shift right_shift_operation(data_operandA, ctrl_shiftamt, right_shift_output);
    left_shift left_shift_operation(data_operandA, ctrl_shiftamt, left_shift_output);
    
    // use or function for each bit of the subtract output to check if data_operandA and data_operandB are not equal
    or is_not_equal_operation(isNotEqual, subtract_output[0], subtract_output[1], subtract_output[2], subtract_output[3], subtract_output[4], subtract_output[5], subtract_output[6], subtract_output[7], subtract_output[8], subtract_output[9], subtract_output[10], subtract_output[11], subtract_output[12], subtract_output[13], subtract_output[14], subtract_output[15], subtract_output[16], subtract_output[17], subtract_output[18], subtract_output[19], subtract_output[20], subtract_output[21], subtract_output[22], subtract_output[23], subtract_output[24], subtract_output[25], subtract_output[26], subtract_output[27], subtract_output[28], subtract_output[29], subtract_output[30], subtract_output[31]);

    // get final results using muxes
    mux_8 result_mux(data_result, ctrl_ALUopcode[2:0], add_output[31:0], subtract_output[31:0], bitwise_and_output[31:0], bitwise_or_output[31:0], left_shift_output[31:0], right_shift_output[31:0], 32'b0, 32'b0);
    mux_8 overflow_mux(overflow, ctrl_ALUopcode[2:0], add_overflow, subtract_overflow, 0, 0, 0, 0, 0, 0);

    // check whether subtraction output is positive or negative to identify if data_operandA is less than data_operandB
    assign subtract_output_sign = subtract_output[31];

    // if there is overflow, the sign of the subtraction operation is the opposite of whether data_operandA is less than data_operandB
    not flip_subtract_sign(subtract_output_sign_flipped, subtract_output_sign);
    // assign isLessThan = overflow ? subtract_output_sign_flipped : subtract_output_sign;
    assign isLessThan = data_operandA > data_operandB;

endmodule