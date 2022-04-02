# ========================================================================== BOF
# Orig: 2021.06.01 - Kit Cischke
# Rev : 2021.09.22 - Evan McKenzie
# FUNC: This code takes a list of numbers and flips them
	so that the first number of the first list becomes
	the last number of the second. This is done over
	and over again, flipping the list back and forth
# r0 = zero constant
# r6 = constant value as defined by NumEntries
# r7 = address of forwardsList variable
# r8 = first value in forwardsList
# r9 = address of first byte of last element in backwardsList
# RETN: backwardsList holds the reverse of the original forwardsList
# ------------------------------------------------------------------------------

.include "nios_macros.s"  # defines pseudo-instructions

# Code goes in the text portion of the memory
# We also need to make the _main label visible
# to the alt_main.c code.
.text
.global _main
_main:

# MOVIA gets the *address* of a variable
 movia r7, forwardsList
# Now get the first value in the list
 ldw r8, 0(r7)

# Now the backwards list
 movia r9, backwardsList
# BUT... move to the first byte of the last slot
 addi r9, r9, 24

# Dealing with constants is a little weird. The MOVIA
# will get the actual value of numEntries.
 movia r6, numEntries

Loop:
# Store the entry (from r8) to the address pointed to by r9
 stw r8, 0(r9)

# Now bookkeeping. Move the pointers.
 addi r7, r7, 4
 subi r9, r9, 4

# Then the counter.
 subi r6, r6, 1

# If the counter = 0, we're done.
 beq r6, r0, END
 
 br Loop

 # Infinite Loop lets user view the results
 
END:
  br END

# ------------------------------------------------------------------------------

.data                        # Load data into .data partition of mem

.equ numEntries, 7

# This is the list in the forwards direction, initialized.
forwardsList:
.word 4,5,3,6,9,8,2

//.word -2,3,4,9,-1,11,16,1,0,1,1,1,1
//.word 1,2,3,4,5,6,7,8,9,-2

# This is the list in the backwards directions, uninitialized.
backwardsList:
.skip numEntries * 4

.end

# ========================================================================== EOF
