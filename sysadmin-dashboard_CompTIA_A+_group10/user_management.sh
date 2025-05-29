#!/bin/bash

# Colors for pretty formatting
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No color

print_section() {
  echo -e "${CYAN}=============================="
  echo -e "$1"
  echo -e "==============================${NC}"
}

pause() {
  read -rp "Press [Enter] to continue..."
}

list_users() {
  print_section "All System Users"
  awk -F: '{ printf "%-20s UID: %-5s GID: %-5s HOME: %-20s SHELL: %s\n", $1, $3, $4, $6, $7 }' /etc/passwd
  echo ""
  pause
}

add_user() {
  read -rp "Enter new username: " username
  read -rp "Create home directory? (y/n): " create_home
  if id "$username" &>/dev/null; then
    echo -e "${RED}User already exists!${NC}"
  else
    if [[ "$create_home" == "y" ]]; then
      sudo useradd -m "$username"
    else
      sudo useradd "$username"
    fi
    echo "User '$username' created."
    sudo passwd "$username"
  fi
  pause
}

modify_user() {
  read -rp "Enter the username to modify: " username
  if ! id "$username" &>/dev/null; then
    echo -e "${RED}User does not exist!${NC}"
    pause
    return
  fi

  echo ""
  print_section "Modify User: $username"
  echo "1. Change password"
  echo "2. Add to group"
  echo "3. Remove from group"
  echo "4. Set account expiration"
  echo "5. Lock account"
  echo "6. Unlock account"
  read -rp "Choose an option [1-6]: " choice
  case $choice in
    1) sudo passwd "$username" ;;
    2) read -rp "Enter group to add: " group
       sudo usermod -aG "$group" "$username" ;;
    3) read -rp "Enter group to remove: " group
       sudo gpasswd -d "$username" "$group" ;;
    4) read -rp "Enter expiration date (YYYY-MM-DD): " date
       sudo chage -E "$date" "$username" ;;
    5) sudo usermod -L "$username" ;;
    6) sudo usermod -U "$username" ;;
    *) echo -e "${RED}Invalid option.${NC}" ;;
  esac
  pause
}

user_info() {
  read -rp "Enter username to view: " username
  if id "$username" &>/dev/null; then
    print_section "Detailed Info for $username"
    id "$username"
    echo ""
    grep "^$username:" /etc/passwd
    chage -l "$username"
  else
    echo -e "${RED}User not found.${NC}"
  fi
  pause
}

# Main Submenu
while true; do
  clear
  echo -e "${GREEN}USER MANAGEMENT MODULE${NC}"
  echo "1. List all users"
  echo "2. Add a new user"
  echo "3. Modify user properties"
  echo "4. Display user info"
  echo "5. Return to main menu"
  echo ""
  read -rp "Choose an option [1-5]: " option
  case $option in
    1) list_users ;;
    2) add_user ;;
    3) modify_user ;;
    4) user_info ;;
    5) break ;;
    *) echo -e "${RED}Invalid choice. Enter a number between 1 and 5.${NC}"
       pause ;;
  esac
done
