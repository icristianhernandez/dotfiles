{
  pkgs,
  lib,
  guardRole,
  ...
}:

guardRole "desktop" {
  home = {
    packages = with pkgs; [
      kitty
      nautilus
    ];

    sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      QT_QPA_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
    };
  };

  xdg.configFile."niri/config.kdl".text = ''
    layer-rules {
      rule {
        match {
          app-id "quickshell"
        }
        z-index -1
      }
    }

    include "dms/colors.kdl"
    include "dms/layout.kdl"
    include "dms/alttab.kdl"
    include "dms/binds.kdl"
  '';

  systemd.user.services.dms.wantedBy = lib.mkAfter [ "niri.service" ];
}
