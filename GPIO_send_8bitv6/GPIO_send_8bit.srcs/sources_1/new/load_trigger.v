`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//creates a trigger pulse that is only high for half a global clock period but
//has a period n times larger
//////////////////////////////////////////////////////////////////////////////////


module load_trigger(
    input clk,
    output reg trigger
    );
    parameter trig_value = 4;
    reg [2:0] counter = 0;
    always @(posedge clk)
    begin
    if (counter == trig_value)
        begin
        counter <= 0;
        trigger <= 1;
        end
    else 
        trigger = 0;
        counter <= counter+1;
    end
   
endmodule