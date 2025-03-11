// прошивка общается с чипом через 4 двунаправленных линии данных,
// rclk
// rcs
// 6 линий led не связанные с чипом, идентифицируют текущий статус программы

module top
(
    input clk,          // HSE clock, 27 MHz
    output [5:0] led,    // LEDs to indicate state
    output rclk,         // clock to PSRAM
    inout [3:0] data,    // data lines to PSRAM. Started as 1-wire
    output rcs
);

reg [1:0] key_s_rise;
assign rclk = clk;

psram999 mypsram(clk, led[0]);
endmodule
