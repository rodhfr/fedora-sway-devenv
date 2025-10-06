sudo -v
trap 'echo "exiting.."; exit 1' SIGINT
sudo dnf install git -y
cd "$HOME"
git clone https://github.com/rodhfr/sway-devenv-dotfiles.git 
cd "$HOME/sway-devenv-dotfiles"
cp -rf * "$HOME/.config/"
sudo sh "$HOME/.config/sway/install-programs.sh"
