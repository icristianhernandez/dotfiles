{
  config,
  const,
  pkgs,
  guardRole,
  ...
}:

guardRole "dev" {
  home.file = {
    ".pi/agent/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/pi/settings.json";
      force = true;
    };
    ".pi/agent/keybindings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/pi/keybindings.json";
      force = true;
    };
    ".pi/agent/SYSTEM.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/pi/SYSTEM.md";
      force = true;
    };
    ".pi/agent/extensions" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/pi/extensions/";
      force = true;
    };
  };

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "pi" ''
      exec ${unstable.pi-coding-agent}/bin/pi \
        --system-prompt "$(cat ${const.dotfilesDir}/pi/SYSTEM.md)" \
        "$@"
    '')
    libnotify
    libcanberra-gtk3
    sound-theme-freedesktop
  ];
}
