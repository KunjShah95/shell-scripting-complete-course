#!/bin/bash

while IFS="," read -r name age department salary
do
  echo "Name: $name"
  echo "Age: $age"
  echo "Department: $department"
  echo "Salary: $salary"
done < name.csv