{
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  home.packages = with pkgs; [
    kitty
    nautilus
  ];

  # DMS generates the included snippets under ~/.config/dms.
  xdg.configFile."niri/config.kdl".text = ''
    env {
      XDG_CURRENT_DESKTOP "niri"
      QT_QPA_PLATFORM "wayland"
      ELECTRON_OZONE_PLATFORM_HINT "auto"
      QT_QPA_PLATFORMTHEME "gtk3"
      QT_QPA_PLATFORMTHEME_QT6 "gtk3"
    }

    include "dms/colors.kdl"
    include "dms/layout.kdl"
    include "dms/alttab.kdl"
    include "dms/binds.kdl"

    layer-rule {
      match {
        app-id "dms-quickshell"
        title "Backdrop"
      }
      below true
    }
  '';

  systemd.user.services.dms = {
    Unit.PartOf = [ "niri.service" ];
    Install.WantedBy = [ "niri.service" ];
  };
}
