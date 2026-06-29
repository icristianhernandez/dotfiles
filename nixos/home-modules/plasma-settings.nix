{
  guardRole,
  pkgs,
  ...
}:

guardRole "plasma" {
  home = {
    packages = with pkgs; [
      gcr
      kdePackages.kwalletmanager
    ];

    file = {
      ".local/share/applications/vicinae-launcher.desktop" = {
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
    };
  };
  programs.plasma = {
    enable = true;

    configFile = {
      "kglobalshortcutsrc" = {
        "vicinae-launcher.desktop" = {
          "_k_friendly_name" = "Vicinae Launcher";
          "_launch" = "Meta\tMeta,Meta,Launch Vicinae";
        };
        "plasmashell" = {
          "show-on-mouse-pos" = "Ctrl+Ñ,Ctrl+Ñ";
        };
        "plasmashell.desktop"."_launch" = "none\tMeta,Meta,Show Application Launcher";
      };
      "plasma-org.kde.plasma.desktop-appletsrc" = {
        "Containments][2][Applets][7][General" = {
          extraItems = "org.kde.plasma.cameraindicator,org.kde.plasma.manage-inputmethod,org.kde.plasma.keyboardlayout,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.devicenotifier,org.kde.kscreen,org.kde.plasma.networkmanagement,org.kde.plasma.printmanager,org.kde.plasma.volume,org.kde.plasma.keyboardindicator,org.kde.plasma.brightness,org.kde.plasma.battery,org.kde.plasma.weather";
          knownItems = "org.kde.plasma.cameraindicator,org.kde.plasma.manage-inputmethod,org.kde.plasma.keyboardlayout,org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.devicenotifier,org.kde.kscreen,org.kde.plasma.networkmanagement,org.kde.plasma.printmanager,org.kde.plasma.volume,org.kde.plasma.keyboardindicator,org.kde.plasma.brightness,org.kde.plasma.battery,org.kde.plasma.weather";
        };
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
      };

      kdeglobals = {
        General = {
          UseSystemBell = true;
          fixed = "JetBrainsMono Nerd Font,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
          font = "Inter,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
          menuFont = "Inter,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
          smallestReadableFont = "Inter,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
          toolBarFont = "Inter,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
        };
        KDE = {
          AnimationDurationFactor = 0;
          SmoothScroll = false;
          AutomaticLookAndFeel = true;
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
      };

      plasmaparc = {
        General.RaiseMaximumVolume = true;
        General.VolumeStep = 3;
      };

      kwalletrc = {
        "KSecretD" = {
          Enabled = false;
        };
      };

      systemsettingsrc."KFileDialog Settings" = {
        detailViewIconSize = 32;
        iconViewIconSize = 256;
      };
    };
  };
}
