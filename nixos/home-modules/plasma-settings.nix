{
  guardRole,
  lib,
  pkgs,
  config,
  ...
}:

guardRole "plasma" {
  home.packages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.breeze
    kdePackages.kde-gtk-config
  ];

  home.file."Templates/Untitled Document".text = "";
  xdg.userDirs = {
    enable = true;
    templates = "${config.home.homeDirectory}/Templates";
    createDirectories = true;
  };

  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "select";
    };

    panels = [
      {
        location = "bottom";
        widgets = [
          {
            kickoff = {
              icon = "preferences-system";
              sortAlphabetically = true;
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:kitty.desktop"
                "applications:google-chrome.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
              configs = {
                battery.showPercentage = true;
              };
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

    configFile = {
      kdeglobals = {
        KDE = {
          AnimationDurationFactor = 0.0;
          SingleClick = false;
          widgetStyle = "Breeze";
        };
        General = {
          TerminalApplication = "kitty";
          XftAntialias = true;
          XftHintStyle = "hintslight";
          XftSubPixel = "rgb";
        };
      };

      kcminputrc = {
        Keyboard = {
          KeyRepeat = "repeat";
          RepeatDelay = 152;
          RepeatRate = 46;
        };
        Mouse = {
          X11LibInputXAccelProfileFlat = true;
          cursorSize = 34;
        };
      };

      dolphinrc = {
        General = {
          ShowFullPath = true;
          ViewPropsTimestamp = 1;
        };
      };
    };
  };
}
