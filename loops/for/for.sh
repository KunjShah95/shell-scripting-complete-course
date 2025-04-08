#!/bin/bash
#method 1
 for i in  1  2 3  4  5
    do
        echo "Number: $i"
    done

#method 2
for i in {1..5}
    do
        echo "Number: $i"
    done

#method 3
for (( i=1; i<=5; i++ ))
    do
        echo "Number: $i"
    done
