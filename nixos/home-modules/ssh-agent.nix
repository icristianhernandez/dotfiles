_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          "AddKeysToAgent" = "ask";
          "HashKnownHosts" = "yes";
          "VerifyHostKeyDNS" = "yes";
          "ForwardAgent" = "no";
          "ForwardX11" = "no";
        };
      };
    };
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [
      "--quiet"
      "--timeout 180"
    ];
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
