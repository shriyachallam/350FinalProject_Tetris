module register_gen(in, out, clock, reset, enable);

	input [31:0] in;
	input clock, enable, reset;
	
	output [31:0] out;
	
	dffe_ref flipflop0(out[0], in[0], clock, enable, reset);
	dffe_ref flipflop1(out[1], in[1], clock, enable, reset);
	dffe_ref flipflop2(out[2], in[2], clock, enable, reset);
	dffe_ref flipflop3(out[3], in[3], clock, enable, reset);
	dffe_ref flipflop4(out[4], in[4], clock, enable, reset);
	dffe_ref flipflop5(out[5], in[5], clock, enable, reset);
	dffe_ref flipflop6(out[6], in[6], clock, enable, reset);
	dffe_ref flipflop7(out[7], in[7], clock, enable, reset);
	dffe_ref flipflop8(out[8], in[8], clock, enable, reset);
	dffe_ref flipflop9(out[9], in[9], clock, enable, reset);
	dffe_ref flipflop10(out[10], in[10], clock, enable, reset);
	dffe_ref flipflop11(out[11], in[11], clock, enable, reset);
	dffe_ref flipflop12(out[12], in[12], clock, enable, reset);
	dffe_ref flipflop13(out[13], in[13], clock, enable, reset);
	dffe_ref flipflop14(out[14], in[14], clock, enable, reset);
	dffe_ref flipflop15(out[15], in[15], clock, enable, reset);
	dffe_ref flipflop16(out[16], in[16], clock, enable, reset);
	dffe_ref flipflop17(out[17], in[17], clock, enable, reset);
	dffe_ref flipflop18(out[18], in[18], clock, enable, reset);
	dffe_ref flipflop19(out[19], in[19], clock, enable, reset);
	dffe_ref flipflop20(out[20], in[20], clock, enable, reset);
	dffe_ref flipflop21(out[21], in[21], clock, enable, reset);
	dffe_ref flipflop22(out[22], in[22], clock, enable, reset);
	dffe_ref flipflop23(out[23], in[23], clock, enable, reset);
	dffe_ref flipflop24(out[24], in[24], clock, enable, reset);
	dffe_ref flipflop25(out[25], in[25], clock, enable, reset);
	dffe_ref flipflop26(out[26], in[26], clock, enable, reset);
	dffe_ref flipflop27(out[27], in[27], clock, enable, reset);
	dffe_ref flipflop28(out[28], in[28], clock, enable, reset);
	dffe_ref flipflop29(out[29], in[29], clock, enable, reset);
	dffe_ref flipflop30(out[30], in[30], clock, enable, reset);
	dffe_ref flipflop31(out[31], in[31], clock, enable, reset);

endmodule