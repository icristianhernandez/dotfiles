{
  guardRole,
  ...
}:

guardRole "desktop" {
  programs.vicinae = {
    enable = true;
    useLayerShell = true;
    systemd = {
      enable = true;
      autoStart = true;
      target = "graphical-session.target";
    };

    settings = {
      file_search = {
        search_locations = [ "/mnt/storage" ];
      };
    };
  };

  home.file.".local/share/applications/darkman-toggle.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Toggle Dark Mode
      Exec=darkman toggle
      Terminal=false
      Type=Application
      Categories=Utility;
      Icon=preferences-desktop-theme
    '';
  };
}
