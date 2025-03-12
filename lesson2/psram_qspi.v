// у вложенного модуля добавляются 23 линии адреса и возможно придется разнести данные чтения с данными записи
// это будут раздельные регистры

module psram999
(
    input clk,
    output led1,    // ready to work
    inout [3:0] data,
    input [22:0] addr, // top input cannot be a register
    input cs_n,     // pull-up
    output ready    // data moved to internal registry
);

localparam STARTUP_TIME = 4055; // ticks to init, 150us
localparam RSTEN = 8'h66;
localparam RST = 8'h99;

reg [11:0] tick_cnt = 12'b0;
reg [7:0] cmd;
reg [5:0] state;

assign data = 4'bz;   // not driven
//assign cs_n = 1;   // not active
assign state = 0;  // wait_for_ready


always @(posedge clk) begin
    if(tick_cnt < STARTUP_TIME) begin
        tick_cnt = tick_cnt + 12'b1;
        led1 <= 1;
    end else begin
        led1 <= 0; // ready to work, 
        if(state == 0) begin
            state <= 1;
        end else if(state == 1) begin
        // start to send "SELECT_QSPI" cmd
        end
    end

end

//assign led1 = 0;   // initial off

endmodule