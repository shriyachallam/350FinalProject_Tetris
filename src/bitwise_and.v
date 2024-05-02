module bitwise_and(a, b, and_output);

    input [31:0] a, b;
    output [31:0] and_output;

    // do and operation for each bit
    and and0(and_output[0], a[0], b[0]);
    and and1(and_output[1], a[1], b[1]);
    and and2(and_output[2], a[2], b[2]);
    and and3(and_output[3], a[3], b[3]);
    and and4(and_output[4], a[4], b[4]);
    and and5(and_output[5], a[5], b[5]);
    and and6(and_output[6], a[6], b[6]);
    and and7(and_output[7], a[7], b[7]);
    and and8(and_output[8], a[8], b[8]);
    and and9(and_output[9], a[9], b[9]);
    and and10(and_output[10], a[10], b[10]);
    and and11(and_output[11], a[11], b[11]);
    and and12(and_output[12], a[12], b[12]);
    and and13(and_output[13], a[13], b[13]);
    and and14(and_output[14], a[14], b[14]);
    and and15(and_output[15], a[15], b[15]);
    and and16(and_output[16], a[16], b[16]);
    and and17(and_output[17], a[17], b[17]);
    and and18(and_output[18], a[18], b[18]);
    and and19(and_output[19], a[19], b[19]);
    and and20(and_output[20], a[20], b[20]);
    and and21(and_output[21], a[21], b[21]);
    and and22(and_output[22], a[22], b[22]);
    and and23(and_output[23], a[23], b[23]);
    and and24(and_output[24], a[24], b[24]);
    and and25(and_output[25], a[25], b[25]);
    and and26(and_output[26], a[26], b[26]);
    and and27(and_output[27], a[27], b[27]);
    and and28(and_output[28], a[28], b[28]);
    and and29(and_output[29], a[29], b[29]);
    and and30(and_output[30], a[30], b[30]);
    and and31(and_output[31], a[31], b[31]);

endmodule