{ config, pkgs, ... }:

let
  # Import global settings from our centralized config file.
  globals = import ./config/globals.nix;
in
{
  imports = [
    # Import the hardware-specific configuration for this machine.
    ./hardware-configuration.nix

    # Import our modular configuration files.
    ./modules/system.nix
    ./modules/desktop.nix
    # Note: home.nix is now imported via the decoupled flake structure
    # and does not need to be listed here.
  ];

  # This is a required setting.
  system.stateVersion = "23.11";

  # Define your user account using the username from globals.nix.
  users.users.${globals.username} = {
    isNormalUser = true;
    description = "Cristian Hernandez";
    extraGroups = [ "wheel" ]; # Enable sudo.
    shell = pkgs.fish;
  };
}
