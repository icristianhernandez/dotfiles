{
  inputs,
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    niri = {
      enableKeybinds = true;
      enableSpawn = true;
    };
  };

  programs.niri.enable = true;

  home.packages = with pkgs; [
    kitty
    nautilus
  ];
}
