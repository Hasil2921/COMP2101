#!/bin/bash
#
# this script rolls a pair of six-sided dice and displays both the rolls
#

# Task 1:
#  put the number of sides in a variable which is used as the range for the random number
#  put the bias, or minimum value for the generated number in another variable
#  roll the dice using the variables for the range and bias i.e. RANDOM % range + bias
echo "we have started processcing"

range=6
bias=1

echo "rolling"

Dice1=$((RANDOM%range+bias))
Dice2=$((RANDOM%range+bias))
# Task 2:
#  generate the sum of the dice
#  generate the average of the dice

sum=$((Dice1+Dice2))
avg=$((sum/2))

#  display a summary of what was rolled, and what the results of your arithmetic were
echo "result of dice1 roll: $Dice1"
echo "result of dice2 roll: $Dice2"
echo "result of sum of dice1 and dice2: $sum"
echo "average of Dice1 and Dice2: $avg"
