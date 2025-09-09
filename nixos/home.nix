{ config, pkgs, ... }:

{
    home.username = "cristianh";
    home.homeDirectory = "/home/cristianh";
    home.stateVersion = "25.05";

    programs.bash = {
      enable = true;
      shellAliases = {
        btw = "sexo";
      };
    };
}
