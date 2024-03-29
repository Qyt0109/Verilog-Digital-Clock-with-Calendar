`timescale 1ns / 1ps

module bin2bcd_tb ();
  reg  [7:0] bin;
  wire [7:0] bcd;

  bin2bcd dut (
      .bin(bin),
      .bcd(bcd)
  );

  initial begin
    // $dumpfile("./Simulate/bin2bcd.vcd");
    // $dumpvars;
    bin <= 6'b100100;  // 36 --> 0011 0110
    #10;
    bin <= 6'b011011;  // 27 --> 0010 0111
  end

  // initial #20 $finish;

endmodule  //bin2bcd_tb
