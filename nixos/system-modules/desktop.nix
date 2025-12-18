{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "desktop" {
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

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

  programs.dms-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
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
