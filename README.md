# Automated-daily-system-backups

This script backs up /var/www into /opt/system_backups, logs to /var/log/system_backup, keeps backups for 7 days, and rotates logs keeping only the last 5.  
It also sends an email if the backup fails.

## Usage
1. Edit the EMAIL variable in Daily_backup.sh.
2. Make it executable:
   ```bash
   chmod +x Daily_backup.sh