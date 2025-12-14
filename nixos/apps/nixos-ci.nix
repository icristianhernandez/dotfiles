{
  pkgs,
  mkApp,
  ...
}:
let
  script =
    let
      helpers = import ../lib/app-helpers.nix { inherit pkgs; };
    in
    pkgs.writeShellApplication {
      name = "nixos-ci";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.nix
      ];
      text = ''
        ${helpers.prelude {
          name = "nixos-ci";
          withNix = true;
          appPrefixAttr = true;
        }}

        run_app() {
          name="$1"; shift || true
          log "start $name"
          "''${NIX_RUN[@]}" "''${APP_PREFIX}.$name" -- "$@" || { rc=$?; log "ERROR: $name failed (exit $rc)"; exit $rc; }
          log "done $name"
        }

        log "format (apply fixes)"
        run_app nixos-fmt
        log "lint"
        run_app nixos-lint

        log "flake check"
        if [ ! -d ./nixos ]; then
          log "ERROR: ./nixos directory not found"
          exit 1
        fi
        "$NIX" --extra-experimental-features "nix-command flakes" flake check ./nixos -L || { rc=$?; log "ERROR: flake check failed (exit $rc)"; exit $rc; }

        log "completed successfully"
      '';
    };
in
mkApp {
  program = "${script}/bin/nixos-ci";
  meta = {
    description = "NixOS: format (fix) then lint and flake checks";
  };
}
