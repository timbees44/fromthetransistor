`timescale 1ns / 1ns

module uart_tx_tb;

reg clk;
reg rst;
reg tx_data;
wire tx;

uart_tx dut (
  .clk(clk),
  .rst(rst),
  .tx_data(tx_data),
  .tx(tx)
);

initial begin
  clk = 0;
  forever #10 clk = ~clk;
end

initial begin
  rst = 1;
  tx_data = 0;
  #100;
  rst = 0;
end

initial begin
  #1000 tx_data = 1;
  #1000 tx_data = 0;
  #1000 tx_data = 1;
  #1000 tx_data = 0;
  #1000 $finish;
end

endmodule

