module psram
(
    input clk,
    output led1,    // ready to work
    inout reg [3:0] data,
    input reg [22:0] addr, // top input cannot be a register
    input cs_n,     // pull-up
    input cor
);

localparam STARTUP_TIME = 4055; // ticks to init
reg tick_cnt[11:0] = 0;
reg [7:0] cmd;
reg [5:0] state;
led1 = 0;   // initial off
data = z;   // not driven
cs_n = 1;   // not active
state = 0;  // wait_for_ready


always @(posedge clk) begin
    if(tick_cnt < STARTUP_TIME) begin
        tick_cnt = tick_cnt + 1;
    end else begin
        led1 = 1; // ready to work, 
        if(state == 0) begin
            state = 1;
        end else if(state == 1) begin
        // start to send "SELECT_QSPI" cmd
        end
    end

end

endmodule