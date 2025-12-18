{
  pkgs,
  hostName,
  lib,
  ...
}:

lib.mkIf (hostName == "desktop") {
  # Bootloader (systemd-boot for UEFI systems)
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Intel microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # Basic filesystem mounts (placeholder - adjust on real machine)
  # These should be regenerated with `nixos-generate-config` on the target machine
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Swap (optional - adjust as needed)
  swapDevices = [ ];
}
