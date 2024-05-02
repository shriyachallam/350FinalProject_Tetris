module register_64(in, out, clock, reset, enable);
	input [63:0] in;
	input clock, enable, reset;

	output [63:0] out;

	genvar i;
	generate
		for(i=0;i<64;i=i+1) begin: loop1 
			dffe_ref flipflop(out[i], in[i], clock, enable, reset);
		end
	endgenerate
endmodule