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
      name = "workflows-lint";
      runtimeInputs = [
        pkgs.actionlint
        pkgs.yamllint
        pkgs.coreutils
      ];
      text = ''
        ${helpers.prelude {
          name = "workflows-lint";
          withNix = false;
        }}
        WORKFLOWS_DIR="${helpers.paths.workflowsDir}"
        log "actionlint"
        ${pkgs.actionlint}/bin/actionlint
        log "yamllint"
        ${pkgs.yamllint}/bin/yamllint "$WORKFLOWS_DIR"
      '';
    };
in
mkApp {
  program = "${script}/bin/workflows-lint";
  meta = {
    description = "Lint GitHub workflows with actionlint and yamllint";
  };
}
