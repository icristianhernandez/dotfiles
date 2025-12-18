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

  # Desktop target assumes Intel CPU/iGPU.
  hardware.cpu.intel.updateMicrocode = true;
}
