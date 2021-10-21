`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//top module for instantiationand control of the overall transmission system and all subroutines

//////////////////////////////////////////////////////////////////////////////////


module top_module(
input CLK1,
input RESET,
input [3:0] sw_in,
input [7:0] dip_sw,
output [7:0] LED,
input [39:0] P13,
output [39:0] P12,
output [3:0] enable,
output [7:0] seven_segment
    );
wire global_clk, ram_clk;
wire tx_bit, rx_bit, ram_trigger;
wire [3:0] count, tx_state, tx_savedata, rx_state, rx_savedata; 
reg [3:0] latch;        //latch records what is written to RAM, because the RAM block is single ended so we can't read and write at the same time

always @(posedge ram_clk)
latch <= rx_state;

//assign parameters for display
assign enable = 4'b0111;
assign LED[7:4] = rx_state;
assign LED[3:0] = tx_state;

//instantiate 7 segment display to record RAM data
bin_to_7seg hex_out(.data_in(latch), .hex_inverted(seven_segment));

//instantiate clock dividers, trigger and counter
clock_divider global_clock(.clk(CLK1),.divided_clk(global_clk));           //dividing input clock for visibility when testing - create a new global clock
clock_divider #(.div_value(100000000))ram_clock(.clk(CLK1),.divided_clk(ram_clk));  //saves data to RAM when all 4 bits have been shifted in
load_trigger RAM_trigger(.clk(global_clk), .trigger(ram_trigger));         //has the same period as ram_clk but is only high for one global_clk pulse
counter_4_bit data_generator(.clk(ram_trigger), .reset(~RESET), .count(count)); //generates our data in the form of a 4-bit counter

/////////////////////////////////////////////////////////////main hardware structure in order/////////////////////////////////////////////////////
//instantiate transmitting shift register
//this can load some data and then shift it to the encoder
shift_reg transmitter(.clk(~global_clk), .reset(RESET), .load(ram_trigger), .data(count), .shift_in(~sw_in[1]), .state(tx_state), .shift_out(tx_bit));

//instantiate transmitter RAM storage to save transmitted data for reference
block_ram transmitter_ram(.data(tx_state), .addr(count), .we(1), .clk(ram_clk), .q(tx_savedata));

//single bit encoder changes each byte of shifted data to manchester code
manchester_encoder encode(.clk(~global_clk), .data(tx_bit), .out(P12[4]));

//transmitting the clock along the pair
assign P12[6] = ~global_clk;

//decoder is single bit, changes received code back to data bits
manchester_encoder decode(.clk(P13[7]), .data(P13[5]), .out(rx_bit));

//shifts received bits to complete received data, serial to parallel converter
shift_reg receiver(.clk(~global_clk), .reset(RESET), .load(0), .data(0), .shift_in(rx_bit), .state(rx_state), .shift_out(0));

//instantiate receiver RAM storage to save received data
block_ram receiver_ram(.data(rx_state), .addr(count), .we(1), .clk(ram_clk), .q(rx_savedata));
    
endmodule
