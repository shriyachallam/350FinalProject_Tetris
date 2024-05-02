`timescale 1ns / 1ps
module ram_digits #( parameter DATA_WIDTH = 8, ADDRESS_WIDTH = 8, DEPTH = 256, MEMFILE = "") (
    input wire                     clk,
    input wire [ADDRESS_WIDTH-1:0] addrUnits,
    output reg [DATA_WIDTH-1:0]    dataOutUnits,
    input wire [ADDRESS_WIDTH-1:0] addrTens,
    output reg [DATA_WIDTH-1:0]    dataOutTens,
    input wire [ADDRESS_WIDTH-1:0] addrHundreds,
    output reg [DATA_WIDTH-1:0]    dataOutHundreds,
    input wire [ADDRESS_WIDTH-1:0] addrThousands,
    output reg [DATA_WIDTH-1:0]    dataOutThousands,
    input wire [ADDRESS_WIDTH-1:0] addrTenThousands,
    output reg [DATA_WIDTH-1:0]    dataOutTenThousands,
    input wire [ADDRESS_WIDTH-1:0] addrHundredThousands,
    output reg [DATA_WIDTH-1:0]    dataOutHundredThousands);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    
    initial begin
        if(MEMFILE > 0) begin
            $readmemh(MEMFILE, MemoryArray);
        end
    end
    
    always @(posedge clk) begin
        dataOutUnits <= MemoryArray[addrUnits];
        dataOutTens <= MemoryArray[addrTens];
        dataOutHundreds <= MemoryArray[addrHundreds];
        dataOutThousands <= MemoryArray[addrThousands];
        dataOutTenThousands <= MemoryArray[addrTenThousands];
        dataOutHundredThousands <= MemoryArray[addrHundredThousands];
    end
endmodule