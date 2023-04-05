#!/bin/bash
iverilog -o output led_blink.v led_blink_tb.v
vvp output
