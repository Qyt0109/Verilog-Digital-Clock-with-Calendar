module seg7led (
    input      [3:0] hex,         // 4-bit data
    output reg [6:0] led_control  // abcdefg led segment
);
  always @(hex) begin
    case (hex)
      4'b0000: led_control <= 7'b0000001;  // 0
      4'b0001: led_control <= 7'b1001111;  // 1
      4'b0010: led_control <= 7'b0010010;  // 2
      4'b0011: led_control <= 7'b0000110;  // 3
      4'b0100: led_control <= 7'b1001100;  // 4
      4'b0101: led_control <= 7'b0100100;  // 5
      4'b0110: led_control <= 7'b0100000;  // 6
      4'b0111: led_control <= 7'b0001111;  // 7
      4'b1000: led_control <= 7'b0000000;  // 8
      4'b1001: led_control <= 7'b0000100;  // 9

      4'b1010: led_control <= 7'b0001000;  // A
      4'b1011: led_control <= 7'b0011000;  // P

      4'b1100: led_control <= 7'b1111110;  // -

      4'b1111: led_control <= 7'b1111111;  // off
      default: begin
        led_control <= 7'b0110110; // - - -
      end
    endcase
  end

endmodule  //seg7led
