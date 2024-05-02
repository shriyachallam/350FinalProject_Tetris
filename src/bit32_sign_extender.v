module bit32_sign_extender(A_out, A);
    input[16:0] A;
    output[31:0] A_out;

    assign A_out[16:0] = A[16:0];
    assign A_out[17] = A[16];
    assign A_out[18] = A[16];
    assign A_out[19] = A[16];
    assign A_out[20] = A[16];
    assign A_out[21] = A[16];
    assign A_out[22] = A[16];
    assign A_out[23] = A[16];
    assign A_out[24] = A[16];
    assign A_out[25] = A[16];
    assign A_out[26] = A[16];
    assign A_out[27] = A[16];
    assign A_out[28] = A[16];
    assign A_out[29] = A[16];
    assign A_out[30] = A[16];
    assign A_out[31] = A[16];
endmodule
