{
  lib,
  hostName,
  ...
}:

lib.mkIf (hostName == "desktop") {
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware.cpu.intel.updateMicrocode = true;
}
