{ lib, dir }:

# Import all .nix files from a directory as a sorted list of module paths.
#
# This function is used to automatically import all modules from a directory
# without manually maintaining an import list.
#
# Type: { lib: attrset, dir: path } -> [path]
#
# Arguments:
#   lib: The nixpkgs lib attribute set
#   dir: Path to directory containing .nix module files
#
# Returns: Sorted list of paths to .nix files found in directory

let
  dirExists = builtins.pathExists dir;
  foundFiles = lib.filesystem.listFilesRecursive dir;
  nixFiles = lib.filter (p: lib.strings.hasSuffix ".nix" (toString p)) foundFiles;
  sortedFiles = lib.sort (a: b: (toString a) < (toString b)) nixFiles;
in
if !dirExists then
  throw "import-modules: directory '${toString dir}' does not exist"
else if nixFiles == [ ] then
  builtins.trace "WARNING: import-modules: no .nix files found in '${toString dir}'" [ ]
else
  sortedFiles
