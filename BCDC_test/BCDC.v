// Top Level Module
// Implements Binary Coded Decimal Converter

module BCDC(
    //inputs
    input clock,            // clock
    input reset,            // reset

	//outputs
	output [15:0]leds,       // leds
	output reg[7:0] sseg,   // seven segment display
	output reg[7:0] sseg_an // seven segment display
);

    // add reset
    wire Reset_wire;
    reg Reset;
    Delay_Reset delay_reset(.Clk(clock), .BTNS(reset), .Reset(Reset_wire));
  
    // setup BCD_Encoder module
    reg[31:0] bcd_input = 32'd12345678;
    reg[7:0] bcd_length = 8'd24;
    wire [3:0]bcd_output[7:0];
    wire bcd_done;
    wire bcd_high;
    BCD_Encoder bcd_encoder(
        .clk(clock),
        .binary_input(bcd_input),
        .length(bcd_length),
        .BCD(bcd_output),
        .done(bcd_done),
        .high(bcd_high)
    );
    
    // Test module
    reg x = 1'b0;
    wire y;
    Test test( .x(x), .y(y));
    

    // registers for storing the time
    reg [3:0]hours1=4'd0;
	reg [3:0]hours2=4'd0;
	reg [3:0]mins1=4'd0;
	reg [3:0]mins2=4'd0;
	
    
	//Initialize seven segment display
	wire[7:0] sseg_an_wire;
	wire[7:0] sseg_wire;
	SS_Driver SS_Driver1(
		.Clk(clock), .Reset(Reset), //<clock_signal>, <reset_signal>,
		.BCD0(bcd_output[0]), .BCD1(bcd_output[1]), .BCD2(bcd_output[2]), .BCD3(bcd_output[3]),
		.BCD4(bcd_output[4]), .BCD5(bcd_output[5]), .BCD6(bcd_output[6]), .BCD7(bcd_output[7]),
		.SegmentDrivers(sseg_an_wire),
		.SevenSegment(sseg_wire)
	);
	
	// Clock timer
	reg [26:0]second_len = 1677721; // length of a 'second' 16777216
	reg [26:0]clkdiv = 0; 
	reg [5:0]seconds = 0;
	
	//The main logic
	always @(posedge clock) begin
	   
	    Reset <= !Reset_wire; // reset active low
	   
        sseg_an <= sseg_an_wire;
        sseg <= sseg_wire;
        
        // increment clock
		clkdiv <= clkdiv + 1;
		if (clkdiv > second_len) begin
		  clkdiv <= 0;
		  if (seconds == 59) begin
		    if (mins2 == 9) begin
		      if (mins1 == 5) begin
		        
		        // end of day
		        if (hours1 == 2 && hours2 == 3) begin
		          hours2 <= 0;
		          hours1 <= 0;
		        end
		        
		        // end of 10 hours
		        else if (hours2 == 9) begin
		          hours1 <= hours1 + 1;
		          hours2 <= 0;
		        end
		        
		        // end of hour
		        else begin
		          hours2 <= hours2 + 1;
		        end
		        
		        mins1 <= 0;
		      end else begin
		        mins1 <= mins1 + 1;
		      end
		      mins2 <= 0;
		    end else begin
		      mins2 <= mins2 + 1;
		    end
		    seconds <= 0;
		  end else begin
		    seconds <= seconds + 1;
		  end
	    end
	end
	
	assign leds[15] = bcd_done;
	assign leds[14] = y;
	assign leds[13] = ~y;
	assign leds[12] = bcd_high;
	assign leds[11:8] = 4'b1010;
	assign leds[7:0] = {bcd_output[0], bcd_output[7]};
	

endmodule