#!/bin/bash

echo "running..."

pid=$(pgrep -x wl-mirror)

swaymsg workspace 8
if [[ -n "$pid" ]]; then 
    echo "wl-mirror is running with PID $pid"
    echo "Mudando para workspace 9"
    swaymsg workspace 9
else
    echo "rodando wl-mirror"
    nohup wl-mirror eDP-1 &
    echo "Mudando para workspace 9"
    swaymsg workspace 9
fi

