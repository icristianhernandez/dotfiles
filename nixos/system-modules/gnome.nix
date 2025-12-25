{
  guardRole,
  pkgs,
  ...
}:

guardRole "gnome" {
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    file-roller
    p7zip
  ];
}
