{
  pkgs,
  lib,
  mkApp,
}:
let
  nixfmt = pkgs.nixfmt-rfc-style;
  script = pkgs.writeShellApplication {
    name = "nixos-fmt";
    runtimeInputs = [
      nixfmt
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gawk
    ];
    text = ''
      set -euo pipefail
      mode="fix"
      if [ $# -gt 0 ] && [ "$1" = "--check" ]; then mode="check"; shift || true; fi

      if [ "$mode" = check ]; then
        find nixos -type f -name '*.nix' -print0 \
          | xargs -0 -r ${nixfmt}/bin/nixfmt --check
      else
        find nixos -type f -name '*.nix' -print0 \
          | xargs -0 -r ${nixfmt}/bin/nixfmt
      fi
    '';
  };
in
mkApp {
  program = "${script}/bin/nixos-fmt";
  meta = {
    description = "Format Nix files in nixos (nixfmt)";
  };
}
