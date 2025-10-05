{ lib, ... }:
let
  dir = ./system-modules;
  systemModules = import ./lib/import-modules.nix { inherit lib dir; };
in
{
  imports = systemModules;
}
