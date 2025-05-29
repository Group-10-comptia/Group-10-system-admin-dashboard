#!/bin/bash

# ===== Dependency Check =====
check_dependencies() {
    local missing=()
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done

    if [ ${#missing[@]} -ne 0 ]; then
        echo "❌ Missing dependencies: ${missing[*]}"
        echo "➡️ Please install them before running this script."
        exit 1
    fi
}

# Example usage: check_dependencies curl grep awk

# ===== Permission Check =====
require_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "⛔ This operation requires root privileges."
        echo "🔁 Please run the script with sudo."
        exit 1
    fi
}

# ===== Input Validation =====
validate_number() {
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "❗ Invalid input: Expected a number, got '$1'"
        return 1
    fi
    return 0
}

validate_username() {
    if ! id "$1" &>/dev/null; then
        echo "❗ User '$1' does not exist."
        return 1
    fi
    return 0
}

# ===== Timeout Wrapper =====
run_with_timeout() {
    local timeout=$1
    shift
    timeout "$timeout" "$@" 2>/dev/null || echo "⚠️ Operation timed out after $timeout seconds."
}

# ===== Graceful Error Trap =====
error_trap() {
    echo "🚨 An unexpected error occurred."
    echo "🛠 Please check inputs, permissions, and try again."
    exit 1
}

trap error_trap ERR
