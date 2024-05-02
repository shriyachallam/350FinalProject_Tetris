module divide(data_operandX, data_operandY, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    // Input ports 
    input [31:0] data_operandX, data_operandY; //X: dividend, Y: divisor
    input ctrl_MULT, ctrl_DIV, clock;
    
    // Output ports
    output [31:0] data_result;
    output data_exception, data_resultRDY;
    
    // Internal wires
    wire signed [63:0] init, reg_in, reg_out, shifted;
    wire signed [31:0] dividend, divisor, send_add, neg_res, quotient;
    wire [31:0] temp_reg_out, X_new, X_new_new, X_final, negated_dividend, negated_divisor;
    wire start, X, cout; 

    // Calculate 2's complement of the dividend and divisor
    add neg_dividend(negated_dividend, cout, ~data_operandX, 32'b1, 1'b0);
    add neg_divisor(negated_divisor, cout, ~data_operandY, 32'b1, 1'b0);
    
    // Register the dividend and divisor
    register_32 reg_dividend(data_operandX[31] ? negated_dividend : data_operandX, dividend, clock, 1'b0, ctrl_DIV); 
    register_32 reg_divisor(data_operandY[31] ? negated_divisor : data_operandY, divisor, clock, 1'b0, ctrl_DIV);
    
    // Register the quotient
    register_64 reg_quotient(reg_in, reg_out, clock, 1'b0, 1'b1);
    
    // Initialize the 'init' variable with the dividend and zeros
    assign init[31:0] = dividend;
    assign init[63:32] = 32'b0;
    assign X = start ? 1'b0 : reg_out[63];

    // Instantiate the divider counter
    divide_counter counter(temp_reg_out, clock, ctrl_DIV, data_resultRDY, start);

    // Calculate the shifted value based on the control signal 'start'
    assign shifted = start ? init<<1 : reg_out<<1;
    
    // Determine whether to add the divisor or its complement
    assign send_add = X ? divisor : ~divisor;
    
    // Execute the first step of the division algorithm
    add step1(X_new, cout, shifted[63:32], send_add, !X);
    assign reg_in[0] = !X_new[31]; 
    assign reg_in[31:1] = shifted[31:1];
    assign reg_in[63:32] = X_new;

    // Execute the second step of the division algorithm
    add step2(neg_res, cout, 32'b0, ~reg_in[31:0], 1'b1);

    // Execute the third step of the division algorithm
    add step3(X_final, cout, X, reg_in[31:0], 1'b1); //last step if X = 1, X = X + M ?
    assign X_new_new = X_new ? 1'b0 : X_final;

    // Calculate the quotient based on the signs of the operands
    assign quotient = (data_operandX[31] ^ data_operandY[31]) ? neg_res : reg_in[31:0]; //^ is bitwise XOR -- negate
    
    // Check for division by zero
    assign data_exception = !(|divisor); //check divide by 0
    
    // Set the data result based on the exception or quotient
    assign data_result = data_exception ? 32'b0 : quotient;
endmodule
