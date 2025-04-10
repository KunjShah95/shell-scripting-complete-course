#!/bin/bash

# This script demonstrates shifting arguments.

echo "Creating users..."
echo "Username is $1"
echo "description is $2"

# Demonstrate shifting arguments
echo "Shifting arguments..."
shift
echo "After shift, the first argument is now: $1"
echo "And the second argument is now: $2"