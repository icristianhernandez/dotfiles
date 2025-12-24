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

  # services = {
  #   power-profiles-daemon.enable = true;
  #   blueman.enable = true;
  # };
  #
  # hardware.bluetooth = {
  #   enable = lib.mkDefault true;
  #   powerOnBoot = lib.mkDefault true;
  # };
  #
  # environment.systemPackages = with pkgs; [
  #   gnome-tweaks
  #   gnome-shell-extensions
  #   gnomeExtensions.appindicator
  #   seahorse
  #   gnome-system-monitor
  #   gnome-disk-utility
  #   simple-scan
  #   file-roller
  #   gvfs
  # ];
}
