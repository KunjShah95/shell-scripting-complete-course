#!/bin/bash

myArray=("apple" "banana" "cherry")
for fruit in "${myArray[@]}"
do
  echo "Fruit: $fruit"
done

length=${#myArray[*]}

for (( i=0; i<$length; i++ ))
do
  echo "Value of array is  ${myArray[$i]}"
done

