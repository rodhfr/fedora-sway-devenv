#!/usr/bin/env bash
set -euo pipefail

# Nome do container e imagem
CONTAINER_NAME="archbox"
IMAGE="ghcr.io/ublue-os/arch-distrobox:latest"

# Detectar se o sistema é imutável
if [ -f /etc/ostree-release ] || [ -d /ostree/deploy ]; then
    echo "Imutable System Detected."
    BASE_HOME="/var$HOME/Machines/$CONTAINER_NAME"
    VOLUME_PREFIX="/var$HOME"
else
    echo "Mutable Root System Detected."
    echo "This script is only for immmutable root systems like fedora silverblue, or ublue. Exiting..."
    exit 1
fi

mkdir -p "$BASE_HOME"

VOLUMES=(
  "Desktop"
  "Downloads"
  "Documents"
  "Pictures"
)

VOLUME_ARGS=()
for dir in "${VOLUMES[@]}"; do
    VOLUME_ARGS+=( "--volume" "$VOLUME_PREFIX/$dir:$BASE_HOME/$dir:rw" )
done

distrobox-create \
  --pull \
  --name "$CONTAINER_NAME" \
  --home "$BASE_HOME" \
  --hostname "$CONTAINER_NAME" \
  --init \
  --image "$IMAGE" \
  "${VOLUME_ARGS[@]}" 
#  --unshare-all \

PACKAGES=(
  podman base-devel git vim neovim python systemd python-pip nodejs npm yarn rustup 
  gcc clang go fzf calc openssl wget aria2 cmake gdb make tmux htop curl unzip zip unrar
)

PACMAN_CONF="/etc/pacman.conf"
MIRROR_FOLDER="$BASE_HOME/.config/ghostmirror"
MIRROR_FILE="$MIRROR_FOLDER/mirrorlist"

# SETTING UP HOME FOLDER
distrobox-enter "$CONTAINER_NAME" -- bash -c '
CONTAINER_HOME="'"$BASE_HOME"'"
BASHRC="$CONTAINER_HOME/.bashrc"

# Substitui qualquer linha existente com export HOME=
if grep -q "^export HOME=" "$BASHRC"; then
    sed -i "s|^export HOME=.*|export HOME=\"$CONTAINER_HOME\"|" "$BASHRC"
else
    echo "export HOME=\"$CONTAINER_HOME\"" >> "$BASHRC"
fi

# Garantir que cd vá para o home
if ! grep -q "cd \$HOME" "$BASHRC"; then
    echo "cd \$HOME" >> "$BASHRC"
fi
'

# INSTALLING BASIC DEV PACKAGES 
PACKAGES_STR="${PACKAGES[*]}"

distrobox-enter "$CONTAINER_NAME" -- bash -c '
set -euo pipefail

CONTAINER_HOME="'"$BASE_HOME"'"
MIRROR_FOLDER="'"$MIRROR_FOLDER"'"
MIRROR_FILE="'"$MIRROR_FILE"'"
PACMAN_CONF="'"$PACMAN_CONF"'"
read -r -a PACKAGES <<< "'"$PACKAGES_STR"'"

mkdir -p "$MIRROR_FOLDER"
sudo cp "$PACMAN_CONF" "${PACMAN_CONF}.bak"

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy archlinux-keyring --needed --noconfirm

echo "➡️ Updating Mirrors..."
paru -Sy --needed --noconfirm ghostmirror
if [[ ! -s "$MIRROR_FILE" ]]; then
    ghostmirror -PoclLS "Brazil,United States" "$MIRROR_FILE" 30 state,outofdate,morerecent,ping
fi
ghostmirror -PoDumlsS "$MIRROR_FILE" "$MIRROR_FILE" light state,outofdate,morerecent,estimated,speed
sudo sed -i "s|^Include = .*|Include = $MIRROR_FILE|" "$PACMAN_CONF"

echo "➡️ Syncing packages..."
sudo pacman -Syyu --noconfirm

echo "➡️ Installing Predefined Packages..."
paru -Syu --needed --noconfirm "${PACKAGES[@]}"
paru -S --needed --noconfirm ttf-firacode-nerd 

sudo usermod --add-subuids 10000-65536 "$USER"
sudo usermod --add-subgids 10000-65536 "$USER"

cat << EOF | sudo tee /etc/containers/containers.conf
[containers]
netns="host"
userns="host"
ipcns="host"
utsns="host"
cgroupns="host"
log_driver = "k8s-file"
[engine]
cgroup_manager = "cgroupfs"
events_logger="file"
EOF

podman run --rm hello-world
source "$CONTAINER_HOME/.bashrc"
'

echo "Distrobox '$CONTAINER_NAME' created and predefined packages installed with success."
echo "➡️ Setup Distrobox '$CONTAINER_NAME' password now: "
distrobox enter $CONTAINER_NAME
