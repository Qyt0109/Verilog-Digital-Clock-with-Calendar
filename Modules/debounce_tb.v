`timescale 1ns / 1ps

module debounce_tb ();
  reg  clk = 0;
  reg  signal = 0;
  wire debounced_signal;

  debounce dut (
      .clk(clk),
      .signal(signal),
      .debounced_signal(debounced_signal)
  );

  parameter CLK_PERIOD = 10;
  reg [15:0] noise_index;

  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    // $dumpfile("./Simulate/debounce.vcd");
    // $dumpvars;
    signal = 0;
    #(CLK_PERIOD * 2);
    // Simulate 10 ns noisy rising signal
    for (noise_index = 0; noise_index < 10; noise_index = noise_index + 1) begin
      signal = $urandom_range(1);
      #1;
    end
    signal = 1;
  end

  initial #(CLK_PERIOD * 5) $finish;
endmodule
