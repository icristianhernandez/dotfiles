{
  config,
  const,
  pkgs,
  guardRole,
  ...
}:

guardRole "dev" {
  xdg.configFile = {
    "opencode/opencode.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/opencode.json";
    };

    "opencode/plugins" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/plugins/";
    };

    "opencode/commands" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/commands/";
    };
  };

  home.packages = with pkgs; [
    unstable.opencode
    libnotify
    libcanberra-gtk3
    sound-theme-freedesktop

    # models tend to use it a lot, I'm testing it...
    github-cli
  ];
}
