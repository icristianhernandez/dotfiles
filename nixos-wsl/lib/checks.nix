{
  nixpkgs,
  systems,
  root,
}:
let
  for_each_system = nixpkgs.lib.genAttrs systems;
in
for_each_system (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    statixConfig =
      if builtins.pathExists (root + "/statix.toml") then
        pkgs.writeText "statix.toml" (builtins.readFile (root + "/statix.toml"))
      else
        pkgs.writeText "statix.toml" ''
          disabled = []
          nix_version = "2.4"
          ignore = [".direnv"]
        '';
    lintChecks = {
      "statix-strict" = pkgs.runCommand "statix-strict" { buildInputs = [ pkgs.statix ]; } ''
        set -eu
        statix check --format errfmt --config ${statixConfig} ${root}
        touch "$out"
      '';

      "deadnix-strict" = pkgs.runCommand "deadnix-strict" { buildInputs = [ pkgs.deadnix ]; } ''
        set -eu
        deadnix --fail --hidden \
          --exclude .git .direnv result dist node_modules .terraform .venv \
          ${root}
        touch "$out"
      '';
    };

    # Only check for the user-preferred `nixd` LSP; do not fall back to other LSPs.
    lspChecks =
      if builtins.hasAttr "nixd" pkgs then {
        "nixd-available" = pkgs.runCommand "nixd-available" { buildInputs = [ pkgs.nixd ]; } ''
          set -eu
          nixd --help >/dev/null 2>&1
          touch "$out"
        '';
      } else {};
  in
  lintChecks // lspChecks
  // {
    formatting =
      pkgs.runCommand "nixfmt-check"
        {
          buildInputs = [
            pkgs.findutils
            pkgs.nixfmt-rfc-style
          ];
        }
        ''
          set -euo pipefail
          find ${root} -type f -name '*.nix' -print0 \
            | xargs --no-run-if-empty -0 nixfmt --check
          touch "$out"
        '';
  }
)
