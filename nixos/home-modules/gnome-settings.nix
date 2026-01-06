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
  ];

  xdg.dataFile."nautilus-python/extensions/backspace-back.py".text = ''
    import gi
    gi.require_version('Gtk', '4.0')
    from gi.repository import GObject, Nautilus, Gtk, GLib

    class BackspaceBack(GObject.GObject, Nautilus.MenuProvider):
        def __init__(self):
            super().__init__()
            self.app = Gtk.Application.get_default()
            
            # Attempt to set accelerator immediately if app is ready
            if self.app:
                self.setup_accels(self.app)
            else:
                # Retry after 100ms if Gtk Application isn't fully ready
                GLib.timeout_add(100, self.wait_for_app)

        def wait_for_app(self):
            self.app = Gtk.Application.get_default()
            if self.app:
                self.setup_accels(self.app)
                return False # Stop timeout
            return True # Run again

        def setup_accels(self, app):
            action_name = "slot.back" # GNOME 47+ action name
            
            # Bind BackSpace to the action
            app.set_accels_for_action(action_name, ["BackSpace"])
            
            # Ensure it persists when new windows are created
            app.connect('window-added', lambda a, w: app.set_accels_for_action(action_name, ["BackSpace"]))
            
            print(">>> Backspace Extension: Accelerator set successfully <<<")

        # Required MenuProvider methods (returning empty lists prevents errors)
        def get_file_items(self, *args):
            return []
            
        def get_background_items(self, *args):
            return []
  '';

  # Ensure sensors support is available for Vitals
  # system packages and services added in system module

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions; [
        dash-to-panel.extensionUuid
        vicinae.extensionUuid
        super-key.extensionUuid
        appindicator.extensionUuid
      ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      lid-close-ac-action = "nothing";
      lid-close-battery-action = "nothing";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 152;

      repeat-interval = lib.hm.gvariant.mkUint32 46;
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
    };

    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
      exec-arg = "-e";
    };

    "org/gnome/desktop/interface" = {
      show-battery-percentage = lib.hm.gvariant.mkBoolean true;
      clock-format = "12h";
      enable-hot-corners = lib.hm.gvariant.mkBoolean false;
      enable-animations = lib.hm.gvariant.mkBoolean false;
      cursor-size = lib.hm.gvariant.mkInt32 28;
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

    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Shift><Super>s" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      switch-windows = "current";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    # Dash to Panel: bottom panel showing running apps

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
      group-apps-label-max-width = lib.hm.gvariant.mkInt32 80;
    };

    "org/gnome/shell/extensions/super-key" = {
      overlay-key-action = "vicinae toggle";
    };

    # doesn't do anything, need fix.
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = lib.hm.gvariant.mkBoolean true;
    };

    # Nautilus default sorting: newest modified first
    "org/gnome/nautilus/preferences" = {
      default-sort-order = "mtime";
      default-sort-in-reverse-order = lib.hm.gvariant.mkBoolean true;
    };
  };
}
