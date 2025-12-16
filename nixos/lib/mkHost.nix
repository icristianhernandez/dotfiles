# Host builder function with roles support.
#
# Usage in flake.nix:
#   mkHost = import ./lib/mkHost.nix { inherit nixpkgs nixos-wsl home-manager; };
#   nixosConfigurations.nixos = mkHost {
#     hostname = "nixos";
#     system = "x86_64-linux";
#     roles = [ "base" "wsl" "development" ];
#   };
{
  nixpkgs,
  nixos-wsl,
  home-manager,
}:
{
  hostname,
  system,
  roles,
  extraModules ? [],
}:
let
  const = import ./const.nix;
  rolesLib = import ./roles.nix;

  # Partially applied hasRole for this host's roles
  hasRole = rolesLib.hasRole roles;

  specialArgs = {
    inherit const roles hasRole;
  };
in
nixpkgs.lib.nixosSystem {
  inherit system specialArgs;

  modules = [
    # Core system modules (always imported, use mkIf internally for role guards)
    {
      networking.hostName = hostname;
      imports = import ./import-modules.nix {
        inherit (nixpkgs) lib;
        dir = ../system-modules;
      };
    }
  ]
  # WSL external module (only if wsl role - provides wsl.* options)
  ++ nixpkgs.lib.optionals (hasRole "wsl") [
    nixos-wsl.nixosModules.default
  ]
  ++ [
    # Home Manager
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = specialArgs;
        users.${const.user} = {
          imports = import ./import-modules.nix {
            inherit (nixpkgs) lib;
            dir = ../home-modules;
          };
        };
      };
    }
  ]
  ++ extraModules;
}
