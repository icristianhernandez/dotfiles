# wsl --install --no-distribution

# install arch in mstore

# Font: JetBrainsMonoNL

# config git

# public keys

sudo pacman -Syu
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
yay -Y --gendb && yay -Syu --devel && yay -Y --devel --save
yay -S wget unzip nodejs npm git python python-pip ripgrep openssh stow starship fish ripgrep fd curl tar fd yazi tree-sitter-git neovim-git
git config --global init.defaultBranch main
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
ssh-keygen -t ed25519 -C "cristianhernandez9007@gmail.c
om"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# search how permanently activate ssh agent

cd ~
git clone git@github.com:icristianhernandez/dotfiles.git
git config --global user.email "cristianhernandez9007@gmail.com"
git config --global user.name "cristian"
cd ~/dotfiles
stow nvim/
stow fish/
stow starship/
