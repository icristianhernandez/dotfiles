{
  guardRole,
  ...
}:

guardRole "plasma" {
  home.file.".local/share/applications/vicinae-launcher.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Vicinae Launcher
      Exec=vicinae toggle
      Terminal=false
      Type=Application
      Categories=Utility;
      Icon=application-launcher
    '';
  };

  home.file.".local/share/applications/copyq-toggle.desktop" = {
    text = ''
      [Desktop Entry]
      Name=CopyQ Toggle
      Exec=copyq toggle
      Terminal=false
      Type=Application
      Categories=Utility;
      Icon=copyq
    '';
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    configFile = {
      "kglobalshortcutsrc" = {
        "vicinae-launcher.desktop" = {
          "_k_friendly_name" = "Vicinae Launcher";
          "_launch" = "Meta\tMeta,Meta,Launch Vicinae";
        };
        "copyq-toggle.desktop" = {
          "_k_friendly_name" = "CopyQ Toggle";
          "_launch" = "Ctrl+Ñ\tCtrl+Ñ,Ctrl+Ñ,Toggle CopyQ";
        };
        "plasmashell.desktop"."_launch" = "none\tMeta,Meta,Show Application Launcher";
      };
      dolphinrc = {
        General.ViewPropsTimestamp = "2026,2,14,14,13,49.493";
        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = false;
          "Places Icons Static Size" = 22;
        };
      };

      kcminputrc = {
        Keyboard = {
          RepeatDelay = 152;
          RepeatRate = 21.74;
        };
        "Libinput/1133/16500/Logitech G305" = {
          PointerAccelerationProfile = 1;
        };
        "Libinput/1267/13/Elan Touchpad" = {
          PointerAcceleration = 0.600;
        };
        "Libinput/12815/20480/Evision RGB Keyboard" = {
          ScrollFactor = 2;
        };
        Mouse.cursorTheme = "Simp1e-Dark";
      };

      kdeglobals = {
        General = {
          UseSystemBell = true;
          Scale = 1.5;
        };
        KDE = {
          AnimationDurationFactor = 0;
          SmoothScroll = false;
        };
        "KFileDialog Settings" = {
          "Allow Expansion" = false;
          "Automatically select filename extension" = true;
          "Breadcrumb Navigation" = true;
          "Decoration position" = 2;
          "Show Full Path" = false;
          "Show Inline Previews" = true;
          "Show Preview" = false;
          "Show Speedbar" = true;
          "Show hidden files" = false;
          "Sort by" = "Name";
          "Sort directories first" = true;
          "Sort hidden files last" = false;
          "Sort reversed" = false;
          "Speedbar Width" = 140;
          "View Style" = "Simple";
        };
      };

      kwinrc = {
        Effect-overview.BorderActivate = 9;
        Plugins.shakecursorEnabled = false;
        Wayland.EnablePrimarySelection = false;
        Xwayland.Scale = 2;
      };

      plasmaparc = {
        General.RaiseMaximumVolume = true;
        General.VolumeStep = 3;
      };

      plasmarc.Wallpapers.usersWallpapers = "/mnt/storage/wallpapers/wallhaven-5yl7x5_1920x1080.png";

      systemsettingsrc."KFileDialog Settings" = {
        detailViewIconSize = 32;
        iconViewIconSize = 256;
      };
    };
  };
}
