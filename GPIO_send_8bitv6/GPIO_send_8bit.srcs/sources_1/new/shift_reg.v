`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//creates an n-bit shift register for use as a transmission buffer
//////////////////////////////////////////////////////////////////////////////////


module shift_reg(clk, reset, load, data, shift_in, state, shift_out);

parameter n = 4;        //length of register
input clk, reset, load, shift_in;
input [n-1:0] data;            //immediate value to load into register
output reg [n-1:0] state;      //value that is stored in the register
output shift_out;              //most significant bit in the register

always @(posedge clk)
    begin
        if (reset)
        state <= 0;
        else if (load)
        state <= data;
        else
        begin
        state = {state[n-2:0], shift_in};
        end
    end
assign shift_out = state[n-1];
endmodule
