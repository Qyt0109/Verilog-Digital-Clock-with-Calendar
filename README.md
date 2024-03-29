# Verilog Digital Clock with Calendar
Digital Clock with Calendar using Verilog implemented on DE2-115 FPGA board.

# 1. Spec
Assignments
## Thiết kế mạch đồng hồ thế kỷ 
Hiển thị ngày tháng năm, giờ phút giây trên các led 7 thanh của DE2
Cho phép sử dụng các nút bấm để đặt ngày/tháng/năm/giờ/phút/giây
Các module: 
1) Tạo xung 1s
2) Đếm 60s
3) Đếm 60min
4) Đếm 24h
5) Đếm ngày
6) Đếm tháng
7) Đếm năm
8) Giải mã 7 thanh
9) Reset ngày
10) Reset tháng
11) Xác định số ngày trong tháng 

B1: Xác định SPEC đồng hồ thế kỷ 
B2: Xác định kiến trúc (kết nối các module trên) 
B3: Xây dựng code từng module
B4: Xây dựng testbench cho đồng hồ
B5: Pin Assignment & nạp xuống FPGA
## 1.1. Thiết kế các module
### 1.1.1. Các module cho đồng hồ thế kỷ
#### 1.1.1.1. timer1hz
Module <b>timer1hz</b> tạo xung mỗi 1 giây. Cơ chế: tạo biến đếm <b>count</b> và đếm dựa theo tần số clock đầu vào.

input(s):
- clk_100MHz: 100 MHz clock
- reset

output(s):
- clk_1Hz: 1 Hz clock
#### 1.1.1.1. clock
Module <b>clock</b> nhận xung 1Hz từ module <b>timer1hz</b> tự động tăng giá trị giây (<b>sec</b>), phút (<b>min</b>), giờ (<b>hour</b>). Ngoài ra còn có thể điều khiển tăng giá trị giờ, phút, giây bằng các tín hiệu <b>inc_hour</b>, <b>inc_min</b>, <b>inc_sec</b> tương ứng. Mỗi khi cuối ngày (23:59:59), tín hiệu <b>end_of_day</b> sẽ được kích hoạt giúp module <b>calendar</b> tính toán lịch.

input(s):
- clk_100MHz: 100 MHz clock
- reset
- inc_hour, inc_min, inc_sec: các tín hiệu chủ động kích hoạt để tăng giá trị giờ, phút, giây.

output(s):
- tick_1Hz: 1 Hz clock
### 1.1.2. Các module hỗ trợ
