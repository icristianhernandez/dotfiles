{ lib, ... }:

{
  imports = (import ./lib/import-modules.nix {
    inherit lib;
    dir = ./home-modules;
  });

  # Set the state version
  home.stateVersion = "23.11";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Backup file extension
  home.backupFileExtension = "backup";

  # Enable dconf for GNOME settings
  programs.dconf.enable = true;
}
