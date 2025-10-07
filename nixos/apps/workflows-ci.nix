{
  pkgs,
  mkApp,
  ...
}:
let
  script = pkgs.writeShellApplication {
    name = "workflows-ci";
    runtimeInputs = [
      pkgs.nix
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail

      NIX="${pkgs.nix}/bin/nix"
      APP_PREFIX="./nixos#apps.${pkgs.system}"
      NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )

      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[workflows-ci] $1" >&2; }

      run_sub() {
        name="$1"; shift || true
        log "start $name"
        "''${NIX_RUN[@]}" "''${APP_PREFIX}.$name" -- "$@" || { rc=$?; log "$name failed (exit $rc)"; exit $rc; }
        log "done $name"
      }

      SUBCIS=( workflows-lint )
      for name in "''${SUBCIS[@]}"; do
        run_sub "$name" "$@"
      done
    '';
  };
in
mkApp {
  program = "${script}/bin/workflows-ci";
  meta = {
    description = "GitHub Workflows: run actionlint and yamllint";
  };
}
