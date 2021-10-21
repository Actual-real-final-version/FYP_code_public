`timescale 1ns / 1ps

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
wire divided_clk, ram_clk;
wire tx_bit, rx_bit, ram_trigger;
wire [3:0] count, tx_state, tx_savedata, rx_state, rx_savedata;
reg [3:0] latch;        //latch records what is written to RAM, because the RAM block is single ended so we can't read and write at the same time

always @(posedge ram_clk)
latch <= rx_state;

assign enable = 4'b0111;
assign LED[7:4] = rx_state;
assign LED[3:0] = tx_state;
//assign LED[3:0] = ~sw_in;
//assign LED[6:4] = ~dip_sw[2:0];
bin_to_7seg hex_out(.data_in(latch), .hex_inverted(seven_segment));

//instantiate clock dividers
clock_divider global_clock(.clk(CLK1),.divided_clk(divided_clk));           //dividing global clock for visibility when testing
clock_divider #(.div_value(100000000))ram_clock(.clk(CLK1),.divided_clk(ram_clk));  //saves data to RAM when all 4 bits have been shifted in
load_trigger RAM_trigger(.clk(divided_clk), .trigger(ram_trigger));
counter_4_bit data_generator(.clk(ram_trigger), .reset(~RESET), .count(count));

/////////////////////////////////////////////////////////////main hardware structure in order/////////////////////////////////////////////////////
//instantiate transmitting shift register
//this can load some data and then shift it to the encoder
shift_reg transmitter(.clk(~divided_clk), .reset(RESET), .load(ram_trigger), .data(count), .shift_in(~sw_in[1]), .state(tx_state), .shift_out(tx_bit));

//instantiate transmitter RAM storage
block_ram transmitter_ram(.data(tx_state), .addr(count), .we(1), .clk(ram_clk), .q(tx_savedata));

//single bit encoder changes each byte of shifted data to manchester code
manchester_encoder encode(.clk(~divided_clk), .data(tx_bit), .out(P12[4]));

//transmitting the clock along the pair
assign P12[6] = ~divided_clk;

//decoder is single bit, changes received code back to data
manchester_encoder decode(.clk(P13[7]), .data(P13[5]), .out(rx_bit));

//shifts received bits to complete received data, serial to parallel converter
shift_reg receiver(.clk(~divided_clk), .reset(RESET), .load(0), .data(0), .shift_in(rx_bit), .state(rx_state), .shift_out(0));

//instantiate receiver RAM storage
block_ram receiver_ram(.data(rx_state), .addr(count), .we(1), .clk(ram_clk), .q(rx_savedata));
    
endmodule
