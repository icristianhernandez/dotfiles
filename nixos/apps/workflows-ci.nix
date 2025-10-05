{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "workflows-ci";
    runtimeInputs = [
      pkgs.nix
      pkgs.coreutils
    ];
    text = ''
      set -eo pipefail

      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[workflows-ci] $1" >&2; }

      log "starting workflows-lint"
      "${pkgs.nix}/bin/nix" --extra-experimental-features 'nix-command flakes' run "./nixos#apps.${pkgs.system}.workflows-lint" || { rc=$?; log "workflows-lint failed (exit $rc)"; exit $rc; }
      log "finished workflows-lint"
    '';
  };
in
mkApp {
  program = "${script}/bin/workflows-ci";
  meta = {
    description = "GitHub Workflows: run actionlint and yamllint";
  };
}
