module calendar (
    // System signals
    // input            clk_100MHz,  // 100 MHz frequency clock
    input            reset,       // reset
    // clock module signals
    input            tick_1Hz,    // 1 Hz frequency signal from clock module
    input            end_of_day,  // End of the day signal from clock module
    // calendar module signals
    input            inc_day,     // day++
    input            inc_month,   // month++
    input            inc_year,    // year++
    output reg [7:0] day,         // day
    output reg [7:0] month,       // month
    output reg [7:0] year         // year
);

  // Default date is 01/09/2001
  parameter DEFAULT_DAY_VALUE = 1;
  parameter DEFAULT_MONTH_VALUE = 9;
  parameter DEFAULT_YEAR_VALUE = 23;

  // Calendar logic
  wire end_of_year;
  assign end_of_year = ((month == 12 && day == 31) & end_of_day) ? 1 : 0;   // end_of_year = (31/12) ? AND end_of_day

  wire leap_year;
  assign leap_year = (year % 4 == 0) ? 1 : 0;

  // Day control
  always @(posedge tick_1Hz or posedge inc_day or posedge reset) begin
    // reset
    if (reset) day = DEFAULT_DAY_VALUE;
    // If inc day button is pressed or end of day signal from clock, inc day value
    else if (inc_day) begin
      case (month)
        1: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        // month == 2 is a speacial case, which the last day of the month depended on is this a leap year or not
        2: begin
          if (leap_year && day == 29) day <= 1;
          if (~leap_year && day == 28) day <= 1;
          else day <= day + 1;
        end

        3: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        4: begin
          if (day == 30) day <= 1;
          else day <= day + 1;
        end

        5: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        6: begin
          if (day == 30) day <= 1;
          else day <= day + 1;
        end

        7: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        8: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        9: begin
          if (day == 30) day <= 1;
          else day <= day + 1;
        end

        10: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        11: begin
          if (day == 30) day <= 1;
          else day <= day + 1;
        end

        12: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        default: day <= 1;
      endcase
    end else if (end_of_day) begin
      case (month)
        1: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        // month == 2 is a speacial case, which the last day of the month depended on is this a leap year or not
        2: begin
          if (leap_year && day == 29) day <= 1;
          if (~leap_year && day == 28) day <= 1;
          else day <= day + 1;
        end

        3: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        4: begin
          if (day == 30) day <= 1;
          else day <= day + 1;
        end

        5: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        6: begin
          if (day == 30) day <= 1;
          else day <= day + 1;
        end

        7: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        8: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        9: begin
          if (day == 30) day <= 1;
          else day <= day + 1;
        end

        10: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        11: begin
          if (day == 30) day <= 1;
          else day <= day + 1;
        end

        12: begin
          if (day == 31) day <= 1;
          else day <= day + 1;
        end

        default: day <= 1;
      endcase
    end
  end

  // Month control
  always @(posedge tick_1Hz or posedge inc_month or posedge reset) begin
    // reset
    if (reset) month = DEFAULT_MONTH_VALUE;
    // forced inc month by pushing inc month button
    else if (inc_month) begin
      if (month == 12) month <= 1;
      else month <= month + 1;
    end  // inc month based on current day/month
    else if ((month == 1 && day == 31) & end_of_day)
      month <= 2;
    else if ((month == 2 && day == 28) & ~leap_year & end_of_day) month <= 3;
    else if ((month == 2 && day == 29) & leap_year & end_of_day) month <= 3;
    else if ((month == 3 && day == 31) & end_of_day) month <= 4;
    else if ((month == 4 && day == 30) & end_of_day) month <= 5;
    else if ((month == 5 && day == 31) & end_of_day) month <= 6;
    else if ((month == 6 && day == 30) & end_of_day) month <= 7;
    else if ((month == 7 && day == 31) & end_of_day) month <= 8;
    else if ((month == 8 && day == 31) & end_of_day) month <= 9;
    else if ((month == 9 && day == 30) & end_of_day) month <= 10;
    else if ((month == 10 && day == 31) & end_of_day) month <= 11;
    else if ((month == 11 && day == 30) & end_of_day) month <= 12;
    // loop back to first month if end of the year
    else if (end_of_year & end_of_day) month <= 1;
  end

  // Year control
  always @(posedge tick_1Hz or posedge inc_year or posedge reset) begin
    // reset
    if (reset) year = DEFAULT_YEAR_VALUE;
    // inc year if inc year button is pressed or end of year signal is trigged
    else if (inc_year) begin
      year <= (year == 99) ? 0 : year + 1;
    end else if (end_of_year) begin
      year <= (year == 99) ? 0 : year + 1;
    end
  end

endmodule
