{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "ci";
    runtimeInputs = [ pkgs.nix ];
    text = ''
      set -euo pipefail
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.nixos-ci
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.nvim-ci
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.workflows-ci
    '';
  };
in
mkApp {
  program = "${script}/bin/ci";
  meta = {
    description = "Run nixos-ci, nvim-ci, workflows-ci in order";
  };
}
