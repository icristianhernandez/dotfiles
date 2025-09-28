{ config, pkgs, ... }:
{
  home.username = "cristianwslnixos";
  home.homeDirectory = "/home/cristianwslnixos";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [ ];
}
