{
  lib,
  pkgs,
  guardRole,
  ...
}:

guardRole "gaming" {
  home.packages = with pkgs; [ prismlauncher ];
}
