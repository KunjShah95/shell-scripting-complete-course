#!/bin/bash

# Function to check connectivity to a website
check_connectivity() {
    local website=$1
    local ping_count=3

    echo "Checking connectivity to $website..."

    if ping -c "$ping_count" "$website" > /dev/null 2>&1; then
        echo "Connectivity to $website: OK"
        return 0
    else
        echo "Connectivity to $website: FAILED"
        return 1
    fi
}

# Ask user for website input
echo "Enter website to check connectivity (e.g., google.com): "
read website

# Check connectivity to the user-provided website
check_connectivity "$website"

# Optional: Ask if user wants to check another website
echo -e "\nDo you want to check another website? (y/n): "
read answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    echo "Enter another website: "
    read website2
    check_connectivity "$website2"
fi
