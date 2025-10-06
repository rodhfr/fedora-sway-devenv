## Installation
> [!IMPORTANT]
> Do no install blindly! This is a personal repo which may not work on your computer, read before.

#### Works on: 
* Fedora 42
  
### Install Script
```bash
sudo dnf install git -y
git clone https://github.com/rodhfr/sway-devenv-dotfiles.git 
cd sway-devenv-dotfiles 
cp -rf * ~/.config/
sh ~/.config/sway/install-programs.sh
```

### [WIP] Currently working on ansible playbook for this dotfiles

