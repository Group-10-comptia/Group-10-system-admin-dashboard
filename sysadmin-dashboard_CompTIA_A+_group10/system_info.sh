#!/bin/bash

# Color codes for aesthetics
CYAN='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

print_section() {
  echo -e "${CYAN}=============================="
  echo -e "$1"
  echo -e "==============================${NC}"
}

clear
echo -e "${GREEN}SYSTEM INFORMATION MODULE${NC}"
echo ""

# 1. OS Distribution and Version
print_section "OS Distribution and Version"
if [ -f /etc/os-release ]; then
  source /etc/os-release
  echo "Name: $NAME"
  echo "Version: $VERSION"
else
  echo "OS release info not found."
fi
echo ""

# 2. Kernel Version and Architecture
print_section "Kernel and Architecture"
uname -srmo
echo ""

# 3. Hostname and Uptime
print_section "Hostname and Uptime"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo ""

# 4. CPU Information
print_section "CPU Information"
lscpu | grep -E "Model name|Socket|Core|MHz" | sed 's/^[ \t]*//'
echo ""

# 5. Memory Usage
print_section "Memory Usage"
free -h | awk 'NR==1 || /Mem:/ {print}'
echo ""

# 6. Swap Usage
print_section "Swap Usage"
free -h | awk '/Swap:/ {print}'
echo ""

# 7. Disk Utilization (partition by partition)
print_section "Disk Utilization"
df -hT -x tmpfs -x devtmpfs
echo ""

# 8. Load Averages
print_section "System Load (1, 5, 15 min)"
uptime | awk -F'load average:' '{ print $2 }' | sed 's/^ //'
echo ""

# 9. Temperature Readings
print_section "Temperature Readings"
if command -v sensors >/dev/null 2>&1; then
  sensors | grep -i 'temp'
else
  echo "Temperature sensors not available. Try installing 'lm-sensors'"
fi

echo -e "\n${GREEN}System Information Loaded Successfully.${NC}"
