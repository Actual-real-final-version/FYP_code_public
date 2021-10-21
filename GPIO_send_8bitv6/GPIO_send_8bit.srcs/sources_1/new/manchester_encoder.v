`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// transforms input data into manchester encoding
//////////////////////////////////////////////////////////////////////////////////


module manchester_encoder(
    input clk,
    input data,
    output reg out
    );
    
    wire hi;
    assign hi = clk;       //vivado does not allow the use of the clock as a variable
    always @(clk)
    out <= hi ^ data;
    
endmodule
