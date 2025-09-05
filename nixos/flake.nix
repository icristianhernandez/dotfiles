{
  description = "A personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        # You can pass special arguments to your modules here, if needed.
      };
      modules = [
        # The main configuration file
        ./configuration.nix

        # Home Manager's NixOS module
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
