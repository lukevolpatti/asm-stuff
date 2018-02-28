.global _start
_start:
  
#r2: return value when reading from UART
#r4: write value when writing to UART
#r10: JTAG UART address
#r11: current sensor data
#r12: current speed data
#r13-r18: reserved for immediate values
#r20: temporary register
#r21: temporary register

# Note: parameters need some tuning!

movia r10, 0x10001020 # putting the address in

OnePossibleAlgorithm:
  call ReadSensorsAndSpeed
  
  movui r13, 0x1f
  movui r14, 0x1e
  movui r15, 0x1c
  movui r16, 0x0f
  movui r17, 0x07
 # movui r18, 0x32 # max speed

  call SetAcceleration

  # Decide what to do
  beq r11, r13, STEERSTRAIGHT
  #if sensors are 0x1f
    call SetSteering to steer straight

  beq r11, r14, STEERRIGHT
  #if sensors are 0x1e
    call SetSteering to steer right

  beq r11, r15, STEERRIGHTHARD
  #if sensors are 0x1c
    call SetSteering to steer hard right

  beq r11, r16, STEERLEFT
  #if sensors are 0x1f
    call SetSteering to steer left

  beq r11, r17, STEERLEFTHARD
  #if sensors are 0x07
    call SetSteering to steer hard left

  br OnePossibleAlgorithm

STEERSTRAIGHT:
  movui r18, 0x40
  movui r5, 0x00
  call SetSteering
  br OnePossibleAlgorithm

STEERRIGHT:
  movui r18, 0xE0
  movui r5, 0x40
  call SetSteering
  br OnePossibleAlgorithm

STEERRIGHTHARD:
  movui r18, 0xFF
  movui r5, 0x70
  call SetSteering
  br OnePossibleAlgorithm

STEERLEFT:
  movui r18, 0xE0
  movui r5, 0xC0
  call SetSteering
  br OnePossibleAlgorithm

STEERLEFTHARD:
  movui r18, 0xFF
  movui r5, 0xF0
  br OnePossibleAlgorithm

SetAcceleration:
mov r21, ra

WRITE0X04:
  ldwio r20, 4(r10)
  srli r20, r20, 16
  beq r20, r0, WRITE0X04
  movui r4, 0x04
  call WriteOneByteToUART
  
blt r12, r18, WRITEACCELERATION # check if current speed is less than set value in r18
br NOSPEED

WRITEACCELERATION:
  ldwio r20, 4(r10)
  srli r20, r20, 16
  beq r20, r0, WRITEACCELERATION
  movui r4, 0x7F # write max acceleration
  call WriteOneByteToUART
  br ENDSPEED

NOSPEED:
  ldwio r20, 4(r10)
  srli r20, r20, 16
  beq r20, r0, NOSPEED
  mov r4, r0 # write zero acceleration
  call WriteOneByteToUART

ENDSPEED:
mov ra, r21
ret
  
ReadSensorsAndSpeed:
mov r21, ra
# Poll to write 0x02
WRITE0X02:
  ldwio r20, 4(r10)
  srli r20, r20, 16
  beq r20, r0, WRITE0X02
  movui r4, 0x02 # put 0x02 in r4
  call WriteOneByteToUART

  # Read the response.
# Poll for 0x00
CHECKZERO:
  call ReadOneByteFromUART
  andi r20, r2, 0x8000 # mask other bits
  beq r20, r0, CHECKZERO # check if data is valid
  andi r20, r2, 0x00FF # data is valid. store it in r20.
  bne r20, r0, CHECKZERO # make sure data is 0x00. otherwise restart.

# Poll for sensor data
CHECKSENSOR:
  call ReadOneByteFromUART
  andi r20, r2, 0x8000
  beq r20, r0, CHECKSENSOR
  andi r11, r2, 0x00FF # sensor data is now in r11

# Poll for speed data
CHECKSPEED:
  call ReadOneByteFromUART
  andi r20, r2, 0x8000
  beq r20, r0, CHECKSPEED
  andi r12, r2, 0x00FF # speed data is now in r12

  mov ra, r21
  ret

  
SetSteering:
mov r21, ra
WRITE0X05:
  ldwio r20, 4(r10)
  srli r20, r20, 16
  beq r20, r0, WRITE0X05
  movui r4, 0x05 # 0x05 specifies steering is to be changed
  call WriteOneByteToUART

WRITESTEERING:
  ldwio r20, 4(r10)
  srli r20, r20, 16
  beq r20, r0, WRITESTEERING
  mov r4, r5 # move r5 (which contains the new steering value) to r4
  call WriteOneByteToUART

  mov ra, r21
  ret

WriteOneByteToUART:
  stwio r4, 0(r10) # send the value in r4 to UART
  ret

ReadOneByteFromUART:
  ldwio r2, 0(r10)
  ret

