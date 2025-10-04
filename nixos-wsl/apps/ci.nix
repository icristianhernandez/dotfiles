{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "ci";
    runtimeInputs = [
      pkgs.nix
      pkgs.coreutils
    ];
    text = ''
      set -eo pipefail

      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[ci] $1" >&2; }

      # Orchestrator fails fast; no timeouts

      run_subci() {
        name="$1"
        log "starting $name"
        "${pkgs.nix}/bin/nix" --extra-experimental-features 'nix-command flakes' run "./nixos-wsl#apps.${pkgs.system}.$name" || { rc=$?; log "$name failed (exit $rc)"; exit $rc; }
        log "finished $name"
      }

      # Default sequential execution; orchestrator invokes per-domain CIs which themselves
      # apply formatting first then run checks.
      log "CI: invoking nixos-ci"
      run_subci nixos-ci

      log "CI: invoking nvim-ci"
      run_subci nvim-ci

      log "CI: invoking workflows-ci"
      run_subci workflows-ci

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
