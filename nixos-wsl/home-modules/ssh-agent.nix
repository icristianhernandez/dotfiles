_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
    '';
    matchBlocks = {
      "*" = { };
    };
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [ "--quiet" ];
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
