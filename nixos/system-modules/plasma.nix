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
    tumbler.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-integration
    kdePackages.kde-gtk-config
    kdePackages.breeze-gtk
    kdePackages.sddm-kcm
    kdePackages.kcalc
    kdePackages.kclock
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.discover

    # Thumbnails for everything (files)
    webp-pixbuf-loader
    ffmpegthumbnailer

    # GStreamer codecs and plugins
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav # Critical: Uses FFmpeg for most common video formats
    gst_all_1.gst-vaapi # Hardware acceleration
  ];

  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa
    kdePackages.khelpcenter
    kdePackages.konversation
  ];
}
