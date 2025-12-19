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

  hardware.graphics.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
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

  programs.niri.enable = true;

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = const.homeDir;
  };

  services.greetd.enable = true;
  services.greetd.settings.default_session.user = const.user;
}
