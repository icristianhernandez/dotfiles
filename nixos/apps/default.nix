{
  nixpkgs,
  systems,
}:
let
  for_each_system = nixpkgs.lib.genAttrs systems;
in
for_each_system (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    mkApp = import ../lib/mk-app.nix { inherit pkgs; };
    dotfilesDir = "$(git rev-parse --show-toplevel 2>/dev/null || pwd)";

    importApp = name: import (./. + "/${name}") { inherit pkgs mkApp dotfilesDir; };

    appFiles = builtins.readDir ./.;

    appNames = builtins.filter (
      name: name != "default.nix" && name != "helpers.nix" && nixpkgs.lib.hasSuffix ".nix" name
    ) (builtins.attrNames appFiles);

    apps = builtins.listToAttrs (
      map (name: {
        name = nixpkgs.lib.removeSuffix ".nix" name;
        value = importApp name;
      }) appNames
    );
  in
  apps
)
