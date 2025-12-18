{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "desktop" {
  services = {
    dbus.enable = true;
    accounts-daemon.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  security.polkit.enable = true;

  networking.networkmanager.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [ niri ];

  programs.niri.enable = true;

  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
    systemd.restartIfChanged = true;
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableDynamicTheming = true;
  };

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = const.homeDir;
    configFiles = [
      "${const.homeDir}/.config/DankMaterialShell/settings.json"
    ];
  };
}
