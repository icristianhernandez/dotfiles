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
  };
  environment.systemPackages = [
    pkgs.input-remapper
  ];
}
