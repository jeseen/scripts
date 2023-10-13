#!/bin/bash

set pipefail -euxo

## # Create a crontab job:
## sudo crontab -e
## # Add line to crontab:
## * * * * * /home/jelle/cronjob.sh

LOCATION="/home/jelle/testfile"

#now=$(date)
echo "Test @ $(date +'%Y-%m-%d %H:%M:%S')" >> $LOCATION
