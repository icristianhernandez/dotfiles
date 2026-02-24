{
  guardRole,
  pkgs,
  ...
}:

guardRole "gnome" {
  services.input-remapper = {
    enable = true;
    package = pkgs.unstable.input-remapper;
  };
  environment.systemPackages = [
    pkgs.unstable.input-remapper
  ];
}
