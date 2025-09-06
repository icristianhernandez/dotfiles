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
      specialArgs = { username = "icristianhernandez"; };
      modules = [
        # The main configuration file
        ./configuration.nix

        # Home Manager's NixOS module
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
