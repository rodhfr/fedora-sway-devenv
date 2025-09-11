#!/usr/bin/env bash
# share.sh - Send clipboard content via KDE Connect automatically

set -euo pipefail

# Get the first connected device
device=$(kdeconnect-cli -a --id-only | head -n 1)

if [[ -z "$device" ]]; then
    echo "❌ No device found. Make sure KDE Connect is running and paired."
    exit 1
fi

# Get clipboard content (supports X11 and Wayland)
if command -v wl-paste &>/dev/null; then
    target=$(wl-paste)
elif command -v xclip &>/dev/null; then
    target=$(xclip -o -selection clipboard)
elif command -v xsel &>/dev/null; then
    target=$(xsel --clipboard --output)
else
    echo "❌ No clipboard utility found (install wl-clipboard, xclip, or xsel)."
    exit 1
fi

if [[ -z "$target" ]]; then
    echo "❌ Clipboard is empty."
    exit 1
fi

# Share clipboard content
kdeconnect-cli -d "$device" --share "$target"

echo "✅ Shared clipboard content with $device."

