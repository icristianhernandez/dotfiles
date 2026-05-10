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
      name = "workflows-ci";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.nix
      ];
      text = ''
        ${helpers.prelude {
          name = "workflows-ci";
          withNix = true;
          appPrefixAttr = true;
        }}

        if [ "$#" -ne 0 ]; then
          log "workflows-ci does not accept arguments"
          echo "usage: workflows-ci"
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

        run_step "workflows-lint" "''${NIX_RUN[@]}" "''${APP_PREFIX}.workflows-lint"
        echo "workflows-ci: passed - formatters and linters completed"
      '';
    };
in
mkApp {
  program = "${script}/bin/workflows-ci";
  meta = {
    description = "GitHub Workflows: run actionlint and yamllint";
  };
}
