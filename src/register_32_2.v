module register_32_2(in_1, in_2, out_1, out_2, clock, enable, reset);
    input clock, enable, reset;
    input [31:0] in_1, in_2;
    output [31:0] out_1, out_2;

    register_32 output1(.in(in_1), .out(out_1), .clock(clock), .reset(reset), .enable(enable));
    register_32 final_output(.in(in_2), .out(out_2), .clock(clock), .reset(reset), .enable(enable));
endmodule