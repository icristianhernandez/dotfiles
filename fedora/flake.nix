{
  description = "Personal Fedora configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
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
        thinkpad = {
          system = builtins.head systems;
          roles = [
            "base"
            "interactive"
            "dev"
            "desktop"
            "thinkpadE14"
            "dms"
            "gaming"
            "gnome"
          ];
        };
      };
    in
    {
      homeConfigurations = lib.genAttrs (builtins.attrNames hosts) (
        hostName:
        let
          host = hosts.${hostName};
          inherit (host) roles;
          helpers = rolesSpec.mkHelpers roles;
        in
        assert rolesSpec.validateRoles roles;
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${host.system};
          extraSpecialArgs = {
            inherit const roles hostName;
            inherit (helpers) hasRole mkIfRole guardRole;
            inherit inputs;
            input = inputs;
          };
          modules = [
            ./home.nix
            {
              home.username = const.user;
              home.homeDirectory = const.homeDir;
            }
          ];
        }
      );

      formatter = eachSystem ({ pkgs, ... }: pkgs.nixfmt);
    };
}
