# Hangman

*created by Vic Vansteelant and Simeon Atanasov*

## Compilation
Run `make` in the parent directory of `src`. A `bin` folder containing object files will be generated. 

## Usage
The game is invoked by providing a dictionary file as an argument. Example dictionary files are provided. Example:
`./hangman dictionary.txt`

The user enters *lowercase* characters for their attempts at guessing the word. If the player fails to guess the letter 7 times, they lose their streak. Otherwise, their st**r**eak count gets incremented.

## Notes
The program generates a file called `scoreboard.txt` which contains the contents of the leaderboard. Five players can earn a spot on the leaderboard.

## Acknowledgements

We would like to express our gratitude towards the CSE1400 team for providing the `brainf*ck` base archive, for its source files were paramount for building our understanding of both file handling and Makefile creation.
