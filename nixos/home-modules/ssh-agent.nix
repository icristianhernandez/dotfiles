_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          "AddKeysToAgent" = "ask";
        };
      };
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
