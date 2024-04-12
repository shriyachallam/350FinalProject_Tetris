module multiply(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    // Input ports
    input [31:0] data_operandA, data_operandB; // Operand A: Multiplicand, Operand B: Multiplier
    input ctrl_MULT, ctrl_DIV, clock; // Control signals for multiplication/division and clock signal
    
    // Output ports
    output [31:0] data_result; // Result of multiplication/division
    output data_exception, data_resultRDY; // Exception flag and Result Ready flag
    
    // Internal wires
    wire signed [64:0] init, reg_in, reg_out, product, shifted_product; // Internal registers and product wires
    wire sub, cout, cout_sub, shift_multiplicand, same, exception_logic, zero_input, all_0, all_1, all_1_or_0, sign_match; // Control and status wires
    wire [2:0] LSB; // Least significant bits for shifting
    wire signed [31:0] multiplicand, multiplier, new_multiplicand, send_add, sum, send_add_next, subtracted; // Signed operands and intermediate results
    wire [31:0] temp_reg_out; // Temporary register output for counter
    
    // SET UP
    assign init[0] = 1'b0; // Initialize the MSB of init to 0
    assign init[32:1] = data_operandB; // Set bits [32:1] of init to data_operandB
    assign init[64:33] = 32'b0; // Set bits [64:33] of init to 0
    register_gen reg_multiplicand(.in(data_operandA), .out(multiplicand), .clock(clock), .reset(1'b0), .enable(ctrl_MULT)); // Register for multiplicand
    register_gen reg_multiplier(.in(data_operandB), .out(multiplier), .clock(clock), .reset(1'b0), .enable(ctrl_MULT)); // Register for multiplier

    // DECIDE WHAT TO DO
    assign reg_in = ctrl_MULT ? init : shifted_product; // Select input based on control signal
    assign LSB = ctrl_MULT ? init[2:0] : reg_out[2:0]; // Select LSB based on control signal
    assign new_multiplicand = shift_multiplicand ? (multiplicand<<1) : multiplicand; // Shift multiplicand left if required
    // replace sum w res (decide btwn add and sub)
    assign send_add = sub ? ~new_multiplicand : new_multiplicand; // Determine operand for addition/subtraction
    assign send_add_next = same ? 32'b0 : send_add; // Select next operand based on control signal

    // PUT IT TOGETHER (modified booth algorithm)
    register_gen65 reg_prod(.in(reg_in), .out(reg_out), .clock(clock), .reset(1'b0), .enable(1'b1)); // Register for product
    
    multiplication_counter counter(.reg_out(temp_reg_out), .clock(clock), .reset(ctrl_MULT), .data_resultRDY(data_resultRDY)); // Counter for result ready signal
    multiplication_control cntrl(.same(same), .sub(sub), .shift(shift_multiplicand), .least_significant_bit(LSB), .clock(clock), .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV)); // Control unit for multiplication/division
    
    
    add adder(.s(sum), .cout(cout), .a(reg_out[64:33]), .b(send_add_next), .c0(sub)); // Adder/subtractor unit
    assign data_result = reg_in[32:1]; // Set the result
    assign product[32:0] = reg_out[32:0]; // Extract lower 32 bits of product
    assign product[64:33] = sum; // Set higher 32 bits of product to the sum
    assign shifted_product = product>>>2; // Right shift the product by 2 bits (arithmetic shift right)

    // DATA EXCEPTION / OVERFLOW
    // Check if signs match
    xor xor1(sign_match, data_operandA[31], data_operandB[31], data_result[31]); // Perform XOR operation to check sign match
    // Check if top 33 bits are all 1s (AND) or all 0s (NOR) --> overflow if they don't match
    assign all_1 = & reg_in[64:32]; // Check if all bits are 1
    assign all_0 = ~| reg_in[64:32]; // Check if all bits are 0
    assign all_1_or_0 = ~(all_1 | all_0); // Perform NOR operation to check if they are all 1s or all 0s
    assign exception_logic = all_1_or_0 | sign_match; // Determine exception logic
    // 0 case: If either inputs are 0, no exception
    assign zero_input = ~|data_operandA | ~|data_operandB; // Check if any input is zero
    assign data_exception = zero_input ? 1'b0 : exception_logic; // Set data exception flag accordingly
endmodule
