{
  description = "Personal NixOS configuration for WSL with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher/c5e133fe06f5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs) nixpkgs nixos-wsl home-manager;
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
        desktopthinkpad = {
          system = builtins.head systems;
          roles = [
            "base"
            "interactive"
            "dev"
            "desktop"
            "thinkpadE14"
            # dms, gnome, plasma :
            "gnome"
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
            inherit (helpers)
              hasRole
              mkIfRole
              guardRole
              guardRoles
              ;
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
                overwriteBackup = true;
                extraSpecialArgs = {
                  inherit const roles hostName;
                  inherit (helpers)
                    hasRole
                    mkIfRole
                    guardRole
                    guardRoles
                    ;
                  inherit inputs;
                  input = inputs;
                };
                users = {
                  "${const.user}" = {
                    imports =
                      (import ./lib/import-modules.nix {
                        inherit lib;
                        dir = ./home-modules;
                      })
                      ++ lib.optionals (helpers.hasRole "plasma") [
                        inputs.plasma-manager.homeModules.plasma-manager
                      ];
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
