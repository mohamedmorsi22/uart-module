`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2023 04:44:53 AM
// Design Name: 
// Module Name: baud_rate_generatorr
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


module baud_rate_generator
#(parameter N = 4)
(
input clk,rst,
input [N-1 : 0]final_value,
output tick
);

reg [N-1 : 0] q_reg;
wire [N-1 :0] q_next;

always @(posedge clk, negedge rst)
if (~rst)
q_reg <= 0;
else
q_reg <= q_next;

// next state logic
assign q_next = (q_reg == final_value) ? 0 : q_reg +1 ;

// output tick
assign tick = (q_reg == final_value);

endmodule 