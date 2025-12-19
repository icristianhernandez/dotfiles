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

    // Default terminal
    spawn-at-startup "kitty"

    // Window rules
    window-rule {
      geometry-corner-radius 8
      clip-to-geometry true
    }
  '';
}
