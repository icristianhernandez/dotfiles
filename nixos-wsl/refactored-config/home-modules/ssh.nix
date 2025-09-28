{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
    '';
    matchBlocks = {
      "*" = {};
    };
  };
}
