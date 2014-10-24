#!/bin/bash -e

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Temp disable ethernet port
modprobe -r r8169

# Disable wake up on lan if I do use ethernet port
# ethtool -s eth2 wol d;

# Temp disable bluetooth
# modprobe -r btusb

# Adjust backlight to start much lower
echo 0 > /sys/class/backlight/acpi_video0/brightness

# - NMI Watchdog (turned off)
echo 0 > '/proc/sys/kernel/nmi_watchdog';

# - SATA Active Link Powermanagement
echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy';

# - USB Autosuspend (after 2 secs of inactivity)
#for i in `find /sys/bus/usb/devices/*/power/control`; do echo auto > $i; done;
#for i in `find /sys/bus/usb/devices/*/power/autosuspend`; do echo 2 > $i; done;

# - Device Power Management
#echo auto | tee /sys/bus/i2c/devices/*/power/control > /dev/null;
#echo auto | tee /sys/bus/pci/devices/*/power/control > /dev/null;

# - CPU Scaling (on demand scaling governor for all CPU's
#for i in `find /sys/devices/system/cpu/*/cpufreq/scaling_governor`; do echo ondemand > $i; done;

exit 0
