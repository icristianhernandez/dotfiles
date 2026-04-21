{
  pkgs,
  mkApp,
  ...
}:
let
  script =
    let
      helpers = import ./helpers.nix { inherit pkgs; };
    in
    pkgs.writeShellApplication {
      name = "nixos-ci";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.nix
      ];
      text = ''
        ${helpers.prelude {
          name = "nixos-ci";
          withNix = true;
          appPrefixAttr = true;
        }}

        if [ "$#" -ne 0 ]; then
          log "nixos-ci does not accept arguments"
          echo "usage: nixos-ci"
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

        run_app() {
          local name="$1"
          run_step "$name" "''${NIX_RUN[@]}" "''${APP_PREFIX}.$name"
        }

        run_app nixos-fmt
        run_app nixos-lint
        run_step "flake-check" "$NIX" --extra-experimental-features "nix-command flakes" flake check "$REPO_ROOT/nixos" --quiet
        echo "nixos-ci: passed - formatters and linters completed"
      '';
    };
in
mkApp {
  program = "${script}/bin/nixos-ci";
  meta = {
    description = "NixOS: format (fix) then lint and flake checks";
  };
}
