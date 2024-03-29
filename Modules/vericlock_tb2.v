`timescale 1ns / 1ps

module vericlock_tb ();
  reg  clk_100MHz = 0;
  reg  reset = 0;
  reg  inc_sec = 0;
  reg  inc_hour = 0;
  reg  inc_min = 0;
  wire [13:0] sec_7seg, min_7seg, hour_7seg;

  reg inc_day = 0;
  reg inc_month = 0;
  reg inc_year = 0;
  wire [13:0] day_7seg, month_7seg;
  wire [27:0] year_7seg;

  vericlock dut (
      .clk_100MHz(clk_100MHz),
      .reset(reset),
      .inc_sec(inc_sec),
      .inc_min(inc_min),
      .inc_hour(inc_hour),
      .sec_7seg(sec_7seg),
      .min_7seg(min_7seg),
      .hour_7seg(hour_7seg)
  );

  parameter CLK_PERIOD = 10;

  always #(CLK_PERIOD / 2) begin
    clk_100MHz = ~clk_100MHz;
  end

  initial begin
    $dumpfile("./Simulate/vericlock.vcd");
    $dumpvars;
    reset = 1;
    #(CLK_PERIOD * 10);
    reset = 0;

    #(CLK_PERIOD * 50 * 250_000);
    $finish;
  end

endmodule
