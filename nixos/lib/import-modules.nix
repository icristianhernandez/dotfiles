{ lib, dir }:

let
  foundFiles = lib.filesystem.listFilesRecursive dir;
  nixFiles = lib.filter (p: lib.strings.hasSuffix ".nix" (toString p)) foundFiles;
  sortedFiles = lib.sort lib.lessThan nixFiles;
in
map (p: dir + "/${builtins.baseNameOf (toString p)}") sortedFiles
