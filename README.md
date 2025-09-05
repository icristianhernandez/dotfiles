# My Personal NixOS Configuration

Welcome to my personal NixOS dotfiles. This repository contains the complete, declarative configuration for my NixOS systems, managed using Nix Flakes and Home Manager.

## Quick Start: Automated Install

On a fresh NixOS installation, you can use the following one-liner to link the system configuration. This script will back up any existing `/etc/nixos` and create a symbolic link to the configuration within this repository.

> **Warning:** Always review scripts from the internet before running them with `sudo`.

```bash
curl -fsSL https://raw.githubusercontent.com/icristianhernandez/dotfiles/main/install.sh | sudo bash
```

After running the script, you still need to generate your hardware configuration (see Step 2 below) and then proceed to the "First Time Build" section.

## Manual Installation

If you prefer to perform the setup manually, follow these steps.

### 1. Clone the Repository

Clone this repository to your preferred location, for example, `~/dotfiles`.

```bash
git clone https://github.com/icristianhernandez/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Generate Hardware Configuration

A NixOS configuration needs a file that describes the specific hardware of the machine it's running on.

From the root of this repository, run the following command. It will automatically place the generated hardware profile into the correct location.

```bash
sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix
```

### 3. Link the Configuration

Link the `nixos` directory from this repository to `/etc/nixos`. You can do this manually, or by using the provided `install.sh` script.

```bash
sudo ./install.sh
```

### 4. First Time Build

Now you are ready to build the system for the first time. The hostname defined in the flake is `nixos`.

```bash
cd nixos/
sudo nixos-rebuild switch --flake .#nixos
```

Your system is now fully managed by this configuration.

## Usage and Maintenance

To apply any future changes you make to this configuration, simply run the build command again from within the `nixos/` directory:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

To update all your flake inputs (like `nixpkgs` and `home-manager`) to their latest versions, run:

```bash
nix flake update
```

---
*This repository is a living configuration and is always a work in progress.*
