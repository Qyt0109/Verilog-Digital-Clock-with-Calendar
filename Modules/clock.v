module clock (
    input        clk_100MHz,  // 100 MHz frequency clock
    input        reset,       // reset
    input        inc_sec,     // sec++
    input        inc_hour,    // hour++
    input        inc_min,     // min++
    output       tick_1Hz,    // 1 Hz frequency signal
    output       end_of_day,  // End of the day signal
    output [7:0] sec,         // sec
    output [7:0] min,         // min
    output [7:0] hour         // hour
);

  // Debounce the inc buttons
  wire debounced_inc_sec, debounced_inc_min, debounced_inc_hour;

  debounce
      debounce_inc_sec (
          .clk(clk_100MHz),
          .signal(inc_sec),
          .debounced_signal(debounced_inc_sec)
      ),
      debounce_inc_min (
          .clk(clk_100MHz),
          .signal(inc_min),
          .debounced_signal(debounced_inc_min)
      ),
      debounce_inc_hour (
          .clk(clk_100MHz),
          .signal(inc_hour),
          .debounced_signal(debounced_inc_hour)
      );

  // Default time is 00:00:00
  parameter DEFAULT_SEC_VALUE = 0;
  parameter DEFAULT_MIN_VALUE = 0;
  parameter DEFAULT_HOUR_VALUE = 0;

endmodule  //clock
