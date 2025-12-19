{ lib, hostName, ... }:

lib.mkIf (hostName == "desktop") {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = lib.mkDefault [ ];
}
