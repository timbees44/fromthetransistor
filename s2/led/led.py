# What we need
# - Clock -> need to set freq
# - Output starts at 0, 1 on pos edge clock
import time
import itertools

clock = 0 
freq = 500 # ms
iterations = 10
# out = we can just print either the clock value or on/off to represent the led out

def first_clock():
    for i in range(iterations):
        #print(i)
        if clock == 0:
            clock = 1
            print("on")
        else:
            clock = 0
            print("off")
        time.sleep(0.001 * freq) # sleep in seconds meaning we need to make it milli by * our freq by 0.001

def itertools_clock():
    clock_cycle = itertools.cycle([0,1])
    for _ in range(iterations):
        clock = next(clock_cycle) 
        print(clock)
        time.sleep(freq / 1000)

# Self built cycle function
def cycle(values: list[int]) -> int:
    while True:
        for value in values:
            print(value)
            yield value

def self_iter_clock():
    clock_cycle = cycle([0,1])
    for _ in range(iterations):
        clock = next(clock_cycle)

        time.sleep(freq / 1000)

self_iter_clock()
#first_clock()
#itertools_clock()

