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

        run_sub() {
          name="$1"; shift || true
          log "start $name"
          "''${NIX_RUN[@]}" "''${APP_PREFIX}.$name" -- "$@" || { rc=$?; log "$name failed (exit $rc)"; exit $rc; }
          log "done $name"
        }

        SUBCIS=( workflows-lint )
        for name in "''${SUBCIS[@]}"; do
          run_sub "$name" "$@"
        done
      '';
    };
in
mkApp {
  program = "${script}/bin/workflows-ci";
  meta = {
    description = "GitHub Workflows: run actionlint and yamllint";
  };
}
