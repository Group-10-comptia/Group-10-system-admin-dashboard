#!/bin/bash

LOG_FILE="/var/log/syslog"  # Fallback if journalctl not available

while true; do
    clear
    echo "============================================"
    echo "           📜 LOG ANALYSIS MODULE"
    echo "============================================"
    echo "1. View recent logs"
    echo "2. Filter logs by service"
    echo "3. Filter logs by severity"
    echo "4. Filter logs by date range"
    echo "5. Search logs using regex"
    echo "6. Export logs to file"
    echo "7. Monitor logs in real-time"
    echo "8. Summarize log statistics"
    echo "9. Return to main menu"
    echo "============================================"
    read -p "Choose an option [1-9]: " choice

    case $choice in
        1)
            echo -e "\n📄 Recent Logs:\n"
            journalctl -n 50 || tail -n 50 "$LOG_FILE"
            read -p $'\nPress enter to continue...'
            ;;
        2)
            read -p "Enter service name (e.g., sshd): " service
            journalctl -u "$service" || grep "$service" "$LOG_FILE"
            read -p $'\nPress enter to continue...'
            ;;
        3)
            read -p "Enter severity (emerg, alert, crit, err, warning, notice, info, debug): " severity
            journalctl -p "$severity" || grep -i "$severity" "$LOG_FILE"
            read -p $'\nPress enter to continue...'
            ;;
        4)
            read -p "Start date (e.g., 2024-05-01): " start
            read -p "End date (e.g., 2024-05-25): " end
            journalctl --since="$start" --until="$end" || echo "Date filtering not available with fallback log file"
            read -p $'\nPress enter to continue...'
            ;;
        5)
            read -p "Enter regex pattern to search logs: " pattern
            journalctl | grep -E "$pattern" || grep -E "$pattern" "$LOG_FILE"
            read -p $'\nPress enter to continue...'
            ;;
        6)
            read -p "Enter filename to export filtered logs: " filename
            journalctl > "$filename" || cp "$LOG_FILE" "$filename"
            echo "Logs exported to $filename"
            read -p $'\nPress enter to continue...'
            ;;
        7)
            echo -e "\n🔍 Real-time Log Monitor (press Ctrl+C to stop):\n"
            journalctl -f || tail -f "$LOG_FILE"
            ;;
        8)
            echo -e "\n📊 Log Summary:\n"
            echo "Top 10 Errors:"
            journalctl -p err -n 1000 | cut -d' ' -f6- | sort | uniq -c | sort -nr | head -n 10 || \
            grep -i "error" "$LOG_FILE" | cut -d' ' -f6- | sort | uniq -c | sort -nr | head -n 10
            read -p $'\nPress enter to continue...'
            ;;
        9)
            break
            ;;
        *)
            echo "❌ Invalid option. Try again."
            sleep 1
            ;;
    esac
done
