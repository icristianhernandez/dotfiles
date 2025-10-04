{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "workflows-ci";
    runtimeInputs = [ pkgs.nix ];
    text = ''
      set -euo pipefail
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.workflows-lint
    '';
  };
in
mkApp {
  program = "${script}/bin/workflows-ci";
  meta = {
    description = "GitHub Workflows: run actionlint and yamllint";
  };
}
