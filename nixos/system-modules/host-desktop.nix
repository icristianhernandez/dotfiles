{
  lib,
  hostName,
  ...
}:

lib.mkIf (hostName == "desktop") {
  # Bootloader configuration (systemd-boot for UEFI)
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Placeholder filesystem configuration
  # This should be replaced with actual hardware-configuration.nix values
  # when deploying to real hardware
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
}
