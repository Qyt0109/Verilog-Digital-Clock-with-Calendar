module timer1hz (
    input      clk_100MHz,  // 100 MHz frequency clock
    input      reset,       // reset
    output reg clk_1Hz      // // 1 Hz frequency clock
);

  reg [31:0] counter_1hz = 0;  // Count 50M time of clk_100MHz to toggle clk_1Hz signal

  always @(posedge clk_100MHz or posedge reset) begin
    if (reset) begin
      counter_1hz <= 0;
      clk_1Hz <= 0;
    end else if (counter_1hz == 49_999_999) begin
      counter_1hz <= 0;
      clk_1Hz = ~clk_1Hz;
    end else begin
      counter_1hz <= counter_1hz + 1;
    end
  end

endmodule  //timer1hz
