#!/bin/bash

# Color definitions
CYAN='\033[0;36m'
NC='\033[0m'

while true; do
    clear
    echo -e "${CYAN}PROCESS MANAGEMENT MODULE${NC}"
    echo "1. Display top processes by CPU usage"
    echo "2. Display top processes by Memory usage"
    echo "3. Show process details for specific PID"
    echo "4. Search for processes by name"
    echo "5. Kill process by PID"
    echo "6. Kill process by name"
    echo "7. Monitor specific process in real-time"
    echo "8. Show process tree"
    echo "9. Return to Main Menu"
    read -rp "Choose an option [1-9]: " option

    case $option in
        1)
            echo -e "\nTop Processes by CPU Usage:"
            ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 15
            read -p "Press Enter to continue..."
            ;;
        2)
            echo -e "\nTop Processes by Memory Usage:"
            ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 15
            read -p "Press Enter to continue..."
            ;;
        3)
            read -rp "Enter PID: " pid
            if [[ $pid =~ ^[0-9]+$ ]]; then
                ps -p "$pid" -o pid,ppid,cmd,%cpu,%mem,etime
            else
                echo "Invalid PID."
            fi
            read -p "Press Enter to continue..."
            ;;
        4)
            read -rp "Enter process name to search: " name
            pgrep -af "$name"
            read -p "Press Enter to continue..."
            ;;
        5)
            read -rp "Enter PID to kill: " pid
            read -rp "Enter signal (default is SIGTERM): " signal
            signal=${signal:-TERM}
            kill "-$signal" "$pid" && echo "Process $pid terminated with signal $signal." || echo "Failed to kill process."
            read -p "Press Enter to continue..."
            ;;
        6)
            read -rp "Enter process name to kill: " pname
            pkill "$pname" && echo "Processes named '$pname' terminated." || echo "No such processes found."
            read -p "Press Enter to continue..."
            ;;
        7)
            read -rp "Enter PID to monitor: " pid
            if [[ $pid =~ ^[0-9]+$ ]]; then
                echo "Monitoring process $pid. Press Ctrl+C to stop."
                watch -n 1 "ps -p $pid -o pid,ppid,cmd,%cpu,%mem,etime"
            else
                echo "Invalid PID."
                read -p "Press Enter to continue..."
            fi
            ;;
        8)
            echo -e "\nProcess Tree:"
            pstree -p
            read -p "Press Enter to continue..."
            ;;
        9)
            echo "Returning to main menu..."
            break
            ;;
        *)
            echo "Invalid option. Try again."
            read -p "Press Enter to continue..."
            ;;
    esac
done
