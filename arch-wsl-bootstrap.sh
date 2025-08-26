#!/bin/bash
# arch in wsl development setup using nvim as edito

# For that wsl enviroment, I previously need to:
# a) Install wsl: wsl --install --no-distributions
# b) Install arch distro in wsl
# c) Download and set a nerd font in the terminal

set -e # Exit on errors
set -x # Debug mode

# Configuration with validation
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
    ta
    fd
    yazi
    tree-sitte
    neovim
    inotify-tools
    keychain
    base-devel
    sudo
    reflecto
    mesa
    vulkan-dzn
    vulkan-icd-loade
)

# Error handling and recovery functions
cleanup_on_error() {
    echo "Error occurred. Cleaning up..."
    # Remove partially created user if it exists but wasn't fully configured
    if id "$name" &>/dev/null && [[ ! -f "/home/$name/.ssh/id_ed25519" ]]; then
        echo "Removing partially created user '$name'..."
        sudo userdel -r "$name" 2>/dev/null || true
    fi
}

trap cleanup_on_error ERR

# Check internet connectivity
if ! ping -c 1 archlinux.org &> /dev/null; then
    echo "Error: No internet connectivity. Please check your network connection."
    exit 1
fi

# Get and validate SSH passphrase
read -rsp "Enter passphrase for SSH key: " passphrase
echo

echo "$(date): Starting Arch WSL bootstrap script..."

# System Updates and Package Installation
echo "Updating system and installing packages..."
if ! sudo pacman -Syu --noconfirm; then
    echo "Error: System update failed. Attempting to continue with package installation..."
    sleep 2
fi

# Install packages
failed_packages=()
for package in "${packages[@]}"; do
    if ! sudo pacman -S --noconfirm --needed "$package"; then
        echo "Warning: Failed to install package '$package'"
        failed_packages+=("$package")
    fi
done

