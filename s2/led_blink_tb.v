`include "led_blink.v"
`timescale 1us/1ns

module led_blink_tb;

    reg r_CLOCK = 1'b0;
    
    wire w_LED_DRIVE;

    // Instantiate the Unit Under Test (UUT)
    led_blink UUT
        (
            .clk(r_CLOCK)
            .LED(w_LED_DRIVE)
            );

    always #20 r_CLOCK <= !r_CLOCK;

    initial begin
        r_ENABLE <= 1'b1;

        r_SWITCH_1 <= 1'b0;
        r_SWITCH_2 <= 1'b0;
        #200000 // 0.2 seconds
         
        r_SWITCH_1 <= 1'b0;
        r_SWITCH_2 <= 1'b1;
        #200000 // 0.2 seconds
         
        r_SWITCH_1 <= 1'b1;
        r_SWITCH_2 <= 1'b0;
        #500000 // 0.5 seconds

        r_SWITCH_1 <= 1'b1;
        r_SWITCH_2 <= 1'b1;
        #2000000 // 2 seconds

        $display("Test Complete");
    end
   
endmodule 
