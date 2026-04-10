{
  guardRole,
  pkgs,
  ...
}:

guardRole "gaming" {
  warnings = pkgs.lib.optional (pkgs.lib.versionAtLeast pkgs.input-remapper.version "2.2.0") "input-remapper in stable nixpkgs reached version or surpass 2.2.0 . Consider switching back from unstable.input-remapper in autoclicker.nix. The unstable version was used because api changes in the latest version when I do that.";

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
