{
  # pkgs,
  # lib,
  guardRole,
  ...
}:

guardRole "gnome" {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  # services = {
  #   displayManager.gdm = {
  #     enable = true;
  #     wayland = lib.mkDefault true;
  #   };
  #
  #   desktopManager.gnome = {
  #     enable = true;
  #     extraGSettingsOverrides = ''
  #       [org.gnome.mutter]
  #       experimental-features=['scale-monitor-framebuffer','xwayland-native-scaling']
  #
  #       [org.gnome.desktop.interface]
  #       scaling-factor=uint32 1
  #
  #       [org.gnome.desktop.peripherals.mouse]
  #       accel-profile='flat'
  #
  #       [org.gnome.desktop.peripherals.keyboard]
  #       delay=uint32 152
  #       repeat-interval=uint32 30
  #     '';
  #   };
  #
  #   power-profiles-daemon.enable = true;
  #   blueman.enable = true;
  # };
  #
  # hardware.bluetooth = {
  #   enable = lib.mkDefault true;
  #   powerOnBoot = lib.mkDefault true;
  # };
  #
  # environment.systemPackages = with pkgs; [
  #   gnome-tweaks
  #   gnome-shell-extensions
  #   gnomeExtensions.appindicator
  #   seahorse
  #   gnome-system-monitor
  #   gnome-disk-utility
  #   simple-scan
  #   file-roller
  #   gvfs
  # ];
}
