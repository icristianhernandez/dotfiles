{
  description = "A personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add flake-utils for multi-architecture support.
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    # Use flake-utils to generate outputs for default systems (x86_64 and aarch64).
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Import our global settings.
        globals = import ./config/globals.nix;
        # Get the package set for the current system.
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Decoupled Home Manager configuration, making it portable.
        homeConfigurations."${globals.username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # The modules for the home configuration.
          modules = [ ./home/home.nix ];
        };

        # NixOS system configuration.
        nixosConfigurations."${globals.hostname}" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            # No special args needed as modules will import globals directly.
          };
          modules = [
            ./configuration.nix

            # Import the Home Manager NixOS module.
            home-manager.nixosModules.home-manager
            {
              # And tell it to use our decoupled Home Manager configuration.
              home-manager.users."${globals.username}" = self.homeConfigurations."${globals.username}".config;
            }
          ];
        };
      });
}
