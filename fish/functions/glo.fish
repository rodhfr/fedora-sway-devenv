function glo
    if test (count $argv) -eq 0
        echo "Uso: detach <comando> [args...]"
        return 1
    end

    # Roda o comando em background totalmente desvinculado
    setsid nohup $argv > /dev/null 2>&1 &

    # Espera brevemente para iniciar
    sleep 0.1

    # Detecta se o comando é gráfico (tem DISPLAY ou WAYLAND)
    set is_gui 0
    if set -q DISPLAY
        set is_gui 1
    else if set -q WAYLAND_DISPLAY
        set is_gui 1
    end

    echo "✅ Processo iniciado. Terminal atual será fechado."
    sleep 0.2

    # Fecha o terminal atual imediatamente
    exit

    # Se for GUI, cria watcher em background
    if test $is_gui -eq 1
        set cmd (string split " " $argv)[1]
        set pid (pgrep -f $cmd | head -n 1)

        setsid nohup fish -c "
            while ps -p $pid > /dev/null
                sleep 1
            end

            if set -q WAYLAND_DISPLAY
                setsid nohup foot > /dev/null 2>&1 &
            else if set -q DISPLAY
                setsid nohup alacritty > /dev/null 2>&1 &
            end
        " > /dev/null 2>&1 &
    end
end

