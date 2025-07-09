#!/bin/bash

notify-send -t 2000 "🔌 Testando conexão SSH..."

# Teste rápido sem abrir shell: timeout 5s e sem pedir senha
ssh -p 8022 -o BatchMode=yes -o ConnectTimeout=2 u0_a234@192.168.1.170 exit

if [ $? -eq 0 ]; then
    notify-send -t 2000 "✅ Conexão OK! Abrindo SSH..."
    ssh -p 8022 u0_a234@192.168.1.170
else
    notify-send -t 2000 "❌ Falha na conexão SSH"
fi

