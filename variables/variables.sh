#!/bin/bash

#Script to how to use variables in bash

a=10
name="Kunj"
echo "The value of a is $a"
echo "The value of name is $name"
echo "What is your name?"
read -r user_name
echo "Your name is $user_name"
read -p "Enter your age: " age
echo "Your age is $age"