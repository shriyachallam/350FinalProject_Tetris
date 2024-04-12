module divide_counter(reg_out, clock, reset, data_resultRDY, start);
    // Input and output ports
    input clock, reset;
    output [31:0] reg_out; 
    output data_resultRDY, start;

    // Internal wires
    wire cin, in_en, cout;
    wire [31:0] b, s;
    
    // Assigning values to internal wires
    assign cin = 32'b0; // Carry-in is always zero
    assign b = 1'b1;    // Constant input value for the adder

    // Instantiate adder module to perform addition
    add adder(s, cout, reg_out, b, cin); // reg_out = b + 0

    // Register module to capture the sum output
    register_32 register(s, reg_out, clock, reset, in_en);

    // AND gate to determine if all bits of reg_out are set, indicating readiness
    and and_gate(data_resultRDY, reg_out[0], reg_out[1], reg_out[2], reg_out[3], reg_out[4]);

    // Enable input control based on data readiness
    assign in_en = data_resultRDY ? 1'b0 : 1'b1; // Disable input when data is ready

    // Determine if the counter has reached its starting state
    assign start = !reg_out[0] & !reg_out[1] & !reg_out[2] & !reg_out[3] & !reg_out[4];
endmodule