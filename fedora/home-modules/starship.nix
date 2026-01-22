{ guardRole, ... }:

guardRole "interactive" {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
