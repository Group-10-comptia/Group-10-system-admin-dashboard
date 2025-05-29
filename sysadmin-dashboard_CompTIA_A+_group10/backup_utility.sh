#!/bin/bash

BACKUP_DIR="$HOME/backups"
HISTORY_FILE="$BACKUP_DIR/backup_history.log"
EXCLUDES_FILE="$BACKUP_DIR/excludes.txt"

mkdir -p "$BACKUP_DIR"

schedule_backup() {
    echo "0 2 * * * $PWD/backup_utility.sh --auto >> $HOME/backup_cron.log 2>&1" | crontab -
    echo "✅ Automatic daily backup scheduled at 2:00 AM."
}

run_backup() {
    read -p "Enter directory to back up: " target_dir
    [ ! -d "$target_dir" ] && echo "❌ Directory not found!" && return

    read -p "Enter name for backup file (without extension): " backup_name
    backup_file="$BACKUP_DIR/${backup_name}_$(date +%Y%m%d_%H%M%S).tar.gz"

    echo -e "Creating backup...\n"
    tar czf "$backup_file" --exclude-from="$EXCLUDES_FILE" "$target_dir"
    
    if [ $? -eq 0 ]; then
        echo "$(date): Backup created at $backup_file" >> "$HISTORY_FILE"
        echo "✅ Backup successful: $backup_file"
    else
        echo "❌ Backup failed."
    fi
}

restore_backup() {
    echo "Available backups:"
    ls -1 "$BACKUP_DIR"/*.tar.gz
    read -p "Enter backup filename to restore: " restore_file
    read -p "Enter destination directory: " dest_dir

    mkdir -p "$dest_dir"
    tar xzf "$BACKUP_DIR/$restore_file" -C "$dest_dir"
    echo "✅ Restored to $dest_dir"
}

verify_backup() {
    read -p "Enter backup filename to verify: " file
    gzip -t "$BACKUP_DIR/$file"
    if [ $? -eq 0 ]; then
        echo "✅ Backup integrity verified."
    else
        echo "❌ Backup is corrupted or invalid."
    fi
}

rotate_backups() {
    keep=5
    echo "🌀 Rotating backups, keeping last $keep files..."
    ls -tp "$BACKUP_DIR"/*.tar.gz | grep -v '/$' | tail -n +$((keep+1)) | xargs -I {} rm -- {}
    echo "✅ Rotation complete."
}

while true; do
    clear
    echo "==============================================="
    echo "           🔐 BACKUP UTILITY MODULE"
    echo "==============================================="
    echo "1. Create a backup"
    echo "2. Restore from backup"
    echo "3. Schedule automatic backup"
    echo "4. View backup history"
    echo "5. Rotate old backups"
    echo "6. Verify backup integrity"
    echo "7. Set excluded files/directories"
    echo "8. Return to main menu"
    echo "==============================================="
    read -p "Choose an option [1-8]: " option

    case $option in
        1) run_backup ;;
        2) restore_backup ;;
        3) schedule_backup ;;
        4) cat "$HISTORY_FILE"; read -p $'\nPress enter to continue...';;
        5) rotate_backups ;;
        6) verify_backup ;;
        7)
            echo "Enter patterns to exclude (one per line). Ctrl+D to save:"
            cat > "$EXCLUDES_FILE"
            echo "✅ Excludes saved to $EXCLUDES_FILE"
            ;;
        8) break ;;
        *) echo "❌ Invalid option." && sleep 1 ;;
    esac
done
