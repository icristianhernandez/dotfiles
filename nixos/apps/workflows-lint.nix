{
  pkgs,
  mkApp,
  ...
}:
let
  script = pkgs.writeShellApplication {
    name = "workflows-lint";
    runtimeInputs = [
      pkgs.actionlint
      pkgs.yamllint
    ];
    text = ''
      set -euo pipefail
      WORKFLOWS_DIR=".github/workflows"
      ${pkgs.actionlint}/bin/actionlint
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
