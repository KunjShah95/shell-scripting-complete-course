#!/bin/bash
x=10  # Initialize variable x with value 10
y=2   # Initialize variable y with value 2

# Arithmetic operations using the $(( )) syntax
sum=$((x+y))     # Add x and y
diff=$((x-y))    # Subtract y from x
prod=$((x*y))    # Multiply x and y
quot=$((x/y))    # Divide x by y (integer division)
rem=$((x%y))     # Get remainder of x divided by y (modulo)
echo "Sum: $sum"
echo "Difference: $diff"
echo "Product: $prod"
echo "Quotient: $quot"
echo "Remainder: $rem"

# Alternative syntax for arithmetic operations
(( sum=x+y ))    # Directly assign sum without $ for the variable
echo "Sum: $sum"

(( x++ ))        # Increment x by 1 (post-increment)
(( x=5*10 ))     # Assign x the result of 5*10 (50)
echo "x: $x"

x=5              # Reset x to 5

echo "Initial value of x: $x"  # Output: 5

(( x++ ))        # Post-increment: use x first, then increment
echo "Value of x after post-increment: $x"  # Output: 6

(( ++x ))        # Pre-increment: increment x first, then use it
echo "Value of x after pre-increment: $x"  # Output: 7

y=10             # Initialize y to 10
echo "Value of y: $y" # Output: 10
echo "Value of y after post-increment in echo: $((y++))" # Output: 10 (y is used, then incremented)
echo "Value of y after post-increment: $y" # Output: 11 (y is now 11)
echo "Value of y after pre-increment in echo: $((++y))" # Output: 12 (y is incremented first, then used)
echo "Value of y after pre-increment: $y" # Output: 12 (y is still 12)

x=5              # Reset x to 5

echo "Initial value of x: $x"  # Output: 5

let x=x+1        # Another way to do arithmetic: using 'let' command
echo "Value of x after incrementing using let: $x"  # Output: 6

let x+=1         # Shorthand increment with let
echo "Value of x after incrementing using let: $x" # Output: 7


x=5              # Reset x to 5

echo "Initial value of x: $x"  # Output: 5

x=$((x + 1))     # Using arithmetic expansion to increment and assign
echo "Value of x after incrementing using arithmetic expansion: $x"  # Output: 6