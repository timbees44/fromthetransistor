module uart_testbench;
  reg clk;
  reg rst;
  reg tx_data;
  wire tx;
  wire rx_data;
  reg rx;

  // Instantiate the modules
  uart_tx dut_tx (
    .clk(clk),
    .rst(rst),
    .tx_data(tx_data),
    .tx(tx)
  );

  uart_rx dut_rx (
    .clk(clk),
    .rst(rst),
    .rx(tx),
    .rx_data(rx_data),
    .rx(rx)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Test stimulus
  initial begin
    clk = 0;
    rst = 0;
    tx_data = 1'b0;
    rx = 1'b0;

    // Reset
    rst = 1;
    #10;
    rst = 0;
    #10;

    // Transmit test data
    tx_data = 1'b1;
    #10;
    tx_data = 1'b0;
    #10;
    tx_data = 1'b1;
    #10;
    tx_data = 1'b0;
    #10;

    // Wait for receiving to complete
    #100;

    // Print received data
    $display("Received data: %b", rx_data);

    // End simulation
    $finish;
  end
endmodule
