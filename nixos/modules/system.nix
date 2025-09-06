{ config, pkgs, ... }:

let
  # Define the locale to be used for regional settings.
  # This avoids repeating the same string multiple times.
  regionalLocale = "nl_NL.UTF-8";
in
{
  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = regionalLocale;
    LC_IDENTIFICATION = regionalLocale;
    LC_MEASUREMENT = regionalLocale;
    LC_MONETARY = regionalLocale;
    LC_NAME = regionalLocale;
    LC_NUMERIC = regionalLocale;
    LC_PAPER = regionalLocale;
    LC_TELEPHONE = regionalLocale;
    LC_TIME = regionalLocale;
  };

  # Set your hostname.
  networking.hostName = "nixos";

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
