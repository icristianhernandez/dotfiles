{
  pkgs,
  lib,
  guardRole,
  ...
}:

guardRole "desktop" {
  environment.systemPackages = with pkgs; [
    kitty
  ];

  # Required when Home Manager is used as a NixOS module
  # and `home-manager.useUserPackages = true`.
  environment.pathsToLink = lib.mkAfter [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  services = {
    dbus.enable = true;
    accounts-daemon.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware.graphics.enable = true;

  networking.networkmanager.enable = true;
}
