{
  pkgs,
  mkApp,
  ...
}:
let
  nixfmt = pkgs.nixfmt-rfc-style;
  script = pkgs.writeShellApplication {
    name = "nixos-fmt";
    runtimeInputs = [
      nixfmt
      pkgs.findutils
    ];
    text = ''
      set -euo pipefail
      mode="fix"
      case "''${1-}" in
        --check) mode="check"; shift ;;
      esac

      FIND_CMD=( find nixos -type f -name '*.nix' -print0 )
      if [ "$mode" = "check" ]; then
        "''${FIND_CMD[@]}" | xargs -0 -r ${nixfmt}/bin/nixfmt --check
      else
        "''${FIND_CMD[@]}" | xargs -0 -r ${nixfmt}/bin/nixfmt
      fi
    '';
  };
in
mkApp {
  program = "${script}/bin/nixos-fmt";
  meta = {
    description = "Format Nix files in nixos (nixfmt)";
  };
}
