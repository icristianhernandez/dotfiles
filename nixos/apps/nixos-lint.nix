{
  pkgs,
  mkApp,
  ...
}:
let
  inherit (pkgs) statix deadnix;
  script =
    let
      helpers = import ./helpers.nix { inherit pkgs; };
    in
    pkgs.writeShellApplication {
      name = "nixos-lint";
      runtimeInputs = [
        statix
        deadnix
        pkgs.coreutils
      ];
      text = ''
        ${helpers.prelude {
          name = "nixos-lint";
          withNix = false;
        }}
        STATIX_ARGS=( check )
        if [ -f ${helpers.paths.statixConfig} ]; then
          STATIX_ARGS+=( --config ${helpers.paths.statixConfig} )
        fi
        log "statix"
        ${statix}/bin/statix "''${STATIX_ARGS[@]}" ${helpers.paths.nixosDir}

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
        log "deadnix"
        ${deadnix}/bin/deadnix "''${DEADNIX_ARGS[@]}" --exclude "''${DEADNIX_EXCLUDES[@]}" -- ${helpers.paths.nixosDir}
      '';
    };
in
mkApp {
  program = "${script}/bin/nixos-lint";
  meta = {
    description = "Run statix and deadnix over nixos";
  };
}
