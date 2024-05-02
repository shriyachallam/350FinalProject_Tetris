`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module bcd(
    input [31:0] binary,
    output reg [3:0] units,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands,
    output reg [3:0] ten_thousands,
    output reg [3:0] hundred_thousands
);

integer i;
reg [63:0] shift_reg;

always @ (binary) begin
    // Initialize the shift register with the binary number on the rightmost side
    shift_reg = {32'd0, binary};  // 32-bit for shifts, 32-bit for binary number

    // Perform the double dabble algorithm across all 32 bits
    for (i = 0; i < 32; i = i + 1) begin
        // Check each BCD digit group for adjustment if they are greater than 4
        if (shift_reg[35:32] >= 5)
            shift_reg[35:32] = shift_reg[35:32] + 3;
        if (shift_reg[39:36] >= 5)
            shift_reg[39:36] = shift_reg[39:36] + 3;
        if (shift_reg[43:40] >= 5)
            shift_reg[43:40] = shift_reg[43:40] + 3;
        if (shift_reg[47:44] >= 5)
            shift_reg[47:44] = shift_reg[47:44] + 3;
        if (shift_reg[51:48] >= 5)
            shift_reg[51:48] = shift_reg[51:48] + 3;
        if (shift_reg[55:52] >= 5)
            shift_reg[55:52] = shift_reg[55:52] + 3;
        if (shift_reg[59:56] >= 5)
            shift_reg[59:56] = shift_reg[59:56] + 3;
        if (shift_reg[63:60] >= 5)
            shift_reg[63:60] = shift_reg[63:60] + 3;

        // Shift the entire register left by one bit
        shift_reg = shift_reg << 1;
    end

    // Extract specific BCD digits
    units = shift_reg[35:32];
    tens = shift_reg[39:36];
    hundreds = shift_reg[43:40];
    thousands = shift_reg[47:44];
    ten_thousands = shift_reg[51:48];
    hundred_thousands = shift_reg[55:52];
end

endmodule