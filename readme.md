## Installation
> [!IMPORTANT]
> Do no install blindly! This is a personal repo which may not work on your computer, read before.

#### Works on: 
* Fedora 42
  
### Install Script
```bash
sudo -v
trap 'echo "exiting.."; exit 1' SIGINT
sudo dnf install git -y
cd "$HOME"
git clone https://github.com/rodhfr/sway-devenv-dotfiles.git 
cd "$HOME/sway-devenv-dotfiles"
cp -rf * "$HOME/.config/"
sudo sh "$HOME/.config/sway/install-programs.sh"
```
Or if you prefer a a single line curl
```bash
curl -fsSL 'https://github.com/rodhfr/fedora-sway-devenv/blob/main/install-helper.sh' | sudo bash
```

### [WIP] Currently working on ansible playbook for this dotfiles

