{
  pkgs,
  lib,
  guardRole,
  ...
}:

guardRole "desktop" {
  environment.systemPackages = with pkgs; [
    kitty
    nautilus
    google-chrome
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/EC68C95668C92066";
    fsType = "ntfs3";
    options = [
      "nofail"
      "rw"
      "uid=1000"
    ];
  };

  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
