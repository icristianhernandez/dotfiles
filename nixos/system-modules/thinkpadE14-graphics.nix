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

  users.groups.video.members = [ const.user ];
  users.groups.render.members = [ const.user ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];

    };
    enableRedistributableFirmware = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  boot.kernelParams = [ "i915.enable_guc=3" ];

  services.xserver.videoDrivers = [ "modesetting" ];
}
