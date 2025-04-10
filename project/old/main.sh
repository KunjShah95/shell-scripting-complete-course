#!/bin/bash
# filepath: d:\SHELL SCRIPTING\project\old logs\main.sh

# RAM Monitoring and Optimization Script

# Set threshold values (in percentage)
WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=90
FILE_SIZE_THRESHOLD=20 # Size in MB

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display RAM usage information
display_ram_info() {
    echo -e "${GREEN}RAM Usage Information:${NC}"
    free -m | grep -v total 2>/dev/null || echo "Free command not available on this system."
    echo ""
    
    # Get memory usage percentage - using different methods based on OS
    if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
        # Linux or macOS
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
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
        # Windows specific
        MEM_INFO=$(powershell -Command "Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory")
        TOTAL=$(echo "$MEM_INFO" | grep -oP "TotalVisibleMemorySize\s*:\s*\K\d+")
        FREE=$(echo "$MEM_INFO" | grep -oP "FreePhysicalMemory\s*:\s*\K\d+")
        USED=$((TOTAL - FREE))
        
        # Calculate percentage and convert to MB
        MEM_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\", $USED/$TOTAL*100}")
        TOTAL_MB=$((TOTAL / 1024))
        USED_MB=$((USED / 1024))
        FREE_MB=$((FREE / 1024))
        
        echo -e "Total Memory: $TOTAL_MB MB"
        echo -e "Used Memory: $USED_MB MB"
        echo -e "Free Memory: $FREE_MB MB"
    fi
    
    # Display usage percentage with color based on threshold
    if (( $(echo "$MEM_PERCENTAGE >= $CRITICAL_THRESHOLD" | bc -l 2>/dev/null) )); then
        echo -e "Memory Usage: ${RED}$MEM_PERCENTAGE%${NC} [CRITICAL]"
    elif (( $(echo "$MEM_PERCENTAGE >= $WARNING_THRESHOLD" | bc -l 2>/dev/null) )); then
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

# Function to find and delete large files
find_large_files() {
    local drive_path=$1
    local size_threshold=$2
    
    echo -e "\n${GREEN}Searching for large files (>${size_threshold}MB) in ${drive_path}...${NC}"
    
    if [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
        # Convert Unix path to Windows path if needed
        if [[ "$drive_path" == /* ]]; then
            win_drive_path=$(cygpath -w "$drive_path")
        else
            win_drive_path="$drive_path"
        fi
        
        # Create a temporary file to store the results
        temp_file=$(mktemp -t large_files.XXXXXX)
        
        # Use PowerShell to find large files and output to the temp file
        powershell -Command "Get-ChildItem -Path '$win_drive_path' -Recurse -File -ErrorAction SilentlyContinue | Where-Object { \$_.Length -gt ${size_threshold}MB * 1MB } | Select-Object FullName, @{Name='SizeMB';Expression={\$_.Length / 1MB}} | Format-Table -AutoSize" > "$temp_file"
        
        # Display the results
        cat "$temp_file"
        
        # Count the number of files found
        file_count=$(powershell -Command "Get-ChildItem -Path '$win_drive_path' -Recurse -File -ErrorAction SilentlyContinue | Where-Object { \$_.Length -gt ${size_threshold}MB * 1MB } | Measure-Object | Select-Object -ExpandProperty Count")
        
        if [[ $file_count -eq 0 ]]; then
            echo -e "${YELLOW}No large files found.${NC}"
            rm "$temp_file"
            return
        fi
        
        echo -e "${YELLOW}Found $file_count files larger than ${size_threshold}MB.${NC}"
        
        read -p "Do you want to move these files to the recycle bin? (y/n): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            echo -e "${YELLOW}Moving files to recycle bin...${NC}"
            
            # Use PowerShell to move each large file to the recycle bin
            powershell -Command "Add-Type -AssemblyName Microsoft.VisualBasic; 
            Get-ChildItem -Path '$win_drive_path' -Recurse -File -ErrorAction SilentlyContinue | 
            Where-Object { \$_.Length -gt ${size_threshold}MB * 1MB } | 
            ForEach-Object { 
                \$path = \$_.FullName
                Write-Host \"Moving \$path to recycle bin...\"
                [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile(
                    \$path,
                    'OnlyErrorDialogs',
                    'SendToRecycleBin'
                )
            }"
            
            echo -e "${GREEN}Files moved to recycle bin successfully.${NC}"
        else
            echo -e "${YELLOW}Operation canceled.${NC}"
        fi
        
        rm "$temp_file"
    else
        # Linux/Mac implementation
        echo "This feature is currently optimized for Windows systems."
        echo "For Linux/Mac, we recommend using the 'find' command directly:"
        echo "find \"$drive_path\" -type f -size +${size_threshold}M -exec ls -lh {} \\;"
    fi
}

# Function to select a drive
select_drive() {
    if [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
        # Windows
        echo -e "${GREEN}Available drives:${NC}"
        drives=$(powershell -Command "Get-PSDrive -PSProvider FileSystem | Select-Object Name, Root | Format-Table -AutoSize")
        echo "$drives"
        
        # Ask user to select a drive
        read -p "Enter drive letter (e.g., C, D) or full path: " selected_drive
        
        # Convert to proper path format
        if [[ ${#selected_drive} -eq 1 ]]; then
            drive_path="${selected_drive}:\\"
        else
            drive_path="$selected_drive"
        fi
        
        # Ask user for file size threshold
        read -p "Enter file size threshold in MB (default: $FILE_SIZE_THRESHOLD): " size_input
        size_threshold=${size_input:-$FILE_SIZE_THRESHOLD}
        
        find_large_files "$drive_path" "$size_threshold"
    else
        # Linux/Mac
        echo -e "${GREEN}Available mount points:${NC}"
        df -h | grep -v tmpfs
        
        read -p "Enter directory path to search: " drive_path
        read -p "Enter file size threshold in MB (default: $FILE_SIZE_THRESHOLD): " size_input
        size_threshold=${size_input:-$FILE_SIZE_THRESHOLD}
        
        find_large_files "$drive_path" "$size_threshold"
    fi
}

# Main menu function
show_menu() {
    echo -e "${GREEN}=== System Optimization Tool ===${NC}"
    echo "1. Display RAM Information"
    echo "2. Clear Memory Cache"
    echo "3. Show Top Memory-Consuming Processes"
    echo "4. Monitor RAM Usage (Updates every 5 seconds, press Ctrl+C to stop)"
    echo "5. Find and Delete Large Files (>20MB)"
    echo "6. Exit"
    echo -n "Enter your choice (1-6): "
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
        if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
            MEM_INFO=$(free | grep Mem)
            TOTAL=$(echo "$MEM_INFO" | awk '{print $2}')
            USED=$(echo "$MEM_INFO" | awk '{print $3}')
            MEM_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\", $USED/$TOTAL*100}")
        elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
            MEM_INFO=$(powershell -Command "Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory")
            TOTAL=$(echo "$MEM_INFO" | grep -oP "TotalVisibleMemorySize\s*:\s*\K\d+")
            FREE=$(echo "$MEM_INFO" | grep -oP "FreePhysicalMemory\s*:\s*\K\d+")
            USED=$((TOTAL - FREE))
            MEM_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\", $USED/$TOTAL*100}")
        fi
        
        if (( $(echo "$MEM_PERCENTAGE >= $CRITICAL_THRESHOLD" | bc -l 2>/dev/null) )); then
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
        5) clear; select_drive; read -p "Press Enter to continue..." ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Press Enter to continue..."; read ;;
    esac
done