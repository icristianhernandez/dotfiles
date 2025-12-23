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
    chromium
    firefox
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "ntfs" ];
  };
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/EC68C95668C92066";
    fsType = "ntfs3";
    options = [
      "nofail"
      "rw"
      "uid=1000"
    ];
  };

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

    xserver = {
      enable = true;

      xkb = {
        layout = "latam";
        variant = "";
      };
    };

    printing.enable = true;
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  environment.pathsToLink = lib.mkAfter [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware.graphics.enable = true;

  networking.networkmanager.enable = true;
}
