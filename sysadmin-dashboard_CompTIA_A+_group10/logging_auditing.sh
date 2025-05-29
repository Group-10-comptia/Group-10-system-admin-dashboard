#!/bin/bash

# ─────────────────────────────────────────────────────────────
# ✨ Logging & Auditing Module
# ─────────────────────────────────────────────────────────────

LOG_FILE="./logs/script_actions.log"
MAX_LOG_SIZE=102400  # 100 KB
VERBOSITY=1          # 0 = Silent, 1 = Normal, 2 = Verbose

# Create logs directory if missing
mkdir -p ./logs

# 🔁 Rotate logs if size exceeds limit
rotate_logs() {
    if [ -f "$LOG_FILE" ] && [ "$(stat -c%s "$LOG_FILE")" -ge "$MAX_LOG_SIZE" ]; then
        mv "$LOG_FILE" "${LOG_FILE}_$(date +%Y%m%d%H%M%S)"
        touch "$LOG_FILE"
    fi
}

# 🪵 Write to log file
log_action() {
    local status="$1"
    local action="$2"
    local user=$(whoami)
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$timestamp] [$user] [$status] $action"

    echo "$message" >> "$LOG_FILE"

    # Display based on verbosity
    if [ "$VERBOSITY" -ge 1 ]; then
        echo "$message"
    fi
}

# 🗣️ Verbose log (only if VERBOSITY=2)
log_verbose() {
    if [ "$VERBOSITY" -ge 2 ]; then
        log_action "INFO" "$1"
    fi
}

# 👁️ View logs
view_logs() {
    echo "---- Script Logs ----"
    less "$LOG_FILE"
}

# 🔘 Module Menu
logging_menu() {
    while true; do
        clear
        echo "📝 LOGGING & AUDITING MODULE"
        echo "1. View script logs"
        echo "2. Set verbosity level (0: Silent, 1: Normal, 2: Verbose)"
        echo "3. Back to main menu"
        echo -n "Choose an option [1-3]: "
        read -r choice

        case "$choice" in
            1) view_logs ;;
            2)
                echo -n "Enter verbosity level (0/1/2): "
                read -r level
                if [[ "$level" =~ ^[012]$ ]]; then
                    VERBOSITY="$level"
                    echo "Verbosity set to $VERBOSITY"
                else
                    echo "Invalid input."
                fi
                sleep 1 ;;
            3) break ;;
            *) echo "Invalid option."; sleep 1 ;;
        esac
    done
}

# 🔗 Example Usage
# Call these from other modules:
# log_action "SUCCESS" "User added to system"
# log_action "ERROR" "Failed to restart nginx"

# Optional auto-rotate on start
rotate_logs
