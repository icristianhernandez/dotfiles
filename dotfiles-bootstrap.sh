#!/bin/bash
# arch in wsl development setup using nvim as editor

# For that wsl enviroment, I previously need to:
# a) Install wsl:
# wsl --install --no-distribution
# wsl --install archlinux
# b) Download and set a nerd font in the terminal

set -e 

if [[ $EUID -eq 0 ]]; then
    echo "User Creation"
    

    read -p "Enter a new username: " username
    if [ -z "$username" ]; then
        echo "Username cannot be empty. Exiting."
        exit 1
    fi

    pacman -Syu --noconfirm
    pacman -S --noconfirm fish
    pacman -S --noconfirm sudo

    echo "Configuring sudo for wheel group..."
    # Uncomment the wheel line in /etc/sudoers to allow sudo for users in wheel
    sed -i -E 's/^[[:space:]]*#([[:space:]]*%wheel[[:space:]]+ALL=\(ALL:ALL\)[[:space:]]+ALL)/\1/' /etc/sudoers

    useradd -m -G wheel -s /usr/bin/fish "$username"

    echo "Configuring locale (en_US.UTF-8)..."
    sed -i 's/^#\s*en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf

    echo "Setting password for user '$username'..."
    passwd "$username"

    echo "Setting password for root..."
    passwd root

    echo "Setting default user in /etc/wsl.conf to '$username'..."
    cat > /etc/wsl.conf <<EOF
[user]
default = $username

[boot]
systemd=true
EOF

    exit 0
fi

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
    keychain
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
    base-devel
)

read -rsp "Enter passphrase for SSH key: " passphrase
echo

# Ensure a sane locale for this session to avoid Perl/locale warnings
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL=${LC_ALL:-en_US.UTF-8}

# System Updates and Package Installation
echo "Updating system and installing packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed "${packages[@]}"

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

# Start keychain for this session so git clone works (will prompt for passphrase once)
# Force bash-compatible output even if user's default SHELL is fish
eval "$(SHELL=/bin/bash keychain --eval --quiet id_ed25519)"

## Ensure SSH config has IdentityFile (keychain manages the agent; no AddKeysToAgent needed)
if ! grep -q "IdentityFile ~/.ssh/id_ed25519" ~/.ssh/config 2>/dev/null; then
    mkdir -p ~/.ssh
    echo -e "Host *\n  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
fi

## Shell integration notes (not applied automatically)
echo
echo "To auto-load your SSH key with keychain in future shells, add one of these to your shell config:"
echo "- Bash (~/.bashrc):"
echo '    eval "$(keychain --quiet --eval id_ed25519)"'
echo "- Fish (~/.config/fish/config.fish):"
echo '    keychain --quiet --eval id_ed25519 | source'

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
    if ! GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" git clone "$repo_url"; then
        echo "Failed to clone repository. Please check your network or SSH configuration."
        exit 1
    fi
else
    echo "Dotfiles repository already exists. Skipping clone."
fi
cd ~/dotfiles || exit
echo "Stowing dotfiles..."
base_dir="$HOME/dotfiles"
# Build package list from top-level directories using find (robust against globbing issues)
mapfile -d '' -t pkgs < <(find "$base_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\0')
if [ ${#pkgs[@]} -eq 0 ]; then
    echo "No packages to stow. Skipping."
else
    stow -d "$base_dir" -t "$HOME" -- "${pkgs[@]}"
fi

echo "Setup complete!"
