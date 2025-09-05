{ config, pkgs, ... }:

{
  imports = [
    # Import the hardware-specific configuration for this machine.
    ./hardware-configuration.nix

    # Import our modular configuration files.
    ./modules/system.nix
    ./modules/desktop.nix
    ./modules/home.nix
  ];

  # This is a required setting.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Or whatever version you originally installed.

  # Define your user account.
  users.users.icristianhernandez = {
    isNormalUser = true;
    description = "Cristian Hernandez";
    extraGroups = [ "wheel" ]; # Enable sudo.
    shell = pkgs.fish;
  };
}
