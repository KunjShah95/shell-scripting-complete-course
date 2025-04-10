#!/bin/bash

for i in {1..10}
do
  echo "Iteration $i"
  if [ $i -eq 5 ]; then
    break
  fi
done