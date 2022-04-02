// - - - - - - - -
// HWSWLab1 C Code
// Authors: Joshua Gindt and Evan McKenzie
//
// Function: This program converts the binary value of a given integer in hexadecimal
//           notation into the gray code binary representation of that integer
//
// Arguments: None
//
// Return: The gray code equivalent of the given integer
// - - - - - - - - 

#include <stdio.h>
#include <stdint.h>

void PrintBinary(uint16_t n)
{ 
   uint16_t i = 0;
   for (i = 1 << 15; i > 0; i = i / 2)
   {
       (n & i) ? printf("1") : printf("0");		//ternary operator to print either a 1 or 0
   }
   printf("\n");
   return;
}

int main()
{
    uint16_t n = 0x123;				//original value
    uint16_t a = n >> 1;			//shift the original value one bit to the right
    n = n ^ a;					//xor the original value and the bit shifted value
    
    PrintBinary(n);			//call the PrintBinary function with our new value
    
    
    return 0;		//exit
}