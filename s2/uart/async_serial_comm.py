#!/usr/bin/env python

def async_serial_comms(bit_arr: list):
    start = 0
    stop = 1
    assert len(bit_arr) == 8, "bit_arr must be 8 bits long"
    assert all(bit in (0,1) for bit in bit_arr), "all bits must be '0' or '1'"
    frame = [start] + bit_arr + [stop]

    return frame

test_arr = [0, 1, 1, 0, 0, 1, 0, 1]

async_serial_comms(test_arr)
