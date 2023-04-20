`timescale 1ns / 1ns

module uart_tb;

  // Input and output signals
  reg clk;
  reg reset;
  reg data_in;
  wire tx_out;
  wire rx_in;
  wire [7:0] rx_data;

  // Instantiate UART module
  uart uart_inst(
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .tx_out(tx_out),
    .rx_in(rx_in),
    .rx_data(rx_data)
  );

  // Clock generator
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Reset the UART module
  initial begin
    reset = 1;
    #20 reset = 0;
  end

  // Test data
  reg [7:0] test_data = 8'h7F; // Send ASCII '0111 1111' (0x7F)

  // Test transmission
  initial begin
    data_in = 0;
    #100;
    data_in = 1; // Start bit
    #10;
    for (int i = 0; i < 8; i = i + 1) begin
      data_in = test_data[i];
      #10;
    end
    data_in = 1; // Stop bit
    #10;
  end

  // Test reception
  initial begin
    #500; // Wait for transmission to finish
    rx_in = 0; // Start bit
    #10;
    for (int i = 0; i < 8; i = i + 1) begin
      assert (rx_data[i] == test_data[i]); // Check received data
      #10;
    end
    rx_in = 1; // Stop bit
    #10;
  end

endmodule
