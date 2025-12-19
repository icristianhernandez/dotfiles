{
  pkgs,
  inputs,
  guardRole,
  ...
}:

guardRole "desktop" {
  # Import the DMS Home Manager module from the flake input
  imports = [ inputs.dms.homeManagerModules.default ];

  # Enable and configure DankMaterialShell
  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableDynamicTheming = true;
  };

  # User applications for desktop
  home.packages = with pkgs; [
    kitty
    nautilus
  ];

  # Niri user configuration
  xdg.configFile."niri/config.kdl".text = ''
    // Niri configuration for desktop
    // DMS integration is handled by the dms-shell module
    
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
    
    output "eDP-1" {
      scale 1.0
    }
    
    layout {
      gaps 8
      
      default-column-width { proportion 0.5; }
      
      preset-column-widths {
        proportion 0.33333;
        proportion 0.5;
        proportion 0.66667;
      }
    }
    
    spawn-at-startup "dms-shell"
    
    binds {
      Mod+Return { spawn "kitty"; }
      Mod+E { spawn "nautilus"; }
      Mod+Q { close-window; }
      Mod+Shift+E { quit; }
      
      Mod+Left { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up { focus-window-up; }
      Mod+Down { focus-window-down; }
      
      Mod+Shift+Left { move-column-left; }
      Mod+Shift+Right { move-column-right; }
      
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      
      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
    }
  '';
}
