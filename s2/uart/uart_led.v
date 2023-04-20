module uart_tx(
  input clk,
  input rst,
  input tx_data,
  output reg tx,
  output reg [7:0] leds
);

// Internal state variables
reg [3:0] tx_state;
reg [7:0] tx_shift_reg;
reg tx_busy;

// Constants
parameter BAUD_RATE = 9600;
parameter CLOCK_FREQ = 50000000;

// Counter for generating baud rate clock
reg [15:0] baud_counter;
wire baud_tick = (baud_counter == 0);

// Clock divider for generating baud rate clock
parameter BAUD_DIV = (CLOCK_FREQ / BAUD_RATE) - 1;
reg [15:0] baud_div_counter;

always @(posedge clk) begin
  if (rst) begin
    tx_state <= 4'b0000;
    tx_shift_reg <= 8'b00000000;
    tx <= 1'b1;
    baud_counter <= BAUD_DIV;
    baud_div_counter <= 0;
    tx_busy <= 1'b0;
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
    case (tx_state)
      4'b0000: begin // IDLE
        tx <= 1'b1;
        leds <= 8'b00000000;
        if (tx_data != 1'b1) begin
          tx_shift_reg <= 8'b10000000; // Start bit
          tx_state <= 4'b0001;
          tx_busy <= 1'b1;
        end
      end
      
      4'b0001: begin // DATA
        tx <= tx_shift_reg[0];
        leds <= {7'b0, tx_shift_reg[0]}; // Set LED to current bit value
        if (baud_tick) begin
          tx_shift_reg <= {tx_shift_reg[6:0], 1'b0}; // Shift in next bit
          if (tx_shift_reg == 8'b00000001) begin // Check if last bit was sent
            tx_state <= 4'b0010;
          end
        end
      end
      
      4'b0010: begin // STOP
        tx <= 1'b1;
        leds <= 8'b00000001; // Set LED to 1 to indicate stop bit
        tx_busy <= 1'b0;
        tx_state <= 4'b0000;
      end
    endcase
  end
end

endmodule

