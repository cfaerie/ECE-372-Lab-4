# ECE 372 Lab 4
Authors: Rachel & Ali

The onjective is to have students figure out how to access the buttons and switches that are on the 
DRAGON12 development board. 

The program will receive inputs from four pushbuttons and five switches located on the development
board under PORT H (PORTH). THe program will use the 8-bit LED output on the board, as well as a
green and red LED output. The push buttons are PH0, PH1, PH2, and PH3. The last four red DIP switches
on the DRAGON12 board must be in the UP position for the push buttons to work.

There are four scenarios that the program must handle:

Scenario 1: User presses PH3: The program should display a random value to the 8-bit LED output on the
development board.

Scenario 2: User presses PH2: The program should logically shift the 8-bit LED's to the left.

Scenario 3: User presses PH1: The program should arithmetically shift the 8-bit LED's right.

Scenario 4: User presses PH0: The program implements 5-input majority voting logic. The program will
only read the five leftmost DIP switch bits as an input. If the number of '1' bits is more than the
number of bits set to '0', then a green LED will be lit, declaring a majority of '1' bits. Otherwise,
the red LED will be lit.
