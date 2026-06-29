{
  inputs,
  pkgs,
  guardRole,
  ...
}:

guardRole "gaming" {
  home.packages = [
    inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher
  ];
}
