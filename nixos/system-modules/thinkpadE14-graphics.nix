{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "thinkpadE14" {
  environment.systemPackages = with pkgs; [
    ffmpeg
  ];

  users.users.${const.user}.extraGroups = [
    "video"
    "render"
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        # the below is more stable, the above is for consistency
        # intel-vaapi-driver
      ];
    };
    enableRedistributableFirmware = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
  services.xserver.videoDrivers = [ "modesetting" ];

  ### changing to i915 drivers
  # boot.kernelParams = [
  #   "i915.enable_guc=3"
  #   "i915.enable_fbc=1"
  # ];

  ### changing to Xe drivers
  boot.initrd.kernelModules = [ "xe" ];
  boot.kernelParams = [
    "i915.enable_guc=3"
    "i915.enable_fbc=1"
    "i915.force_probe=!9a49"
    "xe.force_probe=9a49"
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0x9A49", ATTR{driver_override}="xe"
  '';
}
