#!/bin/bash

# place this in /usr/local/bin/mount_and_start_ct.sh

# Check if all required arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <device> <container-id> <mount-point>"
    exit 1
fi

DEVICE="$1"
CONTAINER_ID="$2"
MOUNT_POINT="$3"

# Ensure mount point exists
mkdir -p "$MOUNT_POINT"

echo "Mount and start CT: DEVICE=${DEVICE} MOUNT_POINT={$MOUNT_POINT} CT=${CONTAINER_ID}"

# Attempt to mount the device
if output=$(mount "$DEVICE" "$MOUNT_POINT" 2>&1); then
    echo "Mount successful"
else
    echo "Can't mount ${DEVICE} to ${MOUNT_POINT}: ${output}"
    exit 1
fi

echo "Mount successful, waiting for device to stabilize..."

# Retry logic for starting the container
ATTEMPTS=0
MAX_ATTEMPTS=10

while [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
    sleep 2  # Wait before retrying

    # Verify if the device is still mounted
    if mountpoint -q "$MOUNT_POINT"; then
        echo "Device is mounted, attempting to start container $CONTAINER_ID..."
        # Try to start the container
        if output=$(pct start "$CONTAINER_ID" 2>&1); then
            echo "Container $CONTAINER_ID started successfully."
            echo "$output"  # Log pct command output
            exit 0  # Exit script successfully
        else
            echo "Warning: Failed to start container $CONTAINER_ID, retrying..."
            echo "$output"  # Log pct command error output
        fi
    else
        echo "Warning: Device is no longer mounted, exiting..."
        exit 1
    fi

    ((ATTEMPTS++))
done

echo "Error: Failed to start container $CONTAINER_ID after $MAX_ATTEMPTS attempts."
exit 1  # Exit with failure if the container could not be started