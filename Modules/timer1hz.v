module timer1hz (
    input  clk_100MHz,  // 100 MHz frequency clock
    input  reset,       // reset
    output clk_1Hz      // // 1 Hz frequency clock
);
  parameter MAX_COUNT =  50_000_000 / 2 - 1;

  reg r_clk_1Hz = 1'b0;

  assign clk_1Hz = r_clk_1Hz;

  reg [31:0] counter_1hz = 0;  // Count 50M time of clk_100MHz to toggle clk_1Hz signal

  always @(posedge clk_100MHz or posedge reset) begin
    if (reset) begin
      counter_1hz <= 0;
      r_clk_1Hz   <= 1'b0;
    end else if (counter_1hz == 50_000_000 / 2 - 1) begin
      counter_1hz <= 0;
      r_clk_1Hz = ~r_clk_1Hz;
    end else begin
      counter_1hz <= counter_1hz + 1;
    end
  end

endmodule  //timer1hz
