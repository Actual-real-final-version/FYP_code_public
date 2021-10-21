// divides clock using a counter to create different frequencies
module clock_divider(
input clk,
output reg divided_clk = 0
    );
parameter div_value = 25000000;        //controls clock frequency

integer counter_value =0;

//check if count has been reached
always@(posedge clk)
begin
    if (counter_value == div_value)
        begin
        counter_value <= 0;
        divided_clk <= ~divided_clk;
        end
    else 
        counter_value <= counter_value+1;
end

endmodule
    
    
    