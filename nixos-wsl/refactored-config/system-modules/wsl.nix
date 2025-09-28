{ config, pkgs, const, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = const.user;
}
