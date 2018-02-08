# Print ten in octal, hexadecimal, and decimal
# Use the following C functions:
#     printHex ( int ) ;
#     printOct ( int ) ;
#     printDec ( int ) ;

.global main

main:
# ...
  addi r4, r0, 10
  call printOct

  addi r4, r0, 10
  call printHex

  addi r4, r0, 10
  call printDec
  ret	# Make sure this returns to main's caller
