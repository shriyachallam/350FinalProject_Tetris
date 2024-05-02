module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31
);

input clock, ctrl_writeEnable, ctrl_reset;
input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
input [31:0] data_writeReg, data_readRegA, data_readRegB;
output [31:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31;

wire [31:0] A, B, write;

decoder32 regA(A, ctrl_readRegA, 1'b1);
decoder32 regB(B, ctrl_readRegB, 1'b1); 
decoder32 writeReg(write, ctrl_writeReg, ctrl_writeEnable);

wire clk; 
assign clk = clock;

register_gen reg0(.clock(clk), .in(data_writeReg), .enable(write[0]), .reset(1'b1), .out(r0));
register_gen reg1(.clock(clk), .in(data_writeReg), .enable(write[1]), .reset(ctrl_reset), .out(r1));
register_gen reg2(.clock(clk), .in(data_writeReg), .enable(write[2]), .reset(ctrl_reset), .out(r2));
register_gen reg3(.clock(clk), .in(data_writeReg), .enable(write[3]), .reset(ctrl_reset), .out(r3));
register_gen reg4(.clock(clk), .in(data_writeReg), .enable(write[4]), .reset(ctrl_reset), .out(r4));
register_gen reg5(.clock(clk), .in(data_writeReg), .enable(write[5]), .reset(ctrl_reset), .out(r5));
register_gen reg6(.clock(clk), .in(data_writeReg), .enable(write[6]), .reset(ctrl_reset), .out(r6));
register_gen reg7(.clock(clk), .in(data_writeReg), .enable(write[7]), .reset(ctrl_reset), .out(r7));
register_gen reg8(.clock(clk), .in(data_writeReg), .enable(write[8]), .reset(ctrl_reset), .out(r8));
register_gen reg9(.clock(clk), .in(data_writeReg), .enable(write[9]), .reset(ctrl_reset), .out(r9));
register_gen reg10(.clock(clk), .in(data_writeReg), .enable(write[10]), .reset(ctrl_reset), .out(r10));
register_gen reg11(.clock(clk), .in(data_writeReg), .enable(write[11]), .reset(ctrl_reset), .out(r11));
register_gen reg12(.clock(clk), .in(data_writeReg), .enable(write[12]), .reset(ctrl_reset), .out(r12));
register_gen reg13(.clock(clk), .in(data_writeReg), .enable(write[13]), .reset(ctrl_reset), .out(r13));
register_gen reg14(.clock(clk), .in(data_writeReg), .enable(write[14]), .reset(ctrl_reset), .out(r14));
register_gen reg15(.clock(clk), .in(data_writeReg), .enable(write[15]), .reset(ctrl_reset), .out(r15));
register_gen reg16(.clock(clk), .in(data_writeReg), .enable(write[16]), .reset(ctrl_reset), .out(r16));
register_gen reg17(.clock(clk), .in(data_writeReg), .enable(write[17]), .reset(ctrl_reset), .out(r17));
register_gen reg18(.clock(clk), .in(data_writeReg), .enable(write[18]), .reset(ctrl_reset), .out(r18));
register_gen reg19(.clock(clk), .in(data_writeReg), .enable(write[19]), .reset(ctrl_reset), .out(r19));
register_gen reg20(.clock(clk), .in(data_writeReg), .enable(write[20]), .reset(ctrl_reset), .out(r20));
register_gen reg21(.clock(clk), .in(data_writeReg), .enable(write[21]), .reset(ctrl_reset), .out(r21));
register_gen reg22(.clock(clk), .in(data_writeReg), .enable(write[22]), .reset(ctrl_reset), .out(r22));
register_gen reg23(.clock(clk), .in(data_writeReg), .enable(write[23]), .reset(ctrl_reset), .out(r23));
register_gen reg24(.clock(clk), .in(data_writeReg), .enable(write[24]), .reset(ctrl_reset), .out(r24));
register_gen reg25(.clock(clk), .in(data_writeReg), .enable(write[25]), .reset(ctrl_reset), .out(r25));
register_gen reg26(.clock(clk), .in(data_writeReg), .enable(write[26]), .reset(ctrl_reset), .out(r26));
register_gen reg27(.clock(clk), .in(data_writeReg), .enable(write[27]), .reset(ctrl_reset), .out(r27));
register_gen reg28(.clock(clk), .in(data_writeReg), .enable(write[28]), .reset(ctrl_reset), .out(r28));
register_gen reg29(.clock(clk), .in(data_writeReg), .enable(write[29]), .reset(ctrl_reset), .out(r29));
register_gen reg30(.clock(clk), .in(data_writeReg), .enable(write[30]), .reset(ctrl_reset), .out(r30));
register_gen reg31(.clock(clk), .in(data_writeReg), .enable(write[31]), .reset(ctrl_reset), .out(r31));

assign data_readRegA = A[0] ? r0 : 32'bz;
assign data_readRegA = A[1] ? r1 : 32'bz;
assign data_readRegA = A[2] ? r2 : 32'bz;
assign data_readRegA = A[3] ? r3 : 32'bz;
assign data_readRegA = A[4] ? r4 : 32'bz;
assign data_readRegA = A[5] ? r5 : 32'bz;
assign data_readRegA = A[6] ? r6 : 32'bz;
assign data_readRegA = A[7] ? r7 : 32'bz;
assign data_readRegA = A[8] ? r8 : 32'bz;
assign data_readRegA = A[9] ? r9 : 32'bz;
assign data_readRegA = A[10] ? r10 : 32'bz;
assign data_readRegA = A[11] ? r11 : 32'bz;
assign data_readRegA = A[12] ? r12 : 32'bz;
assign data_readRegA = A[13] ? r13 : 32'bz;
assign data_readRegA = A[14] ? r14 : 32'bz;
assign data_readRegA = A[15] ? r15 : 32'bz;
assign data_readRegA = A[16] ? r16 : 32'bz;
assign data_readRegA = A[17] ? r17 : 32'bz;
assign data_readRegA = A[18] ? r18 : 32'bz;
assign data_readRegA = A[19] ? r19 : 32'bz;
assign data_readRegA = A[20] ? r20 : 32'bz;
assign data_readRegA = A[21] ? r21 : 32'bz;
assign data_readRegA = A[22] ? r22 : 32'bz;
assign data_readRegA = A[23] ? r23 : 32'bz;
assign data_readRegA = A[24] ? r24 : 32'bz;
assign data_readRegA = A[25] ? r25 : 32'bz;
assign data_readRegA = A[26] ? r26 : 32'bz;
assign data_readRegA = A[27] ? r27 : 32'bz;
assign data_readRegA = A[28] ? r28 : 32'bz;
assign data_readRegA = A[29] ? r29 : 32'bz;
assign data_readRegA = A[30] ? r30 : 32'bz;
assign data_readRegA = A[31] ? r31 : 32'bz;

assign data_readRegB = B[0] ? r0 : 32'bz;
assign data_readRegB = B[1] ? r1 : 32'bz;
assign data_readRegB = B[2] ? r2 : 32'bz;
assign data_readRegB = B[3] ? r3 : 32'bz;
assign data_readRegB = B[4] ? r4 : 32'bz;
assign data_readRegB = B[5] ? r5 : 32'bz;
assign data_readRegB = B[6] ? r6 : 32'bz;
assign data_readRegB = B[7] ? r7 : 32'bz;
assign data_readRegB = B[8] ? r8 : 32'bz;
assign data_readRegB = B[9] ? r9 : 32'bz;
assign data_readRegB = B[10] ? r10 : 32'bz;
assign data_readRegB = B[11] ? r11 : 32'bz;
assign data_readRegB = B[12] ? r12 : 32'bz;
assign data_readRegB = B[13] ? r13 : 32'bz;
assign data_readRegB = B[14] ? r14 : 32'bz;
assign data_readRegB = B[15] ? r15 : 32'bz;
assign data_readRegB = B[16] ? r16 : 32'bz;
assign data_readRegB = B[17] ? r17 : 32'bz;
assign data_readRegB = B[18] ? r18 : 32'bz;
assign data_readRegB = B[19] ? r19 : 32'bz;
assign data_readRegB = B[20] ? r20 : 32'bz;
assign data_readRegB = B[21] ? r21 : 32'bz;
assign data_readRegB = B[22] ? r22 : 32'bz;
assign data_readRegB = B[23] ? r23 : 32'bz;
assign data_readRegB = B[24] ? r24 : 32'bz;
assign data_readRegB = B[25] ? r25 : 32'bz;
assign data_readRegB = B[26] ? r26 : 32'bz;
assign data_readRegB = B[27] ? r27 : 32'bz;
assign data_readRegB = B[28] ? r28 : 32'bz;
assign data_readRegB = B[29] ? r29 : 32'bz;
assign data_readRegB = B[30] ? r30 : 32'bz;
assign data_readRegB = B[31] ? r31 : 32'bz;

endmodule