{
  pkgs,
  lib,
  mkApp,
}:
let
  script = pkgs.writeShellApplication {
    name = "workflows-lint";
    runtimeInputs = [
      pkgs.actionlint
      pkgs.yamllint
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail
      ${pkgs.actionlint}/bin/actionlint
      ${pkgs.yamllint}/bin/yamllint .github/workflows
    '';
  };
in
mkApp {
  program = "${script}/bin/workflows-lint";
  meta = {
    description = "Lint GitHub workflows with actionlint and yamllint";
  };
}
