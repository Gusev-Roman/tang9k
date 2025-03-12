// прошивка общается с чипом через 4 двунаправленных линии данных,
// rclk
// rcs
// 6 линий led не связанные с RAM чипом, идентифицируют текущий статус программы

module top
(
    input clk,          // HSE clock, 27 MHz
    output [5:0] led,    // LEDs to indicate state
    output rclk,         // clock to PSRAM
    inout [3:0] data,    // data lines to PSRAM. Started as 1-wire
    output rcs
);

reg [1:0] key_s_rise; // ?
reg [22:0] haddr = 23'b0;   // address init as 0
wire rce = 0;   // psram clock enable bit, off by def

assign led[5:1] = 5'b11111;

psram999 mypsram(
    .clk(rclk),
    .led1(led[0]),
    .addr(haddr),
    .data(data),
    .cs_n(rcs)
);

//BUFG one_bufg(
//    .I(clk),
//    .O(rclk)
//);

DQCE dqce_one(
    .CLKIN(clk),
    .CLKOUT(rclk),
    .CE(rce)
);
endmodule
