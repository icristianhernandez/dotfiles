{
  pkgs,
  mkApp,
  ...
}:
let
  inherit (pkgs) stylua;
  script =
    let
      helpers = import ../lib/app-helpers.nix { inherit pkgs; };
    in
    pkgs.writeShellApplication {
      name = "nvim-fmt";
      runtimeInputs = [
        stylua
        pkgs.coreutils
      ];
      text = ''
        ${helpers.prelude {
          name = "nvim-fmt";
          withNix = false;
        }}
        ${helpers.parseMode}

        target_dir="${helpers.paths.nvimCfgDir}"
        if [ -d "$target_dir" ]; then
          if [ -f "$target_dir/.stylua.toml" ]; then
            cfg=(--config-path "$target_dir/.stylua.toml")
          else
            cfg=()
          fi
          if [ "$mode" = "check" ]; then
            log "stylua check"
            ${stylua}/bin/stylua --check "''${cfg[@]}" "$target_dir"
          else
            log "stylua fix"
            ${stylua}/bin/stylua "''${cfg[@]}" "$target_dir"
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
