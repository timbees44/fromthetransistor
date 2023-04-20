#!/bin/bash
iverilog -o output uart.v uart_tb.v
vvp output
