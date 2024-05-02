`timescale 1ns / 1ps
module RNG(
    output reg [2:0] random_number, // 3 bits to cover numbers from 0-7
    input clk,
    input rst // reset input to initialize the LFSR
);

// LFSR internal state
reg [2:0] lfsr = 3'b001; // Non-zero initial state

// Update LFSR and output on positive edge of clock
always @(posedge clk or posedge rst) begin
    if (rst) begin
        lfsr <= 3'b001; // Reset to initial non-zero state
        random_number <= 0;
    end else begin
        // Update LFSR using taps at bit 2 and bit 1 (example configuration)
        lfsr[2:0] <= {lfsr[1:0], lfsr[2] ^ lfsr[1]};

        // Only update output if lfsr value is less than 6
        if (lfsr < 6) random_number <= lfsr;
    end
end

endmodule
