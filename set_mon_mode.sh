#!/bin/bash
# Get list of all wireless devices
devices=$(iw dev | grep Interface | cut -f 2 -s -d" ")

# Loop through all devices
for device in $devices
do
  # Try to set device to monitor mode
  if iw dev $device set type monitor &> /dev/null
  then
    echo "Successfully set $device to monitor mode."
    exit 0
  fi
done

echo "No device could be set to monitor mode."
exit 1

