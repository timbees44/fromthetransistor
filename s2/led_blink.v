module led_blink (clk, out); // setting module for block of functionality -> format= module <name> ([port_list]);
    
    input clk; // incoming signal (current)
    output reg out; // goes out to led - using reg (register) as a memory element -> output will stay how it's set until changed

    initial //used for simulation only -> not synthesizable -> type of procedural block
        out = 0; // setting the initial value of our output -> led is off

    always @(posedge clk) // another instantiation of a procedural process that beings at time 0, this repeats unlike "initial"
        // the "@(posedge clk)" expression is an event control is a procedural
        // construct that is waiting for a change in expression.
        out <= ~out; //will toggle the value of out

endmodule
