`timescale 1ns / 1ps

module timer1hz_tb ();

  reg  clk_100MHz = 0;
  reg  reset = 0;
  wire clk_1Hz;

  timer1hz #(
      .MAX_COUNT(49)
  ) dut (
      .clk_100MHz(clk_100MHz),
      .reset(reset),
      .clk_1Hz(clk_1Hz)
  );

  parameter CLK_PERIOD = 10;  // 100MHz clock = 10ns period
  always #((CLK_PERIOD) / 2) clk_100MHz = ~clk_100MHz;

  initial begin
    // Reduce 49_999_999 to 49 for simulating purpose
    // $dumpfile("./Simulate/timer1hz.vcd");
    // $dumpvars;
    reset = 1;
    #(CLK_PERIOD * 10);
    reset = 0;
    #(CLK_PERIOD * 100);
    #(CLK_PERIOD * 24);
    reset = 1;
    #(CLK_PERIOD * 6);
    reset = 0;
    #(CLK_PERIOD * 200);
    $finish;
  end

  // initial #(CLK_PERIOD * 400) $finish;
endmodule
