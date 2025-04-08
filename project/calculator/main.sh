#!/bin/bash

calculate() {
  local num1=$1
  local operator=$2
  local num2=$3

  case "$operator" in
    "+")
      result=$(echo "$num1 + $num2" | bc)
      ;;
    "-")
      result=$(echo "$num1 - $num2" | bc)
      ;;
    "*")
      result=$(echo "$num1 * $num2" | bc)
      ;;
    "/")
      if (( $(echo "$num2 == 0" | bc -l) )); then
        echo "Error: Division by zero"
        return 1
      fi
      result=$(echo "scale=2; $num1 / $num2" | bc -l)
      ;;
    *)
      echo "Error: Invalid operator"
      return 1
      ;;
  esac

  echo "$result"
  return 0
}

while true; do
  read -p "Enter an expression (e.g., 2 + 3, or 'quit' to exit): " expression

  if [[ "$expression" == "quit" ]]; then
    echo "Exiting calculator."
    break
  fi

  if [[ "$expression" =~ ^([0-9.]+)\s*([-+*/])\s*([0-9.]+)$ ]]; then
    num1="${BASH_REMATCH[1]}"
    operator="${BASH_REMATCH[2]}"
    num2="${BASH_REMATCH[3]}"

    calculate "$num1" "$operator" "$num2"
  else
    echo "Error: Invalid expression format."
  fi
done
