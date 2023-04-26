`timescale 1ns / 1ps



module uart
#(parameter bits = 8, stop_tick = 16 , st_tick = 8,word = 8, loc = 10)
(
input clk, rst,
input rd,wr,
input rx,
input [7:0] in_data,
input [10:0] final_value,
output tx,
output [7:0] out_data,
output full,empty
);

wire tick;
baud_rate_generator #(.N(10)) uart_baud (.clk(clk),.rst(rst),.final_value(final_value),.tick(tick));





wire rx_done_tick;
wire [bits-1 :0] rx_dout;
uart_receiver #(.Dbits(bits),.st_tick(st_tick),.d_tick(stop_tick),.en_tick(stop_tick)) uart_rx (.clk(clk),.rst(rst),.baud_tick(tick),.rx(rx),.done_tick(rx_done_tick),.d_out(rx_dout));


fifo #(.word(word),.loc(loc)) fifo_uart_rx (.clk(clk),.rst(rst),.rd(rd),.wr(rx_done_tick),.in_data(rx_dout),.out_data(out_data),.full(),.empty(empty)); 


wire tx_done_tick;
wire tx_empty;
wire [bits-1 :0] tx_din;
uart_transmitter #(.bits(bits),.stop_tick(stop_tick)) uart_tx (.clk(clk),.rst(rst),.baud_tick(tick),.tx_ready(~tx_empty),.tx(tx),.tx_data(tx_din),.tx_done_tick(tx_done_tick));

fifo #(.word(word),.loc(loc)) fifo_uart_tx (.clk(clk),.rst(rst),.rd(tx_done_tick),.wr(wr),.full(full),.empty(tx_empty),.in_data(in_data),.out_data(tx_din)); 


endmodule