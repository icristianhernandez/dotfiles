{
  guardRole,
  pkgs,
  ...
}:

guardRole "gnome" {
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
  };

  environment.systemPackages = with pkgs; [
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
  ];
}
