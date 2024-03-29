`timescale 1ns / 1ps

module clock_tb ();
  reg  clk_100MHz = 0;
  reg  reset = 0;
  reg  inc_sec = 0;
  reg  inc_hour = 0;
  reg  inc_min = 0;
  wire tick_1Hz;
  wire end_of_day;
  wire [7:0] sec, min, hour;

  clock dut (
      .clk_100MHz(clk_100MHz),
      .reset(reset),
      .inc_sec(inc_sec),
      .inc_min(inc_min),
      .inc_hour(inc_hour),
      .tick_1Hz(tick_1Hz),
      .end_of_day(end_of_day),
      .sec(sec),
      .min(min),
      .hour(hour)
  );

  parameter CLK_PERIOD = 10;

  always #(CLK_PERIOD / 2) begin
    clk_100MHz = ~clk_100MHz;
  end

  initial begin
    $dumpfile("./Simulate/clock.vcd");
    $dumpvars;
    reset = 1;
    #(CLK_PERIOD * 10);
    reset = 0;

    #(CLK_PERIOD * 50 * 250_000);
    $finish;
  end

endmodule
