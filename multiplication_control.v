module multiplication_control(same, sub, shift, least_significant_bit, clock, ctrl_MULT, ctrl_DIV);
    // Input ports
    input clock, ctrl_MULT, ctrl_DIV;
    input [2:0] least_significant_bit;
    
    // Output ports
    output same, sub, shift;
    reg result_ready_flag;
    
    // Internal wire
    wire flipflop_output;

    // D Flip-Flop instantiation
    dffe_ref flipflop_instance(.q(flipflop_output), .d(ctrl_MULT), .clk(clock), .clr(1'b0), .en(ctrl_MULT));

    // Determine control flags
    assign same = (!least_significant_bit[2] && !least_significant_bit[1] && !least_significant_bit[0]) || (least_significant_bit[2] && least_significant_bit[1] && least_significant_bit[0]);
    assign sub = (least_significant_bit[2] && !least_significant_bit[1] && !least_significant_bit[0]) || (least_significant_bit[2] && least_significant_bit[1] && !least_significant_bit[0]) || (least_significant_bit[2] && !least_significant_bit[1] && least_significant_bit[0]); 
    assign shift = (least_significant_bit[2] && !least_significant_bit[1] && !least_significant_bit[0]) || (!least_significant_bit[2] && least_significant_bit[1] && least_significant_bit[0]); 
endmodule
