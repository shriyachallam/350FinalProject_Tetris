module bitwise_or(a, b, or_output);

    input [31:0] a, b;
    output [31:0] or_output;

    // do or operation for each bit
    or or0(or_output[0], a[0], b[0]);
    or or1(or_output[1], a[1], b[1]);
    or or2(or_output[2], a[2], b[2]);
    or or3(or_output[3], a[3], b[3]);
    or or4(or_output[4], a[4], b[4]);
    or or5(or_output[5], a[5], b[5]);
    or or6(or_output[6], a[6], b[6]);
    or or7(or_output[7], a[7], b[7]);
    or or8(or_output[8], a[8], b[8]);
    or or9(or_output[9], a[9], b[9]);
    or or10(or_output[10], a[10], b[10]);
    or or11(or_output[11], a[11], b[11]);
    or or12(or_output[12], a[12], b[12]);
    or or13(or_output[13], a[13], b[13]);
    or or14(or_output[14], a[14], b[14]);
    or or15(or_output[15], a[15], b[15]);
    or or16(or_output[16], a[16], b[16]);
    or or17(or_output[17], a[17], b[17]);
    or or18(or_output[18], a[18], b[18]);
    or or19(or_output[19], a[19], b[19]);
    or or20(or_output[20], a[20], b[20]);
    or or21(or_output[21], a[21], b[21]);
    or or22(or_output[22], a[22], b[22]);
    or or23(or_output[23], a[23], b[23]);
    or or24(or_output[24], a[24], b[24]);
    or or25(or_output[25], a[25], b[25]);
    or or26(or_output[26], a[26], b[26]);
    or or27(or_output[27], a[27], b[27]);
    or or28(or_output[28], a[28], b[28]);
    or or29(or_output[29], a[29], b[29]);
    or or30(or_output[30], a[30], b[30]);
    or or31(or_output[31], a[31], b[31]);

endmodule