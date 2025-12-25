{
  pkgs,
  guardRole,
  ...
}:

guardRole "gnome" {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-panel
    gnomeExtensions.vicinae
    gnomeExtensions.super-key
  ];
}
