{ pkgs, const, ... }:
{
  home = {
    username = const.user;
    homeDirectory = const.home_dir;
    stateVersion = const.home_state;
    packages = with pkgs; [ ];
  };
}
