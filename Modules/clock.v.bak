module clock (
    // System signals
    // input            clk_100MHz,  // 100 MHz frequency clock
    input            reset,       // reset
    // clock module signals
    input            tick_1Hz,    // 1 Hz frequency signal
    input            inc_sec,     // sec++
    input            inc_hour,    // hour++
    input            inc_min,     // min++
    output           end_of_day,  // End of the day signal
    output reg [7:0] sec,         // sec
    output reg [7:0] min,         // min
    output reg [7:0] hour         // hour
);

  // Default time is 00:00:00
  parameter DEFAULT_SEC_VALUE = 0;
  parameter DEFAULT_MIN_VALUE = 0;
  parameter DEFAULT_HOUR_VALUE = 0;

  // sec control
  // inc sec if tick or inc sec button pressed
  always @(posedge tick_1Hz or posedge inc_sec or posedge reset) begin
    if (reset) sec <= DEFAULT_SEC_VALUE;
    else if (sec == 59) sec <= 0;
    else sec <= sec + 1;
  end

  // min control
  always @(posedge tick_1Hz or posedge inc_min or posedge reset) begin
    if (reset) min <= DEFAULT_MIN_VALUE;
    // sec = 59 or inc min button pressed
    else if (inc_min | sec == 59) begin
      if (min == 59) min <= 0;
      else min <= min + 1;
    end
  end

  // hour control
  always @(posedge tick_1Hz or posedge inc_hour or posedge reset) begin
    if (reset) hour <= DEFAULT_HOUR_VALUE;
    // min:sec = 59:59 or inc hour button pressed
    else if (inc_hour | (min == 59 && sec == 59)) begin
      // 23:59:59 --> 00:00:00
      if (hour == 23) hour <= 0;
      else hour <= hour + 1;
    end
  end

  assign end_of_day = ((hour == 23) && (min == 59) && (sec == 59)) ? 1 : 0;

endmodule  //clock
