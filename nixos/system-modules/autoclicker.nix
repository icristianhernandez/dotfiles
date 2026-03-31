{
  guardRole,
  pkgs,
  ...
}:

guardRole "gaming" {
  # In plasma break the cursor aceleration or something when is applied, like if
  # overwrite the value
  services.input-remapper = {
    enable = true;
    package = pkgs.unstable.input-remapper;
  };
  environment.systemPackages = [
    pkgs.unstable.input-remapper
  ];
}
