{ lib, ... }:
let
  dir = ./home-modules;
  homeModules = import ./lib/import-modules.nix { inherit lib dir; };
in
{
  imports = homeModules;
}
