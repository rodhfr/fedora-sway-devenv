#!/bin/bash
## ENV VARIABLES ##
while true; do sudo -v; sleep 60; done 2>/dev/null &
export PATH="$HOME/.atuin/bin:$PATH"
sudo usermod -aG pkg-build $USER
newgrp
GIT_USER_EMAIL="souzafrodolfo@gmail.com" # this is only for setup git --global username and email
GIT_USERNAME="Rodolfo Franca" # change for your own otherwise your git commits would be signed in my name

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


# DNF INSTALLATION 
#	copr enable wezfurlong/wezterm-nightly \
# 	tesseract-osd \
#	gammastep \
#   Baobab \
#   @virtualization
# steam \

sudo dnf up -y

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 # for fedora 41

sudo dnf copr enable -y \
	alternateved/keyd \
	erikreider/SwayNotificationCenter \
	zeno/scrcpy \
	monkeygold/nautilus-open-any-terminal \
	sentry/xone \

lpf approve xone-firmware
lpf build xone-firmware
sudo dnf install -y \ 
	gvfs-mtp \
	hugo \
    iperf3 \
	autojump-fish \
	xone lpf-xone-firmware \
	libadwaita-devel \
	nmap \
	nautilus-open-any-terminal \
	xdg-desktop-portal-wlr \
	xdg-desktop-portal-gtk \
	xdg-desktop-portal \
	scrcpy \
	ocrmypdf \
	libssl-devel \
	webkit2gtk4.1 \
	webkit2gtk4.1-devel \
	libEGL \
	libGL \
	gamemode \
	install tesseract-langpack-jpn.noarch \
	install tesseract-langpack-jpn_vert.noarch \
	poetry \
	fzf \
	google-noto-emoji-fonts \
	keyd \
	obs-studio \
	golang \
	pv \
	calc \
	openssh-server \
	gedit \
	ncurses-devel \
	ImageMagick \
	intel-media-driver \
	gnome-software \
	libxkbcommon-devel \
	lxpolkit \
	gnome-disk-utility \
	fuse-overlayfs \
	nautilus \
	openssl \
	swaybg \
	nodejs \
	wl-mirror \
	ydotool -\
	fuse-devel -\
	yad \
	nautilus-open-any-terminal \
	foot \
	alsa-lib-devel \
	mkvtoolnix \
	distrobox \
	libxkbcommon-x11-devel \
	libXcur \
	mesa-libEGL-devel \
	libX11-devel \
	vulkan-devel \
	solaar \
	solaar-udev \
	dejavu-sans-fonts \
	ventoy \
	waybar \
	wl-clipboard \
	kitty \
	wget \
	ffmpeg \
	pavucontrol \
	flatpak \
	unrar \
	git \
	aria2 \
	gparted \
	libva-utils  \
	nodejs-npm  \
	vim  \
	firefox  \
	rofi  \
	htop  \
	nvim \
	fastfetch \
	nmtui \
	rclone \
	python3-pip \
    emacs \
    fd \
    alacritty \
    SwayNotificationCenter \
    qt6-qt5compat \
    fish 


### INSTALLS CODEC IN FEDORA
# more about this change ffmpeg
# https://rpmfusion.org/Howto/Multimedia
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf install rpmfusion-nonfree-release-tainted -y
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware" -y

# Rust install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# TERMINAL SETUP 
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
#atuin register -u rodhfr -e souzafrodolfo@gmail.com
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
# eza
for pkg in lan-mouse swayhide dim-screen rustlings; do
	cargo install $pkg
done
# symlinks

# Git Setup
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USERNAME"

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

# READ TO UNDERSTAND REBOOT LOGIC:
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
    sync && systemctl reboot #sync: Forces all pending disk writes to be flushed from memory to disk. This ensures no data is lost if the system reboots immediately.
fi

### Flatpak Installation
echo "Already rebooted, installation continues..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
#sudo flatpak install https://flatpak.nils.moe/repo/appstream/net.sourceforge.gMKVExtractGUI.flatpakref -y

apps=(
  it.mijorus.gearlever
  com.adamcake.Bolt
  com.bitwarden.desktop
  com.spotify.Client
  org.gnome.Loupe
  org.qbittorrent.qBittorrent
  io.github.josephmawa.Bella
  com.discordapp.Discord
  com.github.iwalton3.jellyfin-media-player
  io.github.getnf.embellish
  org.libreoffice.LibreOffice
  io.mpv.Mpv
  com.belmoussaoui.Decoder
  net.ankiweb.Anki
  com.stremio.Stremio
  com.github.tchx84.Flatseal
  io.github.flattool.Warehouse
  io.github.giantpinkrobots.flatsweep
)

for app in "${apps[@]}"; do
    flatpak install -y flathub "$app"
done

# Systemd Services

keys=($HOME/.ssh/id_*)
if [ ${#keys[@]} -eq 0 ] || [ ! -e "${keys[0]}" ]; then
    echo "No key found, generating..."
    [ -f "$HOME/.ssh/id_ed25519.pub" ] || { mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh" && ssh-keygen -t ed25519 -a 100 -f "$HOME/.ssh/id_ed25519" -N "" -q; }
else
    echo "ssh key exists"
fi

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

#### ENABLING SERVICES ####
## Portainer Setup ## 
systemctl enable --now podman.socket
podman volume create portainer_data
podman run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always --privileged -v /run/podman/podman.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
echo "Setup Login in Portainer: https://localhost:9443"

### setup xdg-desktop-portal ###
# https://gist.github.com/rodhfr/181a0bee00ad5f7a608bc3e1bd021be5
GTK_PORTAL="/usr/share/xdg-desktop-portal/portals/gtk.portal"
sudo sed -i 's|^UseIn=.*|UseIn=wlroots;sway;Wayfire;river;phosh;Hyprland;|' "$GTK_PORTAL"
echo "gtk.portal atualizado:"
grep '^UseIn=' "$GTK_PORTAL"


# ENABLE RCLONE MOUNTS ACESS
echo "user_allow_other" | sudo tee -a /etc/fuse.conf
cat /etc/fuse.conf

### CLIPBOARD SAVER
sudo chmod +x /home/rodhfr/.config/sway/clipboard/cliphistbinary
sudo ln -s /home/rodhfr/.config/sway/clipboard/cliphistbinary /usr/bin/cliphist
ls -l /usr/bin/cliphist
cliphist

### LAN MOUSE SYSTEMD SERVICE
sudo ln -s /home/rodhfr/.cargo/bin/lan-mouse /usr/bin/lan-mouse

systemctl --user daemon-reload
systemctl --user enable --now lan-mouse.service
systemctl --user status --no-pager lan-mouse.service

# KDE CONNECT SERVICE
systemctl --user daemon-reload
systemctl --user enable --now kdeconnect.service
systemctl --user status --no-pager kdeconnect.service

# KEYD SERVICE
sudo mkdir -p /etc/keyd
sudo ln -s ~/.config/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
sudo systemctl status --no-pager keyd


