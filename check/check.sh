#!/bin/bash

filepath="D:\SHELL SCRIPTING\BASIC"

if [[ -d "$filepath" ]]; then
    echo "$filepath exists"
else
    echo "$filepath does not exist, creating it now..."
    mkdir -p "$filepath"
    
    if [[ -d "$filepath" ]]; then
        echo "$filepath has been created successfully"
    else
        echo "Failed to create $filepath"
    fi
fi