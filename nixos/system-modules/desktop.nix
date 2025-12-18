{
  pkgs,
  guardRole,
  const,
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

  # XDG portals for Wayland apps
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Graphics (Intel iGPU)
  hardware.graphics.enable = true;

  # niri compositor (installed system-wide for greeter visibility)
  programs.niri.enable = true;

  # DankMaterialShell (DMS) via nixpkgs module
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

  # DMS Greeter (DankGreeter) as login manager
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = const.homeDir;
    configFiles = [ "${const.homeDir}/.config/DankMaterialShell/settings.json" ];
  };
}
