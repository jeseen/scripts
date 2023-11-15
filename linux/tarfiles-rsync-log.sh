#!/bin/bash

# Script to backup important files from this server to a backup location

DIRECTORIES_TO_BACKUP=(
  "/terraform"
  "/smb_shares/kubit"
)
LOCAL_BACKUP_FILE=/shared/backup-kubit-linux-server.tar
LOGFILE=/shared/create-backup.log


tar -cvf $LOCAL_BACKUP_FILE ${DIRECTORIES_TO_BACKUP[@]}

sshpass -p Ul6Jtl83XcjudShYUucV rsync -rvzPlt --timeout=0 --delete $LOCAL_BACKUP_FILE rsync://sa_cf_backup@s0abck0006g.cbsp.nl/cf_backup/kubit

# Cleanup the logfile
tail -n 400 $LOGFILE > templogfiletodeletelines.log ; cat templogfiletodeletelines.log > $LOGFILE ; rm templogfiletodeletelines.log

# Add logging
echo "Backup time: $(date +'%Y-%m-%d %H:%M:%S')" >> $LOGFILE
echo "  Directories in this backup:" >> $LOGFILE
printf '  - %s\n' "${DIRECTORIES_TO_BACKUP[@]}" >> $LOGFILE

