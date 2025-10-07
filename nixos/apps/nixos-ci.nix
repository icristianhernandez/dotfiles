{
  pkgs,
  mkApp,
  ...
}:
let
  script = pkgs.writeShellApplication {
    name = "nixos-ci";
    runtimeInputs = [
      pkgs.nix
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail

      NIX="${pkgs.nix}/bin/nix"
      APP_PREFIX="./nixos#apps.${pkgs.system}"
      NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )
      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[nixos-ci] $1" >&2; }

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
