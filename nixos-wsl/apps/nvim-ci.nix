{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "nvim-ci";
    runtimeInputs = [
      pkgs.nix
      pkgs.coreutils
    ];
    text = ''
      set -eo pipefail
      # Format (apply fixes), then run checks
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.nvim-fmt
      ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run ./nixos-wsl#apps.${pkgs.system}.nvim-fmt -- --check
    '';
  };
in
mkApp {
  program = "${script}/bin/nvim-ci";
  meta = {
    description = "Neovim: format (fix) then stylua checks";
  };
}
