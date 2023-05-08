module uart_rx(
  input clk, // clock input
  input rst, // reset button input
  input rx, // input for received data
  output reg rx_data, // output for received data
  output reg rx_done // output indicating when a byte has been received
);

// Internal state variables
reg [2:0] rx_state; // declare rx_state with 3-bit value keeps track of current state e.g. idle.
reg [7:0] rx_shift_reg; // used to hold the data being received
reg rx_busy; // indicates if reception is in progress already - boolean

// Constants
parameter BAUD_RATE = 9600; // setting baud rate (how many bits per second)
parameter CLOCK_FREQ = 50000000; // Hz (toggling between high and low - ____|-----|____)

// Counter for generating baud rate clock 
reg [15:0] baud_counter; // counting number of clock cycles that have elapsed since the last bit was received. 
//16 bits for flexibility. Needs to receive both the 8bits of data plus start and stop bits and any other bits that might be present.
wire baud_tick = (baud_counter == 0); // signals the end of each bit reception 
// when true or 0 the counter has reached it's maximum value and the a new bit can be received.

// Clock divider for generating baud rate clock
parameter BAUD_DIV = (CLOCK_FREQ / BAUD_RATE) - 1; // number of clock cycles required to rx each bit at the desired baud rate
// Allows for flexibility in input baud rates set
reg [15:0] baud_div_counter; // counts the number of clock cycles between each bit rx
// incremented on every clock cycle, when it reaches value in 'BAUD_DIV', 'baud_counter is reset to 0

always @(posedge clk) begin // start when clock signal has positive edge ____(|)---|____
  if (rst) begin // checking if reset signal is high
    rx_state <= 3'b000; // sets rx_state to 0 - notation is reflecting 3-bit value
    rx_shift_reg <= 8'b00000000; // sets the value of rx_shift_reg to 0 - reflecting 8-bit value
    rx_data <= 1'b0; // initialize rx_data to 0
    rx_done <= 1'b0; // initialize rx_done to 0
    baud_counter <= BAUD_DIV; // sets baud_counter to BAUD_DIV which kicks off counter used to generate the timing for bit rx
    baud_div_counter <= 0; // 
    rx_busy <= 1'b0;
  end
  else begin
    // Baud rate clock generation
    if (baud_div_counter == BAUD_DIV) begin
      baud_div_counter <= 0;
      baud_counter <= baud_counter - 1;
    end
    else begin
      baud_div_counter <= baud_div_counter + 1;
    end
    
    // State machine
    case (rx_state)
      3'b000: begin // IDLE
        rx_done <= 1'b0; // indicate no byte has been received yet
        if (rx == 1'b0) begin // Check for start bit
          rx_busy <= 1'b1;
          rx_shift_reg <= 8'b00000000;
          rx_state <= 3'b001;
        end
      end
      
      3'b001: begin // DATA
        if (baud_tick) begin
          rx_shift_reg <= {rx
      8'b00000001: begin // Check if last bit was received
        rx_state <= START_BIT;
        rx_data <= rx_shift_reg[6:0];
      end
    endcase
  end
end

endmodule
