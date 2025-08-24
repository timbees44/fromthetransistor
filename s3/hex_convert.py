#!/usr/bin/python3

# Functions
# - take hex input
# - sanitise input e.g. remove any '0x' prefix
# - convert to binary
# - convert to decimal

conversions = {
    "0": 0,
    "1": 1,
    "2": 2,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
    "7": 7,
    "8": 8,
    "9": 9,
    "A": 10,
    "B": 11,
    "C": 12,
    "D": 13,
    "E": 14,
    "F": 15,
}

hexa = "0xF9"


def hex_to_dec(hexa):
    if hexa.startswith("0x"):
        hexa = hexa[2:]
    dec = sum(conversions[item] * (16**index) for index, item in enumerate(hexa[::-1]))
    return dec


def dec_to_bin(dec):
    bin_num = []
    while dec > 0:
        bin_num.append(dec % 2)
        dec = int(dec / 2)
    return bin_num[::-1]


bin_numb = "0111010101101"


def bin_to_hex(bin_num):
    # might want to flip the whole thing to start off with
    bin_num = bin_num[::-1]
    inv_conv = {v: k for k, v in conversions.items()}
    hexa = []
    for i in range(0, len(bin_num), 4):
        chunk = bin_num[i : i + 4]
        dec = sum([2**index for index, item in enumerate(chunk) if item == "1"])
        hexa.append(inv_conv[dec])
    print("".join(hexa[::-1]))


print(bin_numb)
bin_to_hex(bin_numb)
