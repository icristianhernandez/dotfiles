{
  lib,
  hostName,
  ...
}:

lib.mkIf (hostName == "desktop") {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.cpu.intel.updateMicrocode = true;
}
