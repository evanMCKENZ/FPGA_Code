//------------------------------------------------------------------------------
// Prog: Blinky-Pure-C-Template.c
// Func: Given a Nios Timer module in continous run mode w/ a fixed period,
//       Toggle all 18 DE2-115 LEDs every time the timer rolls over past zero.
//
//------------------------------------------------------------------------------
#include <stdio.h>
#include <stdint.h>
	
#define LED_BASE 0xff200000       // LED PIO Base address. Value TBD.
#define TIMER_BASE 0xff202000     // TIMER   Base address. Value TBD.

int main()
{
  volatile uint32_t * LEDBase = (uint32_t *) LED_BASE;
  volatile uint16_t * TimerBase = (uint32_t *) TIMER_BASE;

  // Set all LEDs to OFF
  *LEDBase = 0x000;

  // Set timer CONT  bit to continuous mode
  // and set the START bit to start timer
  TimerBase[4] = 0xFFF6;
  

  while (1)
  {
    // spin while TO bit=0 (=> no rollover)
    while(TimerBase[0] == 0xFFFE);

    // Toggle all LEDs
    *LEDBase = *LEDBase ^ 0xFFF;

    // Clear timer TO bit
    TimerBase[0] = 0xFFFE;
  }

  return 0;
}
//------------------------------------------------------------------------------
