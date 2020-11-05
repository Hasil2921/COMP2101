#!/bin/bash
#
# This script implements a guessing game
# it will pick a secret number from 1 to 10
# it will then repeatedly ask the user to guess the number
#    until the user gets it right

# Give the user instructions for the game
cat <<EOF
Let's play a game.
I will pick a secret number from 1 to 10 and you have to guess it.
If you get it right, you get a virtual prize.
Here we go!

EOF

# Pick the secret number and save it
secretnumber=$(($RANDOM % 10 +1)) # save our secret number to compare later
userguess=0
counter=4
# This loop repeatedly asks the user to guess and tells them if they got the right answer
# TASK 1: Test the user input to make sure it is not blank
# TASK 2: Test the user input to make sure it is a number from 1 to 10 inclusive
# TASK 3: Tell the user if their guess is too low, or too high after each incorrect guess

while [ $counter -gt 0 ]; do
  read -p "Give number from 1-10: "
  counter=$((counter-1))
  if [ "$userguess" = "" -o "$userguess" -lt 0 -o "$userguess" -gt 10 ]; then
    echo "Give me number from 1 to 10"
    continue
  else
    echo
  fi
done
