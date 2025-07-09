#!/bin/bash

device_name=$(bluetoothctl info | grep -i "Name" | awk '{ print $2 }')
shopt -s nocasematch
if [[ $device_name == *pebble* ]]; then
    exit 1
fi
device_battery=$(bluetoothctl info | grep -i "Battery Percentage" | awk -F '[()]' '{print $2}')
ICON_BLUETOOTH=""
ICON_BATTERY_FULL=""
ICON_BATTERY_THREE_QUARTERS=""
ICON_BATTERY_HALF=""
ICON_BATTERY_QUARTER=""
ICON_BATTERY_EMPTY=""

ICON_BATTERY=""
if [[ $device_battery -ge 90 ]]; then
    ICON_BATTERY=$ICON_BATTERY_FULL
elif [[ $device_battery -ge 80 ]]; then
    ICON_BATTERY=$ICON_BATTERY_THREE_QUARTERS
elif [[ $device_battery -ge 50 ]]; then
    ICON_BATTERY=$ICON_BATTERY_HALF
elif [[ $device_battery -ge 25 ]]; then
    ICON_BATTERY=$ICON_BATTERY_QUARTER
else
    ICON_BATTERY=$ICON_BATTERY_EMPTY
fi

tooltip="$device_name $ICON_BATTERY $device_battery% "
tooltip=${tooltip%\\n}
output_battery="$ICON_BLUETOOTH $device_name $device_battery% $ICON_BATTERY"

if [ -z "$device_battery" ]; then
    output_battery=""
fi

echo "{\"text\": \"$output_battery\", \"tooltip\": \"$tooltip\"}"
