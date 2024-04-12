module cla(a, b, cin, s, cout);

    input [7:0] a, b;
    input cin;

    output [7:0] s;
    output cout;

    wire c1, c2, c3, c4, c5, c6, c7;
    wire p0, p1, p2, p3, p4, p5, p6, p7;
    wire g0, g1, g2, g3, g4, g5, g6, g7;
    wire pc0;
    wire pc1, pc2;
    wire pc3, pc4, pc5;
    wire pc6, pc7, pc8, pc9;
    wire pc10, pc11, pc12, pc13, pc14;
    wire pc15, pc16, pc17, pc18, pc19, pc20;
    wire pc21, pc22, pc23, pc24, pc25, pc26, pc27;
    wire pc28, pc29, pc30, pc31, pc32, pc33, pc34, pc35;
    
    // c1
    or propogate0(p0, a[0], b[0]);
    and generate0(g0, a[0], b[0]);

    xor sum0(s[0], a[0], b[0], cin);

    and partial_carry_out0(pc0, p0, cin);

    or carry_out0(c1, g0, pc0);

    // c2
    or propogate1(p1, a[1], b[1]);
    and generate1(g1, a[1], b[1]);

    xor sum1(s[1], a[1], b[1], c1);

    and partial_carry_out10(pc1, p1, g0);
    and partial_carry_out11(pc2, p1, p0, cin);

    or carry_out1(c2, g1, pc1, pc2);

    // c3
    or propogate2(p2, a[2], b[2]);
    and generate2(g2, a[2], b[2]);

    xor sum2(s[2], a[2], b[2], c2);

    and partial_carry_out20(pc3, p2, g1);
    and partial_carry_out21(pc4, p2, p1, g0);
    and partial_carry_out22(pc5, p2, p1, p0, cin);

    or carry_out2(c3, g2, pc3, pc4, pc5);

    // c4
    or propogate3(p3, a[3], b[3]);
    and generate3(g3, a[3], b[3]);

    xor sum3(s[3], a[3], b[3], c3);
    
    and partial_carry_out30(pc6, p3, g2);
    and partial_carry_out31(pc7, p3, p2, g1);
    and partial_carry_out32(pc8, p3, p2, p1, g0);
    and partial_carry_out33(pc9, p3, p2, p1, p0, cin);
    
    or carry_out3(c4, g3, pc6, pc7, pc8, pc9);

    // c5
    or propogate4(p4, a[4], b[4]);
    and generate4(g4, a[4], b[4]);
    
    xor sum4(s[4], a[4], b[4], c4);
    
    and partial_carry_out40(pc10, p4, g3);
    and partial_carry_out41(pc11, p4, p3, g2);
    and partial_carry_out42(pc12, p4, p3, p2, g1);
    and partial_carry_out43(pc13, p4, p3, p2, p1, g0);
    and partial_carry_out44(pc14, p4, p3, p2, p1, p0, cin);
    
    or carry_out4(c5, g4, pc10, pc11, pc12, pc13, pc14);

    // c6
    or propogate5(p5, a[5], b[5]);
    and generate5(g5, a[5], b[5]);
    
    xor sum5(s[5], a[5], b[5], c5);
    
    and partial_carry_out50(pc15, p5, g4);
    and partial_carry_out51(pc16, p5, p4, g3);
    and partial_carry_out52(pc17, p5, p4, p3, g2);
    and partial_carry_out53(pc18, p5, p4, p3, p2, g1);
    and partial_carry_out54(pc19, p5, p4, p3, p2, p1, g0);
    and partial_carry_out55(pc20, p5, p4, p3, p2, p1, p0, cin);
    
    or carry_out5(c6, g5, pc15, pc16, pc17, pc18, pc19, pc20);

    // c7
    or propogate6(p6, a[6], b[6]);
    and generate6(g6, a[6], b[6]);
    
    xor sum6(s[6], a[6], b[6], c6);
    
    and partial_carry_out60(pc21, p6, g5);
    and partial_carry_out61(pc22, p6, p5, g4);
    and partial_carry_out62(pc23, p6, p5, p4, g3);
    and partial_carry_out63(pc24, p6, p5, p4, p3, g2);
    and partial_carry_out64(pc25, p6, p5, p4, p3, p2, g1);
    and partial_carry_out65(pc26, p6, p5, p4, p3, p2, p1, g0);
    and partial_carry_out66(pc27, p6, p5, p4, p3, p2, p1, p0, cin);
    
    or carry_out6(c7, g6, pc21, pc22, pc23, pc24, pc25, pc26, pc27);

    // cout
    or propogate7(p7, a[7], b[7]);
    and generate7(g7, a[7], b[7]);
    
    xor sum7(s[7], a[7], b[7], c7);
    
    and partial_carry_out70(pc28, p7, g6);
    and partial_carry_out071(pc29, p7, p6, g5);
    and partial_carry_out72(pc30, p7, p6, p5, g4);
    and partial_carry_out73(pc31, p7, p6, p5, p4, g3);
    and partial_carry_out74(pc32, p7, p6, p5, p4, p3, g2);
    and partial_carry_out75(pc33, p7, p6, p5, p4, p3, p2, g1);
    and partial_carry_out76(pc34, p7, p6, p5, p4, p3, p2, p1, g0);
    and partial_carry_out77(pc35, p7, p6, p5, p4, p3, p2, p1, p0, cin);
    
    or carry_out7(cout, g7, pc28, pc29, pc30, pc31, pc32, pc33, pc34, pc35);

endmodule