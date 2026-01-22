{ guardRole, ... }:

guardRole "interactive" {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          "AddKeysToAgent" = "yes";
          "HashKnownHosts" = "yes";
          "VerifyHostKeyDNS" = "yes";
          "ForwardAgent" = "no";
          "ForwardX11" = "no";
        };
      };
    };
  };
}
