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
      inputs.home-manager.follows = "home-manager";
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
      plasmaOverlay = final: prev: {
        kdePackages = prev.kdePackages.overrideScope (
          _kdeFinal: kdePrev: {
            plasma-workspace =
              let
                basePkg = kdePrev.plasma-workspace;
                xdgdataPkg = final.stdenv.mkDerivation {
                  name = "${basePkg.name}-xdgdata";
                  buildInputs = [ basePkg ];
                  dontUnpack = true;
                  dontFixup = true;
                  dontWrapQtApps = true;
                  installPhase = ''
                    mkdir -p $out/share
                    ( IFS=:
                      for DIR in $XDG_DATA_DIRS; do
                        if [[ -d "$DIR" ]]; then
                          ${prev.lib.getExe prev.lndir} -silent "$DIR" $out
                        fi
                      done
                    )
                  '';
                };
                derivedPkg = basePkg.overrideAttrs {
                  preFixup = ''
                    for index in "''${!qtWrapperArgs[@]}"; do
                      if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                        unset -v "qtWrapperArgs[$((index+0))]"
                        unset -v "qtWrapperArgs[$((index+1))]"
                        unset -v "qtWrapperArgs[$((index+2))]"
                        unset -v "qtWrapperArgs[$((index+3))]"
                      fi
                    done
                    qtWrapperArgs=("''${qtWrapperArgs[@]}")
                    qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                    qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
                  '';
                };
              in
              derivedPkg;
          }
        );
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
                overlays = [ unstableOverlay ] ++ lib.optionals (helpers.hasRole "plasma") [ plasmaOverlay ];
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
