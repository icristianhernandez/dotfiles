{
  pkgs,
  mkApp,
  dotfilesDir,
  ...
}:
let
  script =
    let
      helpers = import ./helpers.nix { inherit pkgs dotfilesDir; };
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

        if [ "$#" -ne 0 ]; then
          log "nvim-ci does not accept arguments"
          echo "usage: nvim-ci"
          exit 2
        fi

        run_step() {
          local label="$1"; shift
          local tmp_log
          local rc=0
          tmp_log="$(mktemp)"
          if "$@" >"$tmp_log" 2>&1; then
            rm -f "$tmp_log"
            return 0
          else
            rc=$?
            log "$label failed (exit $rc)"
            cat "$tmp_log" >&2
            rm -f "$tmp_log"
            return "$rc"
          fi
        }

        run_step "nvim-fmt" "''${NIX_RUN[@]}" "''${APP_PREFIX}.nvim-fmt"
        run_step "nvim-fmt-check" "''${NIX_RUN[@]}" "''${APP_PREFIX}.nvim-fmt" -- --check
        echo "nvim-ci: passed - formatters and linters completed"
      '';
    };
in
mkApp {
  program = "${script}/bin/nvim-ci";
  meta = {
    description = "Neovim: format (fix) then stylua checks";
  };
}
