{ pkgs, dotfilesDir }:
{
  prelude =
    {
      name,
      withNix ? false,
      appPrefixAttr ? true,
    }:
    let
      nixPart =
        if withNix then
          ''
            NIX="${pkgs.nix}/bin/nix"
            APP_PREFIX="./nixos#${if appPrefixAttr then "apps.${pkgs.stdenv.hostPlatform.system}" else ""}"
            NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )
          ''
        else
          "";
    in
    ''
      set -euo pipefail
      export REPO_ROOT="${dotfilesDir}"
      ${nixPart}
      log() { printf '[%s] %s\n' "${name}" "$1" >&2; }
    '';

  parseMode = ''
    mode="fix"
    case "''${1-}" in
      --check) mode="check"; shift ;;
    esac
  '';

  paths = {
    nixosDir = "${dotfilesDir}/nixos";
    nvimCfgDir = "${dotfilesDir}/nvim";
    workflowsDir = "${dotfilesDir}/.github/workflows";
    statixConfig = "${dotfilesDir}/statix.toml";
  };
}
