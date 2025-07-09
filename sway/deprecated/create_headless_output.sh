#/bin/bash
if ! swaymsg -t get_outputs | grep -q '"name": "HEADLESS-1"'; then
    swaymsg create_output
fi


