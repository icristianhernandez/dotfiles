{
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  programs.mpv = {
    enable = true;
    scripts = [
      pkgs.mpvScripts.mpris # Allows media keys (Play/Pause) to work
      pkgs.mpvScripts.uosc # Adds a beautiful minimalist UI on top
      pkgs.mpvScripts.thumbfast # Adds hover-thumbnails to the seekbar
    ];
    config = {
      # High-quality video settings
      profile = "gpu-hq";
      vo = "gpu";
      hwdec = "auto-safe";
      gpu-context = "wayland";

      # UI preferences
      border = "no"; # Hide window title bar (UOSC handles this)
      osd-bar = "no"; # Hide the default ugly text bar
    };
  };
}
