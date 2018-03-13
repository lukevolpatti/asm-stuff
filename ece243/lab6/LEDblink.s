.equ RED_LEDS, 0xFF200000
.equ TIMER, 0xFF202000

/*
Register allocation:
r9: LED address
r10: temp value
r11: Timer address
*/

.global _start
_start:
# Setup:
movia r9, RED_LEDS  # putting LEDS in register
movia r11, TIMER # putting timer in register
movi r10, 0b01 # enabling interrupts on the timer
stwio r10, 4(r11)
wrctl ctl3, r10 # enabling IRQ line 1
wrctl ctl0, r10 # enable interrupts on the processor
movui r10, 0b1110000100000000 # setting lower 16 bits
stwio r10, 8(r11)
movui r10, 0b10111110101 # setting upper 18 bits
stwio r10, 12(r11)
movui r10, 0b0111 # starting the timer CHECK THIS!
stwio r10, 4(r11)

/*
movi r10, 0b11111111
stwio r10, 0(r9)*/

LOOP:
br LOOP

.section .exceptions, "ax"
myISR:
# flip the state of the LED:
ldwio et, 0(r9)
xori et, r10, 0b0001
stwio et, 0(r9)

# reset the timer
mov et, r0
stwio et, 0(r11)

subi ea, ea, 4
eret
