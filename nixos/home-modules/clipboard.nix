{
  guardRole,
  ...
}:

guardRole "desktop" {
  # services.copyq = {
  #   enable = true;
  #   forceXWayland = true;
  # };

  services.wl-clip-persist.enable = true;
}
