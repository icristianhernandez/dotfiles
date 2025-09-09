{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  # Add necessary packages for the setup process
  buildInputs = with pkgs; [
    git # Used to clone the dotfiles repository
    coreutils # For the 'mv' command
    nixos-rebuild # The main tool for applying the new configuration
  ];

  # This script will run automatically when you enter the shell with `nix-shell`
  shellHook = ''
    if [[ $EUID -ne 0 ]]; then
      echo "This script must be run with root privileges. Please use 'sudo nix-shell'." 1>&2
      exit 1
    fi

    echo "Welcome to the NixOS setup environment."

    echo "Step 1: Cloning dotfiles repository..."
    if [ ! -d "$HOME/dotfiles" ]; then
      git clone https://github.com/icristianhernandez/dotfiles "$HOME/dotfiles"
    else
      echo "Dotfiles directory already exists. Skipping clone."
    fi

    echo "Step 2: Moving hardware-configuration.nix..."
    # Check if the hardware configuration file exists in the default location
    if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
      # Make sure the target directory exists in the cloned repository
      mkdir -p "$HOME/dotfiles/nixos"
      mv /etc/nixos/hardware-configuration.nix "$HOME/dotfiles/nixos/hardware-configuration.nix"
      echo "Moved /etc/nixos/hardware-configuration.nix to $HOME/dotfiles/nixos/"
    else
      echo "No hardware-configuration.nix found at /etc/nixos/. Skipping move."
    fi

    echo ""
    echo "Starting NixOS build and switch process..."
    # This command rebuilds and applies the new system configuration
    # The --flake .# will use the flake in the current directory, which is now
    # the dotfiles repository
    if nixos-rebuild switch --flake "/etc/nixos#<hostname>"; then
      echo "NixOS configuration applied successfully. The system has been switched."
    else
      echo "NixOS configuration failed to build or switch. Please check the logs above."
      exit 1
    fi
    echo ""
    echo "Setup complete. Exiting the shell."
    exit 0
  '';
}
