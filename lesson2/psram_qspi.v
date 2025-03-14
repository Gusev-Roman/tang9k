/* у вложенного модуля добавляются 24 линии адреса и возможно придется разнести данные чтения с данными записи
// это будут раздельные регистры
// каждый адрес указывает на байт, старший всегда нулевой
*/


module psram999
(
    input clk,
    output reg led1,    // ready to work
    inout [3:0] data,
    input [22:0] addr, // top input cannot be a register
    output reg rcs,     // pull-up
    output reg ready,    // data moved to internal registry
    output sck
);

localparam STARTUP_TIME = 4; // 4060 ticks to init, 150us + 50ns
localparam RSTEN = 8'h66;
localparam RST = 8'h99;
localparam READID = 8'h9F;

wire [3:0] data_in;
wire [3:0] data_out;
reg [11:0] tick_cnt = 12'b0;
reg [7:0] cmd;
(* lc_debug *)
reg [5:0] state;
(* lc_debug *)
reg [4:0] bitcnt = 5'h10;   // хватит и 4 бита...
reg o_sck;
(* lc_debug *)
reg mosi;
// сигнал enable должен формироваться внутри модуля, в зависимости от времени и количества отправленных бит
(* lc_debug *)
reg enable;
(* lc_debug *)
reg [1:0] stage = 0; // расширение к state

// если enable=0, data_in===data, иначе data_in===Z
assign data_in = ~enable ? data : 4'bzzzz;
// если enable=0, data_out===Z, иначе data_out===data
assign data_out = enable ? data : 4'bzzzz;
// если enable=0, data===data_in, иначе data===data_out 
assign data = enable ? data_out : data_in;
// меняя значение mosi и enable можно менять линию data
assign data_out[0] = mosi;
assign sck = o_sck;


always @(posedge clk) begin
    if(tick_cnt == 0) begin
        state <= 0;
        mosi <= 0;
        ready <=0;
        //data_out <=0;     // это не регистры, не можем их менять
        enable <= 1;        // drive ports to 0
        rcs = 1;
        o_sck = 0;
        led1 = 1;
    end
    if(state == 0) begin // wait for init time
        if(tick_cnt < STARTUP_TIME) begin
            tick_cnt = tick_cnt + 1;
        end
        else begin  // достигли конца инициализации, подготовим команду сброса
            stage = 1; // первый байт сброса
            cmd = RSTEN;
            bitcnt = 5'h10;
            rcs = 0;    // chip enable
            o_sck = 0;  // start by hi scl
            state = 1;
        end
    end
    else if(state < 3) begin    // reset sequence
        // Сгенерить 16 полуволн. Добавить блок always по падающему sck
        o_sck = (o_sck) ? 0 : 1;    // манипуляция SCK
        bitcnt = bitcnt-1;
        if(bitcnt == 0) begin   // ноль будет моментально заменен на 16 и надо отключить rcs
            stage++;
            bitcnt = 5'o20;
            //rcs = 1;    // EOT
            if(stage == 2) begin
                cmd = RST;
            end
            else if(stage == 3) begin
                state = 2; // next command: write bytes
                stage = 0;
                cmd = READID;
            end
        end
    end
    else if(state == 2) begin   // read id command
        led1 = 0;   // led on!
        rcs = 1;
    end
end

always @(negedge sck) begin
    if(state == 1) begin
        rcs = 0;                // тут единицы в выводе нет, так как она в один и тот же момент устанавливается и в 1 и в 0
        mosi <= cmd[7];         // always put MSB
        cmd[7:1] <= cmd[6:0];   // shift left
    end
    else rcs = 1;
end
//assign led1 = 0;   // initial off

endmodule