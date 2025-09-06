{ config, pkgs, username, ... }:

{
  # This enables the Home Manager module for the user defined in configuration.nix.
  home-manager.users.${username} = {
    # Home Manager needs a state version.
    # It's recommended to start with the same version as your NixOS installation.
    home.stateVersion = "23.11";

    home.username = username;
    home.homeDirectory = "/home/${username}";

    # Packages to install in the user's profile.
    home.packages = with pkgs; [
      # CLI tools
      htop
      neofetch
      eza      # A modern replacement for 'ls'
      ripgrep  # A modern replacement for 'grep'
      fd       # A modern replacement for 'find'

      # Your existing dotfiles expect these to be installed.
      neovim
      fish
      starship
    ];

    # This is the core of linking your existing dotfiles.
    # The paths are relative to this home.nix file.
    home.file = let
      # Directories to be linked recursively.
      recursiveDotfiles = {
        ".config/nvim" = ../../nvim/.config/nvim;
        ".config/fish" = ../../fish/.config/fish;
      };
      # Single files to be linked.
      singleDotfiles = {
        ".config/starship.toml" = ../../starship/.config/starship.toml;
      };
    in
      (pkgs.lib.mapAttrs (target: source: { inherit source; recursive = true; }) recursiveDotfiles) //
      (pkgs.lib.mapAttrs (target: source: { inherit source; }) singleDotfiles);

    # Enable and configure programs using Home Manager options.
    programs.git.enable = true;

    programs.fish = {
      enable = true;
      # You could add fish plugins here, for example:
      # plugins = [
      #   { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      # ];
    };

    programs.starship.enable = true;
    # Starship is configured by the TOML file we linked above.

    # Set KDE animations to be instant.
    kdeglobals = {
      "KDE" = {
        "AnimationDurationFactor" = 0;
      };
    };

    # Placeholder for declarative KDE Plasma configuration.
    # This shows how you could manage DE settings in the future.
    # For example, to set the look and feel package:
    # kdeglobals = {
    #   "KDE" = {
    #     "LookAndFeelPackage" = "org.kde.breezedark.desktop";
    #   };
    # };
  };

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;
}
