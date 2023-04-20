module led_blink_tb;

wire out; // wire is analogous to electricl wire

reg clk = 0; // setting value of clk to 0 in memory
always #5 clk = ~clk; // toggling the value of clk after every 5 time units. No condition for always so it will run indefinitely

led_blink b0 (clk,out); // referencing led_blink module in other file with ports

initial begin // procedural block start -> needs begin and end due to having more than one statement
    $monitor("LED: %d",out); // used to monitor the output -> format: $monitor ("format_string", parameter1, parameter2, ... );
    #500 $stop; // #500 is waiting for 500 time units. $stop suspends the simulation and puts it into interactive mode 
end

endmodule
