{ guardRole, ... }:

guardRole "interactive" {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      addKeysToAgent = "yes";
      hashKnownHosts = true;
      forwardAgent = false;
      forwardX11 = false;
      VerifyHostKeyDNS = "yes";
    };
  };
}
