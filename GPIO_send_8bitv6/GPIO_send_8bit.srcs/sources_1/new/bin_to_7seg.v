`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// binary number to 7-segment display converter
//////////////////////////////////////////////////////////////////////////////////


module bin_to_7seg(
    input [3:0] data_in,
    output [7:0] hex_inverted
    );

    reg [7:0] hex_out;
    always@(data_in)
        case(data_in)
        4'b0000: hex_out = 8'b11111110;
        4'b0001: hex_out = 8'b00111000;
        4'b0010: hex_out = 8'b11011101;
        4'b0011: hex_out = 8'b01111101;
        4'b0100: hex_out = 8'b00111011;
        4'b0101: hex_out = 8'b01110111;
        4'b0110: hex_out = 8'b11110111;
        4'b0111: hex_out = 8'b00111100;
        4'b1000: hex_out = 8'b11111111;
        4'b1001: hex_out = 8'b01111111;
        4'b1010: hex_out = 8'b10111111;
        4'b1011: hex_out = 8'b11110011;
        4'b1100: hex_out = 8'b11010110;
        4'b1101: hex_out = 8'b11111001;
        4'b1110: hex_out = 8'b11010111;
        4'b1111: hex_out = 8'b10010111;
        default: hex_out = 8'bxxxxxxxx;
        endcase
        assign hex_inverted = ~hex_out;
       
endmodule
