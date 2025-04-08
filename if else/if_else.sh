#!/bin/bash

# Script to demonstrate if-else statements in bash
read -p "Enter your marks: " marks

 if [[  $marks -ge 40 ]]; then
    echo "You have passed the exam."
 else
    echo "You have failed the exam."
fi
# The above script uses if-else statements to determine the grade based on marks.
# It prompts the user to enter their marks and then checks the value of marks against various conditions.
# Depending on the range of marks, it prints the corresponding grade.