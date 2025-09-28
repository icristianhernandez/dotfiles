{ config, pkgs, lib, ... }:
let
  systemModules = import ./lib/import-directory.nix { dir = ./system-modules; }; 
in
{
  imports = systemModules;
}
