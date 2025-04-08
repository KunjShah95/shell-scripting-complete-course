#!/bin/bash

# Script to demonstrate else-if statements in bash
read -p "Enter your marks: " marks
if [[ $marks -ge 90 ]]; then
    echo "You have received an A grade."
elif [[ $marks -ge 80 ]]; then
    echo "You have received a B grade."
elif [[ $marks -ge 70 ]]; then
    echo "You have received a C grade."
elif [[ $marks -ge 60 ]]; then
    echo "You have received a D grade."
elif [[ $marks -ge 50 ]]; then
    echo "You have received an E grade."
else
    echo "You have failed the exam."
fi