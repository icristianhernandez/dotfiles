{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "nixos-ci";
    runtimeInputs = [ pkgs.nix ];
    text = ''
      set -euo pipefail
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.nixos-fmt -- --check
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.nixos-lint
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' flake check ./nixos-wsl -L
    '';
  };
in
mkApp {
  program = "${script}/bin/nixos-ci";
  meta = {
    description = "NixOS: fmt --check, lint, and flake checks";
  };
}
