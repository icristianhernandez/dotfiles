{ config, lib, pkgs, modulesPath, ... }:

{
  hardware.bluetooth.enable = true;

  fileSystems."/mnt/listorage" = {
    device = "/dev/disk/by-uuid/4cd837d0-63e5-494f-b33a-ff9143bc3713";
    fsType = "ext4";
    options = [ "defaults" "auto" "nofail" ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/listorage 0777 root root -"
  ];
}
