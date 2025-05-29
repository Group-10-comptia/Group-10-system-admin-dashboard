#!/bin/bash

while true; do
    clear
    echo "========================================"
    echo "        🔧 SERVICE MANAGEMENT MODULE"
    echo "========================================"
    echo "1. List all services"
    echo "2. Filter services (running/stopped)"
    echo "3. Control a service (start/stop/restart/reload)"
    echo "4. Enable/Disable service at boot"
    echo "5. Detailed info of a service"
    echo "6. Show service dependencies"
    echo "7. Return to main menu"
    echo "========================================"
    read -p "Choose an option [1-7]: " option

    case $option in
        1)
            echo -e "\n📝 Listing all services...\n"
            systemctl list-units --type=service --all
            read -p $'\nPress enter to continue...'
            ;;
        2)
            echo -e "\nFilter:"
            echo "1. Running"
            echo "2. Stopped"
            read -p "Choose an option [1-2]: " status_choice
            if [ "$status_choice" == "1" ]; then
                echo -e "\n⚡ Running Services:\n"
                systemctl list-units --type=service --state=running
            elif [ "$status_choice" == "2" ]; then
                echo -e "\n🛑 Stopped Services:\n"
                systemctl list-units --type=service --state=dead
            else
                echo "Invalid option."
            fi
            read -p $'\nPress enter to continue...'
            ;;
        3)
            read -p "Enter the service name: " svc
            echo "1. Start"
            echo "2. Stop"
            echo "3. Restart"
            echo "4. Reload"
            read -p "Select action [1-4]: " act
            case $act in
                1) sudo systemctl start "$svc" && echo "Started $svc" ;;
                2) sudo systemctl stop "$svc" && echo "Stopped $svc" ;;
                3) sudo systemctl restart "$svc" && echo "Restarted $svc" ;;
                4) sudo systemctl reload "$svc" && echo "Reloaded $svc" ;;
                *) echo "Invalid action." ;;
            esac
            read -p $'\nPress enter to continue...'
            ;;
        4)
            read -p "Enter the service name: " svc
            echo "1. Enable at boot"
            echo "2. Disable at boot"
            read -p "Choose [1-2]: " bootopt
            if [ "$bootopt" == "1" ]; then
                sudo systemctl enable "$svc" && echo "$svc enabled at boot."
            elif [ "$bootopt" == "2" ]; then
                sudo systemctl disable "$svc" && echo "$svc disabled at boot."
            else
                echo "Invalid choice."
            fi
            read -p $'\nPress enter to continue...'
            ;;
        5)
            read -p "Enter the service name: " svc
            echo -e "\n🔍 Detailed information for $svc:\n"
            systemctl status "$svc"
            read -p $'\nPress enter to continue...'
            ;;
        6)
            read -p "Enter the service name: " svc
            echo -e "\n🔗 Dependencies for $svc:\n"
            systemctl list-dependencies "$svc"
            read -p $'\nPress enter to continue...'
            ;;
        7)
            break
            ;;
        *)
            echo "❌ Invalid option. Try again."
            sleep 1
            ;;
    esac
done
