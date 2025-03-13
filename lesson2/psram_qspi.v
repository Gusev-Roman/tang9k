// у вложенного модуля добавляются 23 линии адреса и возможно придется разнести данные чтения с данными записи
// это будут раздельные регистры

module psram999
(
    input clk,
    output reg led1,    // ready to work
    inout [3:0] data,
    input [22:0] addr, // top input cannot be a register
    output reg rcs,     // pull-up
    output reg ready    // data moved to internal registry
);

localparam STARTUP_TIME = 4; // 4060 ticks to init, 150us + 50ns
localparam RSTEN = 8'h66;
localparam RST = 8'h99;

wire [3:0] data_in;
wire [3:0] data_out;
reg [11:0] tick_cnt = 12'b0;
reg [7:0] cmd;
reg [5:0] state;
(* lc_debug *)
reg mosi;
// сигнал enable должен формироваться внутри модуля, в зависимости от времени и количества отправленных бит
(* lc_debug *)
reg enable;

// если enable=0, data_in===data, иначе data_in===Z
assign data_in = ~enable ? data : 4'bzzzz;
// если enable=0, data_out===Z, иначе data_out===data
assign data_out = enable ? data : 4'bzzzz;
// если enable=0, data===data_in, иначе data===data_out 
assign data = enable ? data_out : data_in;
// меняя значение mosi и enable можно менять линию data
assign data_out[0] = mosi;


always @(posedge clk) begin
    if(tick_cnt == 0) begin
        state <= 0;
        mosi <= 0;
        enable <= 1;
        ready <=0;
        rcs <= 1;
    end
    if(tick_cnt < STARTUP_TIME) begin
        tick_cnt = tick_cnt + 12'b1;
        led1 <= 1;
    end else begin
        led1 <= 0; // ready to work, 

        if(state == 0) begin
            state <= 1;
            mosi <= 1;
        end else if(state == 1) begin
        // start to send "SELECT_QSPI" cmd
        end
    end
end

//assign led1 = 0;   // initial off

endmodule