module debounce (
    input      clk,
    input      signal,
    output reg debounced_signal
);
  reg delayed_signal = 0;
  always @(posedge clk) begin
    delayed_signal   <= signal;
    debounced_signal <= delayed_signal;
  end
endmodule
