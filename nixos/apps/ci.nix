{
  pkgs,
  mkApp,
  ...
}:
let
  script = pkgs.writeShellApplication {
    name = "ci";
    runtimeInputs = [
      pkgs.nix
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail

      NIX="${pkgs.nix}/bin/nix"
      APP_PREFIX="./nixos#"
      NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )

      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[ci] $1" >&2; }

      run_subci() {
        name="$1"; shift || true
        log "starting $name"
        "''${NIX_RUN[@]}" "''${APP_PREFIX}$name" -- "$@" || { rc=$?; log "$name failed (exit $rc)"; exit $rc; }
        log "finished $name"
      }

      SUBCIS=( nixos-ci nvim-ci workflows-ci )
      for name in "''${SUBCIS[@]}"; do
        run_subci "$name" "$@"
      done

      log "CI: completed all domains"
    '';
  };
in
mkApp {
  program = "${script}/bin/ci";
  meta = {
    description = "Run nixos-ci, nvim-ci, workflows-ci in order (with logging)";
  };
}
