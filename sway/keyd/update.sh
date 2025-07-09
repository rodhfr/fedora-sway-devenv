#!/bin/bash

if sudo cp ./default.conf /etc/keyd/default.conf; then
    echo "[✓] /etc/keyd/default.conf updated successfully."
    #bat /etc/keyd/default.conf
    sudo keyd reload
else
    echo "[✗] Failed to update /etc/keyd/default.conf." >&2
    exit 1
fi

