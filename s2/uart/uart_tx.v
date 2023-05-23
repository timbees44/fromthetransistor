module uart_tx(
  input clk, // clock input
  input rst, // reset button input
  input tx_data, // input for data to be transmitted
  output reg tx // output for data to be transmitted
);

// Internal state variables
reg [3:0] tx_state; // declare tx_state with 4bit value keeps track of current state e.g. idle.
reg [7:0] tx_shift_reg; // used to hold the data being transmitted
reg tx_busy; // indicates if transmission is in progress already - boolean

// Constants
parameter BAUD_RATE = 9600; // setting baud rate (how many bits per second)
parameter CLOCK_FREQ = 50000000; // Hz (toggling between high and low - ____|-----|____)

// Counter for generating baud rate clock 
reg [15:0] baud_counter; // counting number of clock cycles that have elapsed since the last bit was transmitted. 
//16 bits for flexibility. Needs to transfer both the 8bits of data plus start and stop bits and any other bits that might be present.
wire baud_tick = (baud_counter == 0); // signals the end of each bit transmission 
// when true or 1 the counter has reached it's maximum value and the a new bit can be transmitted.

// Clock divider for generating baud rate clock
parameter BAUD_DIV = (CLOCK_FREQ / BAUD_RATE) - 1; // number of clock cycles required to tx each bit at the desired baud rate
// Allows for flexibility in input baud rates set
reg [15:0] baud_div_counter; //  responsible for dividing the clock frequency down to the desired baud rate. It counts the number of clock cycles between each bit transmission

// baud_div_counter vs baud_counter:
// The baud_div_counter controls the frequency of bit transmission, while the baud_counter controls the duration of each bit.

always @(posedge clk) begin // start when clock signal has positive edge ____(|)---|____
  if (rst) begin // checking if reset signal dis high
    tx_state <= 4'b0000; // sets tx_state to 0 - notation is reflecting 4bit value
    tx_shift_reg <= 8'b00000000; // sets the value of tx_shift_reg to 0 - reflecting 8bit value
    tx <= 1'b1; // sets tx value to 1 which is the idle state (high)
    baud_counter <= BAUD_DIV; // sets baud_counter to BAUD_DIV which kicks off counter used to generate the timing for bit tx
    baud_div_counter <= 0; // setting initial value of baud_div_counter to zero
    tx_busy <= 1'b0; // sets tx_busy to 0 indicating that a new transmission can be started
  end
  else begin // if reset signal is low
    // Baud rate clock generation
    if (baud_div_counter == BAUD_DIV) begin // checks if baud_div_counter has reached it's max value which is set/stored by BAUD_DIV.
      baud_div_counter <= 0; // when the above is true baud_div_counter is reset to 0
      baud_counter <= baud_counter - 1; // decrement the value of baud_counter. Eventually this reaches zero to signify that a one bit of data has been transmitted.
    end
    else begin
      baud_div_counter <= baud_div_counter + 1; // if baud_div_counter is not == BAUD_DIV then it counts up until this is the case.
    end
    
    // State machine
    case (tx_state) // we're still in "if (rst) begin" state so this is when tx_state = 0
      4'b0000: begin // IDLE
        tx <= 1'b1; // tx set to 1 to keep in IDLE
        if (tx_data != 1'b1) begin // if tx_data not 1
          tx_shift_reg <= 8'b10000000; // Start bit is loaded
          tx_state <= 4'b0001; // set to transmission state
          tx_busy <= 1'b1; // tx_busy set to 1 to indicate transmission in progress
        end
      end
      
      4'b0001: begin // DATA
        tx <= tx_shift_reg[0];
        if (baud_tick) begin
          tx_shift_reg <= {tx_shift_reg[6:0], 1'b0}; // Shift in next bit
          if (tx_shift_reg == 8'b00000001) begin // Check if last bit was sent
            tx_state <= 4'b0010; // if last bit has been sent then this sets the STOP state
          end
        end
      end
      
      4'b0010: begin // STOP
        tx <= 1'b1; // send stop bit
        tx_busy <= 1'b0; // transmission no longer in progress. ready for next transmission. 
        tx_state <= 4'b0000; // state is 0, this represents idle state.
      end
    endcase
  end
end

endmodule
