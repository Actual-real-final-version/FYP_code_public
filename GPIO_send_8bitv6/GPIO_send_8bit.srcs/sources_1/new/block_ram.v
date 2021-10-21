`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// infers a block of RAM storage in the form of an array.
// the RAM is single ended, so cannot be read and written at the same time
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
