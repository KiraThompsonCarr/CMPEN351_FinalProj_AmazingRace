CMPEN 351 Final Project A-Maze-ing Race: A Timed Bitmap Maze Challenge Kira Carr

Project Summary

A-Maze-ing Race is a real-time maze navigation game built in MIPS assembly using the MARS bitmap display and keyboard simulator. In it, the player controls a traveling pixel using directional input, attempting to complete a sequence of three increasingly difficult mazes. Each maze is defined by a set of hard-coded wall coordinates stored in data tables. The user must complete each maze within 15 seconds to progress to the next maze. When the player successfully navigates to the end of a maze, the screen is cleared and the next maze is drawn, with the player pixel resetting to the new starting position. If the player completes all three mazes within their allotted time limit, the game ends and the player wins. If time runs out before the player has completed a maze, the game ends and the player loses.

MARS Configuration and User Interface

This project uses the bitmap display to visually render the maze and player. The bitmap setup requires the following steps: 
• In MARS, select Tools > Bitmap Display 
• Set Unit Width in Pixels and Unit Height in Pixels to 16 
• Set Display Width in Pixels and Display Height in Pixels to 256 
• Select Connect to MIPS 
• This window will now display message screens and the mazes

The keyboard simulator is used to capture user input, and is set up as follows: 
• In MARS, select Tools > Keyboard and Display MMIO Simulator 
• Select Connect to MIPS 
• Place the cursor in the lower window labeled KEYBOARD; here the player will use WASD keys to navigate the maze shown in the bitmap display

When the user selects “Run the current program” in MARS, the maze paths are drawn in white on a black background. The player pixel (cyan) is initialized in the bottom corner of the maze. The player moves using WASD keys; non-WASD keys are ignored. If an invalid move is attempted (i.e., using WASD keys but attempting to go through a wall), the pixel will briefly flash red before returning to its original color to give visual feedback.

The timer will require system calls to poll elapsed time when the system is validating user input. When the user has 5 seconds remaining, the player pixel turns orange as a visual indicator that time is running out. If a player makes it through all three mazes, she/he will see a “You win” screen, but if the player runs out of time before solving the maze, the screen reads, “You lose”. In either case, the program terminates and needs to be reset if the user intends to play again.
