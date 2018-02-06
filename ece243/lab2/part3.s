IN_LIST:        # List of 10 signed halfwords starting at address IN_LIST
    .hword 1
    .hword -1
    .hword -2
    .hword 2
    .hword 0
    .hword -3
    .hword 100
    .hword 0xff9c
    .hword 0b1111
LAST:			 	# These 2 bytes are the last halfword in IN_LIST
    .byte  0x01		  	    # address LAST
    .byte  0x02		  	    # address LAST+1
    
IN_LINKED_LIST:                     # Used only in Part 3
    A: .word 1
       .word B
    B: .word -1
       .word C
    C: .word -2
       .word E + 8
    D: .word 2
       .word C
    E: .word 0
       .word K
    F: .word -3
       .word G
    G: .word 100
       .word J
    H: .word 0xffffff9c
       .word E
    I: .word 0xff9c
       .word H
    J: .word 0b1111
       .word IN_LINKED_LIST + 0x40
    K: .byte 0x01		    # address K
       .byte 0x02		    # address K+1
       .byte 0x03		    # address K+2
       .byte 0x04		    # address K+3
       .word 0
    
OUT_NEGATIVE:
    .skip 40     # Reserve space for 10 output words
    
OUT_POSITIVE:
    .skip 40     # Reserve space for 10 output words

.global _start
_start:
	# r2 holds the number of negative numbers in the list
    # r3 holds the number of positive numbers in the list
    # r8 holds the memory location of the current element in the list
    # r9 is loop counter
	# r10 holds the negative number output current element
    # r11 holds the positive number output current element
    
    mov r2, r0 # setting our number counters to zero
    mov r3, r0
    movia r8, IN_LINKED_LIST # setting r8 to the start of the list
    movi r9, 9 # initializing the counter
    
    movia r10, OUT_NEGATIVE
    movia r11, OUT_POSITIVE
    
    ITERATE:
    beq r8, r0, LOOPFOREVER
    ldw r16, 0(r8) # load the current word into r16
    beq r16, r0, LOOPFOREVER # we've reached the end of the list
    bgt r16, r0, POSITIVE_NUMBER # the current number is positive
    blt r16, r0, NEGATIVE_NUMBER # the current number is negative
    
    ITERATE_CONTINUE: # continue the iteration after taking
    				    # appropriate action
    ldw r8, 4(r8) # move r8 to the next word in the list
    subi r9, r9, 1 # decrement the counter
    br ITERATE
    
    POSITIVE_NUMBER:
    addi r3, r3, 1 # increment our positive number count
    stw r16, 0(r11)   # store the current value in the pos num list
    addi r11, r11, 4 # set r11 to the next word
    br ITERATE_CONTINUE
    
    NEGATIVE_NUMBER:
    addi r2, r2, 1 # increment our negative number count
    stw r16, 0(r10)   # store the current value in the neg num list
    addi r10, r10, 4 # set r10 to the next word
    br ITERATE_CONTINUE
    
    LOOPFOREVER:
    br LOOPFOREVER