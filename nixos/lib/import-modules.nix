{ lib, dir }:

let
  foundFiles = lib.filesystem.listFilesRecursive dir;
  nixFiles = lib.filter (p: lib.strings.hasSuffix ".nix" (toString p)) foundFiles;
  sortedFiles = lib.sort (a: b: (toString a) < (toString b)) nixFiles;
in
sortedFiles
