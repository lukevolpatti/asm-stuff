TimerDelay:

subi sp, sp, 32
stw r16, 0(sp)
stw r17, 4(sp)
stw r18, 8(sp)
stw r19, 12(sp)
stw r20, 16(sp)
stw r21, 20(sp)
stw r22, 24(sp)
stw r23, 28(sp)

movia r7, 0xFF202000
movui r2, 0b110
movui r3, 0b100
stwio r2, 8(r7)
stwio r3, 12(r7)

movui r2, 4
stwio r2, 4(r7) # start timer

ldw r16, 0(sp)
ldw r17, 4(sp)
ldw r18, 8(sp)
ldw r19, 12(sp)
ldw r20, 16(sp)
ldw r21, 20(sp)
ldw r22, 24(sp)
ldw r23, 28(sp)
addi sp, sp, 32

ret