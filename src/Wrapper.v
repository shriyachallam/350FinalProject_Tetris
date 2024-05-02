`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock, reset, grid, block, level, score, highestScore, moveLeft, moveRight, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31);
	input clock, reset;
	input moveLeft, moveRight;
    output [31:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31;
	output [6399:0] grid;
	output [31:0] block;
	output [31:0] level;
	output [31:0] score;
	output [31:0] highestScore;
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
		
    reg moveLeft_d, moveRight_d; // Delayed signals for edge detection
 
    always @(posedge clock) begin
        if (reset) begin
            moveLeft_d <= 0;
            moveRight_d <= 0;

        end else begin
            moveLeft_d <= moveLeft;
            moveRight_d <= moveRight;
        end
    end
    
    wire writeMoveLeft = moveLeft & ~moveLeft_d;
    wire writeMoveRight = moveRight & ~moveRight_d;
    reg [31:0] writeData;
    reg [11:0] writeAddr;
    reg writeEnable;
    always @(posedge clock) begin
        if (reset) begin
            writeEnable <= 0;
            writeData <= 0;
            writeAddr <= 0;
        end else begin
            if (writeMoveLeft) begin
                writeEnable <= 1;
                writeData <= 1;
                writeAddr <= 206;
            end else if (writeMoveRight) begin
                writeEnable <= 1;
                writeData <= 1;
                writeAddr <= 205;
            end else begin
                writeEnable <= 0;
            end
        end
    end

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "C:/Users/sc746/Downloads/processor/processor/Tetris";

	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
		.r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r8(r8), 
		.r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15), .r16(r16), 
		.r17(r17), .r18(r18), .r19(r19), .r20(r20), .r21(r21), .r22(r22), .r23(r23), .r24(r24), 
		.r25(r25), .r26(r26), .r27(r27), .r28(r28), .r29(r29), .r30(r30), .r31(r31));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(writeEnable | mwe), 
		.addr(writeEnable ? writeAddr : memAddr[11:0]), 
		.dataIn(writeEnable ? writeData : memDataIn), 
		.dataOut(memDataOut),
		.grid(grid),
		.block(block),
		.level(level),
		.score(score),
		.highestScore(highestScore));
	
endmodule
