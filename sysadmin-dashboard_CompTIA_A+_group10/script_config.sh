#!/bin/bash

# Load config file if it exists
CONFIG_FILE="./config.conf"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# Override defaults with environment variables if set
: "${BACKUP_DIR:=${ENV_BACKUP_DIR:-$BACKUP_DIR}}"
: "${LOG_LEVEL:=${ENV_LOG_LEVEL:-$LOG_LEVEL}}"
: "${DEBUG_MODE:=${ENV_DEBUG_MODE:-$DEBUG_MODE}}"

# Command-line arguments
HEADLESS=false

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --headless) HEADLESS=true ;;
        --debug) DEBUG_MODE="true" ;;
        --backup-dir=*) BACKUP_DIR="${1#*=}" ;;
        --log-level=*) LOG_LEVEL="${1#*=}" ;;
        *) echo "Unknown option: $1" ;;
    esac
    shift
done

# Debug function
debug_log() {
    if [ "$DEBUG_MODE" == "true" ]; then
        echo "[DEBUG] $1"
    fi
}

# Sample logic that uses the config
main() {
    debug_log "Debug Mode: $DEBUG_MODE"
    debug_log "Backup Directory: $BACKUP_DIR"
    debug_log "Log Level: $LOG_LEVEL"
    debug_log "Headless Mode: $HEADLESS"

    echo "Configuration loaded successfully!"
    echo "BACKUP_DIR = $BACKUP_DIR"
    echo "LOG_LEVEL = $LOG_LEVEL"
    echo "DEBUG_MODE = $DEBUG_MODE"
    echo "HEADLESS MODE = $HEADLESS"
}

# Run main logic
main
