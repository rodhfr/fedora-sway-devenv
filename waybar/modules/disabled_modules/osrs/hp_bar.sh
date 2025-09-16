#!/bin/bash

# Pegando os dados da API
DATA=$(curl http://127.0.0.1:8080/stats | jq '.[] | select(.stat == "Hitpoints")')

# Verifica se o JSON é válido
if ! echo "$DATA" | jq empty >/dev/null 2>&1; then
    echo -e "<span color='gray'>❤️ No data</span>"
    exit 0
fi


HP=$(echo "$DATA" | jq '.boostedLevel // empty')
MAX=$(echo "$DATA" | jq '.level // empty')

# Verifica se os valores são válidos
if [[ -z "$HP" || -z "$MAX" || "$MAX" -eq 0 ]]; then
    echo -e ""
    exit 0
fi

# Calcula proporção
PERCENT=$(echo "scale=2; $HP / $MAX" | bc)

# Gera barra
BLOCKS=15
FILLED=$(printf "%.0f" "$(echo "$PERCENT * $BLOCKS" | bc)")
EMPTY=$((BLOCKS - FILLED))
BAR=$(printf "%0.s█" $(seq 1 $FILLED))
BAR+=$(printf "%0.s░" $(seq 1 $EMPTY))

# Mostra a barra em vermelho
# echo -e "<span color='#ff6b6b'>❤️ $BAR $HP</span>"
echo -e "<span color='#ff7f7f'>❤️ $BAR $HP</span>"


