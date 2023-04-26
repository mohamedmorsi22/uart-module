`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2023 04:48:21 AM
// Design Name: 
// Module Name: fifo
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


module fifo
#(parameter word = 8, loc = 10)
(
input clk,rst,
input [7:0] in_data,
input wr,rd,
output [7:0] out_data,
output full,empty);

reg [word-1:0] mem [2**loc-1:0];
reg [loc-1 : 0] wr_point_reg, wr_point_next;
reg [loc-1 : 0] rd_point_reg, rd_point_next;
reg empty_reg,full_reg,empty_next,full_next;
wire wr_en;

always @(posedge clk)
if (wr_en)
mem[wr_point_reg] <= in_data;

assign wr_en = wr & ~full_reg;
assign out_data = mem[rd_point_reg];  //FWFT fifo for standard always @(posedge clk) if (rd) out_data <= mem[]

always @(posedge clk, negedge rst)
if (~rst)
begin
wr_point_reg <= 0;
rd_point_reg <= 0;
full_reg <= 1'b0;
empty_reg <= 1'b1;
end
else
begin
wr_point_reg <= wr_point_next;
rd_point_reg <= rd_point_next;
full_reg <= full_next;
empty_reg <= empty_next;
end

always @*
begin
rd_point_next = rd_point_reg;
wr_point_next = wr_point_reg;
full_next = full_reg;
empty_next = empty_reg;

case ({wr,rd})

2'b00 :
begin
wr_point_next = wr_point_reg;
rd_point_next = rd_point_reg;
full_next = full_reg;
empty_next = empty_reg;
end

2'b10 :
begin
if (~full_reg)
begin
wr_point_next = wr_point_reg + 1;
empty_next = 1'b0;
end
if (wr_point_next == rd_point_reg)
full_next = 1'b1;
end

2'b01 :
begin
if(~empty_reg)
rd_point_next = rd_point_reg + 1;
full_next = 1'b0;
if(rd_point_next == wr_point_reg)
empty_next = 1'b1;
end

2'b11 :
begin
wr_point_next = wr_point_reg + 1;
rd_point_next = rd_point_reg + 1;
end

endcase
end


assign empty = empty_reg;
assign full = full_reg;
endmodule
