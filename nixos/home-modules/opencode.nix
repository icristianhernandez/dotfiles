{
  config,
  const,
  pkgs,
  guardRole,
  ...
}:

guardRole "dev" {
  xdg.configFile."opencode/opencode.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/opencode.json";
  };

  xdg.configFile."opencode/plugins" = {
    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/plugins/";
  };

  home.packages = with pkgs; [
    unstable.opencode
    libnotify
    libcanberra-gtk3
    sound-theme-freedesktop
  ];
}
