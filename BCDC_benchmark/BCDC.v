// Top Level Module
// Implements Binary Coded Decimal Converter to be benchmarked
// Timing and Display is removed

module BCDC(
    // inputs
    input clock,            // clock
    input reset,            // reset
    // outputs
    output reg done
);
    
    // add reset
    wire Reset_wire;
    reg Reset;
    Delay_Reset delay_reset(.Clk(clock), .BTNS(reset), .Reset(Reset_wire));
    
    // parameters
    parameter num_numbers = 10;      // number of numbers to convert
    parameter input_bits = 32;      // length of binary input
    parameter output_bits = 40;     // length of BCD output
    
    // input array
    reg [input_bits-1:0] input_array[num_numbers-1:0];
    
    // output array
    wire [output_bits-1:0] output_array[num_numbers-1:0];
    
    // initialize input array
    assign input_array[0] = 0;
    assign input_array[1] = 1;
    assign input_array[2] = 2;
    assign input_array[3] = 3;
    assign input_array[4] = 4;
    assign input_array[5] = 5;
    assign input_array[6] = 6;
    assign input_array[7] = 7;
    assign input_array[8] = 8;
    assign input_array[9] = 9;
    
    // tells BCD_Encoder to start conversion
    reg[num_numbers-1:0] start_array = 0;
    
    // goes high when conversion is complete
    wire[num_numbers-1:0] done_array;
    
    // implement multiple BCD_Encoder modules
    BCD_Encoder bcd_encoder[num_numbers-1:0](
        .clk(clock),
        .binary_input(input_array),
        .start(start_array),
        .BCD(output_array),
        .done(done_array)
    );
    
    // test with single module
//    reg [input_bits-1:0] input_test;    // input
//    wire [3:0] output_test[9:0];  // output
//    wire done_test;
//    assign input_array[0] = 123457890;         // initialize input
    
//    BCD_Encoder bcd_encoder(
//        .clk(clock),
//        .binary_input(input_test),
//        .BCD(output_test),
//        .done(done_test)
//    );
	
	//The main logic
	always @(posedge clock) begin
	    Reset <= !Reset_wire; // reset active low
	    
	    done <= &done_array;
	end

endmodule