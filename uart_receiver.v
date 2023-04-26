`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2023 04:47:15 AM
// Design Name: 
// Module Name: uart_receiver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_receiver
#(parameter Dbits = 8,    // number of data bits
            st_tick = 8,  // one start bit
				d_tick = 16,  // number of ticks needed before acquiring the data bit
				en_tick = 16  // one stop bit
				)
(
input clk,rst,
input rx, baud_tick,
output [Dbits-1 : 0]d_out,
output reg done_tick
);


localparam idle = 00, start = 01, data = 10, stop = 11;
reg [1 : 0] state, next_state;
reg [3 : 0] nb_reg, nb_next;
reg [Dbits -1 : 0] rx_data_reg, rx_data_next;
reg [3:0] s_reg, s_next;
 

always @(posedge clk, negedge rst)
if (~rst)
begin
state <= idle;
nb_reg <= Dbits;
rx_data_reg <= 0;
s_reg <= 0;
end

else
begin
state <= next_state;
nb_reg <= nb_next;
rx_data_reg <= rx_data_next;
s_reg <= s_next;
end



always @(*)
begin

next_state = state;
s_next = s_reg;
nb_next = nb_reg;
done_tick = 1'b0;
rx_data_next = rx_data_reg;

case (state)

idle :
if (rx)
next_state = idle;
else
begin
next_state = start;
s_next = 0;
end


start :
if (baud_tick)
if (s_reg == (st_tick-1))
begin
next_state = data;
s_next = 0;
end
else
begin
next_state = start;
s_next = s_reg + 1;
end


data :
if (baud_tick)
if (s_next == (d_tick-1))
begin
s_next = 0;
rx_data_next = {rx,rx_data_reg[Dbits-1 : 1]};
nb_next = nb_reg -1;
if (nb_reg == 0)
next_state = stop;
else
next_state = data;
end
else
begin
s_next = s_reg + 1;
next_state = data;
end


stop :
if (baud_tick)
if (s_reg == (en_tick-1))
begin
next_state = idle;
done_tick = 1'b1;
end
else
begin
s_next = s_reg +1;
next_state = stop;
end


default :
next_state = state;
endcase
end

assign d_out = rx_data_reg;
endmodule 
