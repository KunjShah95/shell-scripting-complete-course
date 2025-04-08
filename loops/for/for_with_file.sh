#!/bin/bash

# This script demonstrates how to use a for loop to read lines from a file
file="/d/DIAGRAM/loops/for/names.txt"

for name in $(cat $file)
do
  echo "Name is  $name"
done
 