{
  pkgs,
  guardRole,
  ...
}:

guardRole "dms" {
  programs = {
    niri.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    configPackages = with pkgs; [ xdg-desktop-portal-wlr ];
  };

  systemd.user.services.niri-flake-polkit.enable = false;
}
