/*********
 * 
 * Write the assembly function:
 *     printn ( char * , ... ) ;
 * Use the following C functions:
 *     printHex ( int ) ;
 *     printOct ( int ) ;
 *     printDec ( int ) ;
 * 
 * Note that 'a' is a valid integer, so movi r2, 'a' is valid, and you don't need to look up ASCII values.
 *********/

.global	printn
printn:

	mov r19, r4 # moving the string address to r19
	subi sp, sp, 16 # move the stack pointer four words up
	stw ra, 0(sp) # putting the current return address on the stack
	stw r5, 4(sp) # putting the first few parameters on the stack
	stw r6, 8(sp)
	stw r7, 12(sp)
	mov r20, sp # move the top of the data portion of the stack to a temp reg
	addi r20, r20, 4


	# Setting up our registers. Using callee-saved. Sits on top of data portion of stack.
	subi sp, sp, 24
	stw r16, 0(sp)
	stw r17, 4(sp)
	stw r18, 8(sp)
	stw r19, 12(sp)
	stw r20, 16(sp)
	stw r21, 20(sp)

	addi r16, r0, 'D' # decimal
	addi r17, r0, 'O' # octal
	addi r18, r0, 'H' # hexadecimal

	

	LOOP:
	ldb r21, 0(r19) # r21 is temp reg that will hold the current element
	beq r21, r0, PRINT_RET # we've reached the end of the string
	ldw r4, 0(r20) # load the current number to be printed
	
	beq r21, r16, DECIMAL
	beq r21, r17, OCTAL
	beq r21, r18, HEX

	INCREMENT:
	addi r19, r19, 1 # going to the next element in the string
	addi r20, r20, 4 # going to the next element in the stack
	br LOOP

	PRINT_RET:
	ldw ra, 24(sp)

	# getting the initial register values from the stack
	ldw r16, 0(sp)
	ldw r17, 4(sp)
	ldw r18, 8(sp)
	ldw r19, 12(sp)
	ldw r20, 16(sp)
	ldw r21, 20(sp)
    ret

DECIMAL:
call printDec
br INCREMENT

OCTAL:
call printOct
br INCREMENT

HEX:
call printHex
br INCREMENT
