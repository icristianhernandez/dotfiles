{
  pkgs,
  lib,
  mkApp,
}:
let
  inherit (pkgs) stylua;
  script = pkgs.writeShellApplication {
    name = "nvim-fmt";
    runtimeInputs = [
      stylua
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail
      mode="fix"
      if [ $# -gt 0 ] && [ "$1" = "--check" ]; then mode="check"; shift || true; fi

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
  program = "${script}/bin/nvim-fmt";
  meta = {
    description = "Format Neovim Lua with Stylua";
  };
}
