{
  pkgs,
  lib,
  mkApp,
}:
let
  inherit (pkgs) statix deadnix;
  script = pkgs.writeShellApplication {
    name = "lint";
    runtimeInputs = [
      statix
      deadnix
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail
      if [ -f nixos/statix.toml ]; then
        statix_cfg=(--config nixos/statix.toml)
      else
        statix_cfg=()
      fi
      ${statix}/bin/statix check "''${statix_cfg[@]}" nixos
      ${deadnix}/bin/deadnix --fail --hidden \
        --exclude .git .direnv result dist node_modules .terraform .venv \
        nixos
    '';
  };
in
mkApp {
  program = "${script}/bin/lint";
  meta = {
    description = "Run statix and deadnix over nixos";
  };
}
