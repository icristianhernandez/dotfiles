{
  description = "Personal NixOS configuration for WSL with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
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
      unstableOverlay = final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config = {
            allowUnfree = true;
          };
        };
      };
      eachSystem =
        f:
        lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ unstableOverlay ];
            };
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
            "thinkpadE14"
            "dms"
            "gaming"
          ];
        };
        gnomedesktop = {
          system = builtins.head systems;
          roles = [
            "base"
            "interactive"
            "dev"
            "desktop"
            "thinkpadE14"
            "gnome"
            "gaming"
          ];
        };
        plasmadesktop = {
          system = builtins.head systems;
          roles = [
            "base"
            "interactive"
            "dev"
            "desktop"
            "thinkpadE14"
            "plasma"
            "gaming"
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
              nixpkgs = {
                overlays = [ unstableOverlay ];
                config.allowUnfree = true;
              };
            }

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
                    imports =
                      [
                        inputs.plasma-manager.homeManagerModules.plasma-manager
                      ]
                      ++ (import ./lib/import-modules.nix {
                        inherit lib;
                        dir = ./home-modules;
                      });
                  };
                };
              };
            }
          ]
          ++ lib.optionals (helpers.hasRole "wsl") [ nixos-wsl.nixosModules.default ];
        }
      );

      formatter = eachSystem ({ pkgs, ... }: pkgs.nixfmt);

      apps = import ./apps { inherit nixpkgs systems; };
    };
}
