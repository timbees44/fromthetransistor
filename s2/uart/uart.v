module uart(
    input clk,    // system clock - input source
    input reset,    // asynchronous reset
    input [7:0] data_in,    // data to be transmitted - 8 bits, least imprnt 1st 
    output reg tx_out,    // tx output
    input rx_in    // rx input
);


// parameters for UART settings
parameter BAUD_RATE = 9600; // in bits per second
parameter CLK_FREQ = 500000000; // in Hz
parameter BIT_TIME = CLK_FREQ / BAUD_RATE; // time for one bit transmission

// internal state variables
reg [3:0] tx_state = 4'b0000; // TX state machine state
reg [3:0] rx_state = 4'b0000; // RX state machine state
reg [7:0] tx_data = 8'h00;    // data to be transmitted
reg [7:0] rx_data = 8'h00;    // received data
reg [3:0] bit_count = 4'b0000; // bit counter for TX and RX
reg tx_enable = 0;             // enable signal for TX

// TX state machine
always @(posedge clk) begin
    if (reset) begin
        tx_state <= 4'b0000; // reset to idle state
        bit_count <= 4'b0000; // reset bit counter
        tx_enable <= 0; // disable TX output
        tx_data <= 8'h00; // clear TX data
    end else begin
        case(tx_state)
            4'b0000: begin // idle state
                if (tx_enable) begin // if TX is enabled
                    tx_out <= 1'b0; // start bit
                    tx_state <= 4'b0001; // move to next state
                    bit_count <= 4'b0001; // start bit is first bit
                end else begin
                    tx_out <= 1'b1; // keep TX output high
                end
            end
            4'b0001: begin // data transmission state
                tx_out <= tx_data[bit_count]; // output data bit
                if (bit_count == 4'b1000) begin // if last data bit
                    tx_out <= 1'b1; // stop bit
                    tx_state <= 4'b0000; // return to idle state
                end else begin
                    bit_count <= bit_count + 1; // increment bit counter
                end
            end
        endcase
    end
end

// RX state machine
always @(posedge clk) begin
    if (reset) begin
        rx_state <= 4'b0000; // reset to idle state
        bit_count <= 4'b0000; // reset bit counter
        rx_data <= 8'h00; // clear received data
    end else begin
        case(rx_state)
            4'b0000: begin // idle state
                if (!rx_in) begin // if start bit is detected
                    rx_state <= 4'b0001; // move to next state
                    bit_count <= 4'b0001; // start bit is first bit
                end
            end
            4'b0001: begin // data reception state
                rx_data[bit_count] <= rx_in; // input data bit
                if (bit_count == 4'b1000) begin // if last data bit
                    rx_state <= 4'b0002; // move
                    bit_count <= bit_count + 1; // increment bit counter
                end else begin
                    bit_count <= bit_count + 1; // increment bit counter
                end
            end
            4'b0002: begin // stop bit state
                if (rx_in) begin // if stop bit is detected
                    rx_state <= 4'b0000; // return to idle state
                    // output received data
                    rx_data <= rx_data; // keep received data
                end else begin
                    bit_count <= bit_count + 1; // increment bit counter
                end
            end
        endcase
    end
end

endmodule
