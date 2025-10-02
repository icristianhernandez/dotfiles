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

      "format-check" = pkgs.runCommand "format-check" { buildInputs = [ pkgs.nixfmt-tree ]; } ''
        set -eu
        ${pkgs.nixfmt-tree}/bin/treefmt --ci ${root}
        touch "$out"
      '';
    };
  in
  lintChecks
)
