module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    wire[31:0] multiply_result, divide_result;
    output data_exception, data_resultRDY;

    wire decision, multiply_exception, multiply_resultRDY, divide_exception, divide_resultRDY;

    multiply multiply_operation(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, multiply_result, multiply_exception, multiply_resultRDY);
    divide divide_operation(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, divide_result, divide_exception, divide_resultRDY);

    dffe_ref dff(decision, ctrl_MULT ? ctrl_MULT : 1'b0, clock, ctrl_DIV || ctrl_MULT, 1'b0);

    assign data_result = decision ? multiply_result : divide_result;
    assign data_resultRDY = decision ? multiply_resultRDY : divide_resultRDY;
    assign data_exception = decision ? multiply_exception : divide_exception;
endmodule