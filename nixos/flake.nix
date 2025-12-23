{
  description = "Personal NixOS configuration for WSL with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      const = import ./lib/const.nix;

      systems = [ "x86_64-linux" ];
      eachSystem =
        f:
        lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );

      rolesSpec = import ./roles.nix { inherit lib; };

      hosts = {
        wsl = {
          system = builtins.head systems;
          roles = [
            "base"
            "wsl"
            "interactive"
            "dev"
          ];
        };
        dmsdesktop = {
          system = builtins.head systems;
          roles = [
            "base"
            "interactive"
            "dev"
            "desktop"
            "dms"
          ];
        };
      };
    in
    {
      nixosConfigurations = lib.genAttrs (builtins.attrNames hosts) (
        hostName:
        let
          host = hosts.${hostName};
          inherit (host) roles;
          helpers = rolesSpec.mkHelpers roles;
        in
        assert rolesSpec.validateRoles roles;
        lib.nixosSystem {
          inherit (host) system;
          specialArgs = {
            inherit const roles hostName;
            inherit (helpers) hasRole mkIfRole guardRole;
            inherit inputs;
            input = inputs;
          };

          modules = [
            rolesSpec.module
            { inherit roles; }

            {
              imports = import ./lib/import-modules.nix {
                inherit lib;
                dir = ./system-modules;
              };
            }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit const roles hostName;
                  inherit (helpers) hasRole mkIfRole guardRole;
                  inherit inputs;
                  input = inputs;
                };
                users = {
                  "${const.user}" = {
                    imports = import ./lib/import-modules.nix {
                      inherit lib;
                      dir = ./home-modules;
                    };
                  };
                };
              };
            }
          ]
          ++ lib.optionals (helpers.hasRole "wsl") [ nixos-wsl.nixosModules.default ]
          ++ lib.optionals (
            helpers.hasRole "desktop" && builtins.pathExists /etc/nixos/hardware-configuration.nix
          ) [ /etc/nixos/hardware-configuration.nix ]
          ++
            # filesystem stub so CI doesn't break in non-desktop hosts
            lib.optionals
              (helpers.hasRole "desktop" && !(builtins.pathExists /etc/nixos/hardware-configuration.nix))
              [
                (
                  { lib, guardRole, ... }:
                  guardRole "desktop" {
                    fileSystems."/" = {
                      device = "none";
                      fsType = "tmpfs";
                      options = [
                        "mode=755"
                        "size=512M"
                      ];
                    };

                    boot.loader.grub.enable = lib.mkForce false;
                    boot.loader.systemd-boot.enable = lib.mkForce false;
                  }
                )
              ];
        }
      );

      formatter = eachSystem ({ pkgs, ... }: pkgs.nixfmt);

      apps = import ./apps { inherit nixpkgs systems; };
    };
}
