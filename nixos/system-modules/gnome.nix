{
  guardRole,
  pkgs,
  ...
}:

guardRole "gnome" {
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  networking.firewall = {
    # presumeed for wifi hotpost
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

  environment.systemPackages = with pkgs; [
    nautilus-python

    # select a file and press [Space] to preview without opening
    sushi

    # Thumbnails for everything (files)
    webp-pixbuf-loader
    gnome-epub-thumbnailer
    ffmpegthumbnailer

    # Archiving in Files
    file-roller
    p7zip

    # GStreamer codecs and plugins
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav # Critical: Uses FFmpeg for most common video formats
    gst_all_1.gst-vaapi # Hardware acceleration

    # camera tool
    snapshot
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    epiphany
    gnome-terminal
    geary
  ];

}
