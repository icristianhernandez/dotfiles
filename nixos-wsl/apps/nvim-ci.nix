{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "nvim-ci";
    runtimeInputs = [ pkgs.nix ];
    text = ''
      set -euo pipefail
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.nvim-fmt -- --check
    '';
  };
in
mkApp {
  program = "${script}/bin/nvim-ci";
  meta = {
    description = "Neovim: run stylua --check over config";
  };
}
