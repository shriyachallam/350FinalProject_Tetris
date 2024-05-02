`timescale 1 ns/ 100 ps
module VGAController(     
	input CLK100MHZ, 			// 100 MHz System Clock
	input CPU_RESETN, 		// Reset Signal
	input BTNU,
	input BTNL,
	input BTNR, 
	input BTND,
	output [15:0] LED,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data
	);
	
	wire reset;
	assign reset = ~CPU_RESETN;
	
	wire clk;
	assign clk = CLK100MHZ;
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/sc746/Downloads/processor/processor/";
    
//	 Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
    
    integer i;
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
		
		for(i = 0; i < 200; i = i + 1) begin
		  gridArray[i] <= grid[i*32+31 -: 32];
		end
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480, // Standard VGA Height
        GRID_HEIGHT = 480,
        GRID_WIDTH = 240,
        CELL_DIMENSION = 24,
        PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12;	  								 // Nexys A7 uses 12 bits/color
		
	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
	wire[BITS_PER_COLOR-1:0] colorOut;
	wire[6399:0] grid;
	reg[31:0] gridArray[199:0];
	wire[31:0] block;
	wire[31:0] level;
	wire [31:0] score;
	wire[31:0] highestScore;
	assign imgAddress = x + 640*y;				 // Address calculated coordinate
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   


	ram_vga #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(BITS_PER_COLOR),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "GameScene.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorData),				 // Color palette address
		.wEn(1'b0)); 
		
		 // We're always reading
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
	
	wire[31:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31;
    Wrapper myCPU(clk25, reset, grid, block, level, score, highestScore, moveLeft, moveRight, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31);

    wire [12:0] occupiedCellColor = 12'b1111_0000_1111;
    assign LED[7:0] = level[7:0];
    assign LED[15:8] = score[7:0];
    wire isGrid;
    assign isGrid = (x >= 200) && (x < 200 + GRID_WIDTH);
    wire[3:0] gridX = (x - 200) / 24;
    wire[4:0] gridY = y / 24;
    wire[13:0] gridIndex = gridY * 10 + gridX - 1;
    wire[31:0] gridValue = gridArray[gridIndex];
    wire [9:0] blockX = (block % 10) * 24 + 201;
    wire [8:0] blockY = (block / 10) * 24 + 1;
    wire isBlock;
    assign isBlock = (x >= blockX) && (x < blockX + 24) && (y >= blockY) && (y < blockY + 24);
   
    wire isLevel;
    assign isLevel = (x >= 520) && (x < 570) && (y >= 70) && (y < 120);
       
    wire[18-1:0] levelAddress;  	 // Image address for the image data
    assign levelAddress = (x-520 + 50*(y-70)) + ((level-1) * 2500);
	wire[BITS_PER_COLOR-1:0] levelData; 	 // Color address for the color palette
	ram_vga #(		
		.DEPTH(7500), 				  
		.DATA_WIDTH(BITS_PER_COLOR),      
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),    
		.MEMFILE({FILES_PATH, "levels.mem"}))
		
	LevelData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(levelAddress),					 // Image data address
		.dataOut(levelData),				 // Color palette address
		.wEn(1'b0)); 
	
	wire[3:0] units;
	wire[3:0] tens;
	wire[3:0] hundreds;
	wire[3:0] thousands;
	wire[3:0] ten_thousands;
	wire[3:0] hundred_thousands;	
	bcd scoreDigits(.binary(score), .units(units), .tens(tens), .hundreds(hundreds), .thousands(thousands), .ten_thousands(ten_thousands), .hundred_thousands(hundred_thousands));
    
	wire [18-1:0] addrUnits = (x-580 + 10 + 50*(y-235)) + ((units) * 2500);
    wire [BITS_PER_COLOR-1:0] dataOutUnits;
    wire [18-1:0] addrTens = (x-550 + 10 + 50*(y-235)) + ((tens) * 2500);
    wire [BITS_PER_COLOR-1:0] dataOutTens;
    wire [18-1:0] addrHundreds = (x-520 + 10 + 50*(y-235)) + ((hundreds) * 2500);
    wire [BITS_PER_COLOR-1:0] dataOutHundreds;
    wire [18-1:0] addrThousands = (x-490 + 10 + 50*(y-235)) + ((thousands) * 2500);
    wire [BITS_PER_COLOR-1:0] dataOutThousands;
    wire [18-1:0] addrTenThousands = (x-460 + 10 + 50*(y-235)) + ((ten_thousands) * 2500);
    wire [BITS_PER_COLOR-1:0] dataOutTenThousands;
    
    ram_digits #(		
		.DEPTH(28000), 				  
		.DATA_WIDTH(BITS_PER_COLOR),      
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),    
		.MEMFILE({FILES_PATH, "digits.mem"}))
	ScoreData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addrUnits(addrUnits),
		.addrTens(addrTens),
		.addrHundreds(addrHundreds),
		.addrThousands(addrThousands),
		.addrTenThousands(addrTenThousands),
		.dataOutUnits(dataOutUnits),
		.dataOutTens(dataOutTens),
		.dataOutHundreds(dataOutHundreds),
		.dataOutThousands(dataOutThousands),
		.dataOutTenThousands(dataOutTenThousands)); 
		
	wire isUnits;
	wire isTens;
	wire isHundreds;
	wire isThousands;
	wire isTenThousands;
    assign isUnits = (x >= 580) && (x < 610) && (y >= 235) && (y < 285);
    assign isTens = (x >= 550) && (x < 580) && (y >= 235) && (y < 285);
    assign isHundreds = (x >= 520) && (x < 550) && (y >= 235) && (y < 285);
    assign isThousands = (x >= 490) && (x < 520) && (y >= 235) && (y < 285);
    assign isTenThousands = (x >= 460) && (x < 490) && (y >= 235) && (y < 285);

    assign colorOut = isUnits ? dataOutUnits : isTens ? dataOutTens : isHundreds ? dataOutHundreds : 
                      isThousands ? dataOutThousands : isTenThousands ? dataOutTenThousands : isLevel ? levelData : isBlock ? occupiedCellColor : 
                      isGrid ? (gridValue == 32'b1 ? occupiedCellColor : colorData) : colorData;
//    assign colorOut = isBlock ? occupiedCellColor : isGrid ? (gridValue == 32'b1 ? occupiedCellColor : colorData) : colorData;              
    reg moveLeft = 1'b0;
    reg moveRight = 1'b0;    
      always @ (posedge clk25) begin
        if (BTNL) moveLeft = 1'b1;
        if (!BTNL) moveLeft = 1'b0;
        if (BTNR) moveRight = 1'b1;
        if (!BTNR) moveRight = 1'b0;
        
//        blockNumber = randomNumber * 3;
      end
    
//    wire [2:0] randomNumber;
//    reg [2:0] blockNumber;
//    RNG randomNumberGenerator(.clk(clk), .rst(reset), .random_number(randomNumber));
endmodule
