module multiplication_counter(reg_out, clock, reset, data_resultRDY);
    // Output ports
    output [31:0] reg_out; 
    output data_resultRDY;
    
    // Input ports
    input clock, reset; 
    
    // Internal wires
    wire carry_in, enable_flag, carry_out;
    wire [31:0] constant_input, sum_output;
    
    // Assign constants
    assign carry_in = 32'b0; // Carry-in always 0
    assign constant_input = 32'h1; // Constant input to add 1 every clock cycle

    // Adder module instantiation
    add adder(sum_output, carry_out, reg_out, constant_input, carry_in);
    // Register module instantiation
    register_gen register_instance(sum_output, reg_out, clock, reset, enable_flag);
    
    // AND gate to determine result ready
    // True if the specified number of clock cycles are done
    and and_gate(data_resultRDY, reg_out[0], reg_out[1], reg_out[2], reg_out[3]);
    
    // Enable flag control
    assign enable_flag = data_resultRDY ? 1'b0 : 1'b1; // If data is ready, enable should be 0 to stop counting
endmodule
