_:
let
  homeModules = import ./lib/import-directory.nix { dir = ./home-modules; };
in
{
  imports = homeModules;
}
