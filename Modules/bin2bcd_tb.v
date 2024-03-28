`timescale 1ns / 1ps

module bin2bcd_tb ();
  reg  [7:0] bin;
  wire [7:0] bcd;

  bin2bcd dut (
      .bin(bin),
      .bcd(bcd)
  );

  initial begin
    bin <= 6'b100100;  // 36
    #10 bin <= 6'b011011;  // 27
  end

endmodule  //bin2bcd_tb
