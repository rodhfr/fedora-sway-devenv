if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish --disable-up-arrow | source
    starship init fish | source

    set -U fish_user_paths $fish_user_paths ~/.config/sway/scripts/bluetooth/
    set -U fish_user_paths $fish_user_paths ~/.config/sway/scripts/launchers/
    set -U fish_user_paths $fish_user_paths ~/.config/sway/scripts/media_sharing/

    set -x XDG_CURRENT_DESKTOP sway   # xdg-desktop-portal
    set -x XDG_SESSION_DESKTOP sway   # systemd
    set -x XDG_SESSION_TYPE wayland

source /usr/share/autojump/autojump.fish

end
