module clock (
    // System signals
    // input            clk_100MHz,  // 100 MHz frequency clock
    input        reset,       // reset
    // clock module signals
    input        tick_1Hz,    // 1 Hz frequency signal
    input        inc_sec,     // sec++
    input        inc_hour,    // hour++
    input        inc_min,     // min++
    output       end_of_day,  // End of the day signal
    output [7:0] sec,         // sec
    output [7:0] min,         // min
    output [7:0] hour         // hour
);

  // Default time is 00:00:00
  parameter DEFAULT_SEC_VALUE = 0;
  parameter DEFAULT_MIN_VALUE = 0;
  parameter DEFAULT_HOUR_VALUE = 0;

  reg [7:0] r_sec = DEFAULT_SEC_VALUE;
  reg [7:0] r_min = DEFAULT_MIN_VALUE;
  reg [7:0] r_hour = DEFAULT_HOUR_VALUE;

  assign sec  = r_sec;
  assign min  = r_min;
  assign hour = r_hour;

  // sec control
  // inc sec if tick or inc sec button pressed
  always @(posedge tick_1Hz or posedge reset) begin
    if (reset) r_sec <= DEFAULT_SEC_VALUE;
    else if (inc_sec) r_sec <= (r_sec == 59) ? 0 : r_sec + 1;
  end

  // min control
  always @(posedge tick_1Hz or posedge reset) begin
    if (reset) r_min <= DEFAULT_MIN_VALUE;
    // sec = 59 or inc min button pressed
    else if (inc_min | r_sec == 59) begin
      r_min <= (r_min == 59) ? 0 : r_min + 1;
    end
  end

  // hour control
  always @(posedge tick_1Hz or posedge reset) begin
    if (reset) r_hour <= DEFAULT_HOUR_VALUE;
    // min:sec = 59:59 or inc hour button pressed
    else if (inc_hour | ((r_min == 59) && (r_sec == 59))) begin
      r_hour <= (r_hour == 23) ? 0 : r_hour + 1;
    end
  end

  assign end_of_day = ((hour == 23) && (min == 59) && (sec == 59)) ? 1 : 0;

endmodule  //clock
