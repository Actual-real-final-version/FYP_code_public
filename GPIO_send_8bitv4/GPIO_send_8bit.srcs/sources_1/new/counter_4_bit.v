`timescale 1ns / 1ps

module counter_4_bit(
    input clk, reset,
    output reg [3:0] count
    );
    
    always @ (posedge clk or negedge reset)
    begin
        if (!reset)
            count <= 0;
        else 
            count <= count + 1;
    end
endmodule
