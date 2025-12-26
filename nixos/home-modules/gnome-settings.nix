{
  guardRole,
  lib,
  pkgs,
  ...
}:

guardRole "gnome" {
  home.packages = with pkgs; [
    gnomeExtensions.dash-to-panel
    gnomeExtensions.vicinae
    gnomeExtensions.super-key
    gnomeExtensions.gsconnect
    gnomeExtensions.blur-my-shell
  ];

  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 152;

      repeat-interval = lib.hm.gvariant.mkUint32 40;
    };

    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ ];
      screenshot = [ "<Alt><Super>s" ];
    };

    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
      exec-arg = "-e";
    };

    "org/gnome/desktop/interface" = {
      show-battery-percentage = lib.hm.gvariant.mkBoolean true;
      enable-hot-corners = lib.hm.gvariant.mkBoolean false;
      enable-animations = lib.hm.gvariant.mkBoolean false;
      cursor-size = lib.hm.gvariant.mkInt32 32;
      overlay-scrolling = lib.hm.gvariant.mkBoolean false;
    };

    "org/gtk/settings/file-chooser" = {
      show-hidden = lib.hm.gvariant.mkBoolean true;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = lib.hm.gvariant.mkBoolean true;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = lib.hm.gvariant.mkBoolean true;
    };

    "org/gnome/desktop/privacy" = {
      remove-old-temp-files = lib.hm.gvariant.mkBoolean true;
    };

    # Alt+Tab switches between windows (not just apps)
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      switch-windows = "current";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    # Dash to Panel: bottom panel showing running apps
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-panel@jderose9.github.com"
        "vicinae@dagimg-dot"
        "super-key@tommimon.github.com"
        "gsconnect@andyholmes.github.io"
        "blur-my-shell@aunetx"
      ];
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      panel-position = "BOTTOM";
      show-running-apps = true;
      taskbar-style = "WINDOWS";
      panel-anchors = "{}";
      panel-sizes = "{\"0\":32}";
      show-window-previews = true;
      isolate-workspaces = true;
      hide-overview-on-startup = true;
      group-apps = false;
    };

    "org/gnome/shell/extensions/super-key" = {
      overlay-key-action = "vicinae toggle";
    };

    # doesn't do anything, need fix.
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = lib.hm.gvariant.mkBoolean true;
    };

    # GSConnect placeholder for future device config
    "org/gnome/shell/extensions/gsconnect" = { };

    # Nautilus default sorting: newest modified first
    "org/gnome/nautilus/preferences" = {
      default-sort-order = "mtime";
      default-sort-in-reverse-order = lib.hm.gvariant.mkBoolean true;
    };
  };
}
