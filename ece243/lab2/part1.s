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
    movia r8, IN_LIST # setting r8 to the start of the list
    movi r9, 9 # initializing the counter
    
    movia r10, OUT_NEGATIVE
    movia r11, OUT_POSITIVE
    
    ITERATE:
    beq r9, r0, LOOPFOREVER
    ldh r16, 0(r8) # load the current hword into r16
    bge r16, r0, POSITIVE_NUMBER # the current number is positive
    blt r16, r0, NEGATIVE_NUMBER # the current number is negative
    
    ITERATE_CONTINUE: # continue the iteration after taking
    				  # appropriate action
    addi r8, r8, 2 # move r8 to the next half word in the list
    subi r9, r9, 1 # decrement the counter
    br ITERATE
    
    POSITIVE_NUMBER:
    addi r3, r3, 1 # increment our positive number count
    sth r16, 0(r11)   # store the current value in the pos num list
    addi r11, r11, 4 # set r11 to the next half word
    br ITERATE_CONTINUE
    
    NEGATIVE_NUMBER:
    addi r2, r2, 1 # increment our negative number count
    sth r16, 0(r10)   # store the current value in the neg num list
    addi r10, r10, 4 # set r10 to the next half word
    br ITERATE_CONTINUE
    
    LOOPFOREVER:
    br LOOPFOREVER