#!/bin/bash

# CHECK SYSTEM VERSION
# Read Fedora version from /etc/fedora-release
fedora_version=$(cat /etc/fedora-release 2>/dev/null | grep -oP '(?<=release )\d+')

if [[ "$fedora_version" == "42" ]]; then
    echo "Fedora 42 detected. Proceeding with script..."
    # Place the rest of your script commands here
    
else
    echo "This script requires Fedora 42. Exiting."
    exit 1
fi

# this is only for setup git --global username and email
# change for your own otherwise your git commits would be signed in my name
USER_EMAIL="souzafrodolfo@gmail.com"
USER_NAME="Rodolfo Franca"

# DNF INSTALLATION 
sudo dnf update -y
sudo dnf upgrade -y
sudo dnf copr enable alternateved/keyd -y
sudo dnf copr enable erikreider/SwayNotificationCenter -y
#sudo dnf copr enable wezfurlong/wezterm-nightly -y
sudo dnf copr enable zeno/scrcpy -y
sudo dnf copr enable monkeygold/nautilus-open-any-terminal -y
sudo dnf copr enable sentry/xone -y
lpf approve xone-firmware
lpf build xone-firmware
sudo dnf install gvfs-mtp -y
sudo dnf install hugo -y
sudo dnf install autojump-fish -y
sudo dnf install xone lpf-xone-firmware -y
sudo dnf install libadwaita-devel -y
sudo dnf install nmap -y
sudo dnf install nautilus-open-any-terminal -y
# sudo dnf install tesseract-osd -y
sudo dnf install xdg-desktop-portal-wlr -y 
sudo dnf install scrcpy -y
sudo dnf install ocrmypdf -y
sudo dnf install libssl-devel -y
sudo dnf install webkit2gtk4.1 webkit2gtk4.1-devel libEGL libGL -y
sudo dnf install gamemode -y
# sudo dnf install tesseract-langpack-jpn.noarch -y
# sudo dnf install tesseract-langpack-jpn_vert.noarch -y
sudo dnf install poetry -y
sudo dnf install fzf -y
sudo dnf install google-noto-emoji-fonts -y
sudo dnf install keyd -y
#sudo dnf install gammastep -y
sudo systemctl enable keyd --now
sudo mkdir -p /etc/keyd
sudo cp ~/.config/keyd/default.conf /etc/keyd/default.conf
sudo systemctl restart keyd
sudo systemctl status keyd
sudo dnf install obs-studio -y
sudo dnf install golang -y
sudo dnf install pv -y
sudo dnf install calc -y
sudo dnf install openssh-server -y
sudo dnf install gedit -y
sudo dnf install ncurses-devel -y
# more about this change ffmpeg
# https://rpmfusion.org/Howto/Multimedia
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf install rpmfusion-nonfree-release-tainted -y
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware" -y
sudo dnf install ImageMagick -y
sudo dnf install intel-media-driver -y
sudo dnf install gnome-software -y
sudo dnf install libxkbcommon-devel -y
sudo dnf install lxpolkit -y
sudo dnf install gnome-disk-utility -y
sudo dnf install fuse-overlayfs -y
sudo dnf install nautilus -y
sudo dnf install openssl -y
sudo dnf install swaybg -y
sudo dnf install nodejs -y
sudo dnf install wl-mirror -y
sudo dnf install ydotool -y 
sudo dnf install fuse-devel -y 
sudo dnf install yad -y
sudo dnf install nautilus-open-any-terminal -y
sudo dnf install foot -y
sudo dnf install alsa-lib-devel -y
sudo dnf install mkvtoolnix -y
sudo dnf install distrobox -y
sudo dnf install libxkbcommon-x11-devel libXcur -y
sudo dnf install mesa-libEGL-devel -y
sudo dnf install libX11-devel -y
sudo dnf install vulkan-devel -y
sudo dnf install solaar solaar-udev -y
sudo dnf install dejavu-sans-fonts -y
sudo dnf install ventoy -y
sudo dnf install waybar -y
sudo dnf install wl-clipboard -y
sudo dnf install kitty -y
sudo dnf install wget -y
sudo dnf install ffmpeg -y
sudo dnf install pavucontrol -y
sudo dnf install flatpak -y
sudo dnf install unrar -y
sudo dnf install git -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#sudo dnf install @virtualization -y
sudo dnf install aria2 -y
sudo dnf install gparted -y
sudo dnf install cargo  -y
sudo dnf install libva-utils  -y
sudo dnf install nodejs-npm  -y
sudo dnf install vim  -y
sudo dnf install firefox  -y
sudo dnf install rofi  -y
sudo dnf install htop  -y
sudo dnf install nvim -y
sudo dnf install fastfetch -y
sudo dnf install nmtui -y
sudo dnf install rclone -y
sudo dnf install python3-pip -y
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 # for fedora 41
#sudo dnf install steam -y
#sudo dnf install emacs -y
sudo dnf install fd -y
sudo dnf install alacritty -y
sudo dnf install SwayNotificationCenter -y
sudo dnf install qt6-qt5compat -y
#sudo dnf install Baobab -y
sudo dnf install fish -y

# TERMINAL SETUP 
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
atuin register -u rodhfr -e souzafrodolfo@gmail.com
atuin import auto
atuin sync

# AUTOJUMP FISH
echo 'source /usr/share/autojump/autojump.fish' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish

# BASHRC
cp ~/.config/sway/bashrc ~/.bashrc
source ~/.bashrc

# MEMORY VISUALIZER TOOL GDU
curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
chmod +x gdu_linux_amd64
sudo mv gdu_linux_amd64 /usr/bin/gdu

# Cargo Installs
cargo install swayhide
cargo install dim-screen
cargo install rustlings
#cargo install eza

# Git Setup
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

# PYTHON REPO INSTALL
pip3 install pipx 
pipx install yt-dlp
pipx install autotiling

# Setup default xdg-mime
xdg-mime default nautilus.desktop inode/directory
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty

# install vscode from custom repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code -y

# REBOOT LOGIC
# If lockfile missing => first run, create lockfile and reboot
# If lockfile exists => script resumed after reboot, continue installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCKFILE="$SCRIPT_DIR/install_reboot.lock"

if [[ -f "$LOCKFILE" ]]
then
    echo "Reboot Lockfile exists. Proceeding with the script..."
else
    echo "Lockfile not found. Creating and rebooting..."
    touch "$LOCKFILE"
    sync && systemctl reboot
fi

echo "Already rebooted, installation continues..."
# flatpaks installation
## user installations
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
#flatpak install flathub org.freedesktop.Platform.VulkanLayer.gamescope -y
#flatpak install flathub com.github.mtkennerly.ludusavi -y
flatpak install flathub it.mijorus.gearlever -y
#flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud -y
#sudo flatpak override --filesystem=xdg-config/MangoHud:ro
flatpak install flathub com.adamcake.Bolt -y
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub org.gnome.Loupe -y
#flatpak install flathub io.github.josephmawa.TextCompare -y
flatpak install flathub org.gnome.Crosswords -y
flatpak install flathub org.qbittorrent.qBittorrent -y
flatpak install flathub io.github.josephmawa.Bella -y
flatpak install flathub com.discordapp.Discord -y
#flatpak install flathub com.rtosta.zapzap -y
#flatpak install flathub io.github.sigmasd.share -y
flatpak install flathub com.github.iwalton3.jellyfin-media-player -y
flatpak install flathub io.github.getnf.embellish -y
flatpak install flathub org.libreoffice.LibreOffice -y
flatpak install flathnet.sourceforge.gMKVExtractGUIub io.mpv.Mpv -y
flatpak install flathub com.belmoussaoui.Decoder -y
flatpak install flathub net.ankiweb.Anki -y
sudo flatpak install https://flatpak.nils.moe/repo/appstream/net.sourceforge.gMKVExtractGUI.flatpakref -y
#flatpak install flathub org.freedesktop.Sdk.Extension.mono6//24.08 -y
flatpak install flathub com.stremio.Stremio -y
#flatpak install flathub io.gitlab.liferooter.TextPieces -y 
#flatpak install org.torproject.torbrowser-launcher -y
## system installations 
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install io.github.flattool.Warehouse -y
#flatpak install flathub io.github.plrigaux.sysd-manager -y
flatpak install flathub io.github.giantpinkrobots.flatsweep -y
# more advanced setup
ssh-keygen
sudo systemctl start sshd
sudo systemctl enable sshd
sudo systemctl status sshd
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload

# Docker Setup
# sudo dnf remove docker \
#                  docker-client \
#                  docker-client-latest \
#                  docker-common \
#                  docker-latest \
#                  docker-latest-logrotate \
#                  docker-logrotate \
#                  docker-selinux \
#                  docker-engine-selinux \
#                  docker-engine
# sudo dnf install dnf-plugins-core -y
# sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
# sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
#
# sudo systemctl enable --now docker
# sudo groupadd docker
# sudo usermod -aG docker rodhfr
# newgrp docker
# docker run hello-world
# docker rmi hello-world -f
# sudo systemctl enable docker.service
# sudo systemctl enable containerd.service

## Portainer Setup
podman volume create portainer_data
podman run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
echo "Setup Login in Portainer: https://localhost:9443"

sudo systemctl enable keyd
# setup xdg-desktop-portal
# https://gist.github.com/rodhfr/181a0bee00ad5f7a608bc3e1bd021be5

echo "user_allow_other" | sudo tee -a /etc/fuse.conf
cat /etc/fuse.conf

sudo chmod +x /home/rodhfr/.config/sway/cliphistbinary
sudo ln -s /home/rodhfr/.config/sway/cliphistbinary /usr/bin/cliphist
ls -l /usr/bin/cliphist
cliphist


cargo install lan-mouse
sudo ln -s /home/rodhfr/.cargo/bin/lan-mouse /usr/bin/lan-mouse

# need to install systemd service
#
# ~/.config/systemd/user/lan-mouse.service
# [Unit]
# Description=Lan Mouse
# # lan mouse needs an active graphical session
# After=graphical-session.target
# # make sure the service terminates with the graphical session
# BindsTo=graphical-session.target
#
# [Service]
# ExecStart=/usr/bin/lan-mouse -d
# Restart=on-failure
#
# [Install]
# WantedBy=graphical-session.target

systemctl --user daemon-reload
systemctl --user enable --now lan-mouse.service
systemctl --user status lan-mouse.service

