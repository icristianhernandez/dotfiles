{
  pkgs,
  lib,
  mkApp,
}:
let
  nixfmt = pkgs.nixfmt-rfc-style;
  inherit (pkgs) stylua;
  script = pkgs.writeShellApplication {
    name = "fmt";
    runtimeInputs = [
      nixfmt
      stylua
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gawk
      pkgs.git
    ];
    text = ''
      set -euo pipefail
      mode="fix"
      if [ $# -gt 0 ] && [ "$1" = "--check" ]; then mode="check"; shift || true; fi

      # Nix files under nixos
      if [ "$mode" = check ]; then
        find nixos -type f -name '*.nix' -print0 \
          | xargs -0 -r ${nixfmt}/bin/nixfmt --check
      else
        find nixos -type f -name '*.nix' -print0 \
          | xargs -0 -r ${nixfmt}/bin/nixfmt
      fi

      # Stylua for Neovim config
      if [ -d nvim/.config/nvim ]; then
        if [ -f nvim/.config/nvim/.stylua.toml ]; then
          cfg=(--config-path nvim/.config/nvim/.stylua.toml)
        else
          cfg=()
        fi
        if [ "$mode" = check ]; then
          ${stylua}/bin/stylua --check "''${cfg[@]}" nvim/.config/nvim
        else
          ${stylua}/bin/stylua "''${cfg[@]}" nvim/.config/nvim
        fi
      fi
    '';
  };
in
mkApp {
  program = "${script}/bin/fmt";
  meta = {
    description = "Format Nix (nixfmt) and Lua (stylua)";
  };
}
