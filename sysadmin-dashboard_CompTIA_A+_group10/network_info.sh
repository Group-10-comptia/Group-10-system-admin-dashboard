#!/bin/bash

while true; do
    clear
    echo "============================================"
    echo "         🌐 NETWORK INFORMATION MODULE"
    echo "============================================"
    echo "1. Show IP configuration (all interfaces)"
    echo "2. Display routing table"
    echo "3. List active connections & open ports"
    echo "4. Perform connectivity tests (ping/traceroute)"
    echo "5. Display DNS settings & perform lookup"
    echo "6. Monitor network traffic statistics"
    echo "7. Display ARP table"
    echo "8. Return to main menu"
    echo "============================================"
    read -p "Choose an option [1-8]: " option

    case $option in
        1)
            echo -e "\n🧭 IP Configuration:\n"
            ip a
            read -p $'\nPress enter to continue...'
            ;;
        2)
            echo -e "\n🗺️ Routing Table:\n"
            ip route
            read -p $'\nPress enter to continue...'
            ;;
        3)
            echo -e "\n🔓 Active Connections & Open Ports:\n"
            sudo ss -tulnp
            read -p $'\nPress enter to continue...'
            ;;
        4)
            echo -e "\n📡 Connectivity Tests:\n"
            read -p "Enter a hostname or IP to ping: " host
            ping -c 4 "$host"
            echo -e "\nNow performing traceroute..."
            traceroute "$host"
            read -p $'\nPress enter to continue...'
            ;;
        5)
            echo -e "\n🔍 DNS Settings:\n"
            cat /etc/resolv.conf
            read -p "Enter a domain to lookup (e.g., google.com): " domain
            echo -e "\nPerforming DNS lookup...\n"
            nslookup "$domain"
            read -p $'\nPress enter to continue...'
            ;;
        6)
            echo -e "\n📈 Network Traffic Statistics:\n"
            if command -v ifstat >/dev/null; then
                ifstat 1 5
            else
                echo "Tool 'ifstat' not installed. Using 'ip -s link' as fallback.\n"
                ip -s link
            fi
            read -p $'\nPress enter to continue...'
            ;;
        7)
            echo -e "\n🧾 ARP Table:\n"
            ip neigh
            read -p $'\nPress enter to continue...'
            ;;
        8)
            break
            ;;
        *)
            echo "❌ Invalid choice. Try again."
            sleep 1
            ;;
    esac
done
