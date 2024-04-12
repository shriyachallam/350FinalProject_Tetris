module right_shift(a, amount_to_shift, shifted_a_output);

    input [31:0] a;
    input [4:0] amount_to_shift;
    
    output [31:0] shifted_a_output;
    
    wire [31:0] shifted1, shifted2, shifted4, shifted8, shifted16;
    wire [31:0] output2, output4, output8, output16;

    // shift as if there is a 1 in the fourth bit and then use mux 2 to actually check if that shift should be done
    right_shift16 sixteen(a, shifted16);
    mux_2 shift_fourth_bit(output16, amount_to_shift[4], a, shifted16);

    // shift as if there is a 1 in the third bit and then use mux 2 to actually check if that shift should be done
    right_shift8 eight(output16, shifted8);
    mux_2 shift_third_bit(output8, amount_to_shift[3], output16, shifted8);

    // shift as if there is a 1 in the second bit and then use mux 2 to actually check if that shift should be done
    right_shift4 four(output8, shifted4);
    mux_2 shift_second_bit(output4, amount_to_shift[2], output8, shifted4);

    // shift as if there is a 1 in the first bit and then use mux 2 to actually check if that shift should be done
    right_shift2 two(output4, shifted2);
    mux_2 shift_first_bit(output2, amount_to_shift[1], output4, shifted2);

    // shift as if there is a 1 in the zeroth bit and then use mux 2 to actually check if that shift should be done
    right_shift1 one(output2, shifted1);
    mux_2 shift_zeroth_bit(shifted_a_output, amount_to_shift[0], output2, shifted1);

endmodule

// right shift 1 bit
module right_shift1(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the max bit because it is arithmetic shift
    assign out[31] = in[31];

    assign out[30:0] = in[31:1];

endmodule

// right shift 2 bit
module right_shift2(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the max bit because it is arithmetic shift
    assign out[30] = in[31];
    assign out[31] = in[31];

    assign out[29:0] = in[31:2];

endmodule

// right shift 4 bit
module right_shift4(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the max bit because it is arithmetic shift
    assign out[28] = in[31];
    assign out[29] = in[31];
    assign out[30] = in[31];
    assign out[31] = in[31];

    assign out[27:0] = in[31:4];

endmodule

// right shift 8 bit
module right_shift8(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the max bit because it is arithmetic shift
    assign out[24] = in[31];
    assign out[25] = in[31];
    assign out[26] = in[31];
    assign out[27] = in[31];
    assign out[28] = in[31];
    assign out[29] = in[31];
    assign out[30] = in[31];
    assign out[31] = in[31];

    assign out[23:0] = in[31:8];

endmodule

// right shift 16 bit
module right_shift16(in, out);

    input [31:0] in;
    output [31:0] out;

    // set to the max bit because it is arithmetic shift
    assign out[16] = in[31];
    assign out[17] = in[31];
    assign out[18] = in[31];
    assign out[19] = in[31];
    assign out[20] = in[31];
    assign out[21] = in[31];
    assign out[22] = in[31];
    assign out[23] = in[31];
    assign out[24] = in[31];
    assign out[25] = in[31];
    assign out[26] = in[31];
    assign out[27] = in[31];
    assign out[28] = in[31];
    assign out[29] = in[31];
    assign out[30] = in[31];
    assign out[31] = in[31];
    
    assign out[15:0] = in[31:16];

endmodule