# PING-PONG-GAME-in-Assembly-Language
Description
This is a PING PONG game developed in 8086 Assembly Language, designed for educational and nostalgic gaming purposes. It runs in real mode, utilizing interrupts and low-level VGA memory management to display game graphics and manage controls.

Key Features:
Interactive Gameplay:

Two-player game with controls:
Player 1: W (up), S (down).
Player 2: Arrow keys (↑, ↓).
Pause the game by pressing P.
Score Tracking:

Scores are displayed on-screen.
First player to reach a score of 5 wins.
Victory Message:

Displays the winning player's message when either score reaches 5.
Restart/Exit Options:

After a game ends, players can restart (R) or exit (E).
Graphics:

Implements VGA text-mode graphics.
Game boundaries, paddles, and the ball are visually represented.
Delay Function:

Ensures smooth movement of the ball and paddles.
Collision Detection:

Handles paddle-ball collisions and wall boundaries.
Code Organization:
Memory Declarations: All constants, strings, and variables are stored at the start.
Subroutines:
clrScr: Clears the screen for a fresh display.
Welcome: Displays a welcome message.
draw_creator: Displays the names of the creators.
Printing_boundaries: Draws the upper and lower boundaries.
draw_paddle: Draws the paddles.
move_paddle: Handles paddle movement based on user input.
draw_ball and move_ball: Manages the ball's movement and collision detection.
draw_score: Displays player scores.
pause_game: Pauses the game until P is pressed again.
increase_score_count: Updates scores when the ball crosses paddles.
reset_ball_position: Resets the ball's position upon scoring.
draw_player_won: Displays the winning player's message.
draw_restart_exit_option: Provides options to restart or exit the game.
Instructions to Run:
Environment:

Requires an x86 emulator (e.g., DOSBox or EMU8086).
Assembled using tools like MASM or TASM.
Steps:

Assemble the code into a .COM or .EXE file.
Run the game in an emulator.
