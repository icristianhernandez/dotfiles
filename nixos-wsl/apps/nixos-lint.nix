{
  pkgs,
  lib,
  mkApp,
}:
let
  inherit (pkgs) statix deadnix;
  script = pkgs.writeShellApplication {
    name = "nixos-lint";
    runtimeInputs = [
      statix
      deadnix
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail
      if [ -f nixos-wsl/statix.toml ]; then
        statix_cfg=(--config nixos-wsl/statix.toml)
      else
        statix_cfg=()
      fi
      ${statix}/bin/statix check "''${statix_cfg[@]}" nixos-wsl
      ${deadnix}/bin/deadnix --fail --hidden \
        --exclude .git .direnv result dist node_modules .terraform .venv \
        nixos-wsl
    '';
  };
in
mkApp {
  program = "${script}/bin/nixos-lint";
  meta = {
    description = "Run statix and deadnix over nixos-wsl";
  };
}
