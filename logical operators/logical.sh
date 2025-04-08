#!/bin/bash
# Logical operators are used to combine multiple conditions in a single if statement.
# The logical operators in bash are:
# && (and)
# || (or)
# ! (not)
# The && operator is used to check if both conditions are true.
# The || operator is used to check if at least one condition is true.
# The ! operator is used to check if a condition is false.


# Example of using logical operators
# Example of using logical operators
# ==========================================================

# Example of using && (AND)
echo -e "\n--- Example of AND operator (&&) ---"
read -p "Enter a number between 1 and 10: " number

if [[ $number -ge 1 && $number -le 10 ]]; then
    echo "The number is within the valid range."
else
    echo "The number is outside the valid range."
fi

# Example of using || (OR)
echo -e "\n--- Example of OR operator (||) ---"
read -p "Enter a day of the week: " day
day=$(echo "$day" | tr '[:upper:]' '[:lower:]')

if [[ "$day" == "saturday" || "$day" == "sunday" ]]; then
    echo "It's a weekend day!"
else
    echo "It's a weekday."
fi

# Example of using ! (NOT)
echo -e "\n--- Example of NOT operator (!) ---"
read -p "Are you a robot? (yes/no): " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [[ ! "$answer" == "yes" ]]; then
    echo "Welcome, human!"
else
    echo "Beep boop, hello fellow robot!"
fi
