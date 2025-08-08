#!/bin/bash

BACKUP_SOURCE="/var/www"
BACKUP_DEST="/opt/system_backups"
LOG_DIR="/var/log/system_backup"
RETENTION_DAYS=7
LOG_RETENTION=5
EMAIL="rawdaessamrou@gmail.com"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DEST/backup_$DATE.tar.gz"
LOG_FILE="$LOG_DIR/backup_$DATE.log"

mkdir -p "$BACKUP_DEST"
mkdir -p "$LOG_DIR"

exec > >(tee "$LOG_FILE") 2>&1

echo "=== Backup started at $DATE ==="

if tar -czf "$BACKUP_FILE" "$BACKUP_SOURCE"; then
    echo "[OK] Backup created at $BACKUP_FILE"
else
    echo "[ERROR] Backup failed!" >&2
    echo "Backup failed at $DATE" | mail -s "[Backup Error] Failed to create backup" "$EMAIL"
    exit 1
fi

echo "Removing backups older than $RETENTION_DAYS days..."
find "$BACKUP_DEST" -name "backup_*.tar.gz" -type f -mtime +$RETENTION_DAYS -exec rm -f {} \;

echo "Rotating logs..."
cd "$LOG_DIR" || exit
ls -ltr backup_*.log | head -n -$LOG_RETENTION | xargs -r rm -f

echo "=== Backup completed successfully at $(date +'%Y-%m-%d_%H-%M-%S') ==="