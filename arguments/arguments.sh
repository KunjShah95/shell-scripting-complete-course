#!/bin/bash

#to access the arguments
echo "First argument is : $1"
echo "Second argument is : $2"
echo "All the arguments are - $ @"
echo "Numbers of arguments are - $#"

for filename in $ @
do
  echo "Copying  file - $filename"
done
