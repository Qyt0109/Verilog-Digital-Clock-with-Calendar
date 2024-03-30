module debounce #(
  parameter DELAY = 1
) (
    input      clk,
    input      signal,
    output debounced_signal
);
  reg [DELAY:0] delayed_signal = 0;
  assign debounced_signal = delayed_signal[DELAY];
  always @(posedge clk) begin
    delayed_signal   <= {delayed_signal[DELAY-1:0], signal};
  end
endmodule
