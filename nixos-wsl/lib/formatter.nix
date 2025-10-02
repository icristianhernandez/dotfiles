{ nixpkgs, systems }:
let
  for_each_system = nixpkgs.lib.genAttrs systems;
in
for_each_system (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  pkgs.writeShellApplication {
    name = "nix-fmt";
    runtimeInputs = [
      pkgs.findutils
      pkgs.nixfmt-rfc-style
    ];
    text = ''
      set -euo pipefail
      if [ "$#" -gt 0 ]; then
        exec nixfmt "$@"
      else
        find . -type f -name '*.nix' -print0 \
          | xargs --no-run-if-empty -0 nixfmt
      fi
    '';
  }
)
