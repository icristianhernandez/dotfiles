{ dir }:
let
  files = builtins.attrNames (builtins.readDir dir);
  # Only include .nix files that do not start with a dot (hidden files)
  nixFiles = builtins.filter (file: builtins.match "^[^.].*\\.nix$" file != null) files;
  # Sort for deterministic import order
  sortedNixFiles = builtins.sort builtins.lessThan nixFiles;
  modulePaths = map (file: dir + "/${file}") sortedNixFiles;
in
modulePaths
