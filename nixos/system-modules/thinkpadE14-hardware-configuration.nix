{
  config,
  lib,
  modulesPath,
  guardRole,
  ...
}:

guardRole "thinkpadE14" {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  zramSwap.enable = false;

  systemd.tmpfiles.rules = [
    "d /mnt/storage 0755 cristian users -"
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "lz4_compress"
      "lz4"
    ];
    kernelParams = [
      "mem_sleep_default=s2idle"
      "nvme.noacpi=1"
      # "pcie_aspm=force"

      # zswap related config
      "zswap.enabled=1"
      ## for some reason, lz4 is not detected in boot so the other compressor is
      ## used, need to be fixed
      "zswap.compressor=lz4"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=20"
      "zswap.shrinker_enabled=1"
      "transparent_hugepage=madvise"

      # "tpm_tis.interrupts=0"
      # "tpm.disable=1"
      # "i915.enable_dc=1"
      # "i915.enable_psr=1"
      # "pm_async=0"
      # "pci=noaer"
      # "modprobe.blacklist=ucsi_acpi,intel_vbtn,thunderbolt,tpm,tpm_tis,tpm_crb,tpm_tis_core"
    ];
    kernelModules = [
      "kvm-intel"
    ];
    extraModulePackages = [ ];

    # zswap related config
    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.page-cluster" = 0;
      "vm.watermark_boost_factor" = 0;
      "vm.min_free_kbytes" = 65536;
    };

  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a0888c81-f4ae-4adf-861b-505933919cd3";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/19F1-B8A6";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/mnt/storage" = {
      device = "/dev/disk/by-uuid/148a5427-36f4-4947-951b-3b23dfbcd974";
      fsType = "ext4";
      options = [
        "nofail"
        "defaults"
        "noatime"
        "acl"
      ];
    };
  };

  boot.resumeDevice = "/dev/disk/by-uuid/2853ed37-6fdb-4bd7-bd2e-840b7775ee15";
  swapDevices = [ { device = "/dev/disk/by-uuid/2853ed37-6fdb-4bd7-bd2e-840b7775ee15"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
