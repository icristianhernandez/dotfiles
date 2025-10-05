{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    package = pkgs.fish;

    functions = {
      clearnvim = {
        description = "Remove Neovim cache/state/data";
        body = ''
          rm -rf ~/.local/share/nvim
          rm -rf ~/.local/state/nvim
          rm -rf ~/.cache/nvim
        '';
      };

    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };
}
