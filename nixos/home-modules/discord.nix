{
  guardRole,
  ...
}:

guardRole "desktop" {
  home.file.".local/share/applications/discord-wayland.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Discord (Wayland)
      Exec=env GDK_BACKEND=wayland ELECTRON_ENABLE_WAYLAND=1 /run/current-system/sw/bin/Discord --enable-features=UseOzonePlatform --ozone-platform=wayland %U
      Terminal=false
      Type=Application
      Icon=discord
      Categories=Network;InstantMessaging;
      StartupWMClass=discord
    '';
  };
}
