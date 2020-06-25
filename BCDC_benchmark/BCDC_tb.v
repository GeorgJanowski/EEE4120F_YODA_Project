// Tesbench for BCD_Encoder
module BCDC_tb();
  //inputs
  reg clk = 0;
  reg reset = 0;
  
  //outputs
  wire done;
  
  // UUT
  BCDC bcdc(clk, reset, done);
  
  integer i = 0;
  
  initial begin
    // column headers
    $display("i \t clk \t reset \t done");
    
    // monitor to see when conversion is complete
    $monitor("%d \t%b \t%b \t%b", i, clk, reset, done);
    
    // toggle clock 100 times
    repeat (100) begin
      #100 clk = !clk; #100 clk = !clk;
      i = i + 1;
    end
    
    // toggle clock until conversion is complete
//    while (done==0) begin
//      #100 clk = !clk; #100 clk = !clk;
//      i = i + 1;
//    end
    
  end
  
endmodule