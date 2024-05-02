module complement(a, a_complement);

    input [31:0] a;
    output [31:0] a_complement;

    // get the opposite for every bit
    not not0(a_complement[0], a[0]);
    not not1(a_complement[1], a[1]);
    not not2(a_complement[2], a[2]);
    not not3(a_complement[3], a[3]);
    not not4(a_complement[4], a[4]);
    not not5(a_complement[5], a[5]);
    not not6(a_complement[6], a[6]);
    not not7(a_complement[7], a[7]);
    not not8(a_complement[8], a[8]);
    not not9(a_complement[9], a[9]);
    not not10(a_complement[10], a[10]);
    not not11(a_complement[11], a[11]);
    not not12(a_complement[12], a[12]);
    not not13(a_complement[13], a[13]);
    not not14(a_complement[14], a[14]);
    not not15(a_complement[15], a[15]);
    not not16(a_complement[16], a[16]);
    not not17(a_complement[17], a[17]);
    not not18(a_complement[18], a[18]);
    not not19(a_complement[19], a[19]);
    not not20(a_complement[20], a[20]);
    not not21(a_complement[21], a[21]);
    not not22(a_complement[22], a[22]);
    not not23(a_complement[23], a[23]);
    not not24(a_complement[24], a[24]);
    not not25(a_complement[25], a[25]);
    not not26(a_complement[26], a[26]);
    not not27(a_complement[27], a[27]);
    not not28(a_complement[28], a[28]);
    not not29(a_complement[29], a[29]);
    not not30(a_complement[30], a[30]);
    not not31(a_complement[31], a[31]);

endmodule