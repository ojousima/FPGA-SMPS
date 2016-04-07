module input_capture #(parameter CAP_LEN = 8) (
    input clk,
    input rst,
    input [CAP_LEN - 1 : 0] compare, //compare register
    input capture_in, //physical pin to measure
    output [7:0] capture, //register value
    output overflow //error
  );
  
  reg [CAP_LEN : 0] cap_d, cap_q;
  reg run; //Store data on should we run
  
  assign overflow = cap_q [8];     //set overflow error flag
  assign capture [7:0] = cap_q[7:0]; //Show length of captured pulse
  
//Base frequency of 50MHz for counter
// 5.12 uS before counter overflows
  always @(*) begin
    cap_d = cap_q + 1'b1;
  end

  //Increment input capture req on every cycle.
  always @(posedge clk) begin
    if (run == 1)
      cap_q <= cap_d;
  end
  
  //capture rising edge, reset counter, start running counter
  always @(posedge capture_in && run == 0) begin
    cap_q <= 0;
    run <= 1'b1;
  end
  
  //capture falling edge, freeze counter
  always@(negedge capture_in) begin
    run <= 1'b0;
  end
  
endmodule  