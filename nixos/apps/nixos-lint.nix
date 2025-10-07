{
  pkgs,
  mkApp,
  ...
}:
let
  inherit (pkgs) statix deadnix;
  script = pkgs.writeShellApplication {
    name = "nixos-lint";
    runtimeInputs = [
      statix
      deadnix
    ];
    text = ''
      set -euo pipefail
      STATIX_ARGS=( check )
      if [ -f nixos/statix.toml ]; then
        STATIX_ARGS+=( --config nixos/statix.toml )
      fi
      ${statix}/bin/statix "''${STATIX_ARGS[@]}" nixos

      DEADNIX_ARGS=(
        --fail --hidden
      )
      DEADNIX_EXCLUDES=(
        .git
        .direnv
        result
        dist
        node_modules
        .terraform
        .venv
      )
      ${deadnix}/bin/deadnix "''${DEADNIX_ARGS[@]}" --exclude "''${DEADNIX_EXCLUDES[@]}" -- nixos
    '';
  };
in
mkApp {
  program = "${script}/bin/nixos-lint";
  meta = {
    description = "Run statix and deadnix over nixos";
  };
}
