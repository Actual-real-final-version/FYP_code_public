`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2021 15:52:22
// Design Name: 
// Module Name: block_ram
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


module block_ram(
    input [3:0] data,
    input [3:0] addr,
    input we, clk,
    output [3:0] q
    );
    
    //declare RAM variable
    reg [3:0] ram [3:0];
    
    //declare register to store address
    reg [3:0] addr_reg;
    
    always @ (posedge clk)
    begin
        if (we)
        begin
            //write data
            ram[addr] <= data;
        end
        else
            //read data
            addr_reg <= addr;       
    end
    //update output
    assign q = ram[addr_reg];
endmodule
