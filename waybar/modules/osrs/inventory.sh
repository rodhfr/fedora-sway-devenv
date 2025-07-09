#!/bin/bash

DATA=$(curl http://localhost:8080/inv)

if ! echo "$DATA" | jq empty >/dev/null 2>&1; then
    echo -e "<span color='gray'>No data</span>"
    exit 0
fi

INV=$(echo "$DATA" | jq '[.[] | select(.id != -1)] | length')

if [[ -z "$INV" ]]; then
    echo -e ""
    exit 0
fi

if [[ "$INV" -eq 28 ]]; then
    echo '{"text": "🔴❗📦 '"$INV"'", "color": "#FF0000"}'
elif [[ "$INV" -eq 0 ]]; then
    echo '{"text": "🌱📦 '"$INV"'", "color": "#00FF00"}'
else
    echo '{"text": "📦 '"$INV"'", "color": "#FFFFFF"}'
fi

