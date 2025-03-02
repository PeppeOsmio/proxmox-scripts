#!/bin/bash

# place this in /usr/local/bin/stop_ct_after_disconnect.sh

DEVICE_UUID="$1"
CT_ID="$2"

# Check if all required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <device-uuid> <container-id>"
    exit 1
fi

LOG_FILE="/var/log/mount_and_start_ct_${CT_ID}.log"

echo "Device /dev/disk/by-uuid/${DEVICE_UUID} removed, stopping container $CT_ID..." >> "${LOG_FILE}"

pct stop "$CT_ID" >> "${LOG_FILE}"