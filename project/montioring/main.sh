#!/bin/bash
# filepath: d:\SHELL SCRIPTING\project\monitoring free ram space\main.sh

# RAM Monitoring and Optimization Script

# Set threshold values (in percentage)
WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=90

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display RAM usage information
display_ram_info() {
    echo -e "${GREEN}RAM Usage Information:${NC}"
    free -m | grep -v total
    echo ""
    
    # Get memory usage percentage
    MEM_INFO=$(free | grep Mem)
    TOTAL=$(echo "$MEM_INFO" | awk '{print $2}')
    USED=$(echo "$MEM_INFO" | awk '{print $3}')
    FREE=$(echo "$MEM_INFO" | awk '{print $4}')
    SHARED=$(echo "$MEM_INFO" | awk '{print $5}')
    CACHE=$(echo "$MEM_INFO" | awk '{print $6}')
    AVAILABLE=$(echo "$MEM_INFO" | awk '{print $7}')
    
    # Calculate percentage
    MEM_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\", $USED/$TOTAL*100}")
    
    echo -e "Total Memory: $((TOTAL/1024)) MB"
    echo -e "Used Memory: $((USED/1024)) MB"
    echo -e "Free Memory: $((FREE/1024)) MB"
    echo -e "Cached Memory: $((CACHE/1024)) MB"
    echo -e "Available Memory: $((AVAILABLE/1024)) MB"
    
    # Display usage percentage with color based on threshold
    if (( $(echo "$MEM_PERCENTAGE >= $CRITICAL_THRESHOLD" | bc -l) )); then
        echo -e "Memory Usage: ${RED}$MEM_PERCENTAGE%${NC} [CRITICAL]"
    elif (( $(echo "$MEM_PERCENTAGE >= $WARNING_THRESHOLD" | bc -l) )); then
        echo -e "Memory Usage: ${YELLOW}$MEM_PERCENTAGE%${NC} [WARNING]"
    else
        echo -e "Memory Usage: ${GREEN}$MEM_PERCENTAGE%${NC} [NORMAL]"
    fi
}

# Function to clear cache and free up memory
clear_memory_cache() {
    echo -e "\n${YELLOW}Clearing memory cache...${NC}"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux specific commands
        echo "Synchronizing cached writes to persistent storage..."
        sync
        
        echo "Clearing PageCache..."
        sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
        
        echo "Clearing dentries and inodes..."
        sudo sh -c "echo 2 > /proc/sys/vm/drop_caches"
        
        echo "Clearing PageCache, dentries and inodes..."
        sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
        # Windows specific (if running in Git Bash/MinGW)
        echo "On Windows, using available methods..."
        # Empty working set of processes using PowerShell
        powershell -Command "Get-Process | ForEach-Object { \$_.MinWorkingSet = \$_.MinWorkingSet }"
        # Run garbage collection
        powershell -Command "[System.GC]::Collect()"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS specific
        echo "Purging memory cache on macOS..."
        sudo purge
    else
        echo "Unsupported operating system for memory cache clearing."
    fi
    
    echo -e "${GREEN}Memory cache cleared.${NC}"
}

# Function to display top memory-consuming processes
show_top_processes() {
    echo -e "\n${GREEN}Top 5 Memory-Consuming Processes:${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
        # Linux or macOS
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
        # Windows
        powershell -Command "Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 5 | Format-Table -Property Id, ProcessName, WS"
    else
        echo "Unsupported operating system for process listing."
    fi
}

# Main menu function
show_menu() {
    echo -e "${GREEN}=== RAM Monitoring and Optimization Tool ===${NC}"
    echo "1. Display RAM Information"
    echo "2. Clear Memory Cache"
    echo "3. Show Top Memory-Consuming Processes"
    echo "4. Monitor RAM Usage (Updates every 5 seconds, press Ctrl+C to stop)"
    echo "5. Exit"
    echo -n "Enter your choice (1-5): "
}

# Continuous monitoring function
monitor_ram() {
    echo -e "\n${GREEN}Starting RAM Monitoring (Press Ctrl+C to stop)${NC}"
    while true; do
        clear
        echo -e "${GREEN}=== RAM Monitoring (Updated every 5s) ===${NC}"
        echo -e "Time: $(date +"%T")"
        display_ram_info
        show_top_processes
        
        # Check if memory usage exceeds critical threshold for automatic action
        MEM_INFO=$(free | grep Mem)
        TOTAL=$(echo "$MEM_INFO" | awk '{print $2}')
        USED=$(echo "$MEM_INFO" | awk '{print $3}')
        MEM_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\", $USED/$TOTAL*100}")
        
        if (( $(echo "$MEM_PERCENTAGE >= $CRITICAL_THRESHOLD" | bc -l) )); then
            echo -e "\n${RED}Critical memory usage detected. Automatically clearing cache...${NC}"
            clear_memory_cache
        fi
        
        sleep 5
    done
}

# Main script execution
while true; do
    clear
    show_menu
    read choice
    
    case $choice in
        1) clear; display_ram_info; read -p "Press Enter to continue..." ;;
        2) clear; display_ram_info; clear_memory_cache; display_ram_info; read -p "Press Enter to continue..." ;;
        3) clear; show_top_processes; read -p "Press Enter to continue..." ;;
        4) clear; monitor_ram ;;
        5) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Press Enter to continue..."; read ;;
    esac
done