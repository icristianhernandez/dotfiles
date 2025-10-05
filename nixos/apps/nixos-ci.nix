{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "nixos-ci";
    runtimeInputs = [
      pkgs.nix
      pkgs.coreutils
    ];
    text = ''
      set -eo pipefail

      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[nixos-ci] $1" >&2; }

      log "starting formatter (apply fixes)"
      "${pkgs.nix}/bin/nix" --extra-experimental-features 'nix-command flakes' run "./nixos#apps.${pkgs.system}.nixos-fmt" || { rc=$?; log "ERROR: formatter failed (exit $rc)"; exit $rc; }
      log "formatter finished"

      log "running nixos lint"
      "${pkgs.nix}/bin/nix" --extra-experimental-features 'nix-command flakes' run "./nixos#apps.${pkgs.system}.nixos-lint" || { rc=$?; log "ERROR: lint failed (exit $rc)"; exit $rc; }

      log "running flake check"
      "${pkgs.nix}/bin/nix" --extra-experimental-features 'nix-command flakes' flake check ./nixos -L || { rc=$?; log "ERROR: flake check failed (exit $rc)"; exit $rc; }

      log "nixos-ci completed successfully"
    '';
  };
in
mkApp {
  program = "${script}/bin/nixos-ci";
  meta = {
    description = "NixOS: format (fix) then lint and flake checks";
  };
}
