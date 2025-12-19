{
  pkgs,
  const,
  guardRole,
  ...
}:

guardRole "desktop" {
  # Prerequisites for desktop environment
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  hardware.graphics.enable = true;

  # Audio via PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Network management
  networking.networkmanager.enable = true;

  # XDG Desktop Portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  # Niri compositor (system-wide so greeter can find it)
  programs.niri.enable = true;

  # DankGreeter (login manager)
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = const.homeDir;
    configFiles = [ "${const.homeDir}/.config/DankMaterialShell/settings.json" ];
  };
}
