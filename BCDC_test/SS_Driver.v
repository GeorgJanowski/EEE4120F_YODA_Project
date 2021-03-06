//------------------------------------------------------------------------------
// Seven Segment Driver
// Displays 8 BCD digits on a seven segment display
// Based on code provided for EEE4120F prac4 (this only worked with 4 digits)
//------------------------------------------------------------------------------

module SS_Driver(
    input Clk, Reset,
    input [3:0] BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0, // Binary-coded decimal input
    output reg [7:0] SegmentDrivers, // Digit drivers (active low)
    output reg [7:0] SevenSegment // Segments (active low)
);


// Make use of a subcircuit to decode the BCD to seven-segment (SS)
wire [6:0]SS[7:0];
BCD_Decoder BCD_Decoder0 (BCD0, SS[0]);
BCD_Decoder BCD_Decoder1 (BCD1, SS[1]);
BCD_Decoder BCD_Decoder2 (BCD2, SS[2]);
BCD_Decoder BCD_Decoder3 (BCD3, SS[3]);
BCD_Decoder BCD_Decoder4 (BCD4, SS[4]);
BCD_Decoder BCD_Decoder5 (BCD5, SS[5]);
BCD_Decoder BCD_Decoder6 (BCD6, SS[6]);
BCD_Decoder BCD_Decoder7 (BCD7, SS[7]);


// Counter to reduce the 100 MHz clock to 762.939 Hz (100 MHz / 2^17)
reg [16:0]Count;

// Scroll through the digits, switching one on at a time
always @(posedge Clk) begin
 Count <= Count + 1'b1; 
 if ( Reset) SegmentDrivers <= 8'hFE;
 else if(&Count) SegmentDrivers <= {SegmentDrivers[6:0], SegmentDrivers[7]};
end

//------------------------------------------------------------------------------
always @(*) begin // This describes a purely combinational circuit
    SevenSegment[7] <= 1'b1; // Decimal point always off
    if (Reset) begin
        SevenSegment[6:0] <= 7'h7F; // All off during Reset
    end else begin
        case(~SegmentDrivers) // Connect the correct signals,
            8'h01 : SevenSegment[6:0] <= ~SS[0]; // depending on which digit is on at
            8'h02 : SevenSegment[6:0] <= ~SS[1]; // this point
            8'h04 : SevenSegment[6:0] <= ~SS[2];
            8'h08 : SevenSegment[6:0] <= ~SS[3];
            8'h10 : SevenSegment[6:0] <= ~SS[4];
            8'h20 : SevenSegment[6:0] <= ~SS[5];
            8'h40 : SevenSegment[6:0] <= ~SS[6];
            8'h80 : SevenSegment[6:0] <= ~SS[7];
            default: SevenSegment[6:0] <= 7'h00;
        endcase
    end
end

endmodule