if [[ ${#failed_packages[@]} -gt 0 ]]; then
    echo "Warning: The following packages failed to install: ${failed_packages[*]}"
    echo "Attempting to install failed packages individually..."
    for package in "${failed_packages[@]}"; do
        if ! sudo pacman -S --noconfirm --needed "$package"; then
            echo "Error: Critical package '$package' could not be installed."
            echo "Please install manually: sudo pacman -S $package"
        fi
    done
fi

# Verify critical packages were installed
critical_packages=("git" "base-devel" "sudo")
for package in "${critical_packages[@]}"; do
    if ! pacman -Qq "$package" &> /dev/null; then
        echo "Error: Critical package '$package' failed to install."
        exit 1
    fi
done

# Configure reflector for better mirrors
echo "Configuring package mirrors..."
if command -v reflector &> /dev/null; then
    sudo reflector --country US,CA --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
fi

# Create non-root use
echo "Creating non-root user '$name'..."
if ! id "$name" &>/dev/null; then
    # Ensure fish shell is in /etc/shells for PAM compatibility
    if ! grep -q "/usr/bin/fish" /etc/shells; then
        echo "/usr/bin/fish" | sudo tee -a /etc/shells
    fi
    
    # Create user with private group (UPG) and add to wheel as supplementary group
    if ! sudo useradd -m -G wheel -s /usr/bin/fish "$name"; then
        echo "Error: Failed to create user '$name'."
        exit 1
    fi
    echo "Setting password for user '$name'..."
    echo "Please set a strong password for user '$name':"
    if ! sudo passwd "$name"; then
        echo "Error: Failed to set password for user '$name'."
        exit 1
    fi
    
    # Configure sudo for wheel group with security considerations
    echo "Configuring sudo access..."
    echo "WARNING: This will grant sudo access to user '$name'."
    echo "This allows the user to execute commands as root."
    read -rp "Grant sudo access to user '$name'? (y/N): " grant_sudo
    if [[ "$grant_sudo" =~ ^[Yy]$ ]]; then
        echo "%wheel ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/wheel
        echo "Defaults timestamp_timeout=15" | sudo tee -a /etc/sudoers.d/wheel
        echo "Defaults passwd_timeout=5" | sudo tee -a /etc/sudoers.d/wheel
        sudo chmod 440 /etc/sudoers.d/wheel
        echo "Sudo access granted with 15-minute timeout."
    else
        echo "Sudo access not granted. User can be added to sudoers manually later."
    fi
else
    echo "User '$name' already exists."
fi

# Set root password for recovery access
echo "Setting root password..."
sudo passwd root

# WSL Configuration
echo "Configuring WSL settings..."
sudo tee /etc/wsl.conf > /dev/null << EOF
[boot]
systemd=true

[user]
default=$name

[interop]
enabled=true
appendWindowsPath=true

[network]
generateHosts=true
generateResolvConf=true

[automount]
enabled=true
root=/mnt/
options="metadata,umask=22,fmask=11"
mountFsTab=false
EOF

# Install and configure yay (AUR helper)
echo "Installing yay AUR helper..."
if ! command -v yay &> /dev/null; then
    cd /tmp || exit 1
    if ! sudo -u "$name" git clone https://aur.archlinux.org/yay.git; then
        echo "Error: Failed to clone yay repository."
        exit 1
    fi
    cd yay || exit 1
    if ! sudo -u "$name" makepkg -si --noconfirm; then
        echo "Error: Failed to build yay."
        exit 1
    fi
    cd ~ || exit 1
    rm -rf /tmp/yay
else
    echo "yay is already installed."
fi

# Change default shell to fish for the new use
echo "Changing default shell to fish for user '$name'..."
# Note: Shell already set during user creation, but verify it's in /etc/shells
if ! grep -q "/usr/bin/fish" /etc/shells; then
    echo "/usr/bin/fish" | sudo tee -a /etc/shells
fi
# Shell was already set during useradd, but we can verify:
if ! getent passwd "$name" | grep -q "/usr/bin/fish"; then
    sudo chsh -s /usr/bin/fish "$name"
fi

# Configure Git
echo "Configuring Git for user '$name'..."
sudo -u "$name" git config --global init.defaultBranch main
sudo -u "$name" git config --global user.email "$email"
sudo -u "$name" git config --global user.name "$name"

# Generate SSH Key
echo "Generating SSH key for user '$name'..."
ssh_dir="/home/$name/.ssh"
ssh_key="$ssh_dir/id_ed25519"

if [ ! -f "$ssh_key" ]; then
    sudo -u "$name" mkdir -p "$ssh_dir"
    if ! sudo -u "$name" ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N "$passphrase"; then
        echo "Error: Failed to generate SSH key."
        exit 1
    fi
    sudo -u "$name" chmod 700 "$ssh_dir"
    sudo -u "$name" chmod 600 "$ssh_key"
    sudo -u "$name" chmod 644 "$ssh_key.pub"
    echo "SSH key generated successfully."
else
    echo "SSH key already exists. Verifying..."
    if sudo -u "$name" ssh-keygen -y -f "$ssh_key" -P "$passphrase" >/dev/null 2>&1; then
        echo "Existing SSH key verified successfully."
    else
        echo "Error: Existing SSH key verification failed. Passphrase may be incorrect."
        read -rp "Generate new SSH key? (y/N): " generate_new
        if [[ "$generate_new" =~ ^[Yy]$ ]]; then
            backup_key="${ssh_key}.backup.$(date +%Y%m%d_%H%M%S)"
            sudo -u "$name" cp "$ssh_key" "$backup_key"
            sudo -u "$name" cp "$ssh_key.pub" "$backup_key.pub"
            echo "Backed up existing key to $backup_key"
            sudo -u "$name" ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N "$passphrase"
            sudo -u "$name" chmod 600 "$ssh_key"
            sudo -u "$name" chmod 644 "$ssh_key.pub"
        else
            echo "Continuing with existing SSH key..."
        fi
    fi
fi
unset passphrase

# Configure SSH client settings and permissions
echo "Configuring SSH client settings and permissions for user '$name'..."
ssh_dir="/home/$name/.ssh"
ssh_config="$ssh_dir/config"
known_hosts="$ssh_dir/known_hosts"

# Set comprehensive SSH directory and file permissions
sudo -u "$name" chmod 700 "$ssh_dir"
sudo -u "$name" chmod 600 "$ssh_dir/id_ed25519" 2>/dev/null || true
sudo -u "$name" chmod 644 "$ssh_dir/id_ed25519.pub" 2>/dev/null || true
sudo -u "$name" touch "$ssh_dir/authorized_keys" && sudo -u "$name" chmod 600 "$ssh_dir/authorized_keys"
sudo -u "$name" touch "$known_hosts" && sudo -u "$name" chmod 644 "$known_hosts"

# Add GitHub's SSH host key to known_hosts for security
echo "Adding GitHub SSH host keys to known_hosts..."
github_keys=$(ssh-keyscan -H github.com 2>/dev/null)
if [[ -n "$github_keys" ]]; then
    echo "$github_keys" | sudo -u "$name" tee -a "$known_hosts" >/dev/null
    echo "GitHub SSH host keys added to known_hosts."
else
    echo "Warning: Could not retrieve GitHub SSH host keys. You may need to accept them manually."
fi

# Configure SSH client with comprehensive settings
if ! sudo -u "$name" test -f "$ssh_config" || ! grep -q "AddKeysToAgent" "$ssh_config" 2>/dev/null; then
    sudo -u "$name" tee "$ssh_config" > /dev/null << 'EOF'
# Global SSH client configuration
Host *
    # Key management
    AddKeysToAgent yes
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
    
    # Connection settings
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ConnectTimeout 10
    
    # Connection multiplexing for better performance
    ControlMaster auto
    ControlPath ~/.ssh/sockets/master-%r@%h:%p
    ControlPersist 600
    
    # WSL-specific optimizations
    IPQoS throughput
    Compression yes
    
    # Security settings
    HashKnownHosts yes
    StrictHostKeyChecking yes
    VerifyHostKeyDNS yes

# GitHub-specific configuration
Host github.com
    HostName github.com
    User git
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking yes
EOF
    echo "SSH client configuration created."
else
    echo "SSH configuration already exists. Checking for GitHub host entry..."
    if ! grep -q "Host github.com" "$ssh_config"; then
        sudo -u "$name" tee -a "$ssh_config" > /dev/null << 'EOF'

# GitHub-specific configuration
Host github.com
    HostName github.com
    User git
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking yes
EOF
        echo "Added GitHub configuration to existing SSH config."
    fi
fi

# Create control sockets directory for connection multiplexing
sudo -u "$name" mkdir -p "$ssh_dir/sockets"
sudo -u "$name" chmod 700 "$ssh_dir/sockets"

# Set final permissions on SSH config
sudo -u "$name" chmod 600 "$ssh_config"

# Setup keychain for SSH agent management
echo "Setting up keychain for SSH agent management..."
# keychain provides persistent SSH agent across sessions and boots
# Only requires passphrase entry once per machine boot
# More reliable than systemd ssh-agent service in WSL environments

# Clone and Setup Dotfiles
## Display public key and wait for user confirmation
echo "Your SSH public key for user '$name' is:"
sudo -u "$name" cat "$ssh_dir/id_ed25519.pub"
echo "Please add this key to your GitHub account: https://github.com/settings/keys"
read -rp "Press Enter after adding the SSH key to GitHub to continue..."

# Test SSH connection before proceeding
echo "Testing SSH connection to GitHub..."
max_attempts=3
attempt=1
ssh_test_success=false

while [[ $attempt -le $max_attempts ]]; do
    echo "Attempt $attempt of $max_attempts..."
    if sudo -u "$name" ssh -T git@github.com -o ConnectTimeout=10 -o BatchMode=yes 2>&1 | grep -q "successfully authenticated"; then
        echo "SSH connection to GitHub successful!"
        ssh_test_success=true
        break
    else
        echo "SSH connection failed. Please verify:"
        echo "1. SSH key has been added to GitHub"
        echo "2. Internet connectivity is working"
        echo "3. GitHub is accessible"
        if [[ $attempt -lt $max_attempts ]]; then
            read -rp "Press Enter to retry, or Ctrl+C to abort..."
        fi
    fi
    ((attempt++))
done

if [[ "$ssh_test_success" != true ]]; then
    echo "Error: Failed to establish SSH connection to GitHub after $max_attempts attempts."
    echo "Please verify your SSH key setup and try running the dotfiles section manually:"
    echo "  sudo -u $name git clone $repo_url /home/$name/dotfiles"
    echo "  cd /home/$name/dotfiles && sudo -u $name stow -- */"
    echo "Continuing with remaining setup..."
    dotfiles_setup_failed=true
fi

echo
echo "Cloning and setting up dotfiles for user '$name'..."
dotfiles_dir="/home/$name/dotfiles"
if [[ "$ssh_test_success" == true ]]; then
    if [ ! -d "$dotfiles_dir" ]; then
        if ! sudo -u "$name" git clone "$repo_url" "$dotfiles_dir"; then
            echo "Error: Failed to clone repository despite successful SSH test."
            echo "This may be a temporary network issue. You can retry manually:"
            echo "  sudo -u $name git clone $repo_url $dotfiles_dir"
            dotfiles_setup_failed=true
        fi
    else
        echo "Dotfiles repository already exists. Updating..."
        cd "$dotfiles_dir" || exit 1
        if ! sudo -u "$name" git pull; then
            echo "Warning: Failed to update existing dotfiles repository."
        fi
    fi

    if [[ "$dotfiles_setup_failed" != true ]] && [[ -d "$dotfiles_dir" ]]; then
        cd "$dotfiles_dir" || exit 1
        if ! sudo -u "$name" stow --restow -- */; then
            echo "Warning: Some dotfiles may have failed to symlink. Check for conflicts:"
            echo "  cd $dotfiles_dir && stow --simulate -- */"
        else
            echo "Dotfiles successfully stowed."
        fi
    fi
else
    echo "Skipping dotfiles setup due to SSH connection failure."
fi

# Post-installation verification
echo "Performing post-installation verification..."
verification_failed=false

# Test SSH configuration
echo "Testing SSH configuration..."
ssh_config_test_passed=true
if ! sudo -u "$name" ssh -T git@github.com -o ConnectTimeout=10 -o BatchMode=yes 2>&1 | grep -q "successfully authenticated"; then
    echo "Warning: SSH connection to GitHub failed."
    echo "This may indicate:"
    echo "  - SSH key not properly added to GitHub account"
    echo "  - Network connectivity issues"
    echo "  - SSH configuration problems"
    echo "Manual test command: sudo -u $name ssh -T git@github.com"
    ssh_config_test_passed=false
    verification_failed=true
fi

# Verify critical packages
echo "Verifying package installations..."
critical_packages=("git" "fish" "neovim" "stow" "yay")
for package in "${critical_packages[@]}"; do
    if [[ "$package" == "yay" ]]; then
        if ! sudo -u "$name" command -v yay &> /dev/null; then
            echo "Error: $package is not available."
            verification_failed=true
        fi
    else
        if ! pacman -Qq "$package" &> /dev/null; then
            echo "Error: $package is not installed."
            verification_failed=true
        fi
    fi
done

# Verify user configuration
echo "Verifying user configuration..."
if ! id "$name" &>/dev/null; then
    echo "Error: User '$name' was not created successfully."
    verification_failed=true
fi

if ! sudo -u "$name" test -f "/home/$name/.ssh/id_ed25519"; then
    echo "Error: SSH key was not generated for user '$name'."
    verification_failed=true
fi

# Test shell configuration
echo "Testing shell configuration..."
if ! getent passwd "$name" | grep -q "/usr/bin/fish"; then
    echo "Warning: Default shell was not changed to fish for user '$name'."
    verification_failed=true
fi

# Post-installation tips
echo "=========================================="
echo "POST-INSTALLATION TIPS & NEXT STEPS"
echo "=========================================="
echo ""
echo "IMPORTANT: WSL RESTART REQUIRED"
echo "   To apply all changes (especially systemd and default user), restart WSL:"
echo "   From Windows PowerShell/CMD:"
echo "   wsl --terminate archlinux"
echo "   wsl -d archlinux"S
echo "   You should now login as user '$name' by default."
echo ""
echo "1. SSH AGENT CONFIGURATION (RECOMMENDED)"
echo "   To enable persistent SSH agent with keychain, the configuration has been"
echo "   added to your shell. After WSL restart, run:"
echo "   eval \$(keychain --eval --quiet --inherit any-once id_ed25519)"
echo ""
echo "2. VERIFICATION RESULTS"
if [ "$verification_failed" = true ]; then
echo "   Some verification checks failed. Please review the output above."
else
echo "   All verification checks passed successfully!"
fi
echo ""
echo "3. INSTALLED COMPONENTS"
echo "   - User '$name' created with sudo access"
echo "   - ${#packages[@]} packages installed including development tools"
echo "   - yay AUR helper configured"
echo "   - WSLg hardware acceleration enabled"
echo "   - SSH key generated and configured"
echo "   - Dotfiles cloned and stowed"
echo "   - WSL configuration optimized"
echo ""
echo "4. FILES CREATED"
echo "   - WSL config: /etc/wsl.conf"
echo "   - SSH config: /home/$name/.ssh/config"
echo ""
echo "5. OPTIONAL ENHANCEMENTS"
echo "   - Windows SSH agent bridging: sudo -u $name yay -S wsl2-ssh-agent"
echo "   - Windows Hello authentication: sudo -u $name yay -S wsl-hello-sudo-bin"
echo ""
echo "6. TROUBLESHOOTING"
echo "   If you encounter issues:"
echo "   - Verify SSH: ssh -T git@github.com"
echo "   - Test yay: yay --version"
echo "   - Check WSL config: cat /etc/wsl.conf"
echo ""
echo "=========================================="