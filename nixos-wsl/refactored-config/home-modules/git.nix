{ config, ... }:
{
  programs.git = {
    enable = true;
    userName = "cristian";
    userEmail = "cristianhernandez9007@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
