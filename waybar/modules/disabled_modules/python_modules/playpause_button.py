#!/usr/bin/env python3
import subprocess
import json

def print_status(status: str):
    status = status.strip()
    if status == "Playing":
        icon = "  "
        tooltip = "Pause"
        css_class = "playing"
    elif status == "Paused":
        icon = ""
        tooltip = "Play"
        css_class = "paused"
    else:
        icon = ""
        tooltip = "Stopped"
        css_class = "stopped"

    print(json.dumps({
        "text": icon,
        "tooltip": tooltip,
        "class": css_class
    }), flush=True)

# estado inicial
try:
    initial = subprocess.check_output(
        ["playerctl", "status"], stderr=subprocess.DEVNULL
    ).decode()
    print_status(initial)
except subprocess.CalledProcessError:
    print_status("Stopped")

# segue mudanças em tempo real
proc = subprocess.Popen(
    ["playerctl", "--follow", "status"],
    stdout=subprocess.PIPE,
    stderr=subprocess.DEVNULL,
    text=True
)

for line in proc.stdout:
    print_status(line)

