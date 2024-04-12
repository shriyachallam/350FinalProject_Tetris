module left_shift(a, amount_to_shift, shifted_a_output);

    input [31:0] a;
    input [4:0] amount_to_shift;
    
    output [31:0] shifted_a_output;
    
    wire [31:0] shifted1, shifted2, shifted4, shifted8, shifted16;
    wire [31:0] output2, output4, output8, output16;

    // shift as if there is a 1 in the fourth bit and then use mux 2 to actually check if that shift should be done
    left_shift16 sixteen(a, shifted16);
    mux_2 shift_fourth_bit(output16, amount_to_shift[4], a, shifted16);

    // shift as if there is a 1 in the third bit and then use mux 2 to actually check if that shift should be done
    left_shift8 eight(output16, shifted8);
    mux_2 shift_third_bit(output8, amount_to_shift[3], output16, shifted8);

    // shift as if there is a 1 in the second bit and then use mux 2 to actually check if that shift should be done
    left_shift4 four(output8, shifted4);
    mux_2 shift_second_bit(output4, amount_to_shift[2], output8, shifted4);

    // shift as if there is a 1 in the first bit and then use mux 2 to actually check if that shift should be done
    left_shift2 two(output4, shifted2);
    mux_2 shift_first_bit(output2, amount_to_shift[1], output4, shifted2);

    // shift as if there is a 1 in the zeroth bit and then use mux 2 to actually check if that shift should be done
    left_shift1 one(output2, shifted1);
    mux_2 shift_zeroth_bit(shifted_a_output, amount_to_shift[0], output2, shifted1);

endmodule

// left shift 1 bit
module left_shift1(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the 0 because it is logical shift
    assign out[0] = 1'b0;

    assign out[31:1] = in[30:0];

endmodule

// left shift 2 bit
module left_shift2(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the 0 because it is logical shift
    assign out[0] = 1'b0;
    assign out[1] = 1'b0;

    assign out[31:2] = in[29:0];

endmodule

// left shift 4 bit
module left_shift4(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the 0 because it is logical shift
    assign out[0] = 1'b0;
    assign out[1] = 1'b0;
    assign out[2] = 1'b0;
    assign out[3] = 1'b0;

    assign out[31:4] = in[27:0];

endmodule

// left shift 8 bit
module left_shift8(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the 0 because it is logical shift
    assign out[0] = 1'b0;
    assign out[1] = 1'b0;
    assign out[2] = 1'b0;
    assign out[3] = 1'b0;
    assign out[4] = 1'b0;
    assign out[5] = 1'b0;
    assign out[6] = 1'b0;
    assign out[7] = 1'b0;

    assign out[31:8] = in[23:0];

endmodule

// left shift 16 bit
module left_shift16(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the 0 because it is logical shift
    assign out[0] = 1'b0;
    assign out[1] = 1'b0;
    assign out[2] = 1'b0;
    assign out[3] = 1'b0;
    assign out[4] = 1'b0;
    assign out[5] = 1'b0;
    assign out[6] = 1'b0;
    assign out[7] = 1'b0;
    assign out[8] = 1'b0;
    assign out[9] = 1'b0;
    assign out[10] = 1'b0;
    assign out[11] = 1'b0;
    assign out[12] = 1'b0;
    assign out[13] = 1'b0;
    assign out[14] = 1'b0;
    assign out[15] = 1'b0;

    assign out[31:16] = in[15:0];

endmodule