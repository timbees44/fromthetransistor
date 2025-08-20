#!/usr/bin/python3

# 8 bit UART

baud_rate = 9600 # bits per second
wire = None

def transmitter(byte: int) -> list:
    assert 0 <= byte < 256
    binary_out = []
    for i in range(0, 8):
        binary_out.append(byte % 2)
        byte = byte // 2
    assert len(binary_out) == 8

    framed_package = [0] + binary_out[::-1] + even_parity_gen(binary_out) + [1]
    assert len(framed_package) == 11

    print(framed_package)
    return framed_package


def receiver(arr: list) -> int:
    assert len(arr) == 11
    assert arr[0] == 0
    assert arr[-1] == 1
    if arr[1:9].count(1) % 2 == 0:
        assert arr[-2] == 0
    else:
        assert arr[-2] == 1

    bit_arr = arr[1:9]
    assert len(bit_arr) == 8

    rev_arr = bit_arr[::-1]
    byte = 0
    for i, bit in enumerate(rev_arr):
        byte |= (1 << i) if bit == 1 else 0

    assert 0 <= byte < 256
    print(byte)
    return byte


def even_parity_gen(tx_arr: list) -> list:
    assert len(tx_arr) == 8
    return [tx_arr.count(1) % 2]


wire = transmitter(50)
print(wire)
receiver(wire)

