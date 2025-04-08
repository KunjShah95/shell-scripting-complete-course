#!/bin/bash

# Function to greet the user
greet() {
  echo "Hello, $1!"
}

# Function to calculate the sum of two numbers
sum() {
  local result=$(( $1 + $2 ))
  echo $result
}

# Function to check if a number is even
is_even() {
  if (( $1 % 2 == 0 )); then
    echo "true"
  else
    echo "false"
  fi
}

# Example usage
greet "World"
echo "Sum of 5 and 3 is: $(sum 5 3)"
echo "Is 10 even? $(is_even 10)"
echo "Is 7 even? $(is_even 7)"
