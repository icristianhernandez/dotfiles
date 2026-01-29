{
  guardRole,
  pkgs,
  config,
  ...
}:

guardRole "plasma" {
  # Templates directory (matching GNOME)
  home.file."Templates/Untitled Document".text = "";
  xdg.userDirs = {
    enable = true;
    templates = "${config.home.homeDirectory}/Templates";
    createDirectories = true;
  };

  programs.plasma = {
    enable = true;

    workspace = {
      # Click behavior (default open like traditional desktop)
      clickItemTo = "select";

      # Theme settings (matching GNOME Adwaita-dark preference)
      lookAndFeel = "org.kde.breezedark.desktop";

      # Cursor settings (matching GNOME cursor-size of 28, using similar cursor theme)
      cursor = {
        theme = "Simp1e-Adw-Dark";
        size = 28;
      };

      # Icon theme (matching Tela-circle-dark from theming module)
      iconTheme = "Tela-circle-dark";
    };

    fonts = {
      general = {
        family = "Noto Sans";
        pointSize = 10;
      };
      fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
      };
    };

    # Panel configuration (matching GNOME dash-to-panel at bottom)
    panels = [
      {
        location = "bottom";
        height = 32;
        hiding = "none";
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake";
            };
          }
          {
            iconTasks = {
              launchers = [ ];
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
            };
          }
          {
            digitalClock = {
              time.format = "12h";
              calendar.firstDayOfWeek = "sunday";
            };
          }
        ];
      }
    ];

    # Input settings (matching GNOME peripherals)
    input = {
      mice = {
        # Flat acceleration profile (matching GNOME accel-profile = "flat")
        accelerationProfile = "flat";
      };
      keyboard = {
        # Keyboard delay/repeat settings matching GNOME
        # GNOME: delay = 152, repeat-interval = 46
        repeatDelay = 152;
        repeatRate = 22; # ~1000/46 ≈ 22 chars/sec
      };
    };

    # Power management (matching GNOME lid-close-ac-action = "nothing")
    powerdevil = {
      AC = {
        whenLaptopLidClosed = "doNothing";
      };
      battery = {
        whenLaptopLidClosed = "doNothing";
      };
    };

    # KWin settings
    kwin = {
      # Disable hot corners (matching GNOME enable-hot-corners = false)
      edgeBarrier = 0;
      cornerBarrier = false;

      # Disable animations (matching GNOME enable-animations = false)
      effects.desktopSwitching.animation = "off";
    };

    # Screenshot shortcut (matching GNOME show-screenshot-ui = Shift+Super+s)
    shortcuts = {
      "org.kde.spectacle.desktop" = {
        "RectangularRegionScreenShot" = "Shift+Meta+S";
      };

      # Alt+Tab switches windows (matching GNOME switch-windows behavior)
      kwin = {
        "Walk Through Windows" = "Alt+Tab";
        "Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      };
    };

    # Window-related settings
    configFile = {
      # Show hidden files in file dialogs (matching GNOME show-hidden = true)
      kdeglobals.KFileDialog.ShowHidden = true;

      # Allow volume above 100% (matching GNOME allow-volume-above-100-percent)
      # This is handled by the plasma-pa applet settings
      "plasma-org.kde.plasma.desktop-appletsrc"."Containments/1/Applets/2/Configuration/General".volumeOverflow = true;

      # Battery percentage shown (matching GNOME show-battery-percentage)
      # Plasma shows battery percentage by default in the system tray

      # Disable overlay scrollbars (matching GNOME overlay-scrolling = false)
      kdeglobals.General.ScrollbarKDE = "default";
    };
  };

  # App indicator support (matching GNOME appindicator extension)
  # KDE has built-in system tray support for app indicators

  # For KDE apps, use Kitty as default terminal (matching GNOME terminal setting)
  # Note: This is set via plasma-manager's configFile to avoid conflicts
  programs.plasma.configFile.kdeglobals.General = {
    TerminalApplication = "kitty";
    TerminalService = "kitty.desktop";
  };
}
