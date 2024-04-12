module add(s, cout, a, b, c0);

    input [31:0] a, b;
    input c0;

    output [31:0] s;
    output cout;

    wire cout0, cout1, cout2, cout3;
    wire a_bit, b_bit, sum_bit;

    // overflow wires
    wire potential_overflow, sign_a, sign_b;

    cla q1(a[7:0], b[7:0], c0, s[7:0], cout0);
    cla q2(a[15:8], b[15:8], cout0, s[15:8], cout1);
    cla q3(a[23:16], b[23:16], cout1, s[23:16], cout2);
    cla q4(a[31:24], b[31:24], cout2, s[31:24], cout3);

    // OVERFLOW
    assign a_bit = a[31];
    assign b_bit = b[31];
    assign sum_bit = s[31];

    // only if this is 1, there is potential overflow
    xnor check_potential_overflow(potential_overflow, a_bit, b_bit);

    // check whether sign of a and sign of sum are different
    xor check_sign_a(sign_a, a_bit, sum_bit);

    // check whether sign of b and sign of sum are different
    xor check_sign_b(sign_b, b_bit, sum_bit);

    // check for overflow
    and check_final_overflow(cout, potential_overflow, sign_a, sign_b);

endmodule