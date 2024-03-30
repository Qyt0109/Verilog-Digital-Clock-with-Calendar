module vericlock (
    // System signals
    input clk_100MHz,  // 100 MHz frequency clock
    input reset,       // reset

    input        datetime,
    input        inc_enable,
    // clock module signals
    input        inc_0,
    input        inc_1,
    input        inc_2,
    input        tick,
    // input         inc_sec,     // sec++
    // input         inc_hour,    // hour++
    // input         inc_min,     // min++
    // output           tick_1Hz,    // 1 Hz frequency signal
    // output           end_of_day,  // End of the day signal
    // output [13:0] sec_7seg,    // 7 segment led display of sec's 2 decimal digits
    // output [13:0] min_7seg,    // 7 segment led display of min's 2 decimal digits
    // output [13:0] hour_7seg,   // 7 segment led display of hour's 2 decimal digits
    // calendar module signals
    // input         inc_day,     // day++
    // input         inc_month,   // month++
    // input         inc_year,    // year++
    // output [13:0] day_7seg,    // 7 segment led display of day's 2 decimal digits
    // output [13:0] month_7seg,  // 7 segment led display of month's 2 decimal digits
    // output [27:0] year_7seg    // 7 segment led display of year's 4 decimal digits 20xx
    output [6:0] seg7_0,
    output [6:0] seg7_1,

    output [6:0] seg7_2,
    output [6:0] seg7_3,

    output [6:0] seg7_4,
    output [6:0] seg7_5,
    output [6:0] seg7_6,
    output [6:0] seg7_7,

    output tick_1Hz_check,
    output inc_hour_check,
    output inc_min_check,
    output inc_sec_check,
    output inc_day_check,
    output inc_month_check,
    output inc_year_check
);
  wire inc_sec, inc_min, inc_hour, inc_day, inc_month, inc_year;
  reg [13:0] sec_7seg, min_7seg, hour_7seg, day_7seg, month_7seg, year_7seg, cen_7seg;

  assign inc_hour = (debounced_datetime == 1 && debounced_inc_enable == 1) ? ~debounced_inc_0 : 0;
  assign inc_min = (debounced_datetime == 1 && debounced_inc_enable == 1) ? ~debounced_inc_1 : 0;
  assign inc_sec = (debounced_datetime == 1 && debounced_inc_enable == 1) ? ~debounced_inc_2 : 1;

  assign inc_day = (debounced_datetime == 0 && debounced_inc_enable == 1) ? ~debounced_inc_0 : 0;
  assign inc_month = (debounced_datetime == 0 && debounced_inc_enable == 1) ? ~debounced_inc_1 : 0;
  assign inc_year = (debounced_datetime == 0 && debounced_inc_enable == 1) ? ~debounced_inc_2 : 0;

  //TODO: remove test led
  assign inc_hour_check = inc_hour;
  assign inc_min_check = inc_min;
  assign inc_sec_check = inc_sec;
  assign inc_day_check = inc_day;
  assign inc_month_check = inc_month;
  assign inc_year_check = inc_year;

  // Debounce the inc buttons
  wire debounced_inc_0, debounced_inc_1, debounced_inc_2, debounced_datetime, debounced_inc_enable, debounced_tick;

  debounce #(.DELAY(5))
      debounce_datetime (
          .clk(clk_100MHz),
          .signal(datetime),
          .debounced_signal(debounced_datetime)
      ),
      debounce_inc_enable (
          .clk(clk_100MHz),
          .signal(inc_enable),
          .debounced_signal(debounced_inc_enable)
      ),
      debounce_inc_inc_0 (
          .clk(clk_100MHz),
          .signal(inc_0),
          .debounced_signal(debounced_inc_0)
      ),
      debounce_inc_inc_1 (
          .clk(clk_100MHz),
          .signal(inc_1),
          .debounced_signal(debounced_inc_1)
      ),
      debounce_inc_inc_2 (
          .clk(clk_100MHz),
          .signal(inc_2),
          .debounced_signal(debounced_inc_2)
      );

  debounce
      debounce_inc_tick (
          .clk(clk_100MHz),
          .signal(tick),
          .debounced_signal(debounced_tick)
      );

  // 1Hz timer driven clk_100MHz to generate tick_1Hz signal
  wire tick_1Hz, timer_tick_1Hz;
  //FIX: check this
  assign tick_1Hz = (inc_enable == 1) ? debounced_tick : timer_tick_1Hz;  // timer_tick_1Hz;
  timer1hz timer (
      .clk_100MHz(clk_100MHz),
      .reset(~reset),
      .clk_1Hz(timer_tick_1Hz)
  );

  //TODO: remove this
  assign tick_1Hz_check = tick_1Hz;

  // clock module
  wire end_of_day;
  wire [7:0] sec;
  wire [7:0] min;
  wire [7:0] hour;
  clock clock_inst (
      // .clk_100MHz(clk_100MHz),
      .reset(~reset),
      .tick_1Hz(tick_1Hz),
      .inc_sec(inc_sec),
      .inc_min(inc_min),
      .inc_hour(inc_hour),
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
      .reset(~reset),
      .tick_1Hz(tick_1Hz),
      .end_of_day(end_of_day),
      .inc_day(inc_day),
      .inc_month(inc_month),
      .inc_year(inc_year),
      .day(day),
      .month(month),
      .year(year)
  );

  // Binary to BCD
  wire [7:0] hex_01, hex_23, hex_45, hex_67;
  wire [7:0] bcd_01, bcd_23, bcd_45, bcd_67;

  assign hex_01 = (debounced_datetime == 1) ? hour : day;

  assign hex_23 = (debounced_datetime == 1) ? min : month;

  assign hex_45 = (debounced_datetime == 1) ? sec : 8'd20;
  assign hex_67 = (debounced_datetime == 1) ? 0 : year;

  bin2bcd
      bin2bcd_hex01 (
          .bin(hex_01),
          .bcd(bcd_01)
      ),
      bin2bcd_hex23 (
          .bin(hex_23),
          .bcd(bcd_23)
      ),
      bin2bcd_hex45 (
          .bin(hex_45),
          .bcd(bcd_45)
      ),
      bin2bcd_hex67 (
          .bin(hex_67),
          .bcd(bcd_67)
      );

  wire [13:0] bcd_67_datetimes;
  assign {seg7_6, seg7_7} = (debounced_datetime == 1) ? 14'b11111111111111 : bcd_67_datetimes;
  seg7led
      sec_7seg_0 (
          .hex(bcd_01[7:4]),
          .led_control(seg7_0)
      ),
      sec_7seg_1 (
          .hex(bcd_01[3:0]),
          .led_control(seg7_1)
      ),

      sec_7seg_2 (
          .hex(bcd_23[7:4]),
          .led_control(seg7_2)
      ),
      sec_7seg_3 (
          .hex(bcd_23[3:0]),
          .led_control(seg7_3)
      ),

      sec_7seg_4 (
          .hex(bcd_45[7:4]),
          .led_control(seg7_4)
      ),
      sec_7seg_5 (
          .hex(bcd_45[3:0]),
          .led_control(seg7_5)
      ),
      sec_7seg_6 (
          .hex(bcd_67[7:4]),
          .led_control(bcd_67_datetimes[13:7])
      ),
      sec_7seg_7 (
          .hex(bcd_67[3:0]),
          .led_control(bcd_67_datetimes[6:0])
      );
endmodule
