module counter #(
    parameter MAX_COUNT = 6'd6,
    parameter NUMBER_OF_BIT = 6
) (
    input                          rst,
    input                          tick_up,
    input                          tick_down,
    output reg                     max,
    output reg                     min,
    output reg [NUMBER_OF_BIT-1:0] count
);
  always @(posedge tick_up or posedge tick_down or posedge rst) begin
    if (rst) count <= 0;
    else begin
      if (tick_up) begin
        count = count + 1;
        if (count == MAX_COUNT) count = 0;
      end
      if (tick_down) begin
        count = count - 1;
        if (count <= 0) count = 0;
      end
    end
  end

  always @(count) begin
    max <= (count == MAX_COUNT) ? 1'b1 : 1'b0;
    min <= (count == MIN_COUNT) ? 1'b1 : 1'b0;
  end

endmodule
