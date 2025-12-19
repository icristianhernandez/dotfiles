{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "desktop" {
  # Desktop session prerequisites
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;

  # Audio (PipeWire)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
  };

  # Networking
  networking.networkmanager.enable = true;

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # Graphics (OpenGL/Mesa for Intel iGPU)
  hardware.graphics.enable = true;

  # Niri compositor
  programs.niri.enable = true;

  # DankMaterialShell
  programs.dms-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableDynamicTheming = true;
  };

  # DMS Greeter
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = const.homeDir;
    configFiles = [ "${const.homeDir}/.config/DankMaterialShell/settings.json" ];
  };
}
