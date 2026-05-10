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
            APP_PREFIX="$nixosDir#${if appPrefixAttr then "apps.${pkgs.stdenv.hostPlatform.system}" else ""}"
            NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )
          ''
        else
          "";
    in
    ''
      set -euo pipefail
      REPO_ROOT="${dotfilesDir}"
      export REPO_ROOT
      nixosDir="$REPO_ROOT/nixos"
      nvimCfgDir="$REPO_ROOT/nvim"
      workflowsDir="$REPO_ROOT/.github/workflows"
      statixConfig="$REPO_ROOT/statix.toml"
      export nixosDir nvimCfgDir workflowsDir statixConfig
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
    nixosDir = "$nixosDir";
    nvimCfgDir = "$nvimCfgDir";
    workflowsDir = "$workflowsDir";
    statixConfig = "$statixConfig";
  };
}
