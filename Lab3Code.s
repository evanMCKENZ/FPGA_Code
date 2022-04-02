# ==============================================================================
# Orig: 2021.09.30 - Evan McKenzie and Joshua Gindt
# FUNC: This code uses a polling loop to check on the state
#	of the push buttons, and read data from the PIO's of
#	the switches to send to the PIO of the LED's
# ------------------------------------------------------------------------------
.global _main
_main:

# Get pointers for i/o devices 
 movia r2, SLIDER_BASE 
 movia r3, LED_BASE
 movia r4, PUSH_BASE 
 movia r5, SEVENSEG1_BASE
 movia r6, SEVENSEG2_BASE
 
# Move the flag for push buttons being pushed into a register 
 movia r7, FLAG_KEY_ZERO
 movia r8, FLAG_KEY_ONE
 movia r9, FLAG_KEY_TWO

# Get the pointer to the count
 movia r10, Count

# Value of the count pointer
 ldb r11, 0(r10)
 
# Show 0 on the seven segment displays
 addi r20, r0, 0x40
 stwio r20, 0(r5)
 stwio r20, 0(r6)

MainLoop:

# Take value of Sliders and light up correct LEDs
 ldwio r12, 0(r2) # Loads value of slider switches
 stwio r12, 0(r3) # Stores value into LEDs

 ldwio r14, 0(r4) # Grab the value of the push keys
 
# Check if Key[0] is pressed
 beq r15, r14, MainLoop #checks if already equal
 and r15, r14, r7
 beq r15, r14, RESET # r14 is zero if the zero key flag matched the keys
 
# Check if Key[1] is pressed
 and r15, r14, r8 # Subtracts the flag from the value of the keys
 beq r15, r14, ADD # r14 is zero if the zero key flag matched the keys
 
# Check if Key[2] is pressed
 and r15, r14, r9 # Subtracts the flag from the value of the keys
 beq r15, r14, SUB # r14 is zero if the zero key flag matched the keys

 addi r15, r0, 0

 br MainLoop

SEVENSEGDECODE_TENS:
 # Send digits to seven segments
 addi r21, r0, 10
 div r18, r11, r21 # Grab 10s digit
 muli r19, r18, 10
 sub r19, r11, r19
 beq r18, r0, SEVENSEG2_ZERO
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_ONE
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_TWO
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_THREE
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_FOUR
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_FIVE
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_SIX
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_SEVEN
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_EIGHT
 subi r18, r18, 1
 beq r18, r0, SEVENSEG2_NINE
SEVENSEGDECODE_ONES:
 beq r19, r0, SEVENSEG1_ZERO
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_ONE
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_TWO
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_THREE
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_FOUR
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_FIVE
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_SIX
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_SEVEN
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_EIGHT
 subi r19, r19, 1
 beq r19, r0, SEVENSEG1_NINE
 
 
 
RESET:
# Put zero into the count byte and go back to loop
 add r11, r0, r0
 br SEVENSEGDECODE_TENS
 
ADD:
# Check if count is 99, if so, reset
 subi r18, r11, 99
 beq r18, r0, RESET
# Clear r18
 addi r18, r0, 0
# Add to count and go back to loop
 addi r11, r11, 1
 br SEVENSEGDECODE_TENS
 
SUB:
#Make sure count is not 0
subi r18, r11, 0
 beq r18, r0, MainLoop
#Clear r18
addi r18, r0, 0
# Decrease count and go back to loop
 addi r11, r11, -1
 br SEVENSEGDECODE_TENS
 
SEVENSEG1_ZERO:
 addi r20, r0, 0x40
 stwio r20, 0(r5)
 br MainLoop
 
SEVENSEG1_ONE:
 addi r20, r0, 0xF9
 stwio r20, 0(r5)
 br MainLoop

SEVENSEG1_TWO:
 addi r20, r0, 0xA4
 stwio r20, 0(r5)
 br MainLoop
 
SEVENSEG1_THREE:
 addi r20, r0, 0xB0
 stwio r20, 0(r5)
 br MainLoop

SEVENSEG1_FOUR:
 addi r20, r0, 0x99
 stwio r20, 0(r5)
 br MainLoop
 
SEVENSEG1_FIVE:
 addi r20, r0, 0x92
 stwio r20, 0(r5)
 br MainLoop
 
SEVENSEG1_SIX:
 addi r20, r0, 0x02
 stwio r20, 0(r5)
 br MainLoop
 
SEVENSEG1_SEVEN:
 addi r20, r0, 0xF8
 stwio r20, 0(r5)
 br MainLoop

SEVENSEG1_EIGHT:
 addi r20, r0, 0x00
 stwio r20, 0(r5)
 br MainLoop
 
SEVENSEG1_NINE:
 addi r20, r0, 0x98
 stwio r20, 0(r5)
 br MainLoop
 
SEVENSEG2_ZERO:
 addi r20, r0, 0x40
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES
 
SEVENSEG2_ONE:
 addi r20, r0, 0xF9
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES

SEVENSEG2_TWO:
 addi r20, r0, 0xA4
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES
 
SEVENSEG2_THREE:
 addi r20, r0, 0xB0
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES

SEVENSEG2_FOUR:
 addi r20, r0, 0x99
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES
 
SEVENSEG2_FIVE:
 addi r20, r0, 0x92
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES
 
SEVENSEG2_SIX:
 addi r20, r0, 0x02
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES
 
SEVENSEG2_SEVEN:
 addi r20, r0, 0xF8
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES

SEVENSEG2_EIGHT:
 addi r20, r0, 0x00
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES
 
SEVENSEG2_NINE:
 addi r20, r0, 0x98
 stwio r20, 0(r6)
 br SEVENSEGDECODE_ONES
 
 
.data
# Base addresses for the PIO
.equ SLIDER_BASE, 0x00011070
.equ LED_BASE, 0x00011040
.equ PUSH_BASE, 0x00011060
.equ SEVENSEG1_BASE, 0x00011020
.equ SEVENSEG2_BASE, 0x00011000
# Flag to check if KEY[0] is pressed
.equ FLAG_KEY_ZERO, 0xE
# Flag to check if KEY[1] is pressed
.equ FLAG_KEY_ONE, 0xD
# Flag to check if KEY[2] is pressed
.equ FLAG_KEY_TWO, 0xB
# Counter for byte
Count: .byte 0
