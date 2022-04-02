// - - - - - - - -
// HWSW Lab5 C Code
// Authors: Weston Early and Evan McKenzie
//
// Function: This program runs a guessing game in C that uses two methods
// 	     to read and write to the JTAG UART terminal for user interaction
//
// Arguments: JTAG UART Base Address, clock signal
//
// Return: The printed statements from the game to the UART terminal
// - - - - - - - - 

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <string.h>

//Inline Implementations

void JTAGStringWrite(volatile uint32_t * UARTBaseAddress, char * stringToPrint){
	
		asm("add r3, r0, %[Rstr]\n\t"
			"add r6, r0, %[Rjtag]\n\t"
		"ldb r4, 0(r3)\n"
		"LOOP1:\n\t"
		"beq r0, r4, END\n"
		"LOOP2:\n\t"
		"ldwio r5, 4(r6)\n\t"
		"srli r5, r5, 16\n\t"
		"beq r5, r0, LOOP2\n\t"
		"stbio r4, 0(r6)\n\t"
		"addi r3, r3, 1\n\t"
		"ldb r4, 0(r3)\n\t"
		"br LOOP1\n"
		"END:\n"
		:
		:[Rjtag] "r" (UARTBaseAddress), [Rstr] "r" (stringToPrint)
		);
}

void JTAGStringRead(volatile uint32_t * UARTBaseAddress, char * returnString){

	uint32_t flag = 0;
    uint8_t c;

	asm volatile(
	"movi r5, 0x7FFF                                \n\t"
	"addi r5, r5, 1									\n\t"
	"movi r4, 10									\n\t"
	"add r6, r0, %[RJtag]							\n\t"
	"add r8, r0, %[returnString]					\n\t"
	"ldwio %[flag], 0(r6)							\n"
    "LOOP3:                                         \n\t"
		"and r7, %[flag], r5                        \n\t"
		"beq r5, r7, END5	                       	\n\t"
    	"ldwio %[flag], 0(r6)						\n\t"
    	"br LOOP3                                   \n"
	"LOOP4:											\n\t"
		"beq %[c], r4, END4							\n\t"
		"ldwio %[flag], 0(r6)						\n\t"
		"LOOP5:                                     \n\t"
			"and r7, %[flag], r5                    \n\t"
			"beq r5, r7, END5						\n\t"
			"ldwio %[flag], 0(r6)					\n\t"
			"br LOOP5                               \n"
	"END5:											\n\t"
		"andi %[c], %[flag], 0xff					\n\t"
		"stb %[c], 0(r8)							\n\t"
		"addi r8, r8, 1								\n\t"
		"br LOOP4									\n"
	"END4:											\n"
        :[flag] "=r" (flag), [c] "=r" (c)
		:[RJtag] "r" (UARTBaseAddress), [returnString] "r" (returnString)
		:"r4", "r5", "r6", "r7"	
	);
	
	

}

/*

C Implementations
void JTAGStringWrite(volatile uint32_t * UARTBaseAddress, char * stringToPrint){

	char* c = stringToPrint;
	
	while ('\0' != *c)
	{
  		while (0 == (*(UARTBaseAddress+1) >> 16)) ; // wait for room in the FIFO
  		*UARTBaseAddress = *c;
  		c++;
	}
	
	

}

void JTAGStringRead(volatile uint32_t * UARTBaseAddress, char * returnString){

	
	uint32_t flagData = 0;
	uint8_t charThing;

	flagData = *UARTBaseAddress;
	
	while (0x8000 != (flagData & 0x8000)) 
	{
		flagData = *UARTBaseAddress;
	}
	charThing = (uint8_t) (flagData & 0xFF);
	*returnString = charThing;
	*returnString++;
	
	while (charThing != '\n')
	{
		flagData = *UARTBaseAddress;
		while (0x8000 != (flagData & 0x8000)) 
		{
			flagData = *UARTBaseAddress;
		}
		charThing = (uint8_t) (flagData & 0xFF);
		*returnString = charThing;
		*returnString++;
	}

	
}
*/


//Main Method and Game Logic
	
int main()
{
    
    srand(time(NULL));
    
	volatile uint32_t* jtagBase = 0xff201000;
    
    int random_number = rand() % 100 + 1;
    int guesses = 5;
    JTAGStringWrite(jtagBase, "Welcome to the Game! Please guess a number between 1 and 100!\n");
    
    char guess_buf[3];
	int guess;
	
	char *output;
	
    while(1)
	{
		
        JTAGStringRead(jtagBase, guess_buf);
		//printf("result from read: %s\n", guess_buf);
    	guess = atoi(guess_buf);
		
        if(guess < random_number && guesses > 0)
        {
            guesses = guesses - 1;
            if(guesses == 0)
            {
                
				sprintf(output, "Loser! The correct number was %d \n", random_number);
				JTAGStringWrite(jtagBase, output);
                return 0;
            }
            else
            {
				sprintf(output, "Too Low! Try Again!  %d Guess(es) Remaining! \n", guesses);
                JTAGStringWrite(jtagBase, output);
            }
        }
        if(guess > random_number && guesses > 0)
        {
            guesses = guesses - 1;
            if(guesses == 0)
            {
				sprintf(output, "Loser! The correct number was %d \n", random_number);
                JTAGStringWrite(jtagBase, output);
                return 0;
            }
            else
            {
				sprintf(output, "Too High! Try Again! %d Guess(es) Remaining! \n", guesses);
                JTAGStringWrite(jtagBase, output);
            }
        }
        if(guess == random_number)
        {
            JTAGStringWrite(jtagBase, "WINNER");
            return 0;
        }
    }
}