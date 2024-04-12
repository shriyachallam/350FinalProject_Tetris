module register_32_4(in_1, in_2, in_3, in_4, out_1, out_2, out_3, out_4, clock, enable, reset);
    input clock, enable, reset;
    input [31:0] in_1, in_2, in_3, in_4;
    output [31:0] out_1, out_2, out_3, out_4;

    register_32 output1(.in(in_1), .out(out_1), .clock(clock), .reset(reset), .enable(enable));
    register_32 output2(.in(in_2), .out(out_2), .clock(clock), .reset(reset), .enable(enable));
    register_32 output3(.in(in_3), .out(out_3), .clock(clock), .reset(reset), .enable(enable));
    register_32 final_output(.in(in_4), .out(out_4), .clock(clock), .reset(reset), .enable(enable));
endmodule