# This is the primary, standalone Home Manager configuration for a user.
# It can be deployed to any system, not just this specific NixOS machine.
{ pkgs, ... }:

let
  # Import the data from our centralized config files.
  globals = import ../config/globals.nix;
  dotfiles = import ../config/dotfiles.nix;

  # Define categorized packages for better organization and readability.
  packages = {
    cli = with pkgs; [ htop neofetch eza ripgrep fd ];
    gui = with pkgs; [ ]; # Placeholder for future GUI apps
    dev = with pkgs; [ neovim fish starship ];
  };
in
{
  # Home Manager needs a state version.
  home.stateVersion = "23.11";
  home.username = globals.username;
  home.homeDirectory = "/home/${globals.username}";

  # Install all packages by flattening the categorized attribute set.
  home.packages = pkgs.lib.flatten (pkgs.lib.attrValues packages);

  # Link dotfiles using the imported data from dotfiles.nix.
  home.file =
    (pkgs.lib.mapAttrs (target: source: { inherit source; recursive = true; }) dotfiles.recursive) //
    (pkgs.lib.mapAttrs (target: source: { inherit source; }) dotfiles.single);

  # Enable and configure programs.
  programs.git.enable = true;
  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.home-manager.enable = true; # Let Home Manager manage itself.

  # Set KDE animations to be instant.
  kdeglobals = {
    "KDE" = {
      "AnimationDurationFactor" = 0;
    };
  };
}
