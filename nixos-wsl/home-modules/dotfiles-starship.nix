{
  config,
  pkgs,
  lib,
  const,
  ...
}:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
