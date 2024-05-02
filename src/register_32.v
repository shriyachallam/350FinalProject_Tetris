module register_32 (in, out, clock, reset, enable);
	input [31:0] in;
	input clock, enable, reset;

	output [31:0] out;

	genvar i;
	generate
		for(i=0;i<32;i=i+1) begin: loop1 
			dffe_ref flipflop(out[i], in[i], clock, enable, reset);
		end
	endgenerate
endmodule
