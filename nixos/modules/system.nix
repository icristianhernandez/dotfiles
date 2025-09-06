{ config, pkgs, ... }:

let
  # Import global settings from our centralized config file.
  globals = import ../config/globals.nix;
in
{
  # Set time zone from globals.
  time.timeZone = globals.timeZone;

  # Select internationalisation properties from globals.
  i18n.defaultLocale = globals.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = globals.regionalLocale;
    LC_IDENTIFICATION = globals.regionalLocale;
    LC_MEASUREMENT = globals.regionalLocale;
    LC_MONETARY = globals.regionalLocale;
    LC_NAME = globals.regionalLocale;
    LC_NUMERIC = globals.regionalLocale;
    LC_PAPER = globals.regionalLocale;
    LC_TELEPHONE = globals.regionalLocale;
    LC_TIME = globals.regionalLocale;
  };

  # Set hostname from globals.
  networking.hostName = globals.hostname;

  # Enable networking.
  networking.networkmanager.enable = true;

  # Enable the Nix garbage collector.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Improve Nix performance.
  nix.settings.auto-optimise-store = true;

  # Enable Flakes and the new nix command.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable nix-ld for better binary compatibility, as requested.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing libraries for non-nix binaries here.
    # For example:
    # zlib
  ];

  # Install some essential system-wide packages.
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];

  # Allow installation of unfree packages.
  nixpkgs.config.allowUnfree = true;
}
