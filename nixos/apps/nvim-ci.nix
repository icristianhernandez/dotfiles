{
  pkgs,
  mkApp,
  ...
}:
let
  script =
    let
      helpers = import ../lib/app-helpers.nix { inherit pkgs; };
    in
    pkgs.writeShellApplication {
      name = "nvim-ci";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.nix
      ];
      text = ''
        ${helpers.prelude {
          name = "nvim-ci";
          withNix = true;
          appPrefixAttr = true;
        }}

        log "format (apply fixes)"
        "''${NIX_RUN[@]}" "''${APP_PREFIX}.nvim-fmt" -- "$@"

        log "stylua check"
        "''${NIX_RUN[@]}" "''${APP_PREFIX}.nvim-fmt" -- --check "$@"
      '';
    };
in
mkApp {
  program = "${script}/bin/nvim-ci";
  meta = {
    description = "Neovim: format (fix) then stylua checks";
  };
}
