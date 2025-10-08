function glob
    if test (count $argv) -eq 0
        echo "Uso: detach <comando> [args...]"
        return 1
    end

    # Roda o programa em background sem bloquear o Fish
    setsid nohup $argv > /dev/null 2>&1 &

    # Espera 0.1s para garantir que o processo principal já iniciou
    sleep 0.1

    # Captura PID real do programa usando o nome do comando
    set cmd (string split " " $argv)[1]
    set pid (pgrep -f $cmd | head -n 1)

    # Cria watcher que só dispara quando o programa realmente fechar
    setsid nohup fish -c "
        while ps -p $pid > /dev/null
            sleep 1
        end

        if set -q WAYLAND_DISPLAY
            setsid nohup alacritty > /dev/null 2>&1 &
        else if set -q DISPLAY
            setsid nohup alacritty > /dev/null 2>&1 &
        end
    " > /dev/null 2>&1 &

    echo "✅ Processo iniciado (PID $pid). Terminal será reaberto quando ele fechar."
    sleep 0.2
    exit
end


