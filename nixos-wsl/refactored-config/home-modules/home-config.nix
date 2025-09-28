{ config, pkgs, const, ... }:
{
  home.username = const.user;
  home.homeDirectory = const.home_dir;
  home.stateVersion = const.home_state;
  home.packages = with pkgs; [ ];
}
