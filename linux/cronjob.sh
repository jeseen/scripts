#!/bin/bash

set pipefail -euxo

## # Create a crontab job:
## sudo crontab -e
## # Add line to crontab:
## * * * * * /home/jelle/cronjob.sh
## cronjob schedule tester: https://crontab.guru/#0_*_*_*_*


LOCATION="/home/jelle/testfile"

#now=$(date)
echo "Test @ $(date +'%Y-%m-%d %H:%M:%S')" >> $LOCATION


0 * * * * /shared/create-backup.sh

0,15,30,45 * * * * /shared/modify-permissions.sh

