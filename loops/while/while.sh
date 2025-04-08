#!/bin/bash

count=0
num=10

while [ $count -lt $num ]
do
  echo "Count is $count"
  ((count++))
done
echo "Final count is $count"