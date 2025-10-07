{
  pkgs,
  mkApp,
  ...
}:
let
  script = pkgs.writeShellApplication {
    name = "nvim-ci";
    runtimeInputs = [
      pkgs.nix
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail

      NIX="${pkgs.nix}/bin/nix"
      APP_PREFIX="./nixos#apps.${pkgs.system}"
      NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )
      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[nvim-ci] $1" >&2; }

      log "format (apply fixes)"
      "''${NIX_RUN[@]}" "''${APP_PREFIX}.nvim-fmt" -- "$@"

      log "stylua check"
      "''${NIX_RUN[@]}" "''${APP_PREFIX}.nvim-fmt" -- --check "$@"
    '';
  };
in
mkApp {
  program = "${script}/bin/nvim-ci";
  meta = {
    description = "Neovim: format (fix) then stylua checks";
  };
}
