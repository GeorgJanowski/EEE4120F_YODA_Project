// Tesbench for BCD_Encoder
module BCD_Encoder_tb();
  //inputs
  reg clk = 0;
  reg[31:0] binary = 0;
  reg[7:0] length = 0;
  
  //outputs
  wire[3:0] BCD[7:0];
  wire done;
  
  
  BCD_Encoder encoder(clk, binary, length, BCD, done);
  
  initial begin
    $display("clk \t done \t BCD7 \t BCD6 \T\t BCD5 \t BCD4 \t BCD3 \t BCD2 \t BCD1 \t BCD0");
    
    $monitor("%b \t%b \t%b \t%b \t%b \t%b \t%b \t%b \t%b \t%b ",clk,  done, BCD[7], BCD[6], BCD[5], BCD[4], BCD[3], BCD[2], BCD[1], BCD[0]);
    
    //test with 3 digit input
    length = 8;
    binary = 8'd162;
    
    repeat (100) begin
      #2 clk = !clk;
    end
    
    //test with 8 digit input
    binary = 12345678;
  	length = 24;
    #2 clk = !clk;
    
    while (done==0) begin
      #2 clk = !clk;
    end
    
  end
  
endmodule