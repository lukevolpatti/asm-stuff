.equ UART, 0xFF201000

.global _start
_start:
# Setup:
movia r9, UART # putting UART in register
movi r10, 0b01 # enabling interrupts on the UART
stwio r10, 4(r9)
wrctl ctl0, r10 # enabling interrupts on the processor
movi r10, 0b0100000000 # enabling IRQ line 8
wrctl ctl3, r10
movia sp, 0x04000000

LOOP:
br LOOP

.section .exceptions, "ax"
myISR:
subi sp, sp, 4
stw r11, 0(sp)
ldwio et, 0(r9) # getting data from UART
andi r11, et, 0b1000000000000000 # see if read is valid
beq r11, r0, ENDISR
andi r11, et, 0b011111111 # get the data bits
stwio r11, 0(r9) # write the data bits back

ENDISR:
ldw r11, 0(sp)
addi sp, sp, 4
subi ea, ea, 4
eret
