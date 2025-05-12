#!/bin/bash
# arch in wsl development setup using nvim as editor

# For that wsl enviroment, I previously need to:
# a) Install wsl: wsl --install --no-distribution
# b) Install arch distro in wsl
# c) Download and set a nerd font in the terminal

set -e # Exit on errors
set -x # Debug mode

email="cristianhernandez9007@gmail.com"
name="cristian"
repo_url="git@github.com:icristianhernandez/dotfiles.git"
packages=(
    wget
    unzip
    nodejs
    npm
    git
    python
    python-pip
    openssh
    stow
    starship
    fish
    ripgrep
    curl
    tar
    fd
    yazi
    tree-sitter
    neovim
    inotify-tools
)

read -rsp "Enter passphrase for SSH key: " passphrase
echo

# System Updates and Package Installation
echo "Updating system and installing packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed "${packages[@]}"

# Set Locale
echo "Setting locale..."
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=en_US.UTF-8

# Change default shell to fish
echo "Changing default shell to fish"
if ! grep -q "/usr/bin/fish" /etc/shells; then
    echo "/usr/bin/fish" | sudo tee -a /etc/shells
fi
chsh -s /usr/bin/fish

# Configure Git
echo "Configuring Git..."
git config --global init.defaultBranch main
git config --global user.email "$email"
git config --global user.name "$name"

# Generate SSH Key
echo "Generating SSH key..."
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N "$passphrase"
else
    echo "SSH key already exists. Skipping generation."
fi
unset passphrase

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

## Persist SSH agent
if ! grep -q "AddKeysToAgent" ~/.ssh/config 2>/dev/null; then
    mkdir -p ~/.ssh
    echo -e "Host *\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_ed25519" >>~/.ssh/config
fi
systemctl --user enable ssh-agent.service
systemctl --user start ssh-agent.service

# Clone and Setup Dotfiles
## Display public key and wait for user confirmation
echo "Your SSH public key is:"
cat ~/.ssh/id_ed25519.pub
echo "Please add this key to your GitHub account: https://github.com/settings/keys"
read -rp "Press Enter after adding the SSH key to GitHub to continue..."

echo
echo "Cloning and setting up dotfiles..."
cd ~ || exit
if [ ! -d ~/dotfiles ]; then
    if ! git clone "$repo_url"; then
        echo "Failed to clone repository. Please check your network or SSH configuration."
        exit 1
    fi
else
    echo "Dotfiles repository already exists. Skipping clone."
fi
cd ~/dotfiles || exit
stow -- */

echo "Setup complete!"
