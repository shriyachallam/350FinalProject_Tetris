module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] enable_writing, enable_reading_A, enable_reading_B, decoding_wire [31:0];

	decoder32 write_decode(enable_writing, ctrl_writeReg, ctrl_writeEnable);
	decoder32 read_decode_A(enable_reading_A, ctrl_readRegA, 1'b1);
	decoder32 read_decode_B(enable_reading_B, ctrl_readRegB, 1'b1);
	
	genvar index;
	generate
		for(index = 0; index < 32; index = index + 1) begin: loop1
			if (index == 0)
			begin
				my_tri tristate_buffer_A0(32'b0, enable_reading_A[0], data_readRegA);
				my_tri tristate_buffer_B0(32'b0, enable_reading_B[0], data_readRegB);
			end
			else
			begin
				my_tri tristate_buffer_A_at_index(decoding_wire[index], enable_reading_A[index], data_readRegA);
				my_tri tristate_buffer_B_at_index(decoding_wire[index], enable_reading_B[index], data_readRegB);
			end

			register_gen cus_reg(data_writeReg, decoding_wire[index], clock, ctrl_reset, enable_writing[index]);
		end
	endgenerate

endmodule