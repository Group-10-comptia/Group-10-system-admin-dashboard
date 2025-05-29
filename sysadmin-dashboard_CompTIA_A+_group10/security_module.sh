#!/bin/bash

#====================#
# Security Functions #
#====================#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Authentication (basic password prompt)
authenticate_user() {
    read -sp "Enter admin password to proceed: " entered_pass
    echo
    # In real use, hash & secure this password
    local correct_pass="admin123"
    if [[ "$entered_pass" != "$correct_pass" ]]; then
        echo -e "${RED}Authentication failed.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Authentication successful.${NC}"
}

# Check if run as root
check_permissions() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}This operation requires root privileges. Run with sudo.${NC}"
        exit 1
    fi
}

# Harden system settings (sample examples)
harden_system() {
    echo -e "${GREEN}Applying basic hardening...${NC}"

    # Disable root SSH login
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

    # Disable unnecessary services (example)
    systemctl disable bluetooth 2>/dev/null
    systemctl disable cups 2>/dev/null

    # Firewall example
    ufw enable >/dev/null 2>&1
    ufw default deny incoming
    ufw default allow outgoing
    echo -e "${GREEN}Firewall set to deny incoming traffic by default.${NC}"

    echo -e "${GREEN}Basic system hardening complete.${NC}"
}

# Perform basic security audit
security_audit() {
    echo -e "${GREEN}Running security audit...${NC}"
    
    echo "1. Checking for root SSH login..."
    grep -q "^PermitRootLogin no" /etc/ssh/sshd_config && echo -e "✔ Root login disabled" || echo -e "✘ Root login enabled"

    echo "2. Firewall status:"
    ufw status

    echo "3. Checking for world-writable files (may take a moment)..."
    find / -type f -perm -0002 -ls 2>/dev/null | head -n 10

    echo "4. Checking for users with empty passwords..."
    awk -F: '($2 == "") { print $1 }' /etc/shadow

    echo "Audit complete."
}

#================#
# Module Menu UI #
#================#

while true; do
    echo -e "\n🔐 ${GREEN}SECURITY MODULE${NC}"
    echo "1. Authenticate (test sensitive access)"
    echo "2. Check permissions"
    echo "3. Harden system"
    echo "4. Run security audit"
    echo "5. Exit"
    read -p "Choose an option [1-5]: " choice

    case $choice in
        1) authenticate_user ;;
        2) check_permissions ;;
        3) check_permissions && authenticate_user && harden_system ;;
        4) check_permissions && security_audit ;;
        5) echo "Exiting Security Module."; break ;;
        *) echo -e "${RED}Invalid option. Try again.${NC}" ;;
    esac
done
