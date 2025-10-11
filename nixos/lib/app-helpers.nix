{ pkgs }:
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
            APP_PREFIX="./nixos#${if appPrefixAttr then "apps.${pkgs.system}" else ""}"
            NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )
          ''
        else
          '''';
    in
    ''
      set -euo pipefail
      ${nixPart}
      log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[${name}] $1" >&2; }
    '';

  parseMode = ''
    mode="fix"
    case "''${1-}" in
      --check) mode="check"; shift ;;
    esac
  '';

  paths = {
    nixosDir = "nixos";
    nvimCfgDir = "nvim/.config/nvim";
    workflowsDir = ".github/workflows";
    statixConfig = "statix.toml";
  };
}
