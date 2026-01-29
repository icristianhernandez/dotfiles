{
  guardRole,
  pkgs,
  ...
}:

guardRole "plasma" {
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  networking.firewall = {
    # presumed for wifi hotspot (matching GNOME config)
    allowedTCPPorts = [
      53
      80
      443
    ];
    allowedUDPPorts = [
      53
      67
      68
    ];
  };

  environment.systemPackages = with pkgs.kdePackages; [
    # File management extras
    dolphin-plugins
    kio-extras
    kio-fuse

    # Archive support (matching GNOME file-roller functionality)
    ark
    pkgs.p7zip

    # File previews (matching GNOME thumbnails)
    ffmpegthumbs
    kdegraphics-thumbnailers
    taglib # Audio file metadata

    # GStreamer codecs and plugins (matching GNOME)
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad
    pkgs.gst_all_1.gst-plugins-ugly
    pkgs.gst_all_1.gst-libav
    pkgs.gst_all_1.gst-vaapi

    # Camera tool (equivalent to GNOME snapshot)
    kamoso
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # Exclude packages similar to GNOME exclusions
    plasma-browser-integration
    konsole # Using kitty instead
    elisa # Not needed
  ];
}
