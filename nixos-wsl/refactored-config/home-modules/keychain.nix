{ config, ... }:
{
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [ "--quiet" ];
    enableBashIntegration = true;
    # enableFishIntegration = true;
  };
}
