{
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  # Desktop applications
  home.packages = with pkgs; [
    kitty
    nautilus
  ];

  # Niri configuration
  xdg.configFile."niri/config.kdl".text = ''
    // Niri configuration for DankMaterialShell desktop

    // Environment variables
    environment {
      XDG_CURRENT_DESKTOP "niri"
      XDG_SESSION_TYPE "wayland"
      XDG_SESSION_DESKTOP "niri"
    }

    // DMS includes (provided by DankMaterialShell)
    // These files are managed by DMS and contain theming and keybindings
    // include "~/.config/niri/dms/colors.kdl"
    // include "~/.config/niri/dms/binds.kdl"

    // Input configuration
    input {
      keyboard {
        xkb {
          layout "us"
        }
      }

      touchpad {
        tap
        natural-scroll
      }
    }

    // Output configuration (adjust for your monitor setup)
    // output "eDP-1" {
    //   mode "1920x1080@60"
    //   scale 1.0
    // }

    // Default terminal
    spawn-at-startup "kitty"

    // Window rules
    window-rule {
      geometry-corner-radius 8
      clip-to-geometry true
    }
  '';
}
