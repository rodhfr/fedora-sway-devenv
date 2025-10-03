function fish_prompt
    # Mostra o diretório atual em verde
    set_color green
    echo -n (pwd)
    set_color normal

    # Prompt simples
    echo -n " > "
end

