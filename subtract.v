module subtract(a, b, cin, s, cout);

    input [31:0] a, b;
    input cin;

    output [31:0] s;
    output cout;

    //b complement
    wire [31:0] b_complement;
    complement complement_b(b, b_complement);

    //add operation using the b complement and adding 1 by setting cin to 1
    add subtraction(s, cout, a, b_complement, cin);

endmodule