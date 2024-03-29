module vericlock (
    // System signals
    input         clk_100MHz,  // 100 MHz frequency clock
    input         reset,       // reset
    // clock module signals
    input         inc_sec,     // sec++
    input         inc_hour,    // hour++
    input         inc_min,     // min++
    // output           tick_1Hz,    // 1 Hz frequency signal
    // output           end_of_day,  // End of the day signal
    output [13:0] sec_7seg,    // 7 segment led display of sec's 2 decimal digits
    output [13:0] min_7seg,    // 7 segment led display of min's 2 decimal digits
    output [13:0] hour_7seg,   // 7 segment led display of hour's 2 decimal digits
    // calendar module signals
    input         inc_day,     // day++
    input         inc_month,   // month++
    input         inc_year,    // year++
    output [13:0] day_7seg,    // 7 segment led display of day's 2 decimal digits
    output [13:0] month_7seg,  // 7 segment led display of month's 2 decimal digits
    output [27:0] year_7seg    // 7 segment led display of year's 4 decimal digits 20xx
);

  // Debounce the inc buttons
  wire debounced_inc_sec, debounced_inc_min, debounced_inc_hour, debounced_inc_day, debounced_inc_month, debounced_inc_year;

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
      ),
      debounce_inc_day (
          .clk(clk_100MHz),
          .signal(inc_day),
          .debounced_signal(debounced_inc_day)
      ),
      debounce_inc_month (
          .clk(clk_100MHz),
          .signal(inc_month),
          .debounced_signal(debounced_inc_month)
      ),
      debounce_inc_year (
          .clk(clk_100MHz),
          .signal(inc_year),
          .debounced_signal(debounced_inc_year)
      );

  // 1Hz timer driven clk_100MHz to generate tick_1Hz signal
  wire tick_1Hz;
  timer1hz timer (
      .clk_100MHz(clk_100MHz),
      .reset(reset),
      .clk_1Hz(tick_1Hz)
  );

  // clock module
  wire end_of_day;
  wire [7:0] sec;
  wire [7:0] min;
  wire [7:0] hour;
  clock clock_inst (
      // .clk_100MHz(clk_100MHz),
      .reset(reset),
      .tick_1Hz(tick_1Hz),
      .inc_sec(debounced_inc_sec),
      .inc_min(debounced_inc_min),
      .inc_hour(debounced_inc_hour),
      .end_of_day(end_of_day),
      .sec(sec),
      .min(min),
      .hour(hour)
  );

  // calendar module
  wire [7:0] day;
  wire [7:0] month;
  wire [7:0] year;
  calendar calendar_inst (
      // .clk_100MHz(clk_100MHz),
      .reset(reset),
      .tick_1Hz(tick_1Hz),
      .end_of_day(end_of_day),
      .inc_day(debounced_inc_day),
      .inc_month(debounced_inc_month),
      .inc_year(debounced_inc_year),
      .day(day),
      .month(month),
      .year(year)
  );

  // Binary to BCD
  wire [7:0] sec_bcd, min_bcd, hour_bcd, day_bcd, month_bcd, year_bcd;
  bin2bcd
      bin2bcd_sec (
          .bin(sec),
          .bcd(sec_bcd)
      ),
      bin2bcd_min (
          .bin(min),
          .bcd(min_bcd)
      ),
      bin2bcd_hour (
          .bin(hour),
          .bcd(hour_bcd)
      ),
      bin2bcd_day (
          .bin(day),
          .bcd(day_bcd)
      ),
      bin2bcd_month (
          .bin(month),
          .bcd(month_bcd)
      ),
      bin2bcd_year (
          .bin(year),
          .bcd(year_bcd)
      );

  // BCD to 7 segment led control
  seg7led
      // Sec
      seg7led_sec_high (
          .hex(sec_bcd[7:4]),
          .led_control(sec_7seg[13:7])
      ),
      seg7led_sec_low (
          .hex(sec_bcd[3:0]),
          .led_control(sec_7seg[6:0])
      ),
      // Min
      seg7led_min_high (
          .hex(min_bcd[7:4]),
          .led_control(min_7seg[13:7])
      ),
      seg7led_min_low (
          .hex(min_bcd[3:0]),
          .led_control(min_7seg[6:0])
      ),
      // Hour
      seg7led_hour_high (
          .hex(hour_bcd[7:4]),
          .led_control(hour_7seg[13:7])
      ),
      seg7led_hour_low (
          .hex(hour_bcd[3:0]),
          .led_control(hour_7seg[6:0])
      ),
      // Day
      seg7led_day_high (
          .hex(day_bcd[7:4]),
          .led_control(day_7seg[13:7])
      ),
      seg7led_day_low (
          .hex(day_bcd[3:0]),
          .led_control(day_7seg[6:0])
      ),
      // Month
      seg7led_month_high (
          .hex(month_bcd[7:4]),
          .led_control(month_7seg[13:7])
      ),
      seg7led_month_low (
          .hex(month_bcd[3:0]),
          .led_control(month_7seg[6:0])
      ),
      // Year
      seg7led_year_high (
          .hex(year_bcd[7:4]),
          .led_control(year_7seg[13:7])
      ),
      seg7led_year_low (
          .hex(year_bcd[3:0]),
          .led_control(year_7seg[6:0])
      );
endmodule