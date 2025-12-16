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
    {
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }:
    let
      const = import ./lib/const.nix;
      systems = [ "x86_64-linux" ];
      eachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = builtins.head systems;
        specialArgs = { inherit const; };

        modules = [
          {
            imports = import ./lib/import-modules.nix {
              inherit (nixpkgs) lib;
              dir = ./system-modules;
            };
          }
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit const; };
              users = {
                "${const.user}" = {
                  imports = import ./lib/import-modules.nix {
                    inherit (nixpkgs) lib;
                    dir = ./home-modules;
                  };
                };
              };
            };
          }
        ];
      };

      formatter = eachSystem ({ pkgs, ... }: pkgs.nixfmt);
      apps = import ./apps { inherit nixpkgs systems; };
    };
}
