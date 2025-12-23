{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "dms" {
  programs = {
    niri.enable = true;
    dms-shell.enable = true;
  };

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";

    configHome = const.homeDir;
    configFiles = [
      "${const.homeDir}/.config/DankMaterialShell/settings.json"
    ];

  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    configPackages = with pkgs; [ xdg-desktop-portal-wlr ];
  };

  systemd.user.services.niri-flake-polkit.enable = false;
}
