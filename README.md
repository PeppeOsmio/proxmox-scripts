# Proxmox scripts

Utility scripts for my Proxmox homelab.

# 1. mount_and_start_ct

WARNING - CREATE A PVE DIRECTORY FIRST, MOUNTED TO THE SAME MOUNT POINT USED IN THE FOLLOWING CONFIGURATION

Script to automatically mount a device when connected and start a CT afterwards. Used to mount an HDD when connected and start PBS CT afterwards.
This uses a generic `mount_and_start.sh` script that takes the following input parameters:
- device path by id, like /dev/disk/by-uuid/<device-uuid>
- CT id, e.g. 107
- mount point, e.g. /mnt/usb-hdd

The script `mount_and_start.sh` is start by a oneshot systemd service name like `mount_and_start_ct_<ct-id>.service`.
The systemd service is started by a udev rule trigger on the connection of device `/dev/disk/by-uuid/<device-uuid>`