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
      name = "ci";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.nix
      ];
      text = ''
        ${helpers.prelude {
          name = "ci";
          withNix = true;
          appPrefixAttr = false;
        }}

        run_subci() {
          name="$1"; shift || true
          log "starting $name"
          "''${NIX_RUN[@]}" "''${APP_PREFIX}$name" -- "$@" || { rc=$?; log "$name failed (exit $rc)"; exit $rc; }
          log "finished $name"
        }

        SUBCIS=( nixos-ci nvim-ci workflows-ci )
        for name in "''${SUBCIS[@]}"; do
          run_subci "$name" "$@"
        done

        log "CI: completed all domains"
      '';
    };
in
mkApp {
  program = "${script}/bin/ci";
  meta = {
    description = "Run nixos-ci, nvim-ci, workflows-ci in order (with logging)";
  };
}
