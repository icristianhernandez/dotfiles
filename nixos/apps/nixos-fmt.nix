{
  pkgs,
  mkApp,
  ...
}:
let
  inherit (pkgs) nixfmt;
  script =
    let
      helpers = import ../lib/app-helpers.nix { inherit pkgs; };
    in
    pkgs.writeShellApplication {
      name = "nixos-fmt";
      runtimeInputs = [
        nixfmt
        pkgs.findutils
        pkgs.coreutils
      ];
      text = ''
        ${helpers.prelude {
          name = "nixos-fmt";
          withNix = false;
        }}
        ${helpers.parseMode}

        FIND_CMD=( find ${helpers.paths.nixosDir} -type f -name '*.nix' -print0 )
        if [ "$mode" = "check" ]; then
          log "nixfmt check"
          "''${FIND_CMD[@]}" | xargs -0 -r ${nixfmt}/bin/nixfmt --check
        else
          log "nixfmt fix"
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
