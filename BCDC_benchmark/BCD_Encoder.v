// 
module BCD_Encoder(
  input wire clk,
  input wire[31:0] binary_input,
  input wire start,
  output reg[3:0] BCD[9:0], // 10 element array of 4 bits width  	
  output reg done
);
  
  reg[7:0] i;
  reg start_r = 1;
  
  // fixed 32-bit input length
  reg[7:0] length = 32;
  
//  always@(posedge start) begin
//  	start_r = 1;
//  end
  
  always@(posedge clk) begin
  
//    start_r <= start;
    
    if(start_r) begin
      //clear nibbles
      BCD[0] = 4'b0000;
      BCD[1] = 4'b0000;
      BCD[2] = 4'b0000;
      BCD[3] = 4'b0000;
      BCD[4] = 4'b0000;
      BCD[5] = 4'b0000;
      BCD[6] = 4'b0000;
      BCD[7] = 4'b0000;
      BCD[8] = 4'b0000;
      BCD[9] = 4'b0000;
      
      start_r = 0;
      i = length + 1;
      done = 0;
    end
    
    else if(i>0) begin
    //start conversion process
      
      //check value in each column to increment +3
      if(BCD[9]>=5) begin
        BCD[9] = BCD[9] + 4'd3;
      end
      if(BCD[8]>=5) begin
        BCD[8] = BCD[8] + 4'd3;
      end
      if(BCD[7]>=5) begin
        BCD[7] = BCD[7] + 4'd3;
      end
      if(BCD[6]>=5) begin
        BCD[6] = BCD[6] + 4'd3;
      end
      if(BCD[5]>=5) begin
        BCD[5] = BCD[5] + 4'd3;
      end
      if(BCD[4]>=5) begin
        BCD[4] = BCD[4] + 4'd3;
      end
      if(BCD[3]>=5) begin
        BCD[3] = BCD[3] + 4'd3;
      end
      if(BCD[2]>=5) begin
        BCD[2] = BCD[2] + 4'd3;
      end
      if(BCD[1]>=5) begin
        BCD[1] = BCD[1] + 4'd3;
      end
      if(BCD[0]>=5) begin
        BCD[0] = BCD[0] + 4'd3;
      end

      
      //left shift 1    
      BCD[9] = BCD[9] << 1;
      BCD[9][0] = BCD[8][3];
      
      BCD[8] = BCD[8] << 1;
      BCD[8][0] = BCD[7][3];
       
      BCD[7] = BCD[7] << 1;
      BCD[7][0] = BCD[6][3];

      BCD[6] = BCD[6] << 1;
      BCD[6][0] = BCD[5][3];

      BCD[5] = BCD[5] << 1;
      BCD[5][0] = BCD[4][3];

      BCD[4] = BCD[4] << 1;
      BCD[4][0] = BCD[3][3];

      BCD[3] = BCD[3] << 1;
      BCD[3][0] = BCD[2][3];

      BCD[2] = BCD[2] << 1;
      BCD[2][0] = BCD[1][3];

      BCD[1] = BCD[1] << 1;
      BCD[1][0] = BCD[0][3];

      BCD[0] = BCD[0] << 1;
      BCD[0][0] = binary_input[i-1];

	  i = i-1;//go to next input bit

    end
    
    else if(i==0) begin
      done=1;
    end

  end  //always

endmodule